# Copyright (c) 2016 Tobias Meissner
# Licensed under the MIT License (MIT)

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
  annos$cadd.consequence2 <- unlist(lapply(annos$cadd.consequence, function(x) strsplit(x, ',')[[1]][1]))
  annos$snpeff.ann2 <- unlist(lapply(annos$snpeff.ann, function(x) strsplit(x, ',')[[1]][1]))
  annos$exac.af2 <- unlist(lapply(annos$exac.af, function(x) strsplit(x, ',')[[1]][1]))
  annos$Gene2 <- unlist(lapply(annos$Gene, function(x) strsplit(x, ',')[[1]][1]))
  annos$Amino.Acid.Position2 <- unlist(lapply(annos$Amino.Acid.Position, function(x) strsplit(x, ',')[[1]][1]))
  
  ann <- data.frame(
    Gene=annos$Gene2,
    Variant=annos$Variant,
    Transcript=annos$snpeff.ann2,
    Consequence=annos$cadd.consequence2,
    PChange=paste('p.',annos$cadd.naa,annos$Amino.Acid.Position2,annos$cadd.oaa, sep=''),
    Genotype=ifelse(as.vector(geno(vcf)$GT[,'TUMOR'])=='0/0', 'homozygous ref.', ifelse(as.vector(geno(vcf)$GT[,'TUMOR'])=='0/1','heterozygous', 'homozygous')),
    FREQ=round(as.numeric(geno(vcf)$AD[,'TUMOR'])/as.numeric(geno(vcf)$DP[,'TUMOR']),2),
    AD=as.numeric(geno(vcf)$AD[,'TUMOR']),
    DP=as.numeric(geno(vcf)$DP[,'TUMOR']),
    Cadd=as.numeric(as.vector(annos$cadd.phred)),
    ExAc=as.numeric(as.vector(annos$exac.af2)),
    stringsAsFactors = F
  )
  
  return(ann)
}



