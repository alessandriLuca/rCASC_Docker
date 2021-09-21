library(rCASC)
path=getwd()
source(paste(path,"tuneStardust.R",sep="/"))
system(paste("tar -xf ",path,"test.tar.gz"))
file=paste(path,"filtered_expression_matrix.txt",sep="/")
scratch=paste(path,"scratch",sep="/")
dir.create(scratch)
spot_coordinates=paste(path,"spot_coordinates.txt",sep="/")
group="sudo"
separator="\t"
tuneStardust(group=group, scratch.folder=scratch, file=file,spot_coordinates=spot_coordinates,separator=separator)
 
