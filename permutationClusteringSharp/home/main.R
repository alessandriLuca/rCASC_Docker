 
 setwd("/home")
 
source("functions.R")
 #library("SIMLR")
 library("argparser")
 #library(dplyr)
 library("vioplot")
 library("Publish")
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "nPerm", help="Permutation number for bootstrap algorithm ")
p <- add_argument(p, "permAtTime", help="Number of permutation in parallel")
p <- add_argument(p, "percent", help="Percentage of cell removed for bootstrap algorithm ")
p <- add_argument(p, "range1", help="First cluster number ")
p <- add_argument(p, "range2", help="Last cluster number ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "log10", help="1 or 0 if is matrix is already in log10 or if is not")
p <- add_argument(p, "rK", help="1 for rankGene 0 otherwise")
p <- add_argument(p, "perplexity", help="Number of close neighbors each point has")
p <- add_argument(p, "seed", help="Seed necessary for the reproducibility")


argv <- parse_args(p)


#argv=list()
#argv$matrixName="Buettner"
#argv$nPerm=2
#argv$permAtTime=2
#argv$percent=10
#argv$range1=4
#argv$range2=4
#argv$format="csv"
#argv$separator=","
#argv$log10=0
#argv$clustering="SIMLR"
#argv$perplexity=0
#argv$seed=111
#argv$rK=1




options(bitmapType='cairo')
Sys.setenv("DISPLAY"=":0.0")
matrixName=argv$matrixName
nPerm=as.numeric(argv$nPerm)
permAtTime=as.numeric(argv$permAtTime)
percent=as.numeric(argv$percent)
format=argv$format
separator=argv$separator
logTen=as.numeric(argv$log10)
clusteringMethod="griph"
perplexity=as.numeric(argv$perplexity)
seed=as.numeric(argv$seed)
rK=as.numeric(argv$rK)

set.seed(seed)

dir.create(paste("./../scratch/",matrixName,sep=""))
nCluster=4
 
 if(clusteringMethod == "SIMLR" || clusteringMethod == "tSne"){

}else{
    if(!is.null(argv$range1)){cat(paste("\nWARNING: range1 with ",clusteringMethod," is suppose to be null\n"))}
  if(!is.null(argv$range2)){cat(paste("\nWARNING:range2 with ",clusteringMethod," is suppose to be null\n"))}
  setwd(paste("./../scratch/",matrixName,"/",sep=""))
 system(paste("cp ","/scratch","/",matrixName,".",format," ","/scratch","/",matrixName,sep="")) #AGGIUNTA

nCluster=clustering(matrixName,nPerm,permAtTime,percent,nCluster=0,logTen,format,separator,clusteringMethod,perplexity,rK)
system("rm Lvis_*")
system("rm ./../Lvis*")

setwd("./../../../home")
  setwd(paste("./../scratch/",matrixName,"/",sep=""))
  silhouettePlot(matrixName,nCluster,format,separator)

  
#dir.create("./../../data/Results")

#system("cp -r ./../* ./../../data/Results")
setwd("./../..")
#system("rm -r ./scratch/*")



}

system("chmod -R 777 ./scratch") 
system("chmod -R 777 ./data")
