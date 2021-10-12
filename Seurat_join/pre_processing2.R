library(Seurat)
library(cowplot)
library(patchwork)
 library("argparser")
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "format", help="matrix count name")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "matrixName2", help="matrix count name")
p <- add_argument(p, "format2", help="matrix count name")
p <- add_argument(p, "separator2", help="matrix separator ")

p <- add_argument(p, "seed", help="Similarity Percentage ")


argv <- parse_args(p)

#argv=list()
#argv$matrixName="setA"
#argv$format="csv"
#argv$separator=","

#argv$matrixName2="set1"
#argv$format2="csv"
#argv$separator2=","

#argv$seed=1111
setwd("/scratch")
matrixName=argv$matrixName
format=argv$format
separator=argv$separator
matrixName2=argv$matrixName2
format2=argv$format2
separator2=argv$separator2
set.seed(as.numeric(argv$seed))


if(separator=="tab"){
separator="\t"
}
if(separator2=="tab"){
separator2="\t"
}
D1=read.table(paste(matrixName,".",format,sep=""),header=TRUE,row.names=1,sep=separator)
temp=strsplit(colnames(D1),"[.]")
temp=sapply(temp,FUN=function(x){
paste(x[seq(length(x)-1)],"_X_.",x[length(x)],sep="")

})
colnames(D1)=temp

D2=read.table(paste(matrixName2,".",format2,sep=""),header=TRUE,row.names=1,sep=separator2)
temp=strsplit(colnames(D2),"[.]")
temp=sapply(temp,FUN=function(x){
paste(x[seq(length(x)-1)],"_Y_.",x[length(x)],sep="")

})
colnames(D2)=temp
D1=CreateSeuratObject(D1)
D2=CreateSeuratObject(D2)
D=list(D1,D2)

D <- lapply(X = D, FUN = function(x) {
    x <- NormalizeData(x)
    x <- FindVariableFeatures(x, selection.method = "vst", nfeatures = 2000)
})

immune.anchors <- FindIntegrationAnchors(object.list = D, dims = 1:20)
immune.combined <- IntegrateData(anchorset = immune.anchors, dims = 1:20)
DefaultAssay(immune.combined) <- "integrated"
integrated <- GetAssayData(object = immune.combined, assay = "integrated", slot = "data")
write.table(integrated,paste(matrixName,"_",matrixName2,"_AnchorCorrection.",format,sep=""),sep=separator,col.names=NA)
system("chmod -R 777 ./*")
