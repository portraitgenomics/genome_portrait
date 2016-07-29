# Copyright (c) 2016 Tobias Meissner
# Licensed under the MIT License (MIT)

shinyServer(function(input, output) {
  
  ##############################################################################
  ###  load data tab
  ##############################################################################
  source('readVCF.R', local = TRUE)
  source('dataIn.R', local = TRUE)
  
  ###############################################################################
  ### dna variants tab
  ###############################################################################
  source('dnaVar.R', local = TRUE)
  
  ###############################################################################
  ### rna variants tab
  ###############################################################################
  source('rnaVar.R', local = TRUE)

  ###############################################################################
  ### rna expression tab
  ###############################################################################  
  source('rnaExp.R', local = TRUE)
  
  ###############################################################################
  ### report tab
  ###############################################################################
  source('createReport.R', local = TRUE)
  
  ##############################################################################
  ###  save / load session
  ##############################################################################
  saveData <- reactive({
    input$session.save
    isolate({
      sv <- input
      fileName <- paste0(input$session.save.name,'.Rdata')
      save(sv, file = fileName)
    })
  })
  
  loadData <- reactive({
    input$session.load
    isolate({
      load(input$session.load.name)
      input <- sv
    })
  })
  
})