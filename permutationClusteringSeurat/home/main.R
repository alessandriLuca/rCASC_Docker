 
 setwd("/home")
 
source("functions.R")
 library(Seurat)
 library("argparser")
 library(dplyr)
 library("vioplot")
 library("Publish")
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "nPerm", help="Permutation number for bootstrap algorithm ")
p <- add_argument(p, "permAtTime", help="Number of permutation in parallel")
p <- add_argument(p, "percent", help="Percentage of cell removed for bootstrap algorithm ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "log10", help="1 or 0 if is matrix is already in log10 or if is not")
p <- add_argument(p, "pcaDimensions", help="PCA dimension for seurat first number")
p <- add_argument(p, "seed", help="Seed necessary for the reproducibility")
p <- add_argument(p, "sparse", help="Seed necessary for the reproducibility")


argv <- parse_args(p)


#argv=list()
#argv$matrixName="annotated_setPace_10000"
#argv$nPerm=2
#argv$permAtTime=2
#argv$percent=10
#argv$format="txt"
#argv$separator="tab"
#argv$log10=0
#argv$seed=111
#argv$pcaDimensions=5




options(bitmapType='cairo')
Sys.setenv("DISPLAY"=":0.0")
matrixName=argv$matrixName
nPerm=as.numeric(argv$nPerm)
permAtTime=as.numeric(argv$permAtTime)
percent=as.numeric(argv$percent)
format=argv$format
separator=argv$separator
logTen=as.numeric(argv$log10)
seed=as.numeric(argv$seed)
pcaDimensions=as.numeric(argv$pcaDimensions)
set.seed(seed)
sparse=argv$sparse
dir.create(paste("./../scratch/",matrixName,sep=""))
 


  setwd(paste("./../scratch/",matrixName,"/",sep=""))
nCluster=clustering(matrixName,nPerm,permAtTime,percent,nCluster=0,logTen,format,separator,pcaDimensions)


setwd("./../../../home")
  setwd(paste("./../scratch/",matrixName,"/",sep=""))
  silhouettePlot(matrixName,nCluster,format,separator)

  
#dir.create("./../../data/Results")

#system("cp -r ./../* ./../../data/Results")
setwd("./../..")
#system("rm -r ./scratch/*")





system("chmod -R 777 ./scratch") 
system("chmod -R 777 ./data")
