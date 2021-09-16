#' @title Stardust Permutation
#' @description This function executes a ubuntu docker that produces a specific number of permutation to evaluate clustering 
#'  using an extended conf. of seurat (updated to 2020) that take into consideration physical position of spots.
#' @param group, a character string. Two options: sudo or docker, depending to which group the user belongs
#' @param scratch.folder, a character string indicating the path of the scratch folder
#' @param file, a character string indicating the path of the file, with file name and extension included
#' @param tissuePosition, file with tissue position name with extension
#' @param spaceWeight, double in [0,1]. Weight for the linear transormation of spot distance.
#'  1 means spot distance weight as much as profile distance, 0 means spot distance doesn't contribute at all in the overall 
#'  distance measure.
#' @param res, double resolution for louvain algorithm
#' @param nPerm, number of permutations to perform the pValue to evaluate clustering
#' @param permAtTime, number of permutations that can be computes in parallel
#' @param percent, percentage of randomly selected cells removed in each permutation
#' @param separator, separator used in count file, e.g. '\\t', ','
#' @param logTen, 1 if the count matrix is already in log10, 0 otherwise
#' @param pcaDimensions, 	0 for automatic selection of PC elbow.
#' @param seed, important value to reproduce the same results with same input
#' @param sparse, boolean for sparse matrix
#' @param format, output file format csv or txt

#' @author Luca Alessandri, alessandri [dot] luca1991 [at] gmail [dot] com, University of Torino
#' @author Giovanni Motterle, giovanni [dot] motterle [at] studenti [dot] univr [dot] it, University of Verona
#'
#' @return To write
#' @export

StardustPermutation <- function(group=c("sudo","docker"), scratch.folder, 
  file, tissuePosition, spaceWeight=1,res=0.8, nPerm, permAtTime, percent, separator, 
  logTen=0, pcaDimensions=5, seed=1111, sparse=FALSE, format="NULL"){

  if(!sparse){
  data.folder=dirname(file)
  matrixNameC=strsplit(basename(file),"\\.")[[1]]
  positions=length(matrixNameC)
  matrixName=paste(matrixNameC[seq(1,positions-1)],collapse="")
  format=strsplit(basename(basename(file)),"\\.")[[1]][positions]
  }else{
    matrixName=strsplit(dirname(file),"/")[[1]][length(strsplit(dirname(file),"/")[[1]])]
    data.folder=paste(strsplit(dirname(file),"/")[[1]][-length(strsplit(dirname(file),"/")[[1]])],collapse="/")
    if(format=="NULL"){
      stop("Format output cannot be NULL for sparse matrix")
    }
  }

  #check valid value for spaceWeight
  tissuePositionFile = basename(tissuePosition)
  spaceWeight = as.double(spaceWeight)
  if(is.na(spaceWeight))
    stop("Param spaceWeight is not a double number.")
  if(spaceWeight > 1 | spaceWeight < 0)
    stop("spaceWeight is not in [0,1]")
  res = as.double(res)
  if(is.na(res) || res < 0 || res > 5){
    stop("Param res is not valid. Values are in [0,5].")
  }
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
  if (!file.exists(scratch.folder)){
    cat(paste("\nIt seems that the ",scratch.folder, " folder does not exist\n"))
    system("echo 3 > ExitStatusFile 2>&1")
    setwd(data.folder)
    return(3)
  }
  tmp.folder <- gsub(":","-",gsub(" ","-",date()))
  scrat_tmp.folder=file.path(scratch.folder, tmp.folder)
  writeLines(scrat_tmp.folder,paste(data.folder,"/tempFolderID", sep=""))
  cat("\ncreating a folder in scratch folder\n")
  dir.create(file.path(scrat_tmp.folder))
  #preprocess matrix and copying files

  if(separator=="\t"){
    separator="tab"
  }

  dir.create(paste(scrat_tmp.folder,"/",matrixName,sep=""))
  dir.create(paste(data.folder,"/Results",sep=""))
  system(paste("cp ",tissuePosition," ",scrat_tmp.folder,"/",sep=""))
  if(sparse==FALSE){
    system(paste("cp ",data.folder,"/",matrixName,".",format," ",scrat_tmp.folder,"/",sep=""))
  }else{
    system(paste("cp -r ",data.folder,"/",matrixName,"/ ",scrat_tmp.folder,"/",sep=""))
  }

  profileDistance = 2
  spotDistance = 2
  #executing the docker job
  params <- paste("--cidfile ",data.folder,"/dockerID -v ",scrat_tmp.folder,
    ":/scratch -v ", data.folder, 
    ":/data -d docker.io/giovannics/spatial2020seuratpermutation Rscript /home/main.R ",
    matrixName," ",tissuePositionFile," ",profileDistance," ",spotDistance," ", 
  spaceWeight," ",res," ",nPerm," ",permAtTime," ",percent," ",format," ",separator,
    " ",logTen," ",pcaDimensions," ",seed," ",sparse,sep="")

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
