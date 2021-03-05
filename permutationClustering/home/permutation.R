 
 
 library("SIMLR")
 library("argparser")
 library(dplyr)
  
 
p <- arg_parser("permutation")
p <- add_argument(p, "percent", help="matrix count name")
p <- add_argument(p, "matrixName", help="Percentage of cell removed for bootstrap algorithm ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "logTen", help="1 or 0 if is matrix is already in log10 or if is not")
p <- add_argument(p, "clustering", help="Clulstering method: SIMLR tSne Griph")
p <- add_argument(p, "nCluster", help="Clulstering method: SIMLR tSne Griph")
p <- add_argument(p, "rK", help="Clulstering method: SIMLR tSne Griph")
p <- add_argument(p, "perplexity", help="Clulstering method: SIMLR tSne Griph")
p <- add_argument(p, "index", help="Clulstering method: SIMLR tSne Griph")

argv <- parse_args(p)

matrixName=argv$matrixName
percent=as.numeric(argv$percent)
format=argv$format
separator=argv$separator
logTen=as.numeric(argv$logTen)
clusteringMethod=argv$clustering
nCluster=as.numeric(argv$nCluster)
index=argv$index
perplexity=as.numeric(argv$perplexity)
rK=argv$rK
 source("./../../../home/functions.R")
if(separator=="tab"){separator="\t"} #BUG CORRECTION TAB separator PROBLEM 

countMatrix=as.matrix(read.table(paste("./../",matrixName,".",format,sep=""),sep=separator,header=TRUE,row.names=1))
killedCell=sample(ncol(countMatrix),(ncol(countMatrix)*percent/100))
countMatrix=countMatrix[,-killedCell]

if(logTen==0){countMatrix=log10(countMatrix+1)}

switch(clusteringMethod, 
SIMLR={
if(rK==1){
 tt=try(simlrF2(countMatrix,nCluster,index))
 }else{ tt=try(simlrF(countMatrix,nCluster))}
 if(class(tt)=="try-error"){
  system(paste("nohup Rscript ./../../../home/permutation.R ",percent," ",matrixName," ",format," ",separator," ",logTen," ",clusteringMethod," ",nCluster," ",rK," ",perplexity," ",index," & ",sep=""))


 }else{
 clustering.output=tt
 }

},
griph={

 tt=try(griphF(countMatrix))
 if(class(tt)=="try-error"){
  system(paste("nohup Rscript ./../../../home/permutation.R ",percent," ",matrixName," ",format," ",separator," ",logTen," ",clusteringMethod," ",nCluster," ",rK," ",perplexity," ",index," & ",sep=""))


 }else{
 clustering.output=tt
 }






#clustering.output=silhouette(nCluster,clustering.output)
},
tSne={

 tt=try(tsneF(countMatrix,nCluster,perplexity))
 if(class(tt)=="try-error"){
  system(paste("nohup Rscript ./../../../home/permutation.R ",percent," ",matrixName," ",format," ",separator," ",logTen," ",clusteringMethod," ",nCluster," ",rK," ",perplexity," ",index," & ",sep=""))


 }else{
 clustering.output=tt
 }

 
}
)

rel.matrix=relationMatrix(as.numeric(clustering.output[,2]),clustering.output[,1])

write.table(clustering.output[,2],paste("./Permutation/clusterB_",index,".",format,sep=""),sep=separator)

write.table(killedCell,paste("./Permutation/killC_",index,".",format,sep=""),sep=separator)
rm(list=setdiff(ls(),"index"))
dir.create("./memory")
system(paste("cat /proc/meminfo >  ./memory/",index,".txt",sep=""))



