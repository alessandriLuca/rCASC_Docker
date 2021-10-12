library(Seurat)
library(cowplot)
library(patchwork)
 library("argparser")
p <- arg_parser("permutation")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "format", help="matrix separator ")
argv <- parse_args(p)

setwd("/scratch")
separator=argv$separator
format=argv$format

if(separator=="tab"){
separator="\t"
}
listlist=list()
listMatrix=list.files(pattern=format)
count=1
alphabeth=c("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","AA","AB","AC","AD","AE")
for(i in listMatrix){
  
D1=read.table(i,header=TRUE,row.names=1,sep=separator)
temp=strsplit(colnames(D1),"[.]")

letter=alphabeth[count]
temp=sapply(temp,FUN=function(x){
paste(x[seq(length(x)-1)],"_",letter,"_.",x[length(x)],sep="")

})
colnames(D1)=temp
D1=CreateSeuratObject(D1)
listlist[[count]]=D1
count=count+1
}


D <- lapply(X = listlist, FUN = function(x) {
    x <- NormalizeData(x)
    x <- FindVariableFeatures(x, selection.method = "vst", nfeatures = 2000)
})

immune.anchors <- FindIntegrationAnchors(object.list = D, dims = 1:20)
immune.combined <- IntegrateData(anchorset = immune.anchors, dims = 1:20)
DefaultAssay(immune.combined) <- "integrated"
integrated <- GetAssayData(object = immune.combined, assay = "integrated", slot = "data")
write.table(integrated,paste("full_AnchorCorrection.csv",sep=""),sep=separator,col.names=NA)
system("chmod -R 777 ./*")
