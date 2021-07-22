library(edgeR)
args = commandArgs(trailingOnly=TRUE)
setwd("/scratch")
#counts.table="setA"
#file.type="csv"
#sep=","
#cluster.file="setA_clustering.output"
#ref.cluster=3
#logCPM.threshold=4
#FDR.threshold = 0.05
#logFC.threshold=1
#plot="TRUE"

counts.table <- args[1]
file.type <- args[2]
sep <- args[3]
cluster.file <- args[4]
ref.cluster <- as.numeric(args[5])
logCPM.threshold <- as.numeric(args[6])
FDR.threshold <- as.numeric(args[7])
logFC.threshold <- as.numeric(args[8])
plot=args[9]
if(plot=="TRUE"){plot=TRUE}else{plot=FALSE}
if(sep=="tab"){sep="\t"}
if(sep=="comma"){sep=","}

#1 
counts <- read.table(paste(counts.table,".",file.type,sep=""), sep=sep, header=T, row.names=1, stringsAsFactors = F)
names(counts) <- gsub("_","-",names(counts))
clusters <- read.table(paste(cluster.file,".",file.type,sep=""), sep=sep, header=T, row.names=1, stringsAsFactors = F)
       rownames(clusters) <- gsub("_","-",rownames(clusters))

       if(!identical(names(counts), rownames(clusters))){
            clusters <- clusters[order(rownames(clusters)),]
            counts <- counts[,order(names(counts))]
       }
       names(counts) <- paste(names(counts), clusters$Belonging_Cluster, sep="_")
       ref <- counts[,grep(paste("_",ref.cluster,'$', sep=""), names(counts))]
      others <- counts[,setdiff(seq(1,dim(counts)[2]),grep(paste("_",ref.cluster,"$",sep=""), names(counts)))]        
      tmp.n <- as.numeric(sapply(strsplit(names(others), "_"), function(x)x[2]))
       others <- others[,order(tmp.n)]
       counts <- data.frame(ref, others, check.names = F)
 x =counts     
       
       
#2
groups <- strsplit(names(x),"_")
groups <- sapply(groups, function(x)x[2])
groups <- factor(groups)

#groups <- factor(as.numeric(unlist(strsplit(groups, "_"))))
#x <- read.table(matrixName, sep="\t", header=T, row.names=1)
library(edgeR)
y <- DGEList(counts=x, group=groups)
design <- model.matrix(~groups, data=y$samples)
y <- calcNormFactors(y)
y <- estimateDisp(y, design)

fit <- glmQLFit(y, design)
if(length(levels(y$samples$group))>2){
    qlf <- glmQLFTest(fit, coef=2:length(levels(y$samples$group)))
}else{
    qlf <- glmQLFTest(fit, coef=1:2)
}
output <- topTags(qlf, n=dim(y$counts)[1], adjust.method="BH", sort.by="PValue", p.value=1)
write.table(output, paste("DE_", counts.table,".",file.type,sep=""), sep=sep, col.names=NA)


#3
tmp0 <- read.table(paste("DE_", counts.table,".",file.type,sep=""), sep=sep, header=T, row.names=1)
  max0.logfc.tmp <- apply(tmp0[,grep("logFC", names(tmp0))], 1, function(x) unique(x[which(abs(x)== max(abs(x)))]))
  max0.logfc <- sapply(max0.logfc.tmp, function(x)as.numeric(x[[1]]))

  tmp <- tmp0[which(tmp0$logCPM >= logCPM.threshold),]
  max.logfc <- apply(tmp[,grep("logFC", names(tmp))], 1, function(x) max(abs(x)))
  tmp <- tmp[which(max.logfc >= logFC.threshold),]
  tmp <- tmp[which(tmp$FDR <= FDR.threshold),]
  max1.logfc.tmp <- apply(tmp[,grep("logFC", names(tmp))], 1, function(x){
    x[which(abs(x)== max(abs(x)))]
  })
  max1.logfc <- sapply(max1.logfc.tmp, function(x)as.numeric(x[[1]]))
  if(plot){
  	pdf("filteredDE.pdf")
    	plot(tmp0$logCPM, max0.logfc, xlab="log2CPM", ylab="log2FC", type="n")
    	points(tmp$logCPM, max1.logfc, pch=19, cex=0.5, col="red")
    	points(tmp0$logCPM, max0.logfc, pch=".", col="black")
    	abline(h=0, col="black", lty=2)
  	  dev.off()
 }
write.table(tmp, paste("filtered_DE_", counts.table,".",file.type,sep=""), sep=sep, col.names=NA)


#4
  de.full <- read.table(paste("filtered_DE_", sub(".txt","_reordered.txt", counts.table),".",file.type, sep=""), sep=sep, header=T, row.names=1, stringsAsFactors = F)
       others.nu <- unique(as.numeric(sapply(strsplit(names(others), "_"), function(x)x[2])))
       others.nu <- paste(rep("C",length(others.nu)),others.nu, sep="")
       de <- de.full[,1:length(others.nu)]
       names(de) <- others.nu
       names(de.full) <- c(others.nu, c( "logCPM", "F", "PValue", "FDR"))
       write.table(de, paste("logFC_filtered_DE_", sub(".txt","_reordered.txt", counts.table),".",file.type,sep=""), sep=sep, col.names = NA)
       write.table(de.full, paste("filtered_DE_", sub(".txt","_reordered.txt", counts.table),".",file.type, sep=""), sep=sep, col.names = NA)
system("chmod 777 /scratch/*")

       
