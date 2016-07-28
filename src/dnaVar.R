output$tableDNA <- DT::renderDataTable({
  dat <- dataInputDNA()
  
  dat <- dat[dat$ExAc>=input$dna.filter.exac[1] & dat$ExAc<=input$dna.filter.exac[2], ]
  
  DT::datatable(dat, 
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
    sTrack <- SequenceTrack(Hsapiens)
    bam <- paste0(bam.path,input$fileDNATumorBam)
    #bam <- '~/AWS/storage/patients/alignments/CCD130-T1-DNA-REP1/CCD130-T1-DNA-REP1_gatk_recal.bam'
    afrom <- input$alg.start
    ato <- input$alg.stop
    chr <- input$alg.chr
    alTrack <- AlignmentsTrack(bam, is.paired=T)
    
    plotTracks(c(alTrack,sTrack), 
               chromosome = chr, 
               from = afrom, 
               to = ato,
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
    #bam <- '~/AWS/storage/patients/alignments/CCD130-T1-DNA-REP1/CCD130-T1-DNA-REP1_gatk_recal.bam'
    afrom <- input$alg.start
    ato <- input$alg.stop
    chr <- input$alg.chr
    alTrack <- AlignmentsTrack(bam, is.paired=T)
    
    plotTracks(c(alTrack,sTrack), 
               chromosome = chr, 
               from = afrom, 
               to = ato,
               cex = 0.5,
               min.height = 8,
               extend.left = 15,
               extend.right = 15
    )
  })
})