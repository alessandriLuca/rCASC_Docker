 library("argparser")
 library("vioplot")
 library("SHARP")
 library("tools")
 library("Rtsne")
 
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
dir.create(paste("./",projectName,"_SHARP",sep=""))
dir.create(paste("./",projectName,"_SHARP/",nCluster,sep=""))
dir.create(paste("./",projectName,"_SHARP/",nCluster,"/permutation",sep=""))


if(separator=="tab"){separator2="\t"}else{separator2=separator}
lists=list.files(paste("./",projectName,"/",toString(nCluster),"/permutation",sep=""),pattern=paste("*denseSpace*",sep=""))
format=file_ext(lists[1])
system(paste("cp ","./",projectName,"/",matrixName,".",format," ./",projectName,"_SHARP/",sep=""))
system(paste("cp ./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,"  ./",projectName,"_SHARP/",nCluster,sep=""))
clustering.output=read.table(paste("./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,sep=""),sep=separator2,header=TRUE)
permutation=sapply(lists,FUN=function(x){
count=strsplit(x,"denseSpace")[[1]][1]
system(paste("cp ","./",projectName,"/",toString(nCluster),"/permutation/",x," ","./",projectName,"_SHARP/",nCluster,"/permutation/",sep=""))
pdf(paste("./",projectName,"_SHARP/",nCluster,"/permutation/",count,"clusteringGRIPH.pdf",sep=""))
temp=read.table(paste("./",projectName,"/",toString(nCluster),"/permutation/",x,sep=""),sep=separator2,header=TRUE,row.names=1)
res=SHARP(temp)
w=2
y=res
x1=as.matrix(cbind(w*scale(y$x0),scale(y$viE)))
if(dim(x1)[2]<=50){
flag=FALSE
}else{
flag=TRUE
}
rtsne_out=Rtsne(x1,check_duplicates=FALSE,pca=flag)
ydata=cbind(rtsne_out$Y[,1],rtsne_out$Y[,2])
if(length(colnames(clustering.output))>=2){
ydata=clustering.output[,c(3,4)]
}
newColors=rainbow(length(unique(res$pred_clusters)))
plot(ydata,col=newColors[res$pred_clusters])
dev.off()
pdf(paste("./",projectName,"_SHARP/",nCluster,"/permutation/",count,"clustering.pdf",sep=""))
plot(ydata,col=colours[clustering.output[,2]])
dev.off()
write.table(ydata,paste("./",projectName,"_SHARP/",nCluster,"/permutation/",count,"tSne.",format,sep=""),col.names=NA,sep=separator2)
return(res$pred_clusters)


})
write.table(permutation,paste("./",projectName,"_SHARP/",nCluster,"/label.",format,sep=""),col.names=NA,sep=separator2)

system("chmod -R 777 ./../scratch")
#system("cp -r * ./../data/Results")
