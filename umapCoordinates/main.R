library("argparser")
library("umap")


p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "seed", help="matrix separator ")
p <- add_argument(p, "epochs", help="matrix separator ")


argv <- parse_args(p)

matrixName=argv$matrixName
separator=argv$separator
seed=as.numeric(argv$seed)
n_epochs=as.numeric(argv$epochs)
setwd("/scratch")
if(separator=="tab"){separator="\t"} #BUG CORRECTION TAB PROBLEM


name=tools::file_path_sans_ext(matrixName)
df=read.table(matrixName,sep=separator,header=TRUE,row.names=1)

custom.config = umap.defaults
	custom.config$random_state = seed
	custom.config$n_epochs = n_epochs
	df.umap.all = umap(t(df), config=custom.config)
	b=cbind(rownames(df.umap.all$layout),0,df.umap.all$layout)
colnames(b)=c("cellName","BelongingClusters","xChoord","yChoord")

write.table(b,paste(name,"_fake_clustering.output.csv",sep=""),col.names=TRUE,row.names=FALSE,sep=",",quote=FALSE)

system("chmod -R 777 /scratch")
