 
 
 library("Seurat")
 library("argparser")
 library(dplyr)
  
 
p <- arg_parser("permutation")
p <- add_argument(p, "percent", help="matrix count name")
p <- add_argument(p, "matrixName", help="Percentage of cell removed for bootstrap algorithm ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "logTen", help="1 or 0 if is matrix is already in log10 or if is not")
p <- add_argument(p, "pcaDimensions", help="PCA dimensions")
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


 source("./../../../home/functions.R")
#source("./../../home/functions.R")
 if(separator=="tab"){separator="\t"} #BUG CORRECTION TAB separator PROBLEM 

countMatrix=as.matrix(read.table(paste("./../../",matrixName,".",format,sep=""),sep=separator,header=TRUE,row.names=1))
killedCell=sample(ncol(countMatrix),(ncol(countMatrix)*percent/100))
countMatrix=countMatrix[,-killedCell]










if(logTen==1){countMatrix=10^(countMatrix)}
pbmc=CreateSeuratObject(countMatrix)
mito.genes <- grep(pattern = "^MT-", x = rownames(x = pbmc@data), value = TRUE)
percent.mito <- Matrix::colSums(pbmc@raw.data[mito.genes, ])/Matrix::colSums(pbmc@raw.data)

# AddMetaData adds columns to object@meta.data, and is a great place to
# stash QC stats
pbmc <- AddMetaData(object = pbmc, metadata = percent.mito, col.name = "percent.mito")
#pbmc <- FilterCells(object = pbmc, subset.names = c("nGene", "percent.mito"), 
#    low.thresholds = c(200, -Inf), high.thresholds = c(2500, 0.05))

pbmc <- NormalizeData(object = pbmc, normalization.method = "LogNormalize", 
    scale.factor = 10000)
pbmc <- FindVariableGenes(object = pbmc, mean.function = ExpMean, dispersion.function = LogVMR, 
    x.low.cutoff = 0.0125, x.high.cutoff = 3, y.cutoff = 0.5,do.plot = FALSE)
pbmc <- ScaleData(object = pbmc, vars.to.regress = c("nUMI", "percent.mito"))


pbmc <- RunPCA(object = pbmc, pc.genes = pbmc@var.genes, do.print = FALSE, pcs.print = 1:5, 
    genes.print = 5)
    
pbmc <- ProjectPCA(object = pbmc, do.print = FALSE)
pbmc <- JackStraw(object = pbmc, num.replicate = 100, display.progress = FALSE,num.pc=20)



pbmc <- FindClusters(object = pbmc, reduction.type = "pca", dims.use =seq(1,pcaDimensions), 
    resolution = 0.6, print.output = 0, save.SNN = TRUE)
    
    pbmc <- RunTSNE(object = pbmc, dims.use =seq(1,pcaDimensions), do.fast = TRUE)
mainVector=pbmc@ident 













clustering.output=mainVector

















write.table(mainVector,paste("./Permutation/clusterB_",index,".",format,sep=""),sep=separator)

write.table(killedCell,paste("./Permutation/killC_",index,".",format,sep=""),sep=separator)
rm(list=setdiff(ls(),"index"))
dir.create("./memory")
system(paste("cat /proc/meminfo >  ./memory/",index,".txt",sep=""))



