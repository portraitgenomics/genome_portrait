shinyServer(function(input, output) {
  dataInputDNA <- reactive({
    inFile <- input$fileDNAVcf
    if (is.null(inFile))
      return(NULL)
    data <- rvcf(inFile$datapath, input$annotation)
  })
  
  dataInputRNA <- reactive({
    inFile <- input$fileRNAVcf
    if (is.null(inFile))
      return(NULL)
    data <- rvcf(inFile$datapath, input$annotation)
  })
  
  output$tableDNA <- DT::renderDataTable({
    dataInputDNA()
  },
  server=TRUE)
  
  output$tableRNA <- DT::renderDataTable({
    dataInputRNA()
  },
  server=TRUE)
  
  output$seltableDNA <- DT::renderDataTable({
    s = input$tableDNA_rows_selected
    if (length(s)) {
      dataInputDNA()
    }
  })
  
  output$seltableRNA <- DT::renderDataTable({
    s = input$tableRNA_rows_selected
    if (length(s)) {
      dataInputRNA()
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
  
  output$indRNA = renderPrint({
    s = input$tableRNA_rows_selected
    if (length(s)) {
      cat('These rows were selected:\n\n')
      cat(s, sep = ', ')
    }
  })
  
})