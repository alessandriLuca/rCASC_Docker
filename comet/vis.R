library("argparser")
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "nCluster", help="Permutation number for bootstrap algorithm ")


argv <- parse_args(p)

matrixName=argv$matrixName
nCluster=argv$nCluster
setwd("/scratch/")


df = read.table("vis.txt", header=TRUE, row.names=1, stringsAsFactors=F)
df1 <- df[,2:3]
df2 <- data.frame(row.names(df),df[,1])
write.table(df1, "vis.txt", sep="\t", col.names=F, quote=F)
write.table(df2, "cluster.txt", sep="\t", col.names=F, row.names=F, quote=F)

