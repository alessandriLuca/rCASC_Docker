source("skeleton_Comet.R")
library("rCASC")
cometsc(group="docker", file=paste(getwd(), "file.csv",sep="/"), 
            scratch.folder=getwd(),
            threads=1, counts="True", skipvis="False", nCluster=8, 
            separator=",", 
            clustering.output=paste(getwd(),"file_clustering.output.csv",sep="/")) 
