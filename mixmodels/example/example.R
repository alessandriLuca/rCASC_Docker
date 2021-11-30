library(rCASC)
source("./mixmodels.R")
dir.create("scratch")
mixmodels(group=c("docker"), scratch.folder=paste(getwd(),"/scratch",sep=""), file=paste(getwd(),"/setA.csv",sep=""),geneList=paste(getwd(),"/geneList.csv",sep=""),separator=",",k=3,maxit=10)
