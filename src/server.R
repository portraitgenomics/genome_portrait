shinyServer(function(input, output) {
  
 ##############################################################################
 ###  load data tab
 ##############################################################################
 
  ## dna input
  dataInputDNA <- reactive({
    inFile <- input$fileDNAVcf
    if (is.null(inFile))
      return(NULL)
    data <- rvcf(inFile$datapath, input$annotation)
  })

  ## rna input
  dataInputRNA <- reactive({
    inFile <- input$fileRNAVcf
    if (is.null(inFile))
      return(NULL)
    data <- rvcf(inFile$datapath, input$annotation)
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
    dataInputDNA()
  },
  server=TRUE)

  output$seltableDNA <- DT::renderDataTable({
    s = input$tableDNA_rows_selected
    if (length(s)) {
      dataInputDNA()
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
  ###############################################################################
  ### rna variants tab
  ###############################################################################
  output$tableRNA <- DT::renderDataTable({
    dataInputRNA()
  },
  server=TRUE)
  
  output$seltableRNA <- DT::renderDataTable({
    s = input$tableRNA_rows_selected
    if (length(s)) {
      dataInputRNA()
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