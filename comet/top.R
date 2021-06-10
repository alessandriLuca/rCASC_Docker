 setwd("/home")

library("argparser")
library("edgeR")
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "log10", help="1 or 0 if is matrix is already in log10 or if is not")
p <- add_argument(p, "threshold", help="")
p <- add_argument(p, "type", help="")


argv <- parse_args(p)

setwd("./../data")





matrixName=argv$matrixName
format=argv$format
separator=argv$separator

logTen=(argv$log10)
if(logTen=="TRUE"){logTen=1}else{logTen=0}
if(separator=="tab"){separator2="\t"}else{separator2=separator} #BUG CORRECTION TAB PROBLEM
threshold=as.numeric(argv$threshold)
type=argv$type

a=read.table(paste(matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.names=1)
tmp=a
if(logTen==1){
a=10^(a)

}
if(type=="variance"){
group=rep(1,ncol(a))
 dge <- DGEList(counts=a,group)
     dge <- estimateCommonDisp(dge)
     dge <- estimateTagwiseDisp(dge)

     sorted=head(sort(dge$tagwise.dispersion,TRUE,index.return = TRUE)$ix,threshold)

a=a[sorted,]

}else{
  sum.counts <- apply(a, 1, sum)
  a <- data.frame(a, sum.counts)
  a <- a[order(a$sum.counts, decreasing = T),]


  if(threshold>(dim(tmp)[1])){threshold=dim(tmp)[1]
  print("WARNING THRESHOLD IS THE SAME AS THE MATRIX ROW NUMBER")
  }
  a <- a[1:threshold,1:(dim(a)[2]-1)]

}

pdf(paste(matrixName,"_",type,"_gene_expression_distribution.pdf",sep=""))
  sum.countsNew <- apply(a, 1, sum)
    sum.counts <- apply(tmp, 1, sum)

    hist(log10(sum.counts), col=rgb(1,0,0,0.5), xlab="log10 gene counts summary", breaks=100)
    hist(log10(sum.countsNew), col=rgb(0,0,1,0.5), breaks=100)
    legend("topright",legend=c("All","Filtered"), pch=c(15,15), col=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)))
    box()

  dev.off()
    write.table(a,paste("filtered_",type,"_",matrixName,".",format,sep=""), sep=separator2, col.names = NA)

system("chmod -R 777 /data/*")