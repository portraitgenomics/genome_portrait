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

options(shiny.trace=TRUE)
options(shiny.maxRequestSize = 10*1024^2) # 10mb file size limit

source('readVCF.R')