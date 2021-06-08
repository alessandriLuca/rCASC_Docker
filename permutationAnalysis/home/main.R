setwd("/home")
system("chmod -R 777 ./../scratch")
 source("functions.R")
 library("SIMLR")
 library("argparser")
 library(dplyr)
 library("vioplot")
 library("Publish")
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "range1", help="First cluster number ")
p <- add_argument(p, "range2", help="Last cluster number ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "Sp", help="Similarity Percentage ")
p <- add_argument(p, "clusterPermErr", help="Similarity Percentage ")
p <- add_argument(p, "maxDeltaConfidence", help="Similarity Percentage ")
p <- add_argument(p, "minLogMean", help="Similarity Percentage ")

argv <- parse_args(p)

#argv=list()
#argv$matrixName="Buettner"
#argv$range1=4
#argv$range2=4
#argv$format="csv"
#argv$separator=","
#argv$Sp=0.8
#maxDeltaConfidence=1
#minLogMean=80

maxDeltaConfidence=as.numeric(argv$maxDeltaConfidence)
minLogMean=as.numeric(argv$minLogMean)

matrixName=argv$matrixName
rangeVector=seq(as.numeric(argv$range1),as.numeric(argv$range2))
format=argv$format
separator=argv$separator
Sp=as.numeric(argv$Sp)
clusterPermErr=as.numeric(argv$clusterPermErr)
count=1



if(separator=="tab"){separator2="\t"}else{separator2=separator}

system(paste("cp /scratch/",matrixName,"/",matrixName,".",format," /scratch",sep=""))
setwd("/scratch")
l=list()
mainMatrix=read.table(paste("./",matrixName,".",format,sep=""),header=TRUE,sep=separator2,row.names=1)
ScoreBCs=matrix(ncol=ncol(mainMatrix),nrow=ncol(mainMatrix),0)
for(i in rangeVector){

clustering.output=read.table(paste("./",matrixName,"/",i,"/",matrixName,"_clustering.output.",format,sep=""),header=TRUE,sep=separator2)
score = integer(nrow(clustering.output))
relationMatrix0=relationMatrix(clustering.output[,2],clustering.output[,1])
ScoreBCs=ScoreBCs+relationMatrix0
    permutationMatrix=read.table(paste("./",matrixName,"/",i,"/",matrixName,"_",i,"_clusterP.",format,sep=""),header=TRUE,sep=separator2)
    if(length(which(apply(permutationMatrix,2,max)==i))>= (ncol(permutationMatrix)*(1-clusterPermErr))){

    permutationMatrix=permutationMatrix[,which(apply(permutationMatrix,2,max)==i)]

    killedMatrix=as.matrix(read.table(paste("./",matrixName,"/",i,"/",matrixName,"_",i,"_killedCell.",format,sep=""),header=TRUE,sep=separator2))
    killedMatrix=killedMatrix[,which(apply(permutationMatrix,2,max)==i)]

    
    score=sapply(seq(1,ncol(killedMatrix)),FUN=function(x){
    temp=relationMatrix0[-killedMatrix[,x],-killedMatrix[,x]]
         f=temp + relationMatrix(permutationMatrix[,x],row.names(temp))
         scoreTemp=apply(f,1,FUN=function(y){
         y=as.vector(y)
            inter=length(y[y==2])
        
            if((inter/(inter+length(y[y==1])))>=Sp){
                return(1)
            }else{return(0)}
         
         })
       score=numeric(length(scoreTemp)+length(killedMatrix[,x]))
       score[killedMatrix[,x]]=NA
       score[!is.na(score)] = scoreTemp
       return(score)
    })
           score[is.na(score)]=0
   
    rownames(score)=rownames(relationMatrix0)
    colnames(score)=paste("Perm_",seq(1:ncol(killedMatrix)),sep="")
write.table(score,paste("./",matrixName,"/",i,"/",matrixName,"_score.",format,sep=""),col.names=NA,sep=separator2)
finalScore=rowSums(score)/ncol(killedMatrix)
write.table(finalScore,paste("./",matrixName,"/",i,"/",matrixName,"_scoreSum.",format,sep=""),col.names=FALSE,sep=separator2)
pdf(paste("./",matrixName,"/",i,"/",matrixName,"_Stability_Plot.pdf",sep=""))
stabilityPlot(matrixName,i,cbind(clustering.output[,3],clustering.output[,4]),finalScore,i,clustering.output[,2])
a=read.table(paste("./",matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.name=1)
xCoord=log10(colSums(a))
b=a
b[b<3]=0
b[b>=3]=1
yCoord=colSums(b)
clustering.output=read.table(paste("./",matrixName,"/",i,"/",matrixName,"_clustering.output.",format,sep=""),header=TRUE,sep=separator2)
     colours=rainbow(i)
plot(xCoord,yCoord,xlab="log10 sum count cells",ylab="Gene > 3 UMI",col=colours[clustering.output[,2]])

dev.off()

l[[count]]=finalScore
count=count+1
}else{
cat(paste("not enough permutation with correct number of cluster :",-(length(which(apply(permutationMatrix,2,max)==i))-(ncol(permutationMatrix)*(1-clusterPermErr)))))
write(paste("not enough permutation with correct number of cluster :",-(length(which(apply(permutationMatrix,2,max)==i))-(ncol(permutationMatrix)*(1-clusterPermErr)))),paste("./",matrixName,"/",i,"/",matrixName,"_error.txt",sep=""))

   
    permutationMatrix=permutationMatrix[,which(apply(permutationMatrix,2,max)==i)]

    killedMatrix=as.matrix(read.table(paste("./",matrixName,"/",i,"/",matrixName,"_",i,"_killedCell.",format,sep=""),header=TRUE,sep=separator2))
    killedMatrix=killedMatrix[,which(apply(permutationMatrix,2,max)==i)]

    
    score=sapply(seq(1,ncol(killedMatrix)),FUN=function(x){
    temp=relationMatrix0[-killedMatrix[,x],-killedMatrix[,x]]
         f=temp + relationMatrix(permutationMatrix[,x],row.names(temp))
         scoreTemp=apply(f,1,FUN=function(y){
         y=as.vector(y)
            inter=length(y[y==2])
        
            if((inter/(inter+length(y[y==1])))>=Sp){
                return(1)
            }else{return(0)}
         
         })
       score=numeric(length(scoreTemp)+length(killedMatrix[,x]))
       score[killedMatrix[,x]]=NA
       score[!is.na(score)] = scoreTemp
       return(score)
    })
           score[is.na(score)]=0
   
    rownames(score)=rownames(relationMatrix0)
    colnames(score)=paste("Perm_",seq(1:ncol(killedMatrix)),sep="")
write.table(score,paste("./",matrixName,"/",i,"/",matrixName,"_score.",format,sep=""),col.names=NA,sep=separator2)
finalScore=rowSums(score)/ncol(killedMatrix)
write.table(finalScore,paste("./",matrixName,"/",i,"/",matrixName,"_scoreSum.",format,sep=""),col.names=FALSE,sep=separator2)
pdf(paste("./",matrixName,"/",i,"/",matrixName,"_Stability_Plot.pdf",sep=""))
stabilityPlot(matrixName,i,cbind(clustering.output[,3],clustering.output[,4]),finalScore,i,clustering.output[,2])
a=read.table(paste("./",matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.name=1)
xCoord=log10(colSums(a))
b=a
b[b<3]=0
b[b>=3]=1
yCoord=colSums(b)
clustering.output=read.table(paste("./",matrixName,"/",i,"/",matrixName,"_clustering.output.",format,sep=""),header=TRUE,sep=separator2)
     colours=rainbow(i)
plot(xCoord,yCoord,xlab="log10 sum count cells",ylab="Gene > 3 UMI",col=colours[clustering.output[,2]])

dev.off()

l[[count]]=finalScore
count=count+1
    


}

if(file.exists(paste("./rawCC_",matrixName,".",format,sep=""))){
rawCC=read.table(paste("./rawCC_",matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.names=1)
clustering.output=cbind(clustering.output,cellCycle=sapply(clustering.output[,1],FUN=function(x){rawCC[as.vector(x),]}))
write.table(clustering.output,paste("./",matrixName,"/",i,"/",matrixName,"_clustering.output.",format,sep=""),sep=separator2,row.names=FALSE)
pdf(paste("./",matrixName,"/",i,"/",matrixName,"_CCPlot.pdf",sep=""))
par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
     par(xpd=TRUE)
     
plot(clustering.output[,3],clustering.output[,4],col=clustering.output[,9],ylab="y Component",xlab="x Component",main="Cell cycle")
    legend("topright", inset=c(-0.181,0.137),legend=c("G1","S","G2M"),pch=20,col=c(1,2,3),cex=0.5)
nCluster=i    
labelComponent=matrix(ncol=3,nrow=nCluster,0)
mainVector=clustering.output[,2]
for(k in 1:nCluster){

        tempLabelComp=table(clustering.output[,9][which(mainVector==k)])
        for(n in 1:nrow(tempLabelComp)){
        labelComponent[k,as.integer(names(tempLabelComp))[n]]=as.integer(tempLabelComp)[n]
        }
   # labelComponent=rbind(labelComponent,table(label[,1][which(mainVector==i)]))
   
    
}
colnameLabel=c("G1","S","G2M")
colnames(labelComponent)=colnameLabel
rownames(labelComponent)=seq(1:nCluster)
write.table(labelComponent,paste("./",matrixName,"/",nCluster,"/",matrixName,"_labelComponent.",format,sep=""),col.names=NA,sep=separator2,row.names=TRUE)
 for(i in 1:nCluster){
 pie(labelComponent[i,], labels = colnames(labelComponent), main=paste(matrixName,"Cluster number ",i))
}


dev.off()
}




}
if(count>=2){
if(length(unique(as.numeric(unlist(l))))>1){
pdf(paste("./",matrixName,"/_Stability_Violin_Plot.pdf",sep=""))
do.call(vioplot,c(l,list(names=rangeVector)))
dev.off()
}
}


ScoreBCs=ScoreBCs/length(rangeVector)
ScoreBCs[lower.tri(ScoreBCs)]=0
diag(ScoreBCs)=0
colnames(ScoreBCs)=colnames(mainMatrix)
rownames(ScoreBCs)=colnames(mainMatrix)
k <- arrayInd(which(ScoreBCs>=1), dim(ScoreBCs))

name=unique(c(rownames(ScoreBCs)[k[,1]],colnames(ScoreBCs)[k[,2]]))

label=matrix(ncol=2,nrow=ncol(mainMatrix),2)
rownames(label)=colnames(mainMatrix)
label[,2]="Unstable"
label[match(name,colnames(mainMatrix)),1]=1
label[match(name,colnames(mainMatrix)),2]="Stable"
colnames(label)=c("labelID","labelName")
#write.table(label,paste(matrixName,"_Label.",format,sep=""),sep=separator)



if(file.exists(paste("./",matrixName,"/",i,"/",matrixName,"_",i,"_pvalList.",format,sep=""))){
for(i in rangeVector){
pval=as.matrix(read.table(paste("./",matrixName,"/",i,"/",matrixName,"_",i,"_pvalList.",format,sep=""),header=FALSE,sep=separator2))
    resultsPVAL=cbind(apply(pval,1,FUN=function(x){ci.mean(x)$upper - ci.mean(x)$lower}),rowMeans(pval), apply(pval,1,sd))
    colnames(resultsPVAL)=c("deltaConfidence","Mean","SD")
    nCluster=i
#rownames(mainMatrix)=sapply(rownames(mainMatrix),FUN=function(x){strsplit(x,":")[[1]][2]})
a=rownames(mainMatrix)[intersect(which(resultsPVAL[,1]<=maxDeltaConfidence),which(-log10(resultsPVAL[,2])>minLogMean))]
a=sapply(a,FUN=function(x){strsplit(x,":")[[1]][2]})

#write.table(rownames(mainMatrix)[intersect(which(resultsPVAL[,1]<=maxDeltaConfidence),which(-log10(resultsPVAL[,2])>minLogMean))],paste("./",matrixName,"/",nCluster,"/",matrixName,"_geneRankList_",i,".",format,sep=""),col.names=FALSE,row.names=FALSE)

pdf(paste("./",matrixName,"/",nCluster,"/_geneRankList_filtered_",i,".pdf",sep=""))
plot(resultsPVAL[,1],-log10(resultsPVAL[,2]),main="Rank Gene plot",ylab="- log10 Mean",xlab="Delta confidence",pch=20,col="blue",xlim=c(0,maxDeltaConfidence),ylim=c(minLogMean,max(-log10(resultsPVAL[,2]))))
dev.off()
write.table(a,paste("./",matrixName,"/",nCluster,"/",matrixName,"_geneRankList_",i,".",format,sep=""),col.names=FALSE,row.names=FALSE)

}
}

system("chmod -R 777 ./../data/")
system("chmod -R 777 ./../scratch")
#system("cp -r * ./../data/Results")
