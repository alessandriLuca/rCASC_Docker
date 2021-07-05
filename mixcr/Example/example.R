library(rCASC)
source("./mixcr.R")
source("./gibbsR.R")
source("./logos.R")
dir.create("scratch")
system("tar -zxvf ./fastq/fastq.tar.gz -C ./fastq/")
system("rm ./fastq/fastq.tar.gz")
scratch.folder=paste(getwd(),"scratch",sep="/")
fastqPath=paste(getwd(),"fastq",sep="/")
results=paste(fastqPath,"results",sep="/")
dir.create(results)
mixcr(group=c("sudo"),scratch.folder=scratch.folder,fastqPath=fastqPath,resFolderCustom=results)
file=paste(results,"/",basename(fastqPath),"_multiplepep.txt",sep="")
gibbsR(group=c("sudo"),scratch.folder=scratch.folder,file=file,resFolderCustom=results,jobName="test",nCluster=8,motifLength=4,maxDelLength=4,maxInsLength=4,numbOfSeed=4,penalityFactorIntCluster=0.8,backGroundAminoFreq=2,seqWeightType=1)
newFolder=paste(results,"res",list.files(paste(results,"res",sep="/")),"cores",sep="/")
logosR(group=c("sudo"),scratch.folder,newFolder,resFolderCustom=newFolder)



