library("argparser")
library(ggplot2)


p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "clustering.output", help="matrix separator ")
p <- add_argument(p, "geneList", help="matrix separator ")
p <- add_argument(p, "finalName", help="matrix separator ")


argv <- parse_args(p)

matrixName=argv$matrixName
separator=argv$separator
clustering.output=argv$clustering.output
geneList=argv$geneList
finalName=argv$finalName

setwd("/scratch")
if(separator=="tab"){separator="\t"} #BUG CORRECTION TAB PROBLEM

mainMatrix=as.matrix(read.table(matrixName,sep=separator,header=TRUE,row.names=1))
clustering.outputM=as.matrix(read.table(clustering.output,sep=separator,header=TRUE))
geneListM=read.table(geneList,sep=separator,header=FALSE)
geneListM=gsub('\"', "", as.matrix(geneListM), fixed = TRUE)
# par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
#     par(xpd=TRUE)
#granges=c(0.1,round(max((mainMatrix[geneListM[1],]))/5,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*2,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*3,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*4,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*5),digits=2)



#plot(clustering.outputM[,c(3,4)],col=rgb((colorRamp(c("black", "blue","green","orange","gold"))(mainMatrix[geneListM[1],]))/255),pch=19,cex=2)
#legend("topright", inset=c(-0.181,0),
#       legend = c(0.1,round(max((mainMatrix[geneListM[1],]))/5,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*2,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*3,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*4,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*5),digits=2),
#       fill = rgb((colorRamp(c("black", "blue","green","orange","gold"))(c(0.1,round(max((mainMatrix[geneListM[1],]))/5,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*2,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*3,digits=2),round((max((mainMatrix[geneListM[1],]))/#5)*4,digits=2),round((max((mainMatrix[geneListM[1],]))/5)*5),digits=2)))/255), cex = 1)
f=data.frame(x=as.numeric(clustering.outputM[,c(3)]),y=as.numeric(clustering.outputM[,c(4)]))
pdf(paste(getwd(),"/",finalName,".pdf",sep=""))
for(gene in geneListM){
sp <- ggplot(f, aes(x=x,y=y))+  geom_point(aes(color = mainMatrix[gene,])) +theme(axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        axis.text.y=element_blank(),  #remove y axis labels
        axis.ticks.y=element_blank()  #remove y axis ticks
        )+ scale_color_gradientn(colors=c("black", "blue","green","orange","gold")) +theme(legend.title=element_blank())+ theme_bw() + ggtitle(gene)
print(sp)
}
D2 <- apply(mainMatrix[geneListM,], 2, mean)

sp <- ggplot(f, aes(x=x,y=y))+  geom_point(aes(color = D2)) +theme(axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        axis.text.y=element_blank(),  #remove y axis labels
        axis.ticks.y=element_blank()  #remove y axis ticks
        )+ scale_color_gradientn(colors=c("black", "blue","green","orange","gold")) +theme(legend.title=element_blank())+ theme_bw() + ggtitle("Meta Gene")
print(sp)

dev.off()

system("chmod -R 777 /scratch")
