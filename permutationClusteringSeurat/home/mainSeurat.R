 library("argparser")
 library("vioplot")
 library("Seurat")
 library("tools")
 
 
p <- arg_parser("permutation")
p <- add_argument(p, "projectName", help="matrix count name")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "nCluster", help="Similarity Percentage ")
p <- add_argument(p, "pcaDimensions", help="Similarity Percentage ")
p <- add_argument(p, "seed", help="Similarity Percentage ")


argv <- parse_args(p)



projectName=argv$projectName
separator=argv$separator
nCluster=as.numeric(argv$nCluster)
colours=rainbow(nCluster)
matrixName=argv$matrixName
pcaDimensions=as.numeric(argv$pcaDimensions)
set.seed(as.numeric(argv$seed))

setwd("./../scratch")
dir.create(paste("./",projectName,"_SEURAT",sep=""))
dir.create(paste("./",projectName,"_SEURAT/",nCluster,sep=""))
dir.create(paste("./",projectName,"_SEURAT/",nCluster,"/permutation",sep=""))


if(separator=="tab"){separator2="\t"}else{separator2=separator}
lists=list.files(paste("./",projectName,"/",toString(nCluster),"/permutation",sep=""),pattern=paste("*denseSpace*",sep=""))
format=file_ext(lists[1])
system(paste("cp ","./",projectName,"/",matrixName,".",format," ./",projectName,"_SEURAT/",sep=""))
system(paste("cp ./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,"  ./",projectName,"_SEURAT/",nCluster,sep=""))
clustering.output=read.table(paste("./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,sep=""),sep=separator2,header=TRUE)
permutation=sapply(lists,FUN=function(x){
count=strsplit(x,"denseSpace")[[1]][1]
system(paste("cp ","./",projectName,"/",toString(nCluster),"/permutation/",x," ","./",projectName,"_SEURAT/",nCluster,"/permutation/",sep=""))
pdf(paste("./",projectName,"_SEURAT/",nCluster,"/permutation/",count,"clusteringSEURAT.pdf",sep=""))
temp=read.table(paste("./",projectName,"/",toString(nCluster),"/permutation/",x,sep=""),sep=separator2,header=TRUE,row.names=1)
temp=temp*1000000
countMatrix=temp
pbmc=CreateSeuratObject(countMatrix)
mito.genes <- grep(pattern = "^MT-", x = rownames(temp), value = TRUE)
percent.mito <- Matrix::colSums(temp[mito.genes, ])/Matrix::colSums(temp)
pbmc <- AddMetaData(object = pbmc, metadata = percent.mito, col.name = "percent.mito")
pbmc <- NormalizeData(object = pbmc, normalization.method = "LogNormalize",scale.factor = 10000)
pbmc <- FindVariableGenes(object = pbmc, mean.function = ExpMean, dispersion.function = LogVMR, x.low.cutoff = 0.0125, x.high.cutoff = 3, y.cutoff = 0.5,do.plot = FALSE)
pbmc <- ScaleData(object = pbmc, vars.to.regress = c("nUMI", "percent.mito"))
pbmc <- RunPCA(object = pbmc, pc.genes = pbmc@var.genes, do.print = FALSE, pcs.print = 1:5, 
    genes.print = 5)
pbmc <- ProjectPCA(object = pbmc, do.print = FALSE)
pbmc <- JackStraw(object = pbmc, num.replicate = 100, display.progress = FALSE,num.pc=pcaDimensions)
DimElbowPlot2=function (object, reduction.type = "pca", dims.plot = 20, xlab = "", 
    ylab = "", title = "") 
{
    data.use <- GetDimReduction(object = object, reduction.type = reduction.type, 
        slot = "sdev")
    if (length(data.use) == 0) {
        stop(paste("No standard deviation info stored for", reduction.type))
    }
    if (length(x = data.use) < dims.plot) {
        warning(paste("The object only has information for", 
            length(x = data.use), "PCs."))
        dims.plot <- length(x = data.use)
    }
    data.use <- data.use[1:dims.plot]
    dims <- 1:length(x = data.use)
    data.plot <- data.frame(dims, data.use)
    return(cbind(dims,data.use))

}


PCElbowPlot2= function (object, num.pc = 20) 
{
    return(DimElbowPlot2(object = object, reduction.type = "pca", 
        dims.plot = num.pc))
}
sdPC=PCElbowPlot2(pbmc)[,2]
#pdf("PCE_bowPlot.pdf")
#PCElbowPlot(object = pbmc)
#dev.off()

if(pcaDimensions==0){
pcaDimensions=which.max(abs(diff(sdPC)-mean(diff(sdPC))))
if(pcaDimensions==1){pcaDimensions=2}
}

pbmc <- FindClusters(object = pbmc, reduction.type = "pca", dims.use =seq(1,pcaDimensions), 
    resolution = 0.6, print.output = 0, save.SNN = TRUE)
    
    pbmc <- RunTSNE(object = pbmc, dims.use =seq(1,pcaDimensions), do.fast = TRUE)
    #TSNEPlot(object = pbmc)
mainVector=as.numeric(pbmc@ident) 
ydata=pbmc@dr$tsne@cell.embeddings
if(length(colnames(clustering.output))>=2){
ydata=clustering.output[,c(3,4)]
}




newColors=rainbow(length(unique(mainVector)))
plot(ydata,col=newColors[mainVector])
dev.off()
pdf(paste("./",projectName,"_SEURAT/",nCluster,"/permutation/",count,"clustering.pdf",sep=""))
plot(ydata,col=colours[clustering.output[,2]])
dev.off()
write.table(ydata,paste("./",projectName,"_SEURAT/",nCluster,"/permutation/",count,"tSne.",format,sep=""),col.names=NA,sep=separator2)
return(mainVector)


})
write.table(permutation,paste("./",projectName,"_SEURAT/",nCluster,"/label.",format,sep=""),col.names=NA,sep=separator2)

system("chmod -R 777 ./../scratch")
#system("cp -r * ./../data/Results")
