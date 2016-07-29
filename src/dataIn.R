# Copyright (c) 2016 Tobias Meissner
# Licensed under the MIT License (MIT)

## dna input
dataInputDNA <- reactive({
  inFile <- input$fileDNAVcf
  if (is.null(inFile))
    return(NULL)
  data <- rvcf(inFile$datapath, input$annotationDNA)
})

## rna input
dataInputRNA <- reactive({
  inFile <- input$fileRNAVcf
  if (is.null(inFile))
    return(NULL)
  data <- rvcf(inFile$datapath, input$annotationRNA)
})

## epxr data input
dataInputExpr <- reactive({
  inFile <- input$fileExpr
  if (is.null(inFile))
    return(NULL)
  x <- read.csv2(inFile$datapath, stringsAsFactors=F, sep='\t',skip=1)
  data <- x[,7, drop = FALSE]
  colnames(data) <- 'Patient'
  rownames(data) <- x$Geneid
  data
})

## stats on the main tab
output$nVcfDNA <- renderPrint({
  s <- dataInputDNA()
  dim(s)[1]
})

output$exprLibSize <- renderPrint({
  s <- dataInputExpr()
  sum(s[,1])/1000000
})