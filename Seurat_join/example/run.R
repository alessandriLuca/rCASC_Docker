 
library(rCASC)
source("seuratIntegration3.R")
path=getwd()
scratch=paste(path,"/scratch",sep="")
dir.create(scratch)


seuratIntegration3(group=c("sudo"), scratch.folder=scratch, folder=paste(getwd(),"datasetFolder",sep="/"),separator=",","test",format="csv")
