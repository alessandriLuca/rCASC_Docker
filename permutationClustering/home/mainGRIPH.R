 library("argparser")
 library("vioplot")
 library("griph")
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
dir.create(paste("./",projectName,"_GRIPH",sep=""))
dir.create(paste("./",projectName,"_GRIPH/",nCluster,sep=""))
dir.create(paste("./",projectName,"_GRIPH/",nCluster,"/permutation",sep=""))


if(separator=="tab"){separator2="\t"}else{separator2=separator}
lists=list.files(paste("./",projectName,"/",toString(nCluster),"/permutation",sep=""),pattern=paste("*denseSpace*",sep=""))
format=file_ext(lists[1])
system(paste("cp ","./",projectName,"/",matrixName,".",format," ./",projectName,"_GRIPH/",sep=""))
system(paste("cp ./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,"  ./",projectName,"_GRIPH/",nCluster,sep=""))
clustering.output=read.table(paste("./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,sep=""),sep=separator2,header=TRUE)
permutation=sapply(lists,FUN=function(x){
count=strsplit(x,"denseSpace")[[1]][1]
system(paste("cp ","./",projectName,"/",toString(nCluster),"/permutation/",x," ","./",projectName,"_GRIPH/",nCluster,"/permutation/",sep=""))
pdf(paste("./",projectName,"_GRIPH/",nCluster,"/permutation/",count,"clusteringGRIPH.pdf",sep=""))
temp=read.table(paste("./",projectName,"/",toString(nCluster),"/permutation/",x,sep=""),sep=separator2,header=TRUE,row.names=1)
res=griph_cluster(as.matrix(temp),image.format="pdf",use.par=FALSE)
ydata=cbind(res$plotLVis[,1],res$plotLVis[,2])
if(length(colnames(clustering.output))>=2){
ydata=clustering.output[,c(3,4)]
}
newColors=rainbow(length(unique(res$MEMB)))
plot(ydata,col=newColors[res$MEMB])
dev.off()
pdf(paste("./",projectName,"_GRIPH/",nCluster,"/permutation/",count,"clustering.pdf",sep=""))
plot(ydata,col=colours[clustering.output[,2]])
dev.off()
write.table(ydata,paste("./",projectName,"_GRIPH/",nCluster,"/permutation/",count,"tSne.",format,sep=""),col.names=NA,sep=separator2)
return(res$MEMB)


})
write.table(permutation,paste("./",projectName,"_GRIPH/",nCluster,"/label.",format,sep=""),col.names=NA,sep=separator2)

system("chmod -R 777 ./../scratch")
#system("cp -r * ./../data/Results")
