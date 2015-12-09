shinyServer(function(input, output) {
  
 ##############################################################################
 ###  load data tab
 ##############################################################################
 
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
  
  ###############################################################################
  ### dna variants tab
  ###############################################################################
  output$tableDNA <- DT::renderDataTable({
    dat <- dataInputDNA()
    if(is.null(input$annotationDNA)) {
      dat[,c('Variant', 'Gene'), drop=FALSE]
    } else {
      sel <- colnames(dat)[unlist(sapply(input$annotationDNA, function(i) grep(i, colnames(dat))))]
      dat[,c('Variant','Gene',sel), drop=FALSE]
    }
  },
  server=TRUE)

  output$seltableDNA <- DT::renderDataTable({
    s = input$tableDNA_rows_selected
    if (length(s)) {
      dat <- dataInputDNA()
      if(is.null(input$annotationDNA)) {
        dat[s, c('Variant', 'Gene'), drop=FALSE]
      } else {
        sel <- colnames(dat)[unlist(sapply(input$annotationDNA, function(i) grep(i, colnames(dat))))]
        dat[s, c('Variant','Gene',sel), drop=FALSE]
      }
    }
  })  
  
  output$info = renderPrint({
    s = input$tableDNA_rows_selected
    if (length(s)) {
      dim(dataInputDNA())
      str(dataInputDNA())
      dim(data)
    }
  })  
  
  output$indDNA = renderPrint({
    s = input$tableDNA_rows_selected
    if (length(s)) {
      cat('These rows were selected:\n\n')
      cat(s, sep = ', ')
    }
  })
  
  output$infoDNA = renderPrint({

  })
  ###############################################################################
  ### rna variants tab
  ###############################################################################
  output$tableRNA <- DT::renderDataTable({
    dat <- dataInputRNA()
    if(is.null(input$annotationRNA)) {
      dat[,c('Variant', 'Gene'), drop=FALSE]
    } else {
      sel <- colnames(dat)[unlist(sapply(input$annotationRNA, function(i) grep(i, colnames(dat))))]
      dat[,c('Variant','Gene',sel), drop=FALSE]
    }
  },
  server=TRUE)
  
  output$seltableRNA <- DT::renderDataTable({
    s = input$tableRNA_rows_selected
    if (length(s)) {
      dat <- dataInputRNA()
      if(is.null(input$annotationRNA)) {
        dat[s, c('Variant', 'Gene'), drop=FALSE]
      } else {
        sel <- colnames(dat)[unlist(sapply(input$annotationRNA, function(i) grep(i, colnames(dat))))]
        dat[s, c('Variant','Gene',sel), drop=FALSE]
      }
    }
  })
  
  output$indRNA = renderPrint({
    s = input$tableRNA_rows_selected
    if (length(s)) {
      cat('These rows were selected:\n\n')
      cat(s, sep = ', ')
    }
  })

  ###############################################################################
  ### rna expression tab
  ###############################################################################  
  output$libSize = renderTable({
    s <- dataInputExpr()
    s
  })
  
  ###############################################################################
  ### report tab
  ###############################################################################
  
  
  
})