library(shiny)
library(myvariant)
library(magrittr)
library(IRanges)
library(plyr)
library(httr)
library(jsonlite)
library(myvariant)
library(VariantAnnotation)
library(ggplot2)
library(DT)
library(datasets)
library(reshape2)
library(knitr)
library(Gviz)
library(BSgenome.Hsapiens.UCSC.hg19)

options(shiny.trace=TRUE)
options(shiny.maxRequestSize = 10*1024^2) # 10mb file size limit

bam.path="~/AWS/storage/patients/alignments/"
bam.filenames<-list.files(path=bam.path, pattern = "*.bam$", recursive = T)
