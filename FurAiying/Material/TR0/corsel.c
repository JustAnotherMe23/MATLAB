
// static int  MAX_NUM=200000, GRID=3, mingrid=2;
// static int  WARM=1, stepscale=10000, samsize=10000;
// static double eps=0.001, rho=0.01;

int corsel(datanum,row,col,datax, Qmat)
int datanum,*row, *col;
double *datax, **Qmat;
{
FILE *ins, *ins2;
int stime;
long ltime;
char frname[25];
int  grid, bestgrid, v, rep, RG;
int *indx, *indx2,  *sam, i, j, k, k1, k2, m, com, iter, sel, ok;
double **resam,*rez,*dis,*dif,*mu,*alpha,*beta,*prob,*logprob,*wei,*FDR,*Q, entropy;
double delta,z,un,max,min,sum,tep,tep1,tep2,eta,dmu,dalpha,dbeta,minprob;
double bestentropy, *bestprob, *bestmu, *bestalpha, *bestbeta;
double **DataX, **COV, **CORR, pvalue;


 /* initialize the random number generator */
 /*
  ltime=time(NULL);
  stime=(unsigned int)ltime/2;
  srand(stime);

  ins=fopen("ee.log","a");
  fprintf(ins, "random seed=%d\n", stime);
  fclose(ins);
 */

  mu=dvector(1,GRID);
  alpha=dvector(1,GRID);
  beta=dvector(1,GRID);
  prob=dvector(1,GRID);
  wei=dvector(1,GRID);
  sam=ivector(1,MAX_NUM);
  indx=ivector(1,MAX_NUM);
  indx2=ivector(1,GRID);
  FDR=dvector(1,MAX_NUM);
  Q=dvector(1,MAX_NUM);
  bestmu=dvector(1,GRID);
  bestalpha=dvector(1,GRID);
  bestbeta=dvector(1,GRID);
  bestprob=dvector(1,GRID);
  logprob=dvector(1,GRID);
  resam=dmatrix(1,GRID,1,samsize);
  rez=dvector(1,samsize);
  dis=dvector(1,GRID);
  dif=dvector(1,GRID);
  

  printf("working subdata size=%d\n", datanum); 

  indexx(datanum,datax,indx);

  grid=GRID+1;  bestentropy=1.0e+100;
  while(grid>mingrid){
    
     grid--;
  
     /* Initialization */
     mu[1]=0.0; alpha[1]=0.0; k=0;
     for(i=1; i<=(int)(datanum*0.99); i++){
         mu[1]+=datax[indx[i]];
         alpha[1]+=datax[indx[i]]*datax[indx[i]];
         k++;
        }
     mu[1]=mu[1]/k;
     alpha[1]=sqrt(alpha[1]/k-mu[1]*mu[1])*sqrt(2.0);
     beta[1]=2.0; prob[1]=0.99;

     for(j=2; j<=grid; j++){
         tep=(1-prob[1])/(grid-1);
         mu[j]=0.0; alpha[j]=0.0; k=0;
         for(i=(int)(datanum*(prob[1]+(j-2)*tep)); i<=(int)(datanum*(prob[1]+(j-1)*tep)); i++){
             mu[j]+=datax[indx[i]];
             alpha[j]+=datax[indx[i]]*datax[indx[i]];
             k++;
            }
         mu[j]=mu[j]/k;
         alpha[j]=sqrt(alpha[j]/k-mu[j]*mu[j])*sqrt(2.0);
         beta[j]=2.0; prob[j]=tep;
        }
     for(j=1; j<=grid; j++){
         logprob[j]=log(prob[j])-log(prob[grid]);
        }
    

     for(iter=1; iter<=100; iter++){

        random_order(sam,datanum);
        for(i=1; i<=datanum; i++){

            rep=datanum*(iter-1)+i;
            if(rep<=WARM*stepscale) delta=rho;
                else delta=rho*exp(-log(1.0*(rep-(WARM-1)*stepscale)/stepscale));

            for(sum=0.0,j=1; j<=grid; j++) sum+=exp(logprob[j]);
            for(j=1; j<=grid; j++) prob[j]=exp(logprob[j])/sum;

            z=datax[sam[i]];
            max=-1.0e+100;
            for(j=1; j<=grid; j++){
                wei[j]=dlogGnormal(z,mu[j],alpha[j],beta[j])+log(prob[j]);
                if(wei[j]>max){ max=wei[j]; sel=j; }
               }
            for(sum=0.0, j=1; j<=grid; j++) sum+=exp(wei[j]-max);
         
            indexx(grid,mu,indx2);
            for(k=1; k<=grid; k++){
                j=indx2[k];
                eta=exp(wei[j]-max)/sum;

                if(z>mu[j]) dmu=beta[j]/alpha[j]*exp((beta[j]-1.0)*log(fabs(z-mu[j])/alpha[j]));
                   else dmu=-beta[j]/alpha[j]*exp((beta[j]-1.0)*log(fabs(z-mu[j])/alpha[j]));

                dalpha=-1.0/alpha[j]+beta[j]/alpha[j]*exp(beta[j]*log(fabs(z-mu[j])/alpha[j]));
                dbeta=1.0/beta[j]+1.0/beta[j]/beta[j]*derivative_gamma(1.0/beta[j])
                  -exp(beta[j]*log(fabs(z-mu[j])/alpha[j]))*log(fabs(z-mu[j])/alpha[j]);
           
                mu[j]+=delta*eta*dmu;
                alpha[j]+=delta*eta*dalpha;
                beta[j]+=delta*eta*dbeta;
                logprob[j]+=delta*(eta-prob[j]);
             
                if(mu[j]<-20.0) mu[j]=-20.0;
                if(mu[j]>40.0) mu[j]=40.0;
                if(alpha[j]<0.1) alpha[j]=0.1;
                if(alpha[j]>10.0) alpha[j]=10.0;
                if(beta[j]<0.1) beta[j]=0.1;
                if(beta[j]>10.0) beta[j]=10.0;
               }
            } /* end one epoach */
            
            if(iter%1==0) printf("iter=%d delta=%g %g %g %g %g: %g %g %g %g\n", 
               iter,delta,prob[1],mu[1],alpha[1],beta[1],prob[2],mu[2],alpha[2],beta[2]);
           
          }      /* end for iterations */ 

          
         for(sum=0.0,j=1; j<=grid; j++) sum+=exp(logprob[j]);
         for(j=1; j<=grid; j++) prob[j]=exp(logprob[j])/sum;

         for(entropy=0.0,i=1; i<=datanum; i++){
             max=-1.0e+100;
             for(j=1; j<=grid; j++){
                 wei[j]=dlogGnormal(z,mu[j],alpha[j],beta[j])+log(prob[j]);
                 if(wei[j]>max){ max=wei[j]; sel=j; }
                }
             for(sum=0.0, j=1; j<=grid; j++) sum+=exp(wei[j]-max);
             entropy+=log(sum)+max; 
            }
         entropy*=-1.0/datanum;
         entropy+=0.5*(grid*3+grid-1)*log(1.0*datanum)/datanum;
         

         ins=fopen("ee.log","a");
         if(grid==GRID) fprintf(ins, "dataset: %s\n", frname);
         fprintf(ins, "entropy=%g\n", entropy);
         for(j=1; j<=grid; j++){
             fprintf(ins, "%d  %g  %g  %g  %g\n",j,prob[j],mu[j],alpha[j],beta[j]);
            }
         fprintf(ins, "\n");
         fclose(ins);
       
         if(entropy<=bestentropy){
            bestentropy=entropy;
            bestgrid=grid;
            for(j=1; j<=grid; j++){ bestprob[j]=prob[j]; bestmu[j]=mu[j]; 
                bestalpha[j]=alpha[j]; bestbeta[j]=beta[j]; }
           }
       }  /* end for different grid size */

      /* calculating the distance between the mixture components */
      for(k=1; k<=bestgrid; k++){
          MCMCGnormal(bestmu[k],bestalpha[k],bestbeta[k],samsize,rez);
          for(j=1; j<=samsize; j++) resam[k][j]=rez[j]; 
         }
      indexx(bestgrid, bestmu, indx2);
      for(j=1; j<bestgrid; j++){
          k1=indx2[j]; k2=indx2[j+1];
          tep1=tep2=0.0;
          for(i=1; i<=samsize; i++){ 
              tep1+=dlogGnormal(resam[k1][i],bestmu[k1],bestalpha[k1],bestbeta[k1])-
                  dlogGnormal(resam[k1][i],bestmu[k2],bestalpha[k2],bestbeta[k2]);
              tep2+=dlogGnormal(resam[k2][i],bestmu[k2],bestalpha[k2],bestbeta[k2])-
                  dlogGnormal(resam[k2][i],bestmu[k1],bestalpha[k1],bestbeta[k1]);
             }
          if(tep1<tep2) dis[j]=tep1/samsize;
             else dis[j]=tep2/samsize;
         }


      /* determine the number of components for f_0 */
      dif[1]=1.0;
      for(j=2; j<bestgrid; j++) dif[j]=(dis[j]-dis[j-1])/dis[j-1];
      dif[bestgrid]=-1.0;
      com=1; ok=0;
      while(ok==0 && com<bestgrid-1){
         if(dif[com]*dif[com+1]<0.0) ok=1; 
            else com++;
         }
      /*
      max=0.0; k=1;
      for(j=2; j<bestgrid; j++)
          if(dif[j]>max){ max=dif[j]; k=j; }
      if(k<com) com=k; 
      */

      ins=fopen("ee.out","a");
      for(j=1; j<=bestgrid; j++){
          k=indx2[j];
          fprintf(ins, "%d %g %g %g %g\n",j,bestprob[k],bestmu[k],bestalpha[k],bestbeta[k]);
          }
      fprintf(ins,"distance:");
      for(j=1; j<bestgrid; j++) fprintf(ins, "   %g", dis[j]);
      fprintf(ins, "\n");
      fprintf(ins, "com=%d\n\n",com);
      fclose(ins);

      // com=bestgrid-1;
      com=1;

      /* calculating FDR */
      for(i=1; i<=datanum; i++){
        z=datax[indx[i]];
        for(sum=0.0,m=1; m<=com; m++){
          k=indx2[m]; 
          if(z>bestmu[k]){
             un=exp(bestbeta[k]*log((z-bestmu[k])/bestalpha[k]));
             tep=(0.5-0.5*gammp(1.0/bestbeta[k],un))*bestprob[k];
            } else if(z<bestmu[k]){
              un=exp(bestbeta[k]*log((bestmu[k]-z)/bestalpha[k]));
              tep=(0.5+0.5*gammp(1.0/bestbeta[k],un))*bestprob[k];
             } else tep=0.5*bestprob[k];
           sum+=tep;
          }
         FDR[i]=sum;

        for(sum=0.0, k=1; k<=bestgrid; k++){
           if(z>bestmu[k]){
               un=exp(bestbeta[k]*log((z-bestmu[k])/bestalpha[k]));
               tep=(0.5-0.5*gammp(1.0/bestbeta[k],un))*bestprob[k];
              } else if(z<bestmu[k]){
                 un=exp(bestbeta[k]*log((bestmu[k]-z)/bestalpha[k]));
                 tep=(0.5+0.5*gammp(1.0/bestbeta[k],un))*bestprob[k];
                } else tep=0.5*bestprob[k];
            sum+=tep;
           }
          FDR[i]/=sum;
        }

       min=FDR[1]; Q[1]=min;
       for(i=2; i<=datanum; i++){
           if(FDR[i]<min) min=FDR[i];
           Q[i]=min;
          }

       ins=fopen("ee.fdr", "w");
       for(i=1; i<=datanum; i++)
           fprintf(ins, " %5d %5d %g %g %g\n", row[indx[i]],col[indx[i]],datax[indx[i]],FDR[i],Q[i]);
       fprintf(ins, "\n");
       fclose(ins);   

       

       /* alternative method of FDR calculation */
      for(i=1; i<=datanum; i++){
       z=datax[indx[i]];
       for(sum=0.0,m=1; m<=com; m++){
          k=indx2[m];      
          if(z>bestmu[k]){
             un=exp(bestbeta[k]*log((z-bestmu[k])/bestalpha[k]));
             tep=(0.5-0.5*gammp(1.0/bestbeta[k],un))*bestprob[k];
           } else if(z<bestmu[k]){
              un=exp(bestbeta[k]*log((bestmu[k]-z)/bestalpha[k]));
              tep=(0.5+0.5*gammp(1.0/bestbeta[k],un))*bestprob[k];
             } else tep=0.5*bestprob[k];
          sum+=tep;
         }
         FDR[i]=sum*datanum/(datanum-i+1);
         if(FDR[i]>1.0) FDR[i]=1.0;
        }

       min=FDR[1]; Q[1]=min;
       for(i=2; i<=datanum; i++){
           if(FDR[i]<min) min=FDR[i];
           Q[i]=min;
          }

       ins=fopen("eea.fdr", "w");
       for(i=1; i<=datanum; i++){
           Qmat[i][1]=row[indx[i]]; Qmat[i][2]=col[indx[i]]; Qmat[i][3]=datax[indx[i]]; Qmat[i][4]=Q[i];
           fprintf(ins, " %5d %5d %g %g %g\n", row[indx[i]],col[indx[i]],datax[indx[i]],FDR[i],Q[i]);
          }
       fprintf(ins, "\n");
       fclose(ins);


  free_dvector(mu,1,GRID);
  free_dvector(alpha,1,GRID);
  free_dvector(beta,1,GRID);
  free_dvector(prob,1,GRID);
  free_dvector(wei,1,GRID);
  free_ivector(sam,1,MAX_NUM);
  free_ivector(indx,1,MAX_NUM);
  free_ivector(indx2,1,GRID);
  free_dvector(FDR,1,MAX_NUM);
  free_dvector(Q,1,MAX_NUM);
  free_dvector(bestmu,1,GRID);
  free_dvector(bestalpha,1,GRID);
  free_dvector(bestbeta,1,GRID);
  free_dvector(bestprob,1,GRID);
  free_dvector(logprob,1,GRID);
  free_dmatrix(resam,1,GRID,1,samsize);
  free_dvector(rez,1,samsize);
  free_dvector(dis,1,GRID);
  free_dvector(dif,1,GRID);

  return 0;
  }
