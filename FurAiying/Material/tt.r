#p <-read.table("geneandpvalue")
#pp <- p[p$pvalue<0.01,]

#library(huge)
#t001 <- meth[,pp$num]
#t_patient <- t001[phe$A==1,]
#t_control <- t001[phe$A==0,]
#write.table(t_patient,file="tp.dat",sep = " ",row.names = FALSE,col.names = FALSE)
#write.table(t_control,file="tc.dat",sep = " ",row.names = FALSE,col.names = FALSE)

library(R.matlab)

#match <- readMat("fMRI_preproc.mat")
ff <- readMat("fMRI_preproc.mat")
summary(ff)
match <- ff$im.sorted
block <- data.frame(t(unlist(ff$roiClass)))
colnames(block) <- c("block")
voxel <- data.frame(t(match))
brain <- cbind(block,voxel)
level <- factor(brain$block)
brain <- data.frame(level,voxel)
tapply(brain[,2],brain$level,mean)
brain_mean <- sapply(brain[,2:209], function(x) tapply(x,brain$level,mean))



aal_patient <- t(brain_mean[,1:92])
aal_control <- t(brain_mean[,93:208])

write.table(aal_patient,file="vp.dat",sep = " ",row.names = FALSE,col.names = FALSE)
write.table(aal_control,file="vc.dat",sep = " ",row.names = FALSE,col.names = FALSE)


np <- 92
nc <- 116
##correlation matrix#####
cor_pat <- cor(aal_patient)
cor_con <- cor(aal_control)

### multipule hypothesis test for the upper triangle ###
library(psych)
r_pat <- cor_pat[upper.tri(cor_pat)]
zs_pat <- sqrt(np-3)*0.5*log((1+r_pat)/(1-r_pat))
zs_pat <- abs(zs_pat)
pval_p <- 2*(pnorm(-zs_pat))

r_con <- cor_con[upper.tri(cor_con)]
zs_con <- sqrt(nc-3)*0.5*log((1+r_pat)/(1-r_pat))
zs_con <- abs(zs_con)
pval_c <- 2*(pnorm(-zs_con))

#### I figured why you can't find a lot of significant nonzero's####
### For the fisher transformation, we make a transform of correlation coefficient r by doing ###
### z = 1/2 * log((1+r)/(1-r)), this one does not follow standard Gaussian distribution###
### sqrt(n-3)*z follows N(0,1) (standard Gaussian distribution) ####
### So you need to add sqrt(n-3) to your formula ###
