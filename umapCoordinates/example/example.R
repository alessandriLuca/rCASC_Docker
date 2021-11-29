library(rCASC)
source("./umap.R")
dir.create("scratch")
umap(group=c("docker"), scratch.folder=paste(getwd(),"/scratch",sep=""), file=paste(getwd(),"/setA.csv",sep=""),separator=",",seed=111,epochs=1000)
