library(rCASC)
file=paste(getwd(),"testSCumi_mm10.csv",sep="/")
system("wget http://130.192.119.59/public/testSCumi_mm10.csv.zip")
system("unzip testSCumi_mm10.csv.zip ")
scratch=paste(getwd(),"/scratch",sep="")
dir.create(scratch)
#permutationClustering(group=c("sudo"), scratch.folder=scratch, file=file, nPerm=10, permAtTime=5, percent=10, range1=3, range2=3, separator=",", logTen=0, clustering="SIMLR", perplexity=10 , seed=1111, rK=0)

#permutationClustering(group=c("sudo"), scratch.folder=scratch, file=file, nPerm=10, permAtTime=5, percent=10, range1=3, range2=3, separator=",", logTen=0, clustering="griph", perplexity=10 , seed=1111, rK=0)

permutationClustering(group=c("sudo"), scratch.folder=scratch, file=file, nPerm=10, permAtTime=5, percent=10, range1=3, range2=3, separator=",", logTen=0, clustering="tSne", perplexity=10 , seed=1111, rK=0)

