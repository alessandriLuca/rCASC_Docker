#' @title Giotto Permutation
#' @description This function executes a ubuntu docker that produces a specific number of permutation to evaluate clustering 
#'  using Giotto HMRF clustering
#' @param group, a character string. Two options: sudo or docker, depending to which group the user belongs
#' @param scratch.folder, a character string indicating the path of the scratch folder
#' @param file, a character string indicating the full path + name with extension (.txt) of the expression matrix
#' @param h5matrix.name, a character string indicating the full path + name with extension (.h5) of the expression matrix
#' @param spotpositions.name, a character string indicating the full path + name with extension (.csv) of the spot positions
#' @param n_clusters, an integer indicating how many clusters BayeSpace should search
#' @param pcaDimensions, number of PCA dimension to keep
#' @param nPerm, number of permutations to perform the pValue to evaluate clustering
#' @param permAtTime, number of permutations that can be computes in parallel
#' @param percent, percentage of randomly selected cells removed in each permutation
#' @param seed, important value to reproduce the same results with same input

#' @author Giovanni Motterle, giovanni [dot] motterle [at] studenti [dot] univr [dot] it, University of Verona
#'
#' @return To write
#' @export

GiottoPermutation <- function(group=c("sudo","docker"), scratch.folder,
  file, h5matrix.name,spotpositions.name, n_clusters=10, pcaDimensions=10, 
  nPerm=80, permAtTime=8, percent=10, seed=1111,betaStart=0,betaIncrement=2,betaNumber=50,tolerance=0.1,numinit=100){
  
  data.folder = normalizePath(dirname(file))
  matrixName = strsplit(file,"/",fixed = TRUE)[[1]]
  matrixName = matrixName[length(matrixName)]
  matrixName = strsplit(matrixName,".",fixed = TRUE)[[1]][1]

  #running time 1
  ptm <- proc.time()
  #setting the data.folder as working folder
  if (!file.exists(data.folder)){
    cat(paste("\nIt seems that the ",data.folder, " folder does not exist\n"))
    system("echo 2 > ExitStatusFile 2>&1")
    return(2)
  }

  #storing the position of the home folder
  home <- getwd()
  setwd(data.folder)
  #initialize status
  system("echo 0 > ExitStatusFile 2>&1")

  #testing if docker is running
  test <- dockerTest()
  if(!test){
    cat("\nERROR: Docker seems not to be installed in your system\n")
    system("echo 10 > ExitStatusFile 2>&1")
    setwd(home)
    return(10)
  }

  #check  if scratch folder exist

 

scrat_tmp.folder=scratch.folder
  dir.create(paste(scrat_tmp.folder,"/",matrixName,sep=""))
  dir.create(paste(data.folder,"/Results",sep=""))

  system(paste("cp ",file," ",scrat_tmp.folder,"/",sep=""))
  system(paste("cp ",h5matrix.name," ",scrat_tmp.folder,"/",sep=""))
  system(paste("cp ",spotpositions.name," ",scrat_tmp.folder,"/",sep=""))

  filefile = strsplit(file,"/",fixed = TRUE)[[1]]
  filefile = filefile[length(filefile)]
  h5matrixfile = strsplit(h5matrix.name,"/",fixed = TRUE)[[1]]
  h5matrixfile = h5matrixfile[length(h5matrixfile)]
  spotpositionsfile = strsplit(spotpositions.name,"/",fixed = TRUE)[[1]]
  spotpositionsfile = spotpositionsfile[length(spotpositionsfile)]
  #executing the docker job
  params <- paste("--cidfile ",data.folder,"/dockerID -v ",scrat_tmp.folder,
    ":/scratch -v ", data.folder, 
    ":/data -d docker.io/giovannics/giottopermutationtuning Rscript /home/main.R ",
    filefile," ",h5matrixfile," ",spotpositionsfile," ",n_clusters," ",pcaDimensions,
    " ",nPerm," ",permAtTime," ",percent," ",seed," ",betaStart," ",betaIncrement," ",betaNumber," ",tolerance," ",numinit,sep="")

  resultRun <- runDocker(group=group, params=params)

  #waiting for the end of the container work
  if(resultRun==0){
    #system(paste("cp ", scrat_tmp.folder, "/* ", data.folder, sep=""))
  }
  #running time 2
  ptm <- proc.time() - ptm
  dir <- dir(data.folder)
  dir <- dir[grep("run.info",dir)]
  if(length(dir)>0){
    con <- file("run.info", "r")
    tmp.run <- readLines(con)
    close(con)
    tmp.run[length(tmp.run)+1] <- paste("user run time mins ",ptm[1]/60, sep="")
    tmp.run[length(tmp.run)+1] <- paste("system run time mins ",ptm[2]/60, sep="")
    tmp.run[length(tmp.run)+1] <- paste("elapsed run time mins ",ptm[3]/60, sep="")
    writeLines(tmp.run,"run.info")
  }else{
    tmp.run <- NULL
    tmp.run[1] <- paste("run time mins ",ptm[1]/60, sep="")
    tmp.run[length(tmp.run)+1] <- paste("system run time mins ",ptm[2]/60, sep="")
    tmp.run[length(tmp.run)+1] <- paste("elapsed run time mins ",ptm[3]/60, sep="")

    writeLines(tmp.run,"run.info")
  }

  #saving log and removing docker container
  container.id <- readLines(paste(data.folder,"/dockerID", sep=""), warn = FALSE)
  system(paste("docker logs ", substr(container.id,1,12), " &> ",data.folder,"/", 
    substr(container.id,1,12),".log", sep=""))
  system(paste("docker rm ", container.id, sep=""))


  #Copy result folder
  cat("Copying Result Folder")
  system(paste("cp -r ",scrat_tmp.folder,"/* ",data.folder,"/Results",sep=""))
  #removing temporary folder
  cat("\n\nRemoving the temporary file ....\n")
  system(paste("rm -R ",scrat_tmp.folder))
  system("rm -fR out.info")
  system("rm -fR dockerID")
  system("rm  -fR tempFolderID")
  system(paste("cp ",paste(path.package(package="rCASC"),
    "containers/containers.txt",sep="/")," ",data.folder, sep=""))
  setwd(home)
} 
