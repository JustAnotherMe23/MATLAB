 
 p<-3883

 x<-matrix(scan("sim0.edge"), ncol=3, byrow=T)
 w<-rep(0.5,nrow(x))
 edge.list<-cbind(w,x[,1:2])

 E1<-edge.list[,2:3]

 D1<-1:p
 for(i in 1:p){
     D1[i]<-length(E1[E1[,1]==i,2])+length(E1[E1[,2]==i,1])
    }

 f1<-NULL
 for(i in 0:max(D1)){
    k<-length(D1[D1==i])
    f1<-rbind(f1,c(i,k))
   }

 g1<-NULL
 for(i in 1:nrow(f1)){
     if(f1[i,1]*f1[i,2]>0)
       g1<-rbind(g1,f1[i,])
    }

 plot(log(g1))
 
