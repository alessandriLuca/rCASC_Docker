 

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
 
  recorsiveSHARP=function(countMatrix){
 tt=try(SHARP(countMatrix))
 if(class(tt)=="try-error"){
 
tt=recorsiveSHARP(countMatrix)
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
library(SHARP)
library("Rtsne")
cluster_result=recorsiveSHARP(as.matrix(countMatrix))
w=2
y=cluster_result
x1 = as.matrix(cbind(w * scale(y$x0), scale(y$viE)))
 if (dim(x1)[2] <= 50) {
        flag = FALSE
    }else {
        flag = TRUE
    }
     rtsne_out <- Rtsne(x1, check_duplicates = FALSE, pca = flag)





return(cbind(CellName=colnames(countMatrix),Belonging_Cluster=cluster_result$pred_clusters,xChoord=rtsne_out$Y[,1],yChoord=rtsne_out$Y[,2]))

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
nCluster=max(clustering.output[,2])
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
