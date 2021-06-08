
 euc.dist = function(x1, x2) sqrt(sum((x1 - x2) ^ 2))
 #//////////////////////////////////////////////////////////////////////////
 silhouette=function(nCluster,clustering.output){
 
dataPlot=cbind(as.numeric(clustering.output[,3]),as.numeric(clustering.output[,4])) 
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
 
 
  #//////////////////////////////////////////////////////////////////////////

 
 
 
 
simlrF=function(matrixCount,nCluster){
cluster_result=recorsiveSIMLR(matrixCount,nCluster)
return(cbind(CellName=colnames(matrixCount),Belonging_Cluster=cluster_result$y$cluster,xChoord=cluster_result$ydata[,1],yChoord=cluster_result$ydata[,2]))
}

griphF=function(a){cat(a)}

tsneF=function(a){cat(a)}




 

 
 
clustering=function(matrixName,nPerm,permAtTime,percent,nCluster,logTen,format,separator,clusteringMethod)
{
if(separator=="tab"){separator2="\t"}else{separator2=separator} #BUG CORRECTION TAB PROBLEM 
countMatrix=read.table(paste("./../",matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.name=1)
if(logTen==0){countMatrix=log10(countMatrix+1)}

switch(clusteringMethod, 
SIMLR={
clustering.output=simlrF(countMatrix,nCluster)
clustering.output=silhouette(nCluster,clustering.output)
write.table(clustering.output,paste(matrixName,"_clustering.output.",format,sep=""),sep=separator2, row.names = F)
cycles=nPerm/permAtTime
for(i in 1:cycles){
    system(paste("for X in $(seq ",permAtTime,")
do
 nohup Rscript ./../../../home/permutation.R ",percent," ",matrixName," ",format," ",separator," ",logTen," ",clusteringMethod," ",nCluster," $(($X +",(i-1)*permAtTime,")) & 

done"))
d=1
while(length(list.files("./Permutation"))!=i*permAtTime){
if(d==1){cat(paste("Cluster number ",nCluster," ",((permAtTime*i))/nPerm*100," % complete \n"))}
d=2
}

}










},
griph={
  # case 'bar' here...
griphF("ciaoG")},
tSne={
tsneF("Ciaot")
}
)


}

relationMatrix=function(mainVector,nameVector=NULL){
 rel.matrix=as.numeric(mainVector) %*% t(1/as.numeric(mainVector))
 rel.matrix[rel.matrix!=1]=0
 if(!is.null(nameVector)){
 colnames(rel.matrix)=nameVector
 rownames(rel.matrix)=nameVector
 }
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

pos2coord<-function(pos=NULL, coord=NULL, dim.mat=NULL){
 if(is.null(pos) & is.null(coord) | is.null(dim.mat)){
  stop("must supply either 'pos' or 'coord', and 'dim.mat'")
 }
 if(is.null(pos) & !is.null(coord) & !is.null(dim.mat)){
  pos <- ((coord[,2]-1)*dim.mat[1])+coord[,1] 
  return(pos)
 }
 if(!is.null(pos) & is.null(coord) & !is.null(dim.mat)){
  coord <- matrix(NA, nrow=length(pos), ncol=2)
  coord[,1] <- ((pos-1) %% dim.mat[1]) +1
  coord[,2] <- ((pos-1) %/% dim.mat[1]) +1
  return(coord)
 }
}


stabilityPlot<-function(matrixName,i,dataPlot,finalScore,nCluster,mainVector){
     colours=rainbow(nCluster)
     par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
     par(xpd=TRUE)
     plot(1, main=paste(matrixName," Clustering"),type="n", xlab="X component", ylab="Y component", xlim=c(min(dataPlot[,1]),max(dataPlot[,1])), ylim=c(min(dataPlot[,2]),max(dataPlot[,2])))
     t25=which(finalScore<=0.25)
     t50=which(finalScore>0.25 & finalScore<=0.50)
     t75=which(finalScore>0.50 & finalScore <=0.75)
     t100=which(finalScore>0.75 & finalScore <=1)
     colt25=colours[mainVector[t25]]
     colt50=colours[mainVector[t50]]
     colt75=colours[mainVector[t75]]
     colt100=colours[mainVector[t100]]

     points(dataPlot[t25,],pch=0,cex=0.5,col=colt25)
     points(dataPlot[t50,],pch=1,cex=0.5,col=colt50)
     points(dataPlot[t75,],pch=2,cex=0.5,col=colt75)
     points(dataPlot[t100,],pch=3,cex=0.5,col=colt100)
     
 

     legend("topright", inset=c(-0.338,0),legend=c("Cells stable between 0 and 25%","Cells stable between 25% and 50%","Cells stable between 50 and 75%","Cells stable between 75% and 100%"),pch=c(0,1,2,3,4),cex=0.5)
    legend("topright", inset=c(-0.181,0.137),legend=paste("Cluster number",seq(1:nCluster)),pch=20,col=colours,cex=0.5)





	 colours=c("black","green","gold","red")

     plot(1, main=paste(matrixName," Clustering stability by color"),type="n", xlab="X component", ylab="Y component", xlim=c(min(dataPlot[,1]),max(dataPlot[,1])), ylim=c(min(dataPlot[,2]),max(dataPlot[,2])))
     points(dataPlot[t25,],pch=1,cex=0.5,col="black")
     points(dataPlot[t50,],pch=1,cex=0.5,col="green")
     points(dataPlot[t75,],pch=1,cex=0.5,col="gold")
     points(dataPlot[t100,],pch=1,cex=0.5,col="red")

 legend("topright", inset=c(-0.338,0),legend=c("Cells stable between 0 and 25%","Cells stable between 25% and 50%","Cells stable between 50 and 75%","Cells stable between 75% and 100%"),pch=c(1,1,1,1),col=colours,cex=0.5)





}



add_legend <- function(...) {
  opar <- par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0), 
    mar=c(0, 0, 0, 0), new=TRUE)
  on.exit(par(opar))
  plot(0, 0, type='n', bty='n', xaxt='n', yaxt='n')
  legend(...)
}
