 library(rCASC)
seuratPermutation(group=c("sudo"), scratch.folder=getwd(), file=paste(getwd(),"set1.csv",sep="/"), nPerm=4, permAtTime=4, percent=10, separator=",", logTen=0,pcaDimensions=15,seed=1111,sparse=FALSE,format="NULL")
