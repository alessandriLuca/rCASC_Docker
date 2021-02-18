library(Seurat)
library(cowplot)
library(patchwork)
 library("argparser")
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "format", help="matrix count name")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "seed", help="Similarity Percentage ")


argv <- parse_args(p)

argv=list()
argv$matrixName="setA"
argv$format="csv"
argv$separator=","

argv$matrixName2="set1"
argv$format2="csv"
argv$separator2=","

argv$seed=1111
setwd("/scratch")
matrixName=argv$matrixName
format=argv$format
separator=argv$separator



if(separator=="tab"){
separator="\t"
}


D1=read.table(paste(matrixName,".",format,sep=""),header=TRUE,row.names=1,sep=separator)
if(length(strsplit(rownames(D1)[1],":")[[1]])>1){
rownames(D1)=make.unique(sapply(rownames(D1),FUN=function(x){
strsplit(x,":")[[1]][2]

}))

}
marrow <- CreateSeuratObject(counts = D1)
s.genes <- cc.genes$s.genes
g2m.genes <- cc.genes$g2m.genes
marrow <- CreateSeuratObject(counts = D1)
marrow <- NormalizeData(marrow)
marrow <- FindVariableFeatures(marrow, selection.method = "vst")
marrow <- ScaleData(marrow, features = rownames(marrow))
marrow <- RunPCA(marrow, features = VariableFeatures(marrow), ndims.print = 6:10, nfeatures.print = 10)
DimHeatmap(marrow, dims = c(8, 10))
marrow <- CellCycleScoring(marrow, s.features = s.genes, g2m.features = g2m.genes, set.ident = TRUE)
write.table(marrow$Phase,paste(matrixName,"_cellCycle.",format,sep=""),sep=separator,col.names=FALSE)
dev.off()

system("chmod -R 777 ./*")
