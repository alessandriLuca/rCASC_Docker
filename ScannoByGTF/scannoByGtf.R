#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

counts.table=args[1]
gtf.name=args[2]
biotype=args[3]
mt=args[4]
if(mt=="TRUE" || mt=="T"){
   mt <- TRUE
   mt2 =TRUE
}else{
   mt <- FALSE
   mt2=FALSE
}
ribo.proteins=args[5]
if(ribo.proteins=="TRUE" || ribo.proteins=="T"){
   ribo.proteins <- TRUE
}else{
   ribo.proteins <- FALSE
}

file.type=args[6]

percentage.ribo=c(as.numeric(args[7]),as.numeric(args[8])) # DA METTERE DEFAULT X
percentage.mito=c(as.numeric(args[9]),as.numeric(args[10]))# Y


#DATI DEFINE 
#counts.table="setPace.txt"
#gtf.name="Mus_musculus.GRCm38.92.gtf"
#biotype="protein_coding"
#mt=TRUE
#ribo.proteins=TRUE
#file.type="txt"
#percentage.ribo=c(20,70)
#percentage.mito=c(1,100)
#FINE




setwd("/data/scratch")
require("refGenome") || stop("\nMissing refGenome library\n")
  ######
  '%!in%' <- function(x,y)!('%in%'(x,y))
  ######
  




if(file.type=="txt"){
   mainMatrix <- read.table(counts.table, sep="\t", header=T, row.names=1, stringsAsFactors=FALSE)
}else{
   mainMatrix <- read.table(counts.table, sep=",", header=T, row.names=1, stringsAsFactors=FALSE)
}



beg <- ensemblGenome()
basedir(beg) <- getwd()
read.gtf(beg, gtf.name)
annotation <- extractPaGenes(beg)
if(length(biotype) > 0){
  annotation <- annotation[which(annotation$gene_biotype%in%biotype),]
}
  #annotation <- annotation[which(annotation$seqid!="MT"),]
rps <- grep("^RPS",toupper(annotation$gene_name))
  rpl <- grep("^RPL",toupper(annotation$gene_name))
rib=annotation$gene_id[c(rps,rpl)]
  mt=annotation$gene_id[which(annotation$seqid=="MT")]

mmMito=unlist(sapply(mt,FUN=function(x){
return(which(x==rownames(mainMatrix)))

}))

mmRibo=unlist(sapply(rib,FUN=function(x){
return(which(x==rownames(mainMatrix)))

}))  
  
 
 

  
x=colSums(mainMatrix[mmRibo,])/colSums(mainMatrix)*100
y=colSums(mainMatrix[mmMito,])/colSums(mainMatrix)*100



xTest=sapply(x,FUN=function(x){data.table::between(x,percentage.ribo[1],percentage.ribo[2])})
yTest=sapply(y,FUN=function(y){data.table::between(y,percentage.mito[1],percentage.mito[2])})
filteredCells=xTest & yTest
  
  

  
  
beg <- ensemblGenome()
basedir(beg) <- "/data/scratch"
read.gtf(beg, gtf.name)
annotation <- extractPaGenes(beg)
#write.table(mt,"ciao.txt")
if(mt2==FALSE){
#write.table(c(1,2,3),"ciao.txt")  
annotation <- annotation[which(annotation$seqid!="MT"),] 
  #annotation <- annotation[which(annotation$gene_name!="MT"),]
}
if(ribo.proteins==FALSE){
  rps <- grep("^RPS",toupper(annotation$gene_name))
  rpl <- grep("^RPL",toupper(annotation$gene_name))
  rp <- c(rps, rpl)
  annotation <- annotation[setdiff(seq(1,dim(annotation)[1]), rp),]
}

if(length(biotype) > 0){
  annotation <- annotation[which(annotation$gene_biotype%in%biotype),]
}
if(file.type=="txt"){
   tmp0 <- read.table(counts.table, sep="\t", header=T, row.names=1, stringsAsFactors=FALSE)
}else{
   tmp0 <- read.table(counts.table, sep=",", header=T, row.names=1, stringsAsFactors=FALSE)
}
tmp <- tmp0[which(rownames(tmp0)%in%annotation$gene_id),]
tmp <- tmp[order(row.names(tmp)),]
annotation <- annotation[which(annotation$gene_id%in%rownames(tmp)),]
annotation <- annotation[order(annotation$gene_id),]
if(identical(annotation$gene_id, rownames(tmp))){
   tmp.n <- paste(rownames(tmp), annotation$gene_name, sep=":")
   row.names(tmp) <- tmp.n
}

if(file.type=="txt"){
  write.table(tmp, paste("annotated_",counts.table, sep=""), sep="\t", col.names=NA)
    write.table(tmp[,filteredCells], paste("filtered_annotated_",counts.table, sep=""), sep="\t", col.names=NA)

}else{
   write.table(tmp, paste("annotated_",counts.table, sep=""), sep=",", col.names=NA)
  write.table(tmp[,filteredCells], paste("filtered_annotated_",counts.table, sep=""), sep=",", col.names=NA)

}
system("chmod -R 777 ./*") 


