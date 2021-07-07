library(rCASC)
path=getwd()
source(paste(path,"/deepTCR.R",sep="/"))
folderFiles=paste(path,"tetp",sep="/")
scratch.folder=paste(path,"scratch",sep="/")
dir.create(scratch.folder)
deepTCR(group=c("sudo"),scratch.folder,folderFiles=folderFiles,resFolderCustom="NULL")

