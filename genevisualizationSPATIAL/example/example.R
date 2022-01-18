library(rCASC)
source("./geneVisualizationSpatial.R")
dir.create("scratch")
geneVisualizationSpatial(group=c("docker"), scratch.folder=paste(getwd(),"/scratch",sep=""), file=paste(getwd(),"/log2cpm.csv",sep=""),tissuePosition=paste(getwd(),"/tissue_positions_list.csv",sep=""),geneList=paste(getwd(),"/fibro.txt",sep=""),separator=",",finalName="Lista1")
