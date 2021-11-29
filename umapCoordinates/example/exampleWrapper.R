library(rCASC)
source("./wrapperMixModelsUmap.R")
dir.create("scratch")
wrapperMixModelsUmap(group=c("docker"), scratch.folder=paste(getwd(),"/scratch",sep=""), file=paste(getwd(),"/setA.csv",sep=""),separator=",",seed=111,epochs=1000,k=3,finalName="prova",geneList=paste(getwd(),"/geneList.csv",sep=""))

