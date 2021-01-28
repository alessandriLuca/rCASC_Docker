library(rCASC)
file=paste(getwd(),"setA.csv",sep="/")
dir.create(paste(getwd(),"scratch",sep="/"))
autoencoder(group=c("sudo"), scratch.folder=paste(getwd(),"scratch",sep="/"), file=file,separator=",", nCluster=5, bias="TF", permutation=3, nEpochs=50,patiencePercentage=5, cl=paste(getwd(),"setA_clustering.output.csv",sep="/"),seed=1111,projectName="PROVA",bN="NULL",lr=0.01,beta_1=0.9,beta_2=0.999,epsilon=0.00000001,decay=0.0,loss="mean_squared_error",regularization=10,variational=FALSE)

