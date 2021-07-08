library("argparser")
p <- arg_parser("permutation")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "nCluster", help="Permutation number for bootstrap algorithm ")


argv <- parse_args(p)

matrixName=argv$matrixName
nCluster=argv$nCluster
setwd("/scratch/")
df = read.table("markers.txt", header=TRUE, row.names=1, stringsAsFactors=F)
df <- log2(df + 1)
write.table(df, "markers.txt", col.names=NA, quote=F, sep="\t")

