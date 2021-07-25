



subsetCells <- function(filename, cells.number, separator=c(",","tab")){
if(separator=="tab"){separator="\t"}else{separator=separator}
  n <- cells.number
  tmp <- read.table(filename, sep=separator, header=T, row.names=1, stringsAsFactors = F)

  mysample <- sample(seq(1:dim(tmp)[2]), size=n)
  tmp <- tmp[,mysample]
  write.table(tmp, paste("subset",n,filename,sep="_"), sep=separator, col.names = NA)
} 
 setwd("./home")
 #source("functions.R")
 #library("SIMLR")
 library("argparser")
 #library(dplyr)
 #library("vioplot")
 
p <- arg_parser("permutation")
p <- add_argument(p, "filename", help="matrix count name")
p <- add_argument(p, "cells.number", help="matrix format like csv, txt...")
p <- add_argument(p, "separator", help="matrix separator ")
argv <- parse_args(p)

filename=argv$filename
cells.number=as.numeric(argv$cells.number)
separator=argv$separator
setwd("./../scratch")

subsetCells(filename,cells.number,separator)
