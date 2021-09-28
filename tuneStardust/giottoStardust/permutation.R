library("Seurat")
library("argparser")
library(dplyr)
library(Matrix)
library(stringi)
library(ggplot2)
library(Giotto)

p <- arg_parser("permutation")
p <- add_argument(p, "percent", help="matrix count name")
p <- add_argument(p, "matrix.h5", help="matrix count name in h5 format")
p <- add_argument(p, "positions.csv", help="spot positions in csv format")
p <- add_argument(p, "n_clusters", help="how many clusters BayeSpace should search")
p <- add_argument(p, "pcaDimensions", help="PCA dimension for seurat first number")
p <- add_argument(p, "index", help="Clulstering method: SIMLR tSne Griph")

argv <- parse_args(p)
cat(system("pwd"))
matrix.h5=argv$matrix.h5
positions.csv=argv$positions.csv
n_clusters=as.integer(argv$n_clusters)
pcaDimensions=as.integer(argv$pcaDimensions)
index=argv$index
percent=as.numeric(argv$percent)

source("./../../../home/functions.R")
suffix = stri_rand_strings(length=5,n=1)

system(paste0("cp /scratch/",matrix.h5," /scratch/",suffix,".h5"))
my_giotto_object = createGiottoVisiumObject(visium_dir="/scratch", expr_data="filter",
    h5_visium_path=paste0("/scratch/",suffix,".h5"), 
    h5_tissue_positions_path=paste0("/scratch/",positions.csv))

killedCell <- sample(length(my_giotto_object@cell_ID),
    length(my_giotto_object@cell_ID)*percent/100)
killedCellNames <- my_giotto_object@cell_ID[killedCell]
cellsToKeep <- setdiff(my_giotto_object@cell_ID,killedCellNames)
my_giotto_object <- subsetGiotto(my_giotto_object,cell_ids=cellsToKeep)

my_giotto_object <- filterGiotto(gobject = my_giotto_object, 
                            expression_threshold = 1, 
                            gene_det_in_min_cells = 10, 
                            min_det_genes_per_cell = 0)
my_giotto_object <- normalizeGiotto(gobject = my_giotto_object)
my_giotto_object <- calculateHVG(gobject = my_giotto_object)
my_giotto_object <- runPCA(gobject = my_giotto_object,ncp=pcaDimensions,reduction="cells")
my_giotto_object = createSpatialNetwork(gobject = my_giotto_object, minimum_k = 2)
# identify genes with a spatial coherent expression profile
km_spatialgenes = binSpect(my_giotto_object, bin_method = 'kmeans')
my_spatial_genes = km_spatialgenes[1:100]$genes


hmrf_folder = paste0("/scratch/giotto_",suffix,"_out")
if(!file.exists(hmrf_folder)) dir.create(hmrf_folder, recursive = T)
doHMRF(gobject = my_giotto_object,
                                expression_values = 'scaled',
                                spatial_genes = my_spatial_genes,
                                spatial_network_name = 'Delaunay_network',
                                k = n_clusters,
                                betas = c(betaStart,betaIncrement,betaNumber),
                                python_path="/root/miniconda3/bin/python",
                                output_folder = paste0(hmrf_folder,'/SG_top100_scaled'),tolerance,numinit)
my_giotto_object = addHMRF(gobject = my_giotto_object,
                HMRFoutput = HMRF_spatial_genes,
                k = n_clusters, betas_to_add = c(25),
                hmrf_name = 'HMRF')
system(paste0("rm /scratch/",suffix,".h5"))
system(paste0("rm -rf ",hmrf_folder,'/SG_top100_scaled'))

png(paste0(hmrf_folder,'/',suffix,".png"))
# visualize selected hmrf result
giotto_colors = Giotto:::getDistinctColors(n_clusters)
names(giotto_colors) = 1:n_clusters
spatPlot(gobject = my_giotto_object, cell_color = paste0("HMRF_k",n_clusters,"_b.25"),
    point_size = 3, coord_fix_ratio = 1, cell_color_code = giotto_colors)
dev.off()

mainVector = my_giotto_object@cell_metadata[,5]
mainVector = as.numeric(mainVector[[1]])
jumping_clusters = sort(unique(mainVector))
for(i in 1:length(jumping_clusters)){
    mainVector[mainVector==jumping_clusters[i]] = i
}

write.table(mainVector,paste("./Permutation/clusterB_",index,".","txt",sep=""),sep="\t")
write.table(killedCell,paste("./Permutation/killC_",index,".","txt",sep=""),sep="\t")
rm(list=setdiff(ls(),"index"))
dir.create("./memory")
system(paste("cat /proc/meminfo >  ./memory/",index,".txt",sep=""))
