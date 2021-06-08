 library(rCASC)
seuratBootstrap(group=c("sudo"), scratch.folder=getwd(), file=paste(getwd(),"set1.csv",sep="/"), nPerm=4, permAtTime=2, percent=10, separator=",", logTen=0, pcaDimensions=15, seed=111,sparse=FALSE,format="NULL")
griphBootstrap(group=c("sudo"), scratch.folder=getwd(), file=paste(getwd(),"set1.csv",sep="/"), nPerm=4, permAtTime=2, percent=10, separator=",", logTen=0, seed=111)
