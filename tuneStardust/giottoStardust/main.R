setwd("/home")

source("functions.R")
library(Seurat)
library("argparser")
library(dplyr)
library("vioplot")
library("Publish")
library(ggplot2)
library(Giotto)
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "matrix.h5", help="matrix count name in h5 format")
p <- add_argument(p, "positions.csv", help="spot positions in csv format")
p <- add_argument(p, "n_clusters", help="how many clusters BayeSpace should search")
p <- add_argument(p, "pcaDimensions", help="PCA dimension for seurat first number")
p <- add_argument(p, "nPerm", help="Permutation number for bootstrap algorithm ")
p <- add_argument(p, "permAtTime", help="Number of permutation in parallel")
p <- add_argument(p, "percent", help="Percentage of cell removed for bootstrap algorithm ")
p <- add_argument(p, "seed", help="Seed necessary for the reproducibility")


argv <- parse_args(p)


options(bitmapType='cairo')
Sys.setenv("DISPLAY"=":0.0")
matrixName=argv$matrixName
matrix.h5=argv$matrix.h5
positions.csv=argv$positions.csv
n_clusters=argv$n_clusters
pcaDimensions=argv$pcaDimensions
nPerm=as.numeric(argv$nPerm)
permAtTime=as.numeric(argv$permAtTime)
percent=as.numeric(argv$percent)
seed=as.numeric(argv$seed)
set.seed(seed)
matrixNameBis = strsplit(matrixName,".",fixed = TRUE)[[1]][1]
dir.create(paste("./../scratch/",matrixNameBis,sep=""))
 


setwd(paste("./../scratch/",matrixNameBis,"/",sep=""))
nCluster=clustering(matrixName,matrix.h5,positions.csv,n_clusters,pcaDimensions,
    nPerm,permAtTime,percent,nCluster=0)


setwd("./../../../home")
setwd(paste("./../scratch/",matrixNameBis,"/",sep=""))
silhouettePlot(matrixNameBis,nCluster,"txt","\t")

  
#dir.create("./../../data/Results")

#system("cp -r ./../* ./../../data/Results")
setwd("./../..")
#system("rm -r ./scratch/*")





system("chmod -R 777 ./scratch") 
system("chmod -R 777 ./data")
