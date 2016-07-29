# Copyright (c) 2016 Tobias Meissner
# Licensed under the MIT License (MIT)

output$tableDNA <- DT::renderDataTable({
  dat <- dataInputDNA()
  
  if(input$dna.filter.exac.check) {
    dat <- subset(dat, ExAc>=input$dna.filter.exac[1] & ExAc<=input$dna.filter.exac[2])
  }
  if(input$dna.filter.cadd.check) {
    dat <- subset(dat, Cadd>=input$dna.filter.cadd[1] & Cadd<=input$dna.filter.cadd[2])
  }
  
  # add checkboxes
  dat <- cbind(AlgView = sprintf( '<input type="radio" name="blah" value="%d"/>', 1:nrow(dat)),
               dat)
  DT::datatable(dat, 
                escape = FALSE,
                options = list(pageLength = 15, 
                               orderClasses = TRUE,
                               searchable = TRUE
                ),
                filter = 'top'
  )
  #if(is.null(input$annotationDNA)) {
  #dat[,c('Variant', 'Gene'), drop=FALSE]
  #} else {
  #  sel <- colnames(dat)[unlist(sapply(input$annotationDNA, function(i) grep(i, colnames(dat))))]
  #  dat[,c('Variant','Gene',sel), drop=FALSE]
  #}
},
server=TRUE)

output$seltableDNA <- DT::renderDataTable({
  s <- input$tableDNA_rows_selected
  if (length(s)) {
    dat <- dataInputDNA()
    #if(is.null(input$annotationDNA)) {
    #  dat[s, c('Variant', 'Gene'), drop=FALSE]
    #} else {
    #  sel <- colnames(dat)[unlist(sapply(input$annotationDNA, function(i) grep(i, colnames(dat))))]
    #  dat[s, c('Variant','Gene',sel), drop=FALSE]
    #}
    DT::datatable(dat[s,], 
                  options = list(pageLength = 15, 
                                 orderClasses = TRUE,
                                 searchable = TRUE
                  ),
                  filter = 'top'
    )
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
  print(input$fileDNABam)
  print(input$dna.filter.exac)
})

output$infoDNA = renderPrint({
  
})

output$dna.alignment.tumor = renderPlot({
  input$alg.plot
  isolate({
    #bmt <- BiomartGeneRegionTrack(genome = 'hg19', chromosome = input$alg.chr,
    #                              start = input$alg.start, end = input$alg.stop
    #                              #filter = list(with_ox_refseq_mrna = TRUE)
    #                              #stacking = 'dense'
    #                              )
    sTrack <- SequenceTrack(Hsapiens)
    bam <- paste0(bam.path,input$fileDNATumorBam)
    alTrack <- AlignmentsTrack(bam, is.paired=T)
    #plotTracks(c(bmt,alTrack,sTrack), 
    plotTracks(c(alTrack,sTrack), 
               chromosome = input$alg.chr, 
               from = input$alg.start, 
               to = input$alg.stop,
               cex = 0.5,
               min.height = 8,
               extend.left = 15,
               extend.right = 15
    )
  })
})

output$dna.alignment.germline = renderPlot({
  input$alg.plot
  isolate({
    sTrack <- SequenceTrack(Hsapiens)
    bam <- paste0(bam.path,input$fileDNAGermlineBam)
    alTrack <- AlignmentsTrack(bam, is.paired=T)
    plotTracks(c(alTrack,sTrack), 
               chromosome = input$alg.chr, 
               from = input$alg.start, 
               to = input$alg.stop,
               cex = 0.5,
               min.height = 8,
               extend.left = 15,
               extend.right = 15
    )
  })
})