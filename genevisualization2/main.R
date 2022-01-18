library("argparser")
library(ggplot2)


p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "clustering.output", help="matrix separator ")
p <- add_argument(p, "geneList", help="matrix separator ")
p <- add_argument(p, "finalName", help="matrix separator ")
p <- add_argument(p, "pvalueFile", help="matrix separator ")
p <- add_argument(p, "threshold", help="matrix separator ")



argv <- parse_args(p)

matrixName=argv$matrixName
separator=argv$separator
clustering.output=argv$clustering.output
geneList=argv$geneList
finalName=argv$finalName
pvalueFile=argv$pvalueFile
threshold=as.numeric(argv$threshold)
setwd("/scratch")
if(separator=="tab"){separator="\t"} #BUG CORRECTION TAB PROBLEM

mainMatrix=as.matrix(read.table(matrixName,sep=separator,header=TRUE,row.names=1))
clustering.outputM=as.matrix(read.table(clustering.output,sep=separator,header=TRUE))
geneListM=read.table(geneList,sep=separator,header=FALSE)
geneListM=gsub('\"', "", as.matrix(geneListM), fixed = TRUE)


f=data.frame(x=as.numeric(clustering.outputM[,c(3)]),y=as.numeric(clustering.outputM[,c(4)]))
fisher=read.table(pvalueFile,header=TRUE,sep=separator,row.names=1)
pdf(paste(getwd(),"/",finalName,"_fisher.pdf",sep=""))
cccc=c()
for(dj in seq(nrow(fisher))){
if(fisher[dj,1]>= threshold){
cccc=append(cccc,"red")
}
else if(fisher[dj,2]>=threshold){
cccc=append(cccc,"cyan")
}
else{
cccc=append(cccc,"black")
}
}

par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
     par(xpd=TRUE)
plot(f,col=cccc,pch=19,cex=0.5,main=paste("Fisher Threshold"))
    legend("topright", inset=c(-0.181,0.137),legend=c("Group1","Group2","No Group"),pch=20,col=c("Red","Cyan","Black"),cex=0.5)


dev.off()

system("chmod -R 777 /scratch")
