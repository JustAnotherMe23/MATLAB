 library(GeneNet)
 library(qpgraph)
 library(huge)
 require(Rgraphviz)

 # system("./equSA")
 
 p<-200
 x<-matrix(scan("sim0.edge"), ncol=3, byrow=T)
 w<-rep(0.5,nrow(x))
 edge.list<-cbind(w,x[,1:2])
 
 A<-matrix(scan("sim0.mat"), ncol=p, byrow=T)
 
 huge.plot(A,epsflag=TRUE, graph.name="TR0_epcc")



postscript("TR0_edge.ps")


 g<-qpAnyGraph(A, threshold=0.5, remove="below",return.type="graphNEL")
 qpPlotNetwork(g)

dev.off()
