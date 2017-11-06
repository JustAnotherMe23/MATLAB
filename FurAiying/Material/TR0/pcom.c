int psi_calculation(M, Qmat, COV, qthreshold, row, col, score, psi)
int M, *row, *col;
double **Qmat, **COV, qthreshold, *score, *psi;
{
int stime;
long ltime;
char frname[25];
int *x,*y,*indx, *indx0, **sep, *S;
int i,j,k,k0,k1,k2,l,m,v, dim,neisize;
double **A,**IA,*z,sum,mu,eta;
double un, q, qvalue, qscore, pscore, zscore, **SS;
FILE *ins, *ins2;

  x=ivector(1,DataP);
  y=ivector(1,DataP);
  A=dmatrix(1,DataP,1,DataP);
  IA=dmatrix(1,DataP,1,DataP);
  z=dvector(1,DataP);
  indx=ivector(1,DataP);
  indx0=ivector(1,DataP);
  sep=imatrix(1,DataP,0,DataP);
  SS=dmatrix(1,DataP,1,DataP);
  S=ivector(1,DataP);

  k=M; qvalue=Qmat[k][4];
  while(qvalue<qthreshold && k>1){ 
        k--;
        qvalue=Qmat[k][4];
       }   

  if(k==M) { printf("The given q-threshold value is too small\n");  exit; }
     else if(k==1){ printf("The given q-threshold value is too big\n");  exit; }
       else {
          qscore=0.5*(fabs(Qmat[k][3])+fabs(Qmat[k+1][3])); 
          // qscore=fabs(Qmat[k+1][3]);
          printf("q-score=%g\n", qscore); 
         } 

 printf("Thresholding is done\n");

 /*** determine significant neighbors  ****/
 for(i=1; i<=DataP; i++)
   for(j=0; j<=DataP; j++) sep[i][j]=0;


 for(i=1; i<=DataP*(DataP-1)/2; i++){

    k1=row[i]; k2=col[i]; un=score[i];
    
    if(un>qscore){ 
       sep[k1][0]+=1;
       sep[k1][sep[k1][0]]=k2;
       sep[k2][0]+=1;
       sep[k2][sep[k2][0]]=k1;  
       
       SS[k1][sep[k1][0]]=un;
       SS[k2][sep[k2][0]]=un;
      }
   }


 for(i=1; i<=DataP; i++){

     if(sep[i][0]>MaxNei){

        m=sep[i][0];
        indexx(m,SS[i],indx);
        for(j=1; j<=m; j++) S[j]=sep[i][j];
         
        k=m-MaxNei;
        for(j=1; j<=MaxNei; j++) sep[i][j]=S[indx[k+j]];
        sep[i][0]=MaxNei;
       }
    }
 

  v=0;
  ins=fopen("sim0.pcor.est.ini","w");
  for(i=1; i<=DataP; i++){
    for(j=i+1; j<=DataP; j++){

     if(sep[i][0]<sep[j][0]){
        m=sep[i][0];
        for(k=1; k<=m; k++) x[k]=sep[i][k]; 
       }
      else{
        m=sep[j][0];
        for(k=1; k<=m; k++) x[k]=sep[j][k];
        }

     if(m>1) indexx_integer(m,x,indx);
        else{
         if(m==1) indx[1]=1;
         }
     
     y[1]=i; y[2]=j; dim=2;
     
     if(m>=1){
        k=1; 
        if(x[indx[k]]!=i && x[indx[k]]!=j){ dim++; y[dim]=x[indx[k]];}
        while(k<m){
              k++;
              if(x[indx[k]]!=x[indx[k-1]] && x[indx[k]]!=i && x[indx[k]]!=j){ dim++; y[dim]=x[indx[k]]; }
            }
       }

     for(k=1; k<=dim; k++) 
       for(l=1; l<=dim; l++) A[k][l]=COV[y[k]][y[l]]; 

     for(k=1; k<=dim; k++) A[k][k]+=1.0e-3;
     matrix_inverse(A,IA,dim);

     eta=-IA[1][2]/sqrt(IA[1][1]*IA[2][2]);
     zscore=0.5*log((1+eta)/(1-eta))*sqrt(DataNum-dim-1);
     
     /*
     un=-fabs(zscore);
     q=gauss_cdf_ln(un)+log(2.0);
     pscore=-1.0*inverse_normal_cdf_log(q);
     */

     fprintf(ins, " %d %d %g\n", i,j,zscore);
     
     v++;
     psi[v]=zscore; 
    }
     if(i%100==0) printf("psi-score i=%d\n", i);
   }
    
  fclose(ins);
 
     
 free_ivector(x,1,DataP);
 free_ivector(y,1,DataP);
 free_dmatrix(A,1,DataP,1,DataP);
 free_dmatrix(IA,1,DataP,1,DataP);
 free_dvector(z,1,DataP);
 free_ivector(indx,1,DataP);
 free_ivector(indx0,1,DataP);
 free_imatrix(sep,1,DataP,0,DataP);
 free_dmatrix(SS,1,DataP,1,DataP);
 free_ivector(S,1,DataP);

return 0;
}
