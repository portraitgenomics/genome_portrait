shinyUI(navbarPage("Genome Portrait",
  tabPanel('Load Data',
           sidebarPanel(
             fileInput('fileDNA', 'Choose DNA VCF File',
                       accept=c('text/csv', 'text/comma-separated-values,text/plain', '.vcf')
                       ),
             hr(),
             fileInput('fileRNA', 'Choose RNA VCF File',
                       accept=c('text/csv', 'text/comma-separated-values,text/plain', '.vcf')
                       ),
             checkboxGroupInput("annotation", 
                                label = h3("Annotate VCF Files"), 
                                choices = list("dbSNP" = 'dbsnp', 
                                               "dbNSFP" = 'dbnsfp', 
                                               "CADD" = 'cadd'),
                                selected = NULL),
             submitButton(text = "Annotate", icon = NULL, width = NULL)
           ),
           mainPanel()
           ),
  tabPanel('DNA',
           sidebarPanel(
           
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
  tabPanel('RNA',
           sidebarPanel(
             
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
  tabPanel('Report')
))
