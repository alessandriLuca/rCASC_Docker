library("argparser")
library(ggplot2)
library(mixtools)
library("dplyr")
plot_mix_comps <- function(x, mu, sigma, lam) {
  lam * dnorm(x, mu, sigma)
}




p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "geneList", help="matrix separator ")
p <- add_argument(p, "k", help="matrix separator ")


argv <- parse_args(p)

matrixName=argv$matrixName
separator=argv$separator
geneList=argv$geneList
k=as.numeric(argv$k)
setwd("/scratch")
if(separator=="tab"){separator="\t"} #BUG CORRECTION TAB PROBLEM


name=tools::file_path_sans_ext(matrixName)
mainMatrix=as.matrix(read.table(matrixName,sep=separator,header=TRUE,row.names=1))
geneListM=read.table(geneList,sep=separator,header=FALSE)
geneListM=gsub('\"', "", as.matrix(geneListM), fixed = TRUE)
mainMatrix2=colSums(mainMatrix[geneListM,])
 mainMatrix2D=data.frame(metaGene=mainMatrix2)


pdf(paste(name,"_density.pdf",sep=""))
options(scipen = 999)

p <- ggplot(mainMatrix2D, aes(x = metaGene)) +
  geom_density()
p
cc=rainbow(k)
dev.off()
mixmdl <- normalmixEM(mainMatrix2, k = k)
a = data.frame(x = mixmdl$x) %>%
 ggplot() +
 geom_histogram(aes(x, ..density..), binwidth = 1, colour = "black",
                 fill = "white")
for(i in seq(k)){
 a=a+ stat_function(geom = "line", fun = plot_mix_comps,
                args = list(mixmdl$mu[i], mixmdl$sigma[i], lam = mixmdl$lambda[i]),
                colour = cc[i], lwd = 1.5)
}
 a=a+ ylab("Density")
pdf(paste(name,"_softLabels.pdf",sep=""))
a
dev.off()

 post.df <- as.data.frame(cbind(x = mixmdl$x, mixmdl$posterior))
 rownames(post.df)=colnames(mainMatrix)
write.table(post.df,"probability_cluster.csv",sep=",",col.names=NA,quote=FALSE)

system("chmod -R 777 /scratch")
