library(rCASC)
source("./geneVisualization2.R")
dir.create("scratch")
geneVisualization2(group=c("docker"), scratch.folder=paste(getwd(),"/scratch",sep=""), file=paste(getwd(),"/setA.csv",sep=""),clustering.output=paste(getwd(),"/setA_clustering.output.csv",sep=""),geneList=paste(getwd(),"/geneList.csv",sep=""),separator=",",finalName="Lista1",pvalueFile=paste(getwd(),"log2cpmfisher.csv",sep="/"),threshold=0.95)
