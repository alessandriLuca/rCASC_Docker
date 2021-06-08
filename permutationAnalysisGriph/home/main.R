setwd("/home")
system("chmod -R 777 ./../scratch")
 source("functions.R")
 library("argparser")
 library(dplyr)
 library("vioplot")
 library("Publish")
 library("Seurat")
 library(Matrix)
 
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "nCluster", help="Last cluster number ")
p <- add_argument(p, "format", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "Sp", help="Similarity Percentage ")
p <- add_argument(p, "sparse", help="Similarity Percentage ")

argv <- parse_args(p)

#argv=list()
#argv$matrixName="annotated_setPace_10000"
#argv$nCluster=4
#argv$format="txt"
#argv$separator="\t"
#argv$Sp=0.8



matrixName=argv$matrixName
nCluster=argv$nCluster
format=argv$format
separator=argv$separator
Sp=as.numeric(argv$Sp)
count=1
sparse=argv$sparse


if(separator=="tab"){separator2="\t"}else{separator2=separator}
system(paste("cp /scratch/",matrixName,"/",matrixName,".",format," /scratch",sep=""))
#system(paste("cp -r ./../data/Results/",matrixName,"/ ./../scratch",sep=""))
setwd("./../scratch")
i=nCluster

l=list()



if(sparse=="FALSE"){
mainMatrix=read.table(paste("./",matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.name=1)}else{
mainMatrix <- as.matrix(Read10X(data.dir = paste("./",matrixName,sep="")))

}










ScoreBCs=matrix(ncol=ncol(mainMatrix),nrow=ncol(mainMatrix),0)# COSA SEI????
clustering.output=read.table(paste("./",matrixName,"/",i,"/",matrixName,"_clustering.output.",format,sep=""),header=TRUE,sep=separator2)
score = integer(nrow(clustering.output))
relationMatrix0=relationMatrix(clustering.output[,2],clustering.output[,1])
ScoreBCs=ScoreBCs+relationMatrix0 #OK QUINDI???
    permutationMatrix=read.table(paste("./",matrixName,"/",i,"/",matrixName,"_",i,"_clusterP.",format,sep=""),header=TRUE,sep=separator2)

   # permutationMatrix=permutationMatrix[,which(apply(permutationMatrix,2,max)==i)]

    killedMatrix=as.matrix(read.table(paste("./",matrixName,"/",i,"/",matrixName,"_",i,"_killedCell.",format,sep=""),header=TRUE,sep=separator2))
   # killedMatrix=killedMatrix[,which(apply(permutationMatrix,2,max)==i)]

    
    score=sapply(seq(1,ncol(killedMatrix)),FUN=function(x){
    temp=relationMatrix0[-killedMatrix[,x],-killedMatrix[,x]] #Tolgo le cellule eliminate nella permutazione X
         f=temp + relationMatrix(permutationMatrix[,x]+1,row.names(temp))
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







if(sparse=="FALSE"){
a=read.table(paste("./",matrixName,".",format,sep=""),sep=separator2,header=TRUE,row.name=1)}else{
a <- as.matrix(Read10X(data.dir = paste("./",matrixName,sep="")))

}





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





if(count>=2){
if(length(unique(as.numeric(unlist(l))))>1){
pdf(paste("./",matrixName,"/",nCluster,"_Stability_Violin_Plot.pdf",sep=""))
do.call(vioplot,c(l,list(names=nCluster)))
dev.off()
}
}


#ScoreBCs=ScoreBCs/length(rangeVector)
#ScoreBCs[lower.tri(ScoreBCs)]=0
#diag(ScoreBCs)=0
#colnames(ScoreBCs)=colnames(mainMatrix)
#rownames(ScoreBCs)=colnames(mainMatrix)
#k <- arrayInd(which(ScoreBCs>=1), dim(ScoreBCs))

#name=unique(c(rownames(ScoreBCs)[k[,1]],colnames(ScoreBCs)[k[,2]]))

#label=matrix(ncol=2,nrow=ncol(mainMatrix),2)
#rownames(label)=colnames(mainMatrix)
#label[,2]="Unstable"
#label[match(name,colnames(mainMatrix)),1]=1
#label[match(name,colnames(mainMatrix)),2]="Stable"
#colnames(label)=c("labelID","labelName")
#write.table(label,paste(matrixName,"_Label.",format,sep=""),sep=separator)

  


system("chmod -R 777 ./../data/")
system("chmod -R 777 ./../scratch")
#system("cp -r * ./../data/Results")
