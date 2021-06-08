 
library(rCASC)
scratch=paste(getwd(),"scratch",sep="/")
system("tar -zxvf testSCumi_mm10.tar.gz")
file=paste(getwd(),"testSCumi_mm10.csv",sep="/")
dir.create(scratch)

simlrBootstrap(group=c("sudo"), scratch, file, nPerm=4, permAtTime=2, percent=10, range1=3, range2=4, separator=",", logTen=0, seed=111, sp=0.8, clusterPermErr=0.05, maxDeltaConfidence=NULL, minLogMean=NULL)
tsneBootstrap(group=c("sudo"), scratch, file, nPerm=4, permAtTime=2, percent=10, range1=5, range2=6, separator=",", logTen=0, seed=111, sp=0.8, clusterPermErr=0.05, perplexity=10)
