 
library(rCASC)
source("seurat_cCycle.R")
path=getwd()
scratch=paste(path,"/scratch",sep="")
dir.create(scratch)
file1=paste(path,"/setA.csv",sep="")

seurat_ccycle(group=c("sudo"), scratch.folder=scratch, file1=file1,separator1=",",seed=1111)
