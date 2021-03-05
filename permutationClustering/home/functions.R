 library("griph")
griph_cluster2=function (DM, K = NULL, SamplingSize = NULL, ref.iter = 1, use.par = TRUE, 
    ncores = "all", filter = TRUE, rho = 0.25, batch.penalty = 0.5, 
    seed = 127350, ClassAssignment = rep(1, ncol(DM)), BatchAssignment = NULL, 
    ncom = NULL, plot_ = TRUE, maxG = 2500, fsuffix = NULL, image.format = "png") 
{
    if (ref.iter == 0 && !is.null(SamplingSize) && ncol(DM) > 
        SamplingSize) 
        warning("only ", SamplingSize, " of ", ncol(DM), " cells selected for clustering")
    ptm <- proc.time()
    set.seed(seed = seed)
    params <- as.list(environment())
    params$plot_ <- FALSE
    if (is.null(rownames(DM))) {
        rownames(DM) <- c(1:nrow(DM))
        params$DM <- DM
    }
    if (is.null(colnames(DM))) {
        colnames(DM) <- c(1:ncol(DM))
        params$DM <- DM
    }
    if (ncol(DM) < 300) {
        use.par <- FALSE
        params$use.par <- FALSE
    }
    if (is.null(SamplingSize)) {
        params$SamplingSize <- max(500, min(2000, ceiling(ncol(DM)/2)))
    }
    SPearsonCor <- sparse.cor
    PPearsonCor <- stats::cor
    PSpearmanCor <- PSpcor
    PHellinger <- PHellingerMat
    PCanberra <- PCanberraMat
    ShrinkCor <- corpcor::cor.shrink
    if (length(ClassAssignment) != ncol(DM)) 
        stop("length(ClassAssignment) must be equal to ncol(DM)")
    if (!is.null(BatchAssignment) && length(BatchAssignment) != 
        ncol(DM)) 
        stop("length(BatchAssignment) must be equal to ncol(DM)")
    if (isTRUE(use.par)) {
        SPearsonCor <- FlashSPearsonCor
        PPearsonCor <- if (checkOpenMP()) 
            FlashPPearsonCorOMP
        else FlashPPearsonCor
        PSpearmanCor <- if (checkOpenMP()) 
            FlashPSpearmanCorOMP
        else FlashPSpearmanCor
        PHellinger <- if (checkOpenMP()) 
            FlashPHellingerOMP
        else FlashPHellinger
        PCanberra <- if (checkOpenMP()) 
            FlashPCanberraOMP
        else FlashPCanberra
        ShrinkCor <- FlashShrinkCor
        if (ncores == "all") {
            ncores <- parallel::detectCores()
            ncores <- min(ceiling(0.9 * ncores), ceiling(ncol(DM)/200))
        }
        else {
            ncores <- min(ncores, parallel::detectCores(), ceiling(ncol(DM)/200))
        }
        cl <- parallel::makeCluster(ncores)
        doParallel::registerDoParallel(cl)
    }
    tryCatch({
        for (i in 0:ref.iter) {
            if (i == 0) {
                if (ref.iter == 0) {
                  params$ncom <- ncom
                }
                Gcounts <- colSums(DM > 0)
                LowQual <- which(Gcounts <= quantile(Gcounts, 
                  0.01))
                if ((ncol(DM) - length(LowQual)) > params$SamplingSize) {
                  SMPL <- sample((1:ncol(DM))[-LowQual], params$SamplingSize)
                }
                else {
                  SMPL <- c(1:ncol(DM))[-LowQual]
                }
                message("Preprocessing...", appendLF = FALSE)
                NoData <- which(colSums(DM[, SMPL]) == 0)
                if (length(NoData > 0)) {
                  SMPL <- SMPL[-NoData]
                }
                params$DM <- DM[, SMPL]
                AllZeroRows <- which(rowSums(params$DM) < 1e-09)
                if (length(AllZeroRows) > 0) {
                  params$DM <- params$DM[-AllZeroRows, ]
                }
                meanDM <- mean(params$DM)
                nSD <- apply(params$DM, 1, function(x) sd(x)/meanDM)
                ConstRows <- which(nSD < 0.001)
                if (length(ConstRows) > 0) {
                  params$DM <- params$DM[-ConstRows, ]
                }
                message("\nRemoved ", length(c(ConstRows, AllZeroRows)), 
                  " uninformative (invariant/no-show) gene(s)...\n", 
                  appendLF = FALSE)
                DMS <- as(params$DM, "dgCMatrix")
                DMS@x <- log2(DMS@x + 1)
                cM <- SPearsonCor(DMS)
                sum.cM <- (colSums(cM) - 1)/2
                Y1 <- sum.cM
                X1 <- log2(Gcounts[SMPL])
                m <- lm(Y1 ~ X1)
                Yhat <- predict(m)
                exclude <- which(Y1/Yhat > quantile(Y1/Yhat, 
                  0.25) & sum.cM > quantile(sum.cM, 0.25))
                fraction <- min(((ncol(DM)^2)/1e+06), 0.9)
                exclude <- sample(exclude, ceiling(length(exclude) * 
                  fraction))
                SMPL <- SMPL[-c(exclude)]
                params$DM <- params$DM[, -c(exclude)]
                if (filter) {
                  if (!is.numeric(filter)) {
                    keep <- ceiling(0.5 * nrow(params$DM))
                  }
                  else if (filter < 0) {
                    stop("filter cannot be a negative number")
                  }
                  else if (filter <= 1) {
                    keep <- ceiling(nrow(params$DM) * filter)
                  }
                  else if (filter > 1) {
                    keep <- ceiling(filter)
                  }
                  if (keep < nrow(params$DM)) {
                    message("\nFiltering Genes...", appendLF = FALSE)
                    norm_GeneDispersion <- select_variable_genes(params$DM)
                    disp_cut_off <- sort(norm_GeneDispersion, 
                      decreasing = TRUE)[keep]
                    use <- norm_GeneDispersion >= disp_cut_off
                    fraction <- signif((100 * sum(use))/nrow(params$DM), 
                      digits = 3)
                    params$DM <- params$DM[use, ]
                    message("Retained the top ", fraction, "% overdispersed gene(s) \n", 
                      appendLF = FALSE)
                  }
                }
                genelist <- rownames(params$DM)
                params$ClassAssignment <- ClassAssignment[SMPL]
                if (!is.null(BatchAssignment)) {
                  params$BatchAssignment <- BatchAssignment[SMPL]
                }
                message("done")
                cluster.res <- do.call(SC_cluster, c(params, 
                  list(comm.method = igraph::cluster_louvain, 
                    pr.iter = 1)))
            }
            else {
                message("\n\nRefining Cluster Structure...\n", 
                  appendLF = FALSE)
                params$ncom <- ncom
                params$is.cor <- TRUE
                params$ClassAssignment <- ClassAssignment
                params$BatchAssignment <- BatchAssignment
                message("MISCL", "\n", cluster.res$miscl, "\n")
                memb <- cluster.res$MEMB
                min.csize <- max(4, ceiling(0.25 * sqrt(length(memb))))
                nclust <- length(unique(memb))
                good.clust <- as.vector(which(table(memb) >= 
                  min.csize))
                if (length(good.clust) < 2) {
                  message("\nNotice: No substantial clusters found. This might indicate unstructured data...\n", 
                    appendLF = FALSE)
                }
                else {
                  message("\n", length(good.clust), " substantial clusters found...\n", 
                    appendLF = FALSE)
                }
                message("\nBootstrapping to refine clusters...\n", 
                  appendLF = FALSE)
                Nboot.Smpls <- min(ceiling(250/(length(good.clust)^2)), 
                  80)
                Nboot.Smpls <- max(Nboot.Smpls, 16)
                bootS.size <- Nboot.Smpls^(-0.4)
                FakeBulk <- matrix(0, length(genelist), length(good.clust) * 
                  Nboot.Smpls)
                r <- 0
                for (c in 1:length(good.clust)) {
                  clust <- good.clust[c]
                  ssize <- ceiling(sum(memb == clust) * bootS.size) + 
                    1
                  ssize <- min(100, ssize)
                  for (b in 1:Nboot.Smpls) {
                    r <- r + 1
                    cluster.sample <- sample(which(memb == clust), 
                      ssize, replace = TRUE)
                    FakeBulk[, r] <- rowMeans(DM[genelist, names(memb)][, 
                      cluster.sample])
                  }
                }
                if (is.null(K)) {
                  Kmnn = min(max(floor(0.25 * (sqrt(ncol(DM)) + 
                    ncol(FakeBulk))), 10), floor(ncol(DM))/1.5)
                }
                else {
                  Kmnn = K
                }
                message("Calculating Cell Distances to Cluster Centroids (Bulks)...", 
                  appendLF = FALSE)
                params$DM <- WScorFB(DM[genelist, ], FakeBulk, 
                  PSpearmanCor = PSpearmanCor, PPearsonCor = PPearsonCor, 
                  PHellinger = PHellinger, PCanberra = PCanberra, 
                  ShrinkCor = ShrinkCor, K = Kmnn)
                message("done")
                cluster.res <- do.call(SC_cluster, c(params, 
                  list(comm.method = igraph::cluster_louvain, 
                    do.glasso = FALSE, pr.iter = 0, Kmnn = Kmnn)))
                cluster.res$GeneList <- genelist
            }
            gc()
        }
        if (plot_ == TRUE) {
            if (is.null(fsuffix)) 
                fsuffix <- RandString()
            cluster.res[["plotLVis"]] <- plotLVis(cluster.res, 
                fsuffix = fsuffix, image.format = image.format, 
                quiet = FALSE)
        }
    }, finally = {
        if (isTRUE(use.par) & foreach::getDoParRegistered()) 
            parallel::stopCluster(cl)
    })
    Te <- (proc.time() - ptm)[3]
    Te <- signif(Te, digits <- 6)
    message("Finished (Elapsed Time: ", Te, ")")
    return(cluster.res)
}

environment(griph_cluster2)=asNamespace('griph')
 
 
 euc.dist = function(x1, x2) sqrt(sum((x1 - x2) ^ 2))
 #//////////////////////////////////////////////////////////////////////////
 silhouette=function(nCluster,clustering.output){
 
dataPlot=cbind(as.numeric(clustering.output[,3]),as.numeric(clustering.output[,4])) 
nCluster=length(unique(clustering.output[,2]))
mainVector=as.numeric(clustering.output[,2])
intraScore=c()   
extraScore=c()
neighbor=c()
silhouetteValue=c()
    #per ogni cluster
  
    #per ogni elemento
for(k in 1:(length(dataPlot)/2))
{
    a=0
    count=0
    #per ogni altro elemento nel suo cluster
    for(j in 1:(length(dataPlot)/2)){
        if(mainVector[k]==mainVector[j])
            {   
                
                if(k != j ){
                    a=a+euc.dist(dataPlot[k,],dataPlot[j,])
                    count=count+1
                }
            }
    
    }
      intraScore[k]=a/count 



}
    extraScoreTemp=c()
extraCountTemp=c()

for(k in 1:(length(dataPlot)/2))
{
    for(s in 1:nCluster){
        extraScoreTemp[s]=0
        extraCountTemp[s]=0
    }
    
    for(j in 1:(length(dataPlot)/2))
    {
        if(mainVector[k] != mainVector[j]){
                                            extraScoreTemp[mainVector[j]]=extraScoreTemp[mainVector[j]]+ euc.dist(dataPlot[k,],dataPlot[j,])
                                            extraCountTemp[mainVector[j]]=extraCountTemp[mainVector[j]]+1
                                            }
    
    }
    extraScoreTemp=extraScoreTemp[-mainVector[k]]
    extraCountTemp=extraCountTemp[-mainVector[k]]
    extraScore[k]=min(extraScoreTemp/extraCountTemp)
    minIndex=which.min(extraScoreTemp/extraCountTemp)
    if(minIndex>=mainVector[k]){neighbor[k]=minIndex+1}else{neighbor[k]=minIndex}
    }
    for(u in 1:length(extraScore)){silhouetteValue[u]=(extraScore[u]-intraScore[u])/max(extraScore[u],intraScore[u])}
    silhouette=matrix(cbind(extraScore,intraScore,mainVector,neighbor,silhouetteValue),nrow=length(extraScore))
    colnames(silhouette) = c("extraScore","intraScore","ClusterBelong","Neighbor","SilhouetteValue") # the first row will be the header
silhouetteValue[is.na(silhouetteValue)] <- -1
return(cbind(clustering.output,extraScore,intraScore,neighbor,silhouetteValue))
 }
  #//////////////////////////////////////////////////////////////////////////

 recorsiveSIMLR=function(matrixCount,nCluster){
 tt=try(SIMLR(matrixCount,nCluster,cores.ratio=0))
 if(class(tt)=="try-error"){
tt=recorsiveSIMLR(matrixCount,nCluster)
			}
return(tt)
 } 
 
  recorsivegriph=function(countMatrix,image.format="pdf",use.par = FALSE){
 tt=try(griph_cluster2(countMatrix,image.format="pdf",use.par = FALSE))
 if(class(tt)=="try-error"){
 
tt=recorsivegriph(countMatrix,image.format="pdf",use.par = FALSE)
			}
return(tt)
 } 
 
 
  #//////////////////////////////////////////////////////////////////////////
 #5.112772e-14

 
 
 
 
simlrF=function(matrixCount,nCluster){
cluster_result=recorsiveSIMLR(matrixCount,nCluster)
return(cbind(CellName=colnames(matrixCount),Belonging_Cluster=cluster_result$y$cluster,xChoord=cluster_result$ydata[,1],yChoord=cluster_result$ydata[,2]))
}
simlrF2=function(matrixCount,nCluster,index){
cluster_result=recorsiveSIMLR(matrixCount,nCluster)

rank=SIMLR_Feature_Ranking(cluster_result$S,matrixCount)
foo=cbind(rank$aggR,rank$pval)
foo=foo[order(foo[,1]),]
rownames(foo)=rownames(matrixCount)
foo=foo[,-1]
write.table(foo,paste("./Permutation/pvalue/",index,".",format,sep=""),sep=separator,col.names=FALSE)

return(cbind(CellName=colnames(matrixCount),Belonging_Cluster=cluster_result$y$cluster,xChoord=cluster_result$ydata[,1],yChoord=cluster_result$ydata[,2]))
}

griphF=function(countMatrix){
cluster_result=recorsivegriph(as.matrix(countMatrix),image.format="pdf",use.par = FALSE)
return(cbind(CellName=colnames(countMatrix),Belonging_Cluster=cluster_result$MEMB,xChoord=cluster_result$plotLVis[,1],yChoord=cluster_result$plotLVis[,2]))

}


tsneF=function(countMatrix,nCluster,perplexity){
library(Rtsne)
ts=Rtsne(dist(t(countMatrix)), is_distance=TRUE, perplexity=perplexity, verbose = TRUE)
cluster_result=kmeans(ts$Y,nCluster)
return(cbind(CellName=colnames(countMatrix),Belonging_Cluster=cluster_result$cluster,xChoord=ts$Y[,1],yChoord=ts$Y[,2]))


}




 

 
 
clustering=function(matrixName,nPerm,permAtTime,percent,nCluster,logTen,format,separator,clusteringMethod,perplexity,rK)
{
if(separator=="tab"){separator2="\t"}else{separator2=separator} #BUG CORRECTION TAB PROBLEM 


switch(clusteringMethod, 
SIMLR={
countMatrix=read.table(paste("./../",matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.name=1)
if(logTen==0){countMatrix=log10(countMatrix+1)}
clustering.output=simlrF(countMatrix,nCluster)
clustering.output=silhouette(nCluster,clustering.output)






},
griph={
countMatrix=read.table(paste("./",matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.name=1)
if(logTen==0){countMatrix=log10(countMatrix+1)}
clustering.output=griphF(countMatrix)
clustering.output=silhouette(nCluster,clustering.output)
nCluster=max(as.numeric(clustering.output[,2]))
dir.create(paste("./",nCluster,sep=""))
dir.create(paste("./",nCluster,"/Permutation",sep=""))

setwd(paste("./",nCluster,sep=""))
},
tSne={
countMatrix=read.table(paste("./../",matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.name=1)
if(logTen==0){countMatrix=log10(countMatrix+1)}
clustering.output=tsneF(countMatrix,nCluster,perplexity)
clustering.output=silhouette(nCluster,clustering.output)
}
)

write.table(clustering.output,paste(matrixName,"_clustering.output.",format,sep=""),sep=separator2, row.names = F)
cycles=nPerm/permAtTime
for(i in 1:cycles){
    system(paste("for X in $(seq ",permAtTime,")
do
 nohup Rscript ./../../../home/permutation.R ",percent," ",matrixName," ",format," ",separator," ",logTen," ",clusteringMethod," ",nCluster," ",rK," ",perplexity," $(($X +",(i-1)*permAtTime," )) & 

done"))
d=1
while(length(list.files("./Permutation",pattern=paste("*.",format,sep="")))!=i*permAtTime*2){
if(d==1){cat(paste("Cluster number ",nCluster," ",((permAtTime*i))/nPerm*100," % complete \n"))}
d=2
}

system("echo 3 > /proc/sys/vm/drop_caches")
system("sync")
gc()
}


#write.table(as.matrix(sapply(list.files("./Permutation/",pattern="cluster*"),FUN=function(x){a=read.table(paste("./Permutation/",x,sep=""),header=TRUE,col.names=1,sep=separator2)[[1]]}),col.names=1),paste(matrixName,"_",nCluster,"_clusterP.",format,sep=""),sep=separator2,row.names=FALSE, quote=FALSE)
#write.table(as.matrix(sapply(list.files("./Permutation/",pattern="killC*"),FUN=function(x){a=read.table(paste("./Permutation/",x,sep=""),header=TRUE,col.names=1,sep=separator2)[[1]]}),col.names=1),paste(matrixName,"_",nCluster,"_killedCell.",format,sep=""),sep=separator2,row.names=FALSE, quote=FALSE)

cluster_p=sapply(list.files("./Permutation/",pattern="cluster*"),FUN=function(x){a=read.table(paste("./Permutation/",x,sep=""),header=TRUE,col.names=1,sep=separator2)[[1]]})
killedC=sapply(list.files("./Permutation/",pattern="killC*"),FUN=function(x){a=read.table(paste("./Permutation/",x,sep=""),header=TRUE,col.names=1,sep=separator2)[[1]]})
if(rK==1){
pval=sapply(list.files("./Permutation/pvalue/",pattern="*"),FUN=function(x){a=read.table(paste("./Permutation/pvalue/",x,sep=""),header=FALSE,row.names=1,sep=separator2)[[1]]})
}
write.table(as.matrix(cluster_p,col.names=1),paste(matrixName,"_",nCluster,"_clusterP.",format,sep=""),sep=separator2,row.names=FALSE, quote=FALSE)
write.table(as.matrix(killedC,col.names=1),paste(matrixName,"_",nCluster,"_killedCell.",format,sep=""),sep=separator2,row.names=FALSE, quote=FALSE)
if(rK==1){
write.table(as.matrix(pval,col.names=1),paste(matrixName,"_",nCluster,"_pvalList.",format,sep=""),sep=separator2,row.names=FALSE, quote=FALSE,col.names=FALSE)
resultsPVAL=cbind(apply(pval,1,FUN=function(x){ci.mean(x)$upper - ci.mean(x)$lower}),rowMeans(pval), apply(pval,1,sd))
colnames(resultsPVAL)=c("deltaConfidence","Mean","SD")

pdf("geneRank.pdf")
plot(resultsPVAL[,1],-log10(resultsPVAL[,2]),main="Rank Gene plot",ylab="- log10 Mean",xlab="Delta confidence",pch=20,col="blue")
dev.off()
}
pdf("hist.pdf")
clusters=apply(cluster_p,2,FUN=function(x){max(x)})
hist(clusters,xlab="nCluster",breaks=length(unique(cluster_p)))
dev.off()

system("rm -r Permutation")

switch(clusteringMethod, 
SIMLR={
  write(paste(" MatrixName: ",matrixName,"\n nPerm:",nPerm,"\n permAtTime:",permAtTime,"\n Percent:",percent,"\n Clusters:",nCluster,"\n Format:",format,"\n Separator:",separator,"\n log10",logTen,"\n Clustering Method:",clusteringMethod,"\n Perplexity:",perplexity),"log.txt")
},
griph={
write(paste(" MatrixName: ",matrixName,"\n nPerm:",nPerm,"\n permAtTime:",permAtTime,"\n Percent:",percent,"\n Clusters:",nCluster,"\n Format:",format,"\n Separator:",separator,"\n log10",logTen,"\n Clustering Method:",clusteringMethod,"\n Perplexity:",perplexity),"log.txt")
return(nCluster)
},
tSne={
write(paste(" MatrixName: ",matrixName,"\n nPerm:",nPerm,"\n permAtTime:",permAtTime,"\n Percent:",percent,"\n Clusters:",nCluster,"\n Format:",format,"\n Separator:",separator,"\n log10",logTen,"\n Clustering Method:",clusteringMethod,"\n Perplexity:",perplexity),"log.txt")
}
)



}
relationMatrix=function(mainVector,nameVector){
 rel.matrix=as.numeric(mainVector) %*% t(1/as.numeric(mainVector))
 rel.matrix[rel.matrix!=1]=0
 colnames(rel.matrix)=nameVector
 rownames(rel.matrix)=nameVector
 return(rel.matrix)
 
}



silhouettePlot=function(matrixName,rangeVector,format,separator){
if(separator=="tab"){separator="\t"} #BUG CORRECTION TAB PROBLEM 
count=1
l=list()
for(i in rangeVector){
l[[count]]=read.table(paste("./",i,"/",matrixName,"_clustering.output.",format,sep=""),sep=separator,header=TRUE)[,8]
count=count+1
}
pdf(paste(matrixName,"_vioplot.pdf",sep=""))
do.call(vioplot,c(l,list(names=rangeVector)))
dev.off()
}
