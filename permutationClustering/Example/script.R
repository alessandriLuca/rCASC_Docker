 
library(rCASC)
scratch=paste(getwd(),"scratch",sep="/")
system("tar -zxvf testSCumi_mm10.tar.gz")
file=paste(getwd(),"testSCumi_mm10.csv",sep="/")
dir.create(scratch)
permutationClustering(group=c("sudo"), scratch.folder=scratch, file=file, nPerm=4, permAtTime=2, percent=10, range1=3, range2=3, separator=",", logTen=0, clustering="tSne", perplexity=10 , seed=1111, rK=0)
permutationClustering(group=c("sudo"), scratch.folder=scratch, file=file, nPerm=4, permAtTime=2, percent=10, range1=4, range2=4, separator=",", logTen=0, clustering="SIMLR", perplexity=10 , seed=1111, rK=0)
permutationClustering(group=c("sudo"), scratch.folder=scratch, file=file, nPerm=4, permAtTime=2, percent=10, range1=3, range2=3, separator=",", logTen=0, clustering="griph", perplexity=10 , seed=1111, rK=0)
