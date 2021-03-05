 
 
 library("SIMLR")
 library("argparser")
 library(dplyr)
  
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="Percentage of cell removed for bootstrap algorithm ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "nCluster", help="Clulstering method: SIMLR tSne Griph")
p <- add_argument(p, "projectName", help="Clulstering method: SIMLR tSne Griph")
p <- add_argument(p, "x", help="Clulstering method: SIMLR tSne Griph")


argv <- parse_args(p)

matrixName=argv$matrixName
format=argv$format
separator=argv$separator
nCluster=as.numeric(argv$nCluster)
projectName=argv$projectName
colours=rainbow(nCluster)
x=as.numeric(argv$x) #PRIMO CAMBIAMENTO 
lists=list.files(paste("./",projectName,"/",toString(nCluster),"/permutation",sep=""),pattern=paste("*denseSpace*",sep="")) #SECONDO CAMBIAMENTO
#lists=list.files(paste("./",projectName,"_SIMLR/",toString(nCluster),"/permutation",sep=""),pattern=paste("*denseSpace*",sep=""))
x=lists[x] #TERZO CAMBIAMENTO 

if(separator=="tab"){separator2="\t"}else{separator2=separator} #BUG CORRECTION TAB separator PROBLEM 
setwd("/scratch")

clustering.output=read.table(paste("./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,sep=""),sep=separator2,header=TRUE)

count=strsplit(x,"denseSpace")[[1]][1]
system(paste("cp ","./",projectName,"/",toString(nCluster),"/permutation/",x," ","./",projectName,"_SIMLR/",nCluster,"/permutation/",sep=""))
pdf(paste("./",projectName,"_SIMLR/",nCluster,"/permutation/",count,"clusteringSIMLR.pdf",sep=""))
temp=read.table(paste("./",projectName,"/",toString(nCluster),"/permutation/",x,sep=""),sep=separator2,header=TRUE,row.names=1)
#temp=temp[,seq(1,100)]
res=SIMLR(temp,nCluster,cores.ratio = 0)
ydata=res$ydata
if(length(colnames(clustering.output))>=2){
ydata=clustering.output[,c(3,4)]
}
plot(ydata,col=colours[res$y$cluster])
dev.off()
pdf(paste("./",projectName,"_SIMLR/",nCluster,"/permutation/",count,"clustering.pdf",sep=""))
plot(ydata,col=colours[clustering.output[,2]])
dev.off()
write.table(ydata,paste("./",projectName,"_SIMLR/",nCluster,"/permutation/",count,"tSne.",format,sep=""),col.names=NA,sep=separator2)
write.table(res$y$cluster,paste("./",projectName,"_SIMLR/",nCluster,"/permutation/TEMP/",count,".",format,sep=""),row.names=FALSE,col.names=FALSE)

rm(list=setdiff(ls(),"index"))



