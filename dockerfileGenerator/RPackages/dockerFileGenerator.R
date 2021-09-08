install.packages('devtools', repos='http://cran.us.r-project.org')
system("grep trying nohup.out > toDownload.txt")
toDownload=read.table("toDownload.txt")[,3]
dir.create("packages")
setwd("./packages")
for(i in toDownload){
system(paste("wget ",i))
}
install.packages("/scratch/packrat_0.7.0.tar.gz",repos = NULL, type="source")
sorted=packrat:::recursivePackageDependencies("devtools",lib.loc = .libPaths()[1])

ll=c()
ll=append(ll,"R CMD INSTALL --build \\")
for(i in sorted){
ll=append(ll,paste("/tmp/packages/",basename(as.vector(toDownload[grep(i,toDownload)]))," \\",sep=""))
}
write(unique(ll),"listForDockerfile.sh")
system("chmod 777 listForDockerfile.sh")
system("7za -v25165824 a /scratch/install_files.7z /scratch/packages")
