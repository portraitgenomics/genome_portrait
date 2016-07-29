# Copyright (c) 2016 Tobias Meissner
# Licensed under the MIT License (MIT)

# rando string fucntion
# code from https://ryouready.wordpress.com/2008/12/18/generate-random-string-name/
MHmakeRandomString <- function(n=1, lenght=12)
{
  randomString <- c(1:n)                  # initialize vector
  for (i in 1:n)
  {
    randomString[i] <- paste(sample(c(0:9, letters, LETTERS),
                                    lenght, replace=TRUE),
                             collapse="")
  }
  return(randomString)
}

report.sample <- reactive({
  patient <- list(
    name='Peppermint',
    surname='Patty',
    street            = '123 Cray Court',
    state             = 'CA',
    city              = 'San Diego',
    zip               = '92122',
    date_of_birth     = '01/01/1899',
    clinical_diagnosis= 'Breast Cancer',
    tumor_type        = 'Breast Cancer',
    tumor_site        = 'left breast',
    specimen_type     = 'fresh frozen',
    cancer_stage      = 'III',
    date_of_diagnosis = '01/01/1990',
    receptor_type     = 'HER2+ ER- PR-',
    molecular_type    = 'HER2',
    specimen_id       = '14MS-10038 1A',
    sex               = 'female'
  )
  physician <- list(
    name='House',
    surname='Gregory',
    street     = '1 Princeton-Plainsboro Teaching Hospital',
    state      = 'NJ',
    city       = 'Princeton',
    zip        = '12345',
    facility   = 'Princeton-Plainsboro',
    facility_id= '12345'
  )
  pathologist <- list(
    name       = 'Murphy',
    surname    = 'Katie'
  )
  medical_director <- list(
    name       = 'House',
    surname    = 'Gregory',
    title      = 'M.D., Medical Director'
  )
  lab <- list(
    name       = 'Avera Cancer Institute',
    street     = '11099 N Torrey Pines Rd, Suite 160',
    state      = 'CA',
    city       = 'La Jolla',
    zip        = '92037',
    clia_number= '12345',
    phone      = '858 450 2805'
  )
  sample_details <- list(
    received       = '09/17/1014',
    biopsy_date    = '09/15/1014',
    sample_purity  = '85',
    amount_rna_used= '100ng',
    seq_type       = 'RNA-Seq',
    seq_protocoll  = 'KAPPA'
  )
  run_info <- list(
    run_id                     = '1234',
    kit_len                    = '150'
  )
  
  sample <- list(patID = input$report.sample,
                 patient = patient,
                 physician = physician,
                 pathologist = pathologist,
                 medical_director = medical_director,
                 lab = lab,
                 sample_details = sample_details,
                 run_info = run_info
  )
  sample
})

output$report = downloadHandler(
  filename = paste0(report.sample()$patID,'_',gsub(' ', '-',Sys.time()),'.pdf'),
  content = function(file) {
    sample <- report.sample()
    
    s <- input$tableDNA_rows_selected
    if (length(s)) {
      dat <- dataInputDNA()
      #if(is.null(input$annotationDNA)) {
      #  tab <- dat[s, c('Variant', 'Gene'), drop=FALSE]
      #} else {
      #  sel <- colnames(dat)[unlist(sapply(input$annotationDNA, function(i) grep(i, colnames(dat))))]
      #  tab <- dat[s, c('Variant','Gene',sel), drop=FALSE]
      #}
      tab <- dat[s,]
    }
    
    
    out <- paste0(tempdir(),'/',MHmakeRandomString())
    dir.create(out)
    knit('patientReport.Rnw', output = paste0(out,'/patientReport.tex'))
    system(paste0('pdflatex -interaction=nonstopmode -output-directory=', out ,' ', out, '/patientReport.tex'))
    file.copy(paste0(out, '/patientReport.pdf'), file) # move pdf to file for downloading
  },
  contentType <- 'application/pdf'
)


