 
 
 library("Seurat")
 library("argparser")
 library(dplyr)
 library(Matrix)
  
 
p <- arg_parser("permutation")
p <- add_argument(p, "percent", help="matrix count name")
p <- add_argument(p, "matrixName", help="Percentage of cell removed for bootstrap algorithm ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "logTen", help="1 or 0 if is matrix is already in log10 or if is not")
p <- add_argument(p, "pcaDimensions", help="PCA dimensions")
p <- add_argument(p, "sparse", help="PCA dimensions")
p <- add_argument(p, "index", help="Clulstering method: SIMLR tSne Griph")

argv <- parse_args(p)
cat(system("pwd"))
matrixName=argv$matrixName
percent=as.numeric(argv$percent)
format=argv$format
separator=argv$separator
logTen=as.numeric(argv$logTen)
pcaDimensions=as.numeric(argv$pcaDimensions)
index=argv$index
sparse=argv$sparse

 source("./../../../home/functions.R")
#source("./../../home/functions.R")
 if(separator=="tab"){separator="\t"} #BUG CORRECTION TAB separator PROBLEM 

 if(sparse=="FALSE"){
countMatrix=as.matrix(read.table(paste("./../../",matrixName,".",format,sep=""),sep=separator,header=TRUE,row.names=1))
if(logTen==1){countMatrix=10^(countMatrix)}
 killedCell=sample(ncol(countMatrix),(ncol(countMatrix)*percent/100))
countMatrix=countMatrix[,-killedCell]

}else{
countMatrix <- Read10X(data.dir = "./..")
if(logTen==1){
stop("Sparse Matrix in Seurat has to be raw count")
}

 killedCell=sample(countMatrix@Dim[2],(countMatrix@Dim[2]*percent/100))
 countMatrix=as.matrix(countMatrix)
countMatrix=countMatrix[,-killedCell]
countMatrix=Matrix(countMatrix, sparse = TRUE) 

}








pbmc=CreateSeuratObject(countMatrix)
pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")
pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 10000)
pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)
all.genes <- rownames(pbmc)
pbmc <- ScaleData(pbmc, features = all.genes)
pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))
pbmc <- JackStraw(pbmc, num.replicate = 100)
pbmc <- ScoreJackStraw(pbmc, dims = 1:pcaDimensions)
pbmc <- FindNeighbors(pbmc, dims = 1:10)
pbmc <- FindClusters(pbmc, resolution = 0.5)
pbmc <- RunUMAP(pbmc, dims = 1:pcaDimensions)



    #TSNEPlot(object = pbmc)
mainVector=as.numeric(pbmc@active.ident)












clustering.output=mainVector

















write.table(mainVector,paste("./Permutation/clusterB_",index,".",format,sep=""),sep=separator)

write.table(killedCell,paste("./Permutation/killC_",index,".",format,sep=""),sep=separator)
rm(list=setdiff(ls(),"index"))
dir.create("./memory")
system(paste("cat /proc/meminfo >  ./memory/",index,".txt",sep=""))



