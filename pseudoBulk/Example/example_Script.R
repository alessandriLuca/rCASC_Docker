library(rCASC)
file=paste(getwd(),"setA.csv",sep="/")
dir.create(paste(getwd(),"scratch",sep="/"))
autoencoder4pseudoBulk(group=c("sudo"), scratch.folder=paste(getwd(),"scratch",sep="/"), file=file,separator=",", permutation=3, nEpochs=50,patiencePercentage=5, bN=paste(getwd(),"setA_clustering.output.csv",sep="/"),seed=1111,projectName="PROVA")
