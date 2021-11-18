library(rCASC)
source("./geneVisualization.R")
dir.create("scratch")
geneVisualization(group=c("docker"), scratch.folder=paste(getwd(),"/scratch",sep=""), file=paste(getwd(),"/setA.csv",sep=""),clustering.output=paste(getwd(),"/setA_clustering.output.csv",sep=""),geneList=paste(getwd(),"/geneList.csv",sep=""),separator=",",finalName="Lista1")
