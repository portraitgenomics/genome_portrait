# Copyright (c) 2016 Tobias Meissner
# Licensed under the MIT License (MIT)

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