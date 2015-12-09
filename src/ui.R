shinyUI(navbarPage("Genome Portrait",
  tabPanel('Load Data',
           sidebarPanel(
             fileInput('fileDNAVcf', 'Choose DNA VCF File',
                       accept=c('text/csv', 'text/comma-separated-values,text/plain', '.vcf')
                       ),
             fileInput('fileDNABam', 'Choose DNA BAM File',
                       accept=c('text/csv', 'text/comma-separated-values,text/plain', '.bam')
             ),
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
             checkboxGroupInput("annotationDNA", 
                                label = h3("Annotate DNA Variants"), 
                                choices = list("dbSNP" = 'dbsnp', 
                                               "dbNSFP" = 'dbnsfp', 
                                               "CADD" = 'cadd'),
                                selected = NULL)
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
             )
           )
           ),
  tabPanel('RNA - Variants',
           sidebarPanel(
             checkboxGroupInput("annotationRNA", 
                                label = h3("Annotate DNA Variants"), 
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
  tabPanel('Report')
))
