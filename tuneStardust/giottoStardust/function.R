euc.dist = function(x1, x2) sqrt(sum((x1 - x2) ^ 2))

silhouette=function(nCluster,clustering.output){
 
    dataPlot=cbind(as.numeric(clustering.output[,3]),as.numeric(clustering.output[,4])) 
    nCluster=length(unique(clustering.output[,2]))
    mainVector=as.numeric(clustering.output[,2])
    intraScore=c()   
    extraScore=c()
    neighbor=c()
    silhouetteValue=c()

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

clustering=function(matrixName,matrix.h5,positions.csv,n_clusters,pcaDimensions,
    nPerm,permAtTime,percent,nCluster,betaStart,betaIncrement,betaNumber,tolerance,numinit){

    n_clusters = as.integer(n_clusters)
    pcaDimensions = as.integer(pcaDimensions)
    countMatrix=read.table(paste("/scratch/",matrixName,sep=""),sep="\t",header=TRUE,row.name=1)
    countMatrix <- countMatrix[,sort(colnames(countMatrix))]
    pbmc <- CreateSeuratObject(countMatrix)
    pbmc <- SCTransform(pbmc, assay = "RNA", verbose = FALSE)
    pbmc <- RunPCA(pbmc, assay = "SCT", verbose = FALSE)
    pbmc.new <- RunTSNE(object = pbmc) 
    Coordinates <- pbmc.new@reductions[["tsne"]]@cell.embeddings

    #############
    my_giotto_object = createGiottoVisiumObject(visium_dir="/scratch", expr_data="filter",
        h5_visium_path=paste0("/scratch/",matrix.h5), 
        h5_tissue_positions_path=paste0("/scratch/",positions.csv))

    my_giotto_object <- filterGiotto(gobject = my_giotto_object, 
                             expression_threshold = 1, 
                             gene_det_in_min_cells = 10, 
                             min_det_genes_per_cell = 0)
    my_giotto_object <- normalizeGiotto(gobject = my_giotto_object)
    my_giotto_object <- calculateHVG(gobject = my_giotto_object)
    my_giotto_object <- runPCA(gobject = my_giotto_object,ncp=pcaDimensions,reduction="cells")

    # create network (required for binSpect methods)
    my_giotto_object = createSpatialNetwork(gobject = my_giotto_object, minimum_k = 2)
    # identify genes with a spatial coherent expression profile
    km_spatialgenes = binSpect(my_giotto_object, bin_method = 'kmeans')

    hmrf_folder = "/scratch/giotto_out"
    if(!file.exists(hmrf_folder)) dir.create(hmrf_folder, recursive = T)
    # perform hmrf
    my_spatial_genes = km_spatialgenes[1:100]$genes
    HMRF_spatial_genes = doHMRF(gobject = my_giotto_object,
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
    png(filename="/scratch/giotto_out/full_giotto.png")
    # visualize selected hmrf result
    giotto_colors = Giotto:::getDistinctColors(n_clusters)
    names(giotto_colors) = 1:n_clusters
    spatPlot(gobject = my_giotto_object, cell_color = paste0("HMRF_k",n_clusters,"_b.25"),
        point_size = 3, coord_fix_ratio = 1, cell_color_code = giotto_colors)
    dev.off()

    #############

    mainVector = my_giotto_object@cell_metadata[,5]
    mainVector = as.numeric(mainVector[[1]])
    jumping_clusters = sort(unique(mainVector))
    for(i in 1:length(jumping_clusters)){
        mainVector[mainVector==jumping_clusters[i]] = i
    }
    nCluster <- length(unique(mainVector))
    dir.create(paste("./",nCluster,sep=""))
    dir.create(paste("./",nCluster,"/Permutation",sep=""))
    setwd(paste("./",nCluster,sep=""))

    clustering.output <- cbind(rownames(Coordinates),mainVector,Coordinates[,1],Coordinates[,2])
    clustering.output <- silhouette(length(unique(mainVector)),clustering.output)
    colnames(clustering.output) <- c("cellName","Belonging_Cluster","xChoord","yChoord","extraScore","intraScore","neighbor","silhouetteValue")
    matrixNameBis = strsplit(matrixName,".",fixed = TRUE)[[1]][1]
    write.table(clustering.output,paste(matrixNameBis,"_clustering.output.","txt",sep=""),sep="\t", row.names = F)
    cycles <- nPerm/permAtTime
    cat(getwd())
    for(i in 1:cycles){
            system(paste("for X in $(seq ",permAtTime,")
        do
        nohup Rscript ./../../../home/permutation.R ",percent," ",matrix.h5," ",positions.csv," ",n_clusters," ",pcaDimensions," $(($X +",(i-1)*permAtTime," )) & 
        done"))
        d=1
        while(length(list.files("./Permutation",pattern=paste("*.","txt",sep="")))!=i*permAtTime*2){
            if(d==1){cat(paste("Cluster number ",nCluster," ",((permAtTime*i))/nPerm*100," % complete \n"))}
            d=2
        }
        system("echo 3 > /proc/sys/vm/drop_caches")
        system("sync")
        gc()
    }
    cluster_p <- sapply(list.files("./Permutation/",pattern="cluster*"),FUN=function(x){a=read.table(paste("./Permutation/",x,sep=""),header=TRUE,col.names=1,sep="\t")[[1]]})
    killedC <- sapply(list.files("./Permutation/",pattern="killC*"),FUN=function(x){a=read.table(paste("./Permutation/",x,sep=""),header=TRUE,col.names=1,sep="\t")[[1]]})

    write.table(as.matrix(cluster_p,col.names=1),paste(matrixNameBis,"_",nCluster,"_clusterP.","txt",sep=""),sep="\t",row.names=FALSE, quote=FALSE)
    write.table(as.matrix(killedC,col.names=1),paste(matrixNameBis,"_",nCluster,"_killedCell.","txt",sep=""),sep="\t",row.names=FALSE, quote=FALSE)

    pdf("hist.pdf")
    clusters <- apply(cluster_p,2,FUN=function(x){max(x)})
    hist(clusters,xlab="nCluster",breaks=length(unique(cluster_p)))
    dev.off()

    write.table(sort(unique(clusters)),paste("./../rangeVector.","txt",sep=""),sep="\t",row.names=FALSE,col.names=FALSE)
    system("rm -r Permutation")
    return(length(unique(mainVector)))
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
