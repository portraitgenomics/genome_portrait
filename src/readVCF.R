.collapse <- function (...) {
  paste(unlist(list(...)), sep = ",", collapse = ",")
}

rvcf <- function(file, annotation) {
  vcf <- readVcf(file, genome="hg19")
  hgvs <- formatHgvs(vcf)
  allfields <- c("cadd.gene.genename", "cadd.consequence", 
                 "cadd.gene.prot.protpos", "cadd.oaa", "cadd.naa",
                 "cadd.phred", "exac.af", "dbsnp.rsid", 'snpeff.ann.feature_id')
  annos <- getVariants(hgvs, fields=allfields)
  
  if("cadd.gene.genename" %in% names(annos)) {
    Gene <- annos$cadd.gene.genename
  } else {
    Gene <- sapply(annos$cadd.gene, function(i) i$genename)
  }
  annos$Gene <- Gene
  if("cadd.gene.prot.protpos" %in% names(annos)) {
    aaprot <- annos$cadd.gene.prot.protpos
  } else {
    aaprot <- lapply(annos$cadd.gene, function(i) .collapse(i$prot))
  }
  annos$`Amino Acid Position` <- aaprot
  
  names(annos)[names(annos) %in% "query"] <- "Variant"
  #names(annos)[names(annos) %in% c("cadd.gene.genename", "cadd.gene")] <- "Gene"
  annos[c("notfound", "X_id", "cadd._license", 'X_score', 'cadd.gene')] <- NULL
  annos <- as.data.frame(DataFrame(lapply(annos, function(i) sapply(i, .collapse))))
  rownames(annos) <- 1:dim(annos)[1]
  
  # pick the first field
  annos$cadd.consequence <- unlist(lapply(annos$cadd.consequence, function(x) strsplit(x, ',')[[1]][1]))
  annos$snpeff.ann <- unlist(lapply(annos$snpeff.ann, function(x) strsplit(x, ',')[[1]][1]))
  annos$exac.af <- unlist(lapply(annos$exac.af, function(x) strsplit(x, ',')[[1]][1]))
  annos$Gene <- unlist(lapply(annos$Gene, function(x) strsplit(x, ',')[[1]][1]))
  annos$Amino.Acid.Position <- unlist(lapply(annos$Amino.Acid.Position, function(x) strsplit(x, ',')[[1]][1]))
  
  ann <- data.frame(
    Gene=annos$Gene,
    Variant=annos$Variant,
    Transcript=annos$snpeff.ann,
    Consequence=annos$cadd.consequence,
    PChange=paste('p.',annos$cadd.naa,annos$Amino.Acid.Position,annos$cadd.oaa, sep=''),
    Genotype=ifelse(as.vector(geno(vcf)$GT[,'TUMOR'])=='0/0', 'homozygous ref.', ifelse(as.vector(geno(vcf)$GT[,'TUMOR'])=='0/1','heterozygous', 'homozygous')),
    FREQ=round(as.numeric(geno(vcf)$AD[,'TUMOR'])/as.numeric(geno(vcf)$DP[,'TUMOR']),2),
    Cadd=annos$cadd.phred,
    ExAc=annos$exac.af,
    stringsAsFactors = F
  )
  
  return(ann)
}



