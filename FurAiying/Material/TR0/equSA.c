#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define pi 3.14159265

static int DataNum=100, DataP=200, MaxNei=22;
static int ratio;
static double ALPHA1=0.05, ALPHA2=0.05;

/*** parameter settings for corsel.c and pcorsel.c ***/
static int  MAX_NUM=2000000, GRID=3, mingrid=2;
static int  WARM=1, stepscale=10000, samsize=10000;
static double eps=0.001, rho=0.01;

#include "nrutil.h"
#include "nrutil.c"
#include "lib.c"
#include "corsel.c"
#include "pcom.c"
#include "pcorsel.c"

main()
{
FILE *ins, *ins2;
int stime;
long ltime;
char frname[25];
int  DATA_NUM, DATA_NUM_PLUS, *no, *row, *col, *subrow, *subcol,*indx, **E;
int i, j, k, m, M, m0, iter;
double *datax, **DataX, **COV, **CORR, *score, *subscore, *psi, **Qmat;
double q, sum, un, b1, q1, b2, q2, qscore;

 /* initialize the random number generator */
  ltime=time(NULL);
  stime=(unsigned int)ltime/2;
  srand(stime);

  ins=fopen("sim0.log","a");
  fprintf(ins, "random seed=%d\n", stime);
  fclose(ins);

  DATA_NUM=DataP*(DataP-1)/2;
  DATA_NUM_PLUS=DataP*(DataP+1)/2;
  ratio=ceil(DATA_NUM/100000.0); 

  datax=dvector(1,DATA_NUM_PLUS);
  score=dvector(1,DATA_NUM_PLUS);
  row=ivector(1,DATA_NUM_PLUS);
  col=ivector(1,DATA_NUM_PLUS);
  no=ivector(1,DATA_NUM);
  indx=ivector(1,DATA_NUM);
  DataX=dmatrix(1,DataNum,1,DataP);
  COV=dmatrix(1,DataP,1,DataP);
  CORR=dmatrix(1,DataP,1,DataP);
  subrow=ivector(1,DATA_NUM);
  subcol=ivector(1,DATA_NUM);
  subscore=dvector(1,DATA_NUM); 
  Qmat=dmatrix(1,DATA_NUM,1,4);
  psi=dvector(1,DATA_NUM);
  E=imatrix(1,DataP,1,DataP);

 
  ins=fopen("TR0.dat","r");
  if(ins==NULL){ printf("No data\n"); return 0; }
  for(i=1; i<=DataNum; i++){
     for(j=1; j<=DataP; j++) fscanf(ins, " %lf", &DataX[i][j]);
   }
  fclose(ins);

 /*** centralization ****/
  for(j=1; j<=DataP; j++){
    for(sum=0.0,i=1; i<=DataNum; i++) sum+=DataX[i][j];
    un=sum/DataNum;
    for(i=1; i<=DataNum; i++) DataX[i][j]-=un;
   }

 /*** calculate covariance matrix ***/
  m=0;
  for(i=1; i<=DataP; i++){
     for(j=i; j<=DataP; j++){
        COV[i][j]=0.0;
        for(k=1; k<=DataNum; k++) COV[i][j]+=DataX[k][i]*DataX[k][j];
        COV[i][j]/=DataNum;
        if(i!=j) COV[j][i]=COV[i][j]; 
         
        m++;
        row[m]=i; col[m]=j; datax[m]=COV[i][j];
      }
   if(i%100==0) printf("i=%d\n", i);
    } 
  if(m!=DATA_NUM_PLUS){ printf("Matrix error I in corz.c\n"); }

  ins=fopen("sim0.cov","w");
  for(k=1; k<=DATA_NUM_PLUS; k++)
    fprintf(ins, " %d %d %g\n", row[k],col[k],datax[k]);
  fclose(ins);


 
  for(i=1; i<=DataP; i++)
     for(j=i; j<=DataP; j++){
         CORR[i][j]=COV[i][j]/sqrt(COV[i][i]*COV[j][j]);
         if(i!=j) CORR[j][i]=CORR[i][j];
        }

  sum=0.0; k=0;
  for(i=1; i<=DataP; i++)
      for(j=i+1; j<=DataP; j++){
         k++;
         un=0.5*log((1+CORR[i][j])/(1-CORR[i][j]))*sqrt(DataNum-3.0);
         
         row[k]=i; col[k]=j; datax[k]=un;
         no[k]=k;
        }
  if(k!=DATA_NUM) printf("Matrix size error\n"); 

  ins=fopen("sim0.score","w");
  for(k=1; k<=DATA_NUM; k++){

    un=-fabs(datax[k]);
    q=gauss_cdf_ln(un);
    sum=q+log(2.0); 
    score[k]=-1.0*inverse_normal_cdf_log(sum);

    fprintf(ins, " %d %d %g %g\n", row[k],col[k],datax[k],score[k]);
   }
  fclose(ins);

  
  /*** subsampling  **************/
  if(ratio>1){ 
     indexx(DATA_NUM, score, indx);
     M=DATA_NUM/ratio;
     m0=DATA_NUM-M*ratio;
  
     for(i=1; i<=M; i++){

        k=0;
        while(k<=0 || k>ratio) k=floor(rand()*1.0/RAND_MAX*ratio)+1; 
       
        j=(i-1)*ratio+k;
        subrow[i]=row[indx[j]]; subcol[i]=col[indx[j]]; subscore[i]=score[indx[j]];
      }
     if(m0>0){
        k=0;
        while(k<=0 || k>m0) k=floor(rand()*1.0/RAND_MAX*m0)+1;

        j=M*ratio+k;
        M++;
        subrow[M]=row[indx[j]]; subcol[M]=col[indx[j]]; subscore[M]=score[indx[j]];
      }
    }
   else{
     M=DATA_NUM;
     for(i=1; i<=M; i++){ subrow[i]=row[i]; subcol[i]=col[i]; subscore[i]=score[i]; }
    }
  
  ins=fopen("sim0.score.sub","w");
  for(i=1; i<=M; i++)
     fprintf(ins, " %d %d %g\n", subrow[i], subcol[i], subscore[i]);
  fclose(ins); 
  
  corsel(M,subrow,subcol,subscore,Qmat); 
  
  /*** psi-score calculation *****/

  psi_calculation(M,Qmat,COV,ALPHA1,row,col,score,psi);

  /*** psi-score transformation  ***/
  for(i=1; i<=DATA_NUM; i++){
      un=-fabs(psi[i]);
      q=gauss_cdf_ln(un)+log(2.0);
      psi[i]=-1.0*inverse_normal_cdf_log(q);
    }

  ins=fopen("sim0.pcor.est","w");
  for(i=1; i<=DATA_NUM; i++){
     fprintf(ins, " %d %d %g\n", row[i], col[i], psi[i]);
    }
  fclose(ins);
   

  /*** subsampling  for psi-score **************/
  if(ratio>1){
     indexx(DATA_NUM, psi, indx);
     M=DATA_NUM/ratio;
     m0=DATA_NUM-M*ratio;

     for(i=1; i<=M; i++){

        k=0;
        while(k<=0 || k>ratio) k=floor(rand()*1.0/RAND_MAX*ratio)+1;

        j=(i-1)*ratio+k;
        subrow[i]=row[indx[j]]; subcol[i]=col[indx[j]]; subscore[i]=psi[indx[j]];
      }
     if(m0>0){
        k=0;
        while(k<=0 || k>m0) k=floor(rand()*1.0/RAND_MAX*m0)+1;

        j=M*ratio+k;
        M++;
        subrow[M]=row[indx[j]]; subcol[M]=col[indx[j]]; subscore[M]=psi[indx[j]];
      }
    }
   else{
     M=DATA_NUM;
     for(i=1; i<=M; i++){ subrow[i]=row[i]; subcol[i]=col[i]; subscore[i]=psi[i]; }
    }

  ins=fopen("sim0.pcor.sub","w");
  for(i=1; i<=M; i++)
     fprintf(ins, " %d %d %g\n", subrow[i], subcol[i], subscore[i]);
  fclose(ins);

  pcorsel(M,subrow,subcol,subscore,Qmat);

  k=M; q=Qmat[k][4];
  while(q<ALPHA2 && k>1){
        k--;
        q=Qmat[k][4];
       }

  if(k==M) { printf("The given q-threshold value is too small\n");  exit; }
     else if(k==1){ printf("The given q-threshold value is too big\n");  exit; }
       else {
          qscore=0.5*(fabs(Qmat[k][3])+fabs(Qmat[k+1][3]));
          // qscore=fabs(Qmat[k+1][3]);
          printf("threshold psi-score=%g\n", qscore);
         }

  for(i=1; i<=DataP; i++)
     for(j=1; j<=DataP; j++) E[i][j]=0;

  ins=fopen("sim0.edge","w");
  for(i=1; i<=DATA_NUM; i++)
    if(psi[i]>qscore){ 
       fprintf(ins, " %d %d %g\n", row[i], col[i], psi[i]);
       E[row[i]][col[i]]=1; 
       E[col[i]][row[i]]=1;
      }
  fclose(ins);

  ins=fopen("sim0.mat","w");
  for(i=1; i<=DataP; i++){
     for(j=1; j<=DataP; j++) fprintf(ins, " %d", E[i][j]);
     fprintf(ins, "\n");
    }
  fclose(ins);
  
  
  free_dvector(datax,1,DATA_NUM_PLUS);
  free_dvector(score,1,DATA_NUM_PLUS);
  free_ivector(row,1,DATA_NUM_PLUS);
  free_ivector(col,1,DATA_NUM_PLUS);
  free_ivector(no,1,DATA_NUM);
  free_dmatrix(DataX,1,DataNum,1,DataP);
  free_dmatrix(COV,1,DataP,1,DataP);
  free_dmatrix(CORR,1,DataP,1,DataP);
  free_ivector(indx,1,DATA_NUM);
  free_ivector(subrow,1,DATA_NUM);
  free_ivector(subcol,1,DATA_NUM);
  free_dvector(subscore,1,DATA_NUM);
  free_dmatrix(Qmat,1,DATA_NUM,1,4);
  free_dvector(psi,1,DATA_NUM);
  free_imatrix(E,1,DataP,1,DataP);

  return 0;
  }
