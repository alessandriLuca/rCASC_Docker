 library("argparser")
 library("vioplot")
 library("SIMLR")
 library("tools")
 library("ps")
 
p <- arg_parser("permutation")
p <- add_argument(p, "projectName", help="matrix count name")
p <- add_argument(p, "matrixName", help="matrix count name")
p <- add_argument(p, "separator", help="matrix separator ")
p <- add_argument(p, "nCluster", help="Similarity Percentage ")
p <- add_argument(p, "seed", help="Similarity Percentage ")
p <- add_argument(p, "permAtTime", help="Similarity Percentage ")


argv <- parse_args(p)

#projectName="HBC_TF"
#separator=","
#nCluster=9
#colours=rainbow(nCluster)
#matrixName="HBC_BAS1_expr-var-ann_matrix"
#seed=111
#permAtTime=4

projectName=argv$projectName
separator=argv$separator
nCluster=as.numeric(argv$nCluster)
colours=rainbow(nCluster)
matrixName=argv$matrixName
set.seed(as.numeric(argv$seed))
permAtTime=as.numeric(argv$permAtTime)



setwd("/scratch")
dir.create(paste("./",projectName,"_SIMLR",sep=""))
dir.create(paste("./",projectName,"_SIMLR/",nCluster,sep=""))
dir.create(paste("./",projectName,"_SIMLR/",nCluster,"/permutation",sep=""))
dir.create(paste("./",projectName,"_SIMLR/",nCluster,"/permutation/TEMP",sep=""))


if(separator=="tab"){separator2="\t"}else{separator2=separator}
lists=list.files(paste("./",projectName,"/",toString(nCluster),"/permutation",sep=""),pattern=paste("*denseSpace*",sep=""))
format=file_ext(lists[1])
system(paste("cp ","./",projectName,"/",matrixName,".",format," ./",projectName,"_SIMLR/",sep=""))
system(paste("cp ./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,"  ./",projectName,"_SIMLR/",nCluster,sep=""))
clustering.output=read.table(paste("./",projectName,"/",toString(nCluster),"/",matrixName,"_clustering.output.",format,sep=""),sep=separator2,header=TRUE)

nPerm=length(lists)

finished=FALSE

#while(!finished)
#{
cycles=length(lists)/permAtTime
for(i in 1:cycles){
    system(paste("for X in $(seq ",permAtTime,")
do
 nohup Rscript /home/permutationSIMLR.R ",matrixName," ",format," ",separator," ",nCluster," ",projectName," $(($X +",(i-1)*permAtTime," )) > my.log 2>&1 &
echo $! >> save_pid.txt 

done",sep=""))
d=1
files=read.table("save_pid.txt",header=FALSE)
wl=TRUE
while(wl){
    wlCount=c()
    for(ppid in files[[1]]){
        psTable=as.matrix(ps())
        if(as.matrix(psTable[which(as.matrix(psTable[,1])==ppid),"status"])=="zombie"){ttr=1}else{ttr=0}
        wlCount=append(wlCount,ttr)
    }
if(length(which(wlCount==1))==permAtTime){wl=FALSE}
if(d==1){cat(paste("Cluster number ",nCluster," ",((permAtTime*i))/nPerm*100," % complete \n"))}
d=2
}
system("rm save_pid.txt")
system("sync")
gc()
}


#listsComplete=list.files(paste("./",projectName,"_SIMLR/",nCluster,"/permutation/TEMP/",sep=""))
#listsComplete=paste(tools::file_path_sans_ext(listsComplete),"denseSpace.",format,sep="")
#newlists=setdiff(lists,listsComplete)
#dir.create(paste("./",projectName,"_SIMLR/",nCluster,"/permutation/TEMP2/",sep=""))
#for(fn in listsComplete){
#system(paste("mv ./",projectName,"_SIMLR/",nCluster,"/permutation/",fn," ","./",projectName,"_SIMLR/",nCluster,"/permutation/TEMP2/",sep=""))

#}
#if(length(newlists)==0){
#finished=TRUE
#}
#lists=newlists
#}
#system(paste("mv ./",projectName,"_SIMLR/",nCluster,"/permutation/TEMP2/* ","./",projectName,"_SIMLR/",nCluster,"/permutation/",sep=""))


permutation=sapply(list.files(paste("./",projectName,"_SIMLR/",nCluster,"/permutation/TEMP/",sep=""),pattern=paste("*.",format,sep="")),FUN=function(x){

return(read.table(paste("./",projectName,"_SIMLR/",nCluster,"/permutation/TEMP/",x,sep=""),sep=separator2,header=FALSE))

})

permutation=do.call(cbind,permutation)
write.table(permutation,paste("./",projectName,"_SIMLR/",nCluster,"/label.",format,sep=""),col.names=NA,sep=separator2)

system("chmod -R 777 ./../scratch")
#system("cp -r * ./../data/Results")
