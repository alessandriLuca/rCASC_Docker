 
library(rCASC)
source("seuratIntegration.R")
path=getwd()
scratch=paste(path,"/scratch",sep="")
dir.create(scratch)
file1=paste(path,"/setA.csv",sep="")
file2=paste(path,"/set1.csv",sep="")

seuratIntegration(group=c("sudo"), scratch.folder=scratch, file1=file1,file2=file2, separator1=",",separator2=",",seed=1111)
