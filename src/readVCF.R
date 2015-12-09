.collapse <- function (...) {
  paste(unlist(list(...)), sep = ",", collapse = ",")
}

rvcf <- function(file, annotation) {
  vcf <- readVcf(file, genome="hg19")
  hgvs <- formatHgvs(vcf)
  allfields <- c("dbsnp.rsid", "cadd.consequence", "dbnsfp.aa.pos", "dbnsfp.aa.ref",
                 "dbnsfp.aa.alt", "cadd.gene.genename",
                 "cosmic.cosmic_id", "cosmic.tumor_site", "exac.af",
                 "dbnsfp.1000gp1.af", "cadd.phred", "dbnsfp.sift.converted_rankscore", "dbnsfp.sift.pred",
                 "dbnsfp.polyphen2.hdiv.rankscore", "dbnsfp.polyphen2.hdiv.pred", "dbnsfp.mutationtaster.converted_rankscore", 
                 "dbnsfp.mutationtaster.pred", "dbnsfp.mutationassessor.rankscore", "dbnsfp.mutationassessor.pred", 
                 "dbnsfp.lrt.converted_rankscore", "dbnsfp.lrt.pred", "dbnsfp.metasvm.rankscore", "dbnsfp.metasvm.pred")
  annos <- getVariants(hgvs, fields=allfields)
  names(annos)[names(annos) %in% "query"] <- "Variant"
  names(annos)[names(annos) %in% c("cadd.gene.genename", "cadd.gene")] <- "Gene"
  annos[c("notfound", "X_id", "cadd._license", 'X_score')] <- NULL
  annos <- as.data.frame(DataFrame(lapply(annos, function(i) sapply(i, .collapse))))
  rownames(annos) <- 1:dim(annos)[1]
  return(annos)
}



