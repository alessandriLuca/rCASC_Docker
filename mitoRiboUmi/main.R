 #setwd("./home")
 #source("functions.R")
 #library("SIMLR")
 library("argparser")
 #library(dplyr)
 #library("vioplot")
 library("refGenome")
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "gtf.name", help="gtf name ")
p <- add_argument(p, "bio.type", help="bio type ")
p <- add_argument(p, "umiXgene", help="umi X gene ")


argv <- parse_args(p)

#argv=list()
#argv$matrixName="setPace"
#argv$format="txt"
#argv$separator="tab"
#argv$gtf.name="Mus_musculus.GRCm38.92.gtf"
#argv$bio.type="protein_coding"



matrixName=argv$matrixName
format=argv$format
separator=argv$separator
gtf.name=argv$gtf.name
biotype=argv$bio.type
umiXgene=as.numeric(argv$umiXgene)

if(separator=="tab"){separator2="\t"}else{separator2=separator}

#system(paste("cp -r ./../data/Results/",matrixName,"/ ./../scratch",sep=""))
setwd("/scratch")



mainMatrix=read.table(paste("./",matrixName,".",format,sep=""),header=TRUE,sep=separator2,row.names=1)
rnmm=sapply(rownames(mainMatrix),FUN=function(x){strsplit(x,":")[[1]][1]})
rownames(mainMatrix)=rnmm
require("refGenome") || stop("\nMissing refGenome library\n")

beg <- ensemblGenome()
basedir(beg) <- getwd()
read.gtf(beg, gtf.name)
annotation <- extractPaGenes(beg)




newNames=sapply(rownames(mainMatrix),FUN=function(x){
return(annotation$gene_name[which(annotation$gene_id==x)])

})
#rownames(mainMatrix)=newNames


rps <- grep("^RPS",toupper(newNames))
rpl <- grep("^RPL",toupper(newNames))
ribosomal <- c(rps, rpl)
ribosomal=rownames(mainMatrix)[ribosomal]
mitocondrial=intersect(annotation$gene_id[which(annotation$seqid=="MT")],rownames(mainMatrix))
mainMatrix=mainMatrix[union(union(intersect(annotation$gene_id[which(annotation$gene_biotype%in%biotype)],rownames(mainMatrix)),ribosomal),mitocondrial),]

x=colSums(mainMatrix[ribosomal,])/colSums(mainMatrix)*100
y=colSums(mainMatrix[mitocondrial,])/colSums(mainMatrix)*100



b=mainMatrix
b[b<3]=0
b[b>=3]=1
sgns=colSums(b)
colors=sapply(sgns,FUN=function(x){
    if(x<=100){return("black")}
    if(x>100 && x<=250){return("green")}
    if(x>250 && x<=500){return("gold")}
    if(x>500 && x<=1000){return("red")}
    if(x>1000){return("violet")}


})
    pdf("Ribo_mito.pdf")
     par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
     par(xpd=TRUE)


plot(x,y,pch=19, cex=0.2,xlab="% ribosomal count",ylab="%mitochondrial count",col=colors)
 legend("topright", inset=c(-0.338,0),legend=c("Genes number <= 100","100<Genes number<=250","250<Genes number<=500","500<Genes Number <=1000","Genes Number >1000"),pch=c(1),cex=0.5,col=c("black","green","gold","red","violet"))
dev.off()




  #genes <- list()
  #mainMatrix=read.table(paste("./",matrixName,".",format,sep=""),header=TRUE,sep=separator2,row.names=1)
#tmp=mainMatrix
#  for(i in 1:dim(tmp)[2]){
#    x = rep(0, dim(tmp)[1])
#    x[which(tmp[,i] >=  umiXgene)] <- 1
#    genes[[i]] <- x
#  }
#  genes <- as.data.frame(genes)
#  genes.sum <-  apply(genes,2, sum)
#  umi.sum <- apply(tmp,2, sum)
#  pdf("genes.umi.pdf")
#     plot(log10(umi.sum), genes.sum, xlab="log10 UMI", ylab="# of genes")
#dev.off()


