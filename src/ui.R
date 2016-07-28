shinyUI(navbarPage("Genome Portrait",
  tabPanel('Load Data',
           sidebarPanel(
             fileInput('fileDNAVcf', 'Choose DNA VCF File',
                       accept=c('text/csv', 'text/comma-separated-values,text/plain', '.vcf')
                       ),
             selectInput('fileDNATumorBam', 'Choose DNA Tumor BAM File', bam.filenames),
             selectInput('fileDNAGermlineBam', 'Choose DNA Germline BAM File', bam.filenames),
             hr(),
             fileInput('fileRNAVcf', 'Choose RNA VCF File',
                       accept=c('text/csv', 'text/comma-separated-values,text/plain', '.vcf')
                       ),
             fileInput('fileRNABam', 'Choose RNA BAM File',
                       accept=c('text/csv', 'text/comma-separated-values,text/plain', '.bam')
             ),
             hr(),
             fileInput('fileExpr', 'Choose Expression Data',
                       accept=c('text/csv', 'text/comma-separated-values,text/plain', '.vcf')
             ),
             selectInput('tumorType', 
                         'Tumor Type', 
                         selected=NULL, 
                         c('',
                           'BRCA', 
                           'OV')
                         ),
             hr()
           ),
           mainPanel(
             h3('Loaded Data Stats'),
             h4('* Number of Variants, DNA:'),
              verbatimTextOutput('nVcfDNA'),
             h4('* Expression Data, Library Size:'),
              verbatimTextOutput('exprLibSize')
           )
           ),
  tabPanel('DNA - Variants',
           sidebarPanel(
             h4('Variant Filters'),
             sliderInput("dna.filter.exac", "ExAC:",
                         min = 0, max = 1, value = c(0,0.05)),
             hr(),
             h4('View Alignment'),
             numericInput('alg.start', 'Start:', NULL),
             numericInput('alg.stop', 'Stop:', NULL),
             textInput('alg.chr', 'Chromosome:', NULL),
             actionButton("alg.plot", "View")
           ),
           mainPanel(
             tabsetPanel(
               tabPanel('All Data',
                        DT::dataTableOutput(outputId="tableDNA"),
                        hr(),
                        verbatimTextOutput('indDNA')
               ),
               tabPanel('Selected Data',
                        DT::dataTableOutput(outputId='seltableDNA'),
                        hr(),
                        verbatimTextOutput('infoDNA')
               )
             ),
             h4('DNA Tumor Track'),
             plotOutput('dna.alignment.tumor'),
             h4('DNA Germline Track'),
             plotOutput('dna.alignment.germline')
           )
           ),
  tabPanel('RNA - Variants',
           sidebarPanel(
             checkboxGroupInput("annotationRNA", 
                                label = h3("Annotate RNA Variants"), 
                                choices = list("dbSNP" = 'dbsnp', 
                                               "dbNSFP" = 'dbnsfp', 
                                               "CADD" = 'cadd'),
                                selected = NULL)
           ),
           mainPanel(
             tabsetPanel(
               tabPanel('All Data',
                        DT::dataTableOutput(outputId="tableRNA"),
                        hr(),
                        verbatimTextOutput('indRNA')
               ),
               tabPanel('Selected Data',
                        DT::dataTableOutput(outputId='seltableRNA'),
                        hr(),
                        verbatimTextOutput('infoRNA')
               )
             )
           )
           ),
  tabPanel('RNA - Expression',
           tableOutput('libSize')
           ),
  tabPanel('Report',
           h4("Sample Information"),
           fluidRow(
             column(3,
                    textInput('report.sample', 'Sample:', value='')
                    ),
             column(3,
                    dateInput('report.date', 'Date of Collection:', value='', format = "mm/dd/yy")
             )
           ),
           fluidRow(
             column(3,
                    textInput('report.specimen.id', 'Specimen ID:', value='')
             ),
             column(3,
                    textInput('report.specimen.site', 'Specimen Site:', value='')
             ),
             column(3,
                    textInput('report.specimen.type', 'Specimen Type:', value='')
             )
           ),
           hr(),
           h4("Patient Information"),
           fluidRow(
             column(3,
                    textInput('report.name', 'Name:', value='')
                    ),
             column(3,
                    textInput('report.surname', 'Surname:', value='')
                    )
           ),
           fluidRow(
             column(3,
                    selectInput('report.sex', 'Sex:', c('', 'Male', 'Female'), selected = NULL)
                    )
           ),
           fluidRow(
             column(3,
                    textInput('report.tumor.type', 'Tumor Type:', value = '')
             )
           ),
           hr(),
           h4("Medical Facility"),
           fluidRow(
             column(3,
                    textInput('report.med.name', 'Physician Name:', value='')
             ),
             column(3,
                    textInput('report.med.surname', 'Physician Surname:', value='')
             )
           ),
           fluidRow(
             column(3,
                    textInput('report.path.name', 'Pathologist Name:', value='')
             ),
             column(3,
                    textInput('report.path.surname', 'Pathologist Surname:', value='')
             )
           ),
           fluidRow(
             column(3,
                    textInput('report.med.facility', 'Medical Facility:', value='')
             )
           ),
           hr(),
           h4("Generate Report"),
           downloadButton('report')
           )
)
)