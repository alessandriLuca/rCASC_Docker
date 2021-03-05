 library("argparser")
 library("vioplot")
 library("SIMLR")
 library("tools")
 
 
p <- arg_parser("permutation")
p <- add_argument(p, "projectName", help="matrix count name")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "nCluster", help="Similarity Percentage ")
p <- add_argument(p, "seed", help="Similarity Percentage ")


argv <- parse_args(p)



projectName=argv$projectName
separator=argv$separator
nCluster=as.numeric(argv$nCluster)
colours=rainbow(nCluster)
matrixName=argv$matrixName
set.seed(as.numeric(argv$seed))


setwd("./../scratch")
dir.create(paste("./",projectName,"_SIMLR",sep=""))
dir.create(paste("./",projectName,"_SIMLR/",nCluster,sep=""))
dir.create(paste("./",projectName,"_SIMLR/",nCluster,"/permutation",sep=""))


if(separator=="tab"){separator2="\t"}else{separator2=separator}
lists=list.files(paste("./",projectName,"/",toString(nCluster),"/permutation",sep=""),pattern=paste("*denseSpace*",sep=""))
format=file_ext(lists[1])
system(paste("cp ","./",projectName,"/",matrixName,".",format," ./",projectName,"_SIMLR/",sep=""))
system(paste("cp ./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,"  ./",projectName,"_SIMLR/",nCluster,sep=""))
clustering.output=read.table(paste("./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,sep=""),sep=separator2,header=TRUE)
permutation=sapply(lists,FUN=function(x){
count=strsplit(x,"denseSpace")[[1]][1]
system(paste("cp ","./",projectName,"/",toString(nCluster),"/permutation/",x," ","./",projectName,"_SIMLR/",nCluster,"/permutation/",sep=""))
pdf(paste("./",projectName,"_SIMLR/",nCluster,"/permutation/",count,"clusteringSIMLR.pdf",sep=""))
temp=read.table(paste("./",projectName,"/",toString(nCluster),"/permutation/",x,sep=""),sep=separator2,header=TRUE,row.names=1)
res=SIMLR(temp,nCluster)
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
return(res$y$cluster)


})
write.table(permutation,paste("./",projectName,"_SIMLR/",nCluster,"/label.",format,sep=""),col.names=NA,sep=separator2)

system("chmod -R 777 ./../scratch")
#system("cp -r * ./../data/Results")
