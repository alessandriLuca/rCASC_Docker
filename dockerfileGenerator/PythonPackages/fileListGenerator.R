a=rev(readLines("out.txt"))

aSpace=sapply(a,FUN=function(x){

length(gregexpr(" ", x)[[1]])

})

filesList=c()
for(i in sort(unique(aSpace),decreasing=TRUE)){
filesList=append(filesList,names(aSpace)[which(aSpace==i)])

}
filesList=gsub(" ","",filesList)
filesList=gsub("-","_",filesList)
if(length(which(filesList==""))>0){
filesList=filesList[-which(filesList=="")]
}
filesFolder="/home/lucastormreig/git/rCASC_Docker/deepTCR/tmp/"
filesFolderList=list.files(filesFolder)
filesList2=c()
for(x in filesList){
filesList2=append(filesList2,filesFolderList[grep(filesFolderList,pattern=paste(strsplit(x,"==")[[1]][1],"-",sep=""))])
}
writeLines(paste("/tmp/tmp/",unlist(filesList2)," \\",sep=""),"yo.txt")
