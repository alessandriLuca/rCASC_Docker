library("GenomicRanges")
library("argparser")
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "type", help="matrix separator ")

argv <- parse_args(p)

matrixName=argv$matrixName
format=argv$format
separator=argv$separator
type=argv$type
if(type=="census"){
custom="superTest.csv"
}
if(type=="tf"){
custom="tf_atac.csv"
}

if(type=="tf2"){
custom="tf_atac2.csv"
}



if(separator=="tab"){separator2="\t"}else{separator2=separator} #BUG CORRECTION TAB PROBLEM

setwd("/scratch")
system(paste("/home/ss.sh ",matrixName,".",format,sep=""))
a=as.matrix(read.table("/scratch/yo2.csv",header=FALSE,sep=","))
b=read.table(paste("/home/",custom,sep=""),header=TRUE,sep=",")
namesA=grangesA=sapply(a,FUN=function(x){
tmp=strsplit(x,":")[[1]][1]
})
range1A=grangesA=sapply(a,FUN=function(x){
tmp=strsplit(strsplit(x,":")[[1]][2],"-")[[1]][1]
})
range2A=grangesA=sapply(a,FUN=function(x){
tmp=strsplit(strsplit(x,":")[[1]][2],"-")[[1]][2]
})

namesB=sapply(as.matrix(b[,2]),FUN=function(x){
tmp=strsplit(x,"_")[[1]][1]
})
range1B=sapply(as.matrix(b[,2]),FUN=function(x){
tmp=strsplit(x,"_")[[1]][2]
})
range2B=sapply(as.matrix(b[,2]),FUN=function(x){
tmp=strsplit(x,"_")[[1]][3]
})

grA=GRanges(seqnames=namesA, ranges=IRanges(start = as.numeric(range1A), end = as.numeric(range2A)))
 remove1=which(is.na(as.numeric(range1B)))
if(length(remove1)!=0){

namesB=namesB[-remove1]
range1B=range1B[-remove1]
range2B=range2B[-remove1]
}
grB=GRanges(seqnames=namesB, ranges=IRanges(start = as.numeric(range1B), end = as.numeric(range2B)))
finalNames=a[findOverlaps(grB,grA)@to]
write.table(finalNames,"/scratch/toFilter.csv",col.names=FALSE,row.names=FALSE,sep=",",quote=FALSE)
relMat=cbind(as.matrix(b[findOverlaps(grB,grA)@from,1]),as.matrix(a[findOverlaps(grB,grA)@to]))
write.table(relMat,"/scratch/relMat.csv",col.names=c("source","target"),row.names=FALSE,sep=",")
system(paste("/home/ss2.sh ",matrixName,".",format,sep=""))
