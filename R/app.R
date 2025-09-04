#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(reactable)
library(dplyr)
library(purrr)
library(readr)
library(tibble)
library(stringr)
library(lubridate)
library(tidyr)
library(glue)
library(fs)
library(bslib)
library(htmltools)
library(pdftools)

costmos_app <- function(...) {
  
  csvDownloadButton <- function(id, filename = "data.csv", label = "Download table as CSV") {
    tags$button(
      tagList(icon("download"), label),
      onclick = sprintf("Reactable.downloadDataCSV('%s', '%s')", id, filename)
    )
  }
  
  # Define UI for application that draws a histogram
  ui <- page_navbar(
    title = "COSTmos",
    nav_panel("Data sets",
              navset_pill_list(
                widths = c(2, 10),
                nav_panel("Drug Tariff",
                          card(
                            layout_sidebar(
                              fillable = T,
                              sidebar = sidebar(
                                selectInput("drug_tariff_section",
                                            label = "Section",
                                            choices = drug_tariff_sections
                                            ),
                                ),
                              h3(textOutput("drug_tariff_title")),
                              card_body(
                                layout_column_wrap(
                                  width = NULL,
                                  style = css(grid_template_columns = "3fr 1fr"),
                                  uiOutput("drug_tariff_date_caption"),
                                  uiOutput("drug_tariff_download_button")
                                  )
                                ),
                              reactableOutput("drug_tariff_table")
                            )
                          )
                          ),
                nav_panel("Prescription Cost Analysis",
                          card(
                            layout_sidebar(
                              fillable = T,
                              sidebar = sidebar(
                                selectInput("PCA_section",
                                            label = "Select BNF chapters",
                                            choices = c("All", PCA_sections),
                                            selected = "All"
                                ),
                              ),
                              h3("Prescription Cost Analysis"),
                              card_body(
                                layout_column_wrap(
                                  width = NULL,
                                  style = css(grid_template_columns = "3fr 1fr"),
                                  uiOutput("PCA_caption"),
                                  uiOutput("PCA_download_button")
                                )
                              ),
                              reactableOutput("PCA_table")
                            )
                          )
                          ),
                nav_panel("NHS Collection Costs"),
                nav_panel("Unit Costs of Health and Social Care",
                          card(
                            layout_sidebar(
                              fillable = T,
                              sidebar = sidebar(
                                width = "25%",
                                selectInput("pssru_year",
                                            label = "Year",
                                            choices = c("2023", "2024"),
                                            selected = "2024"),  
                                selectInput("pssru_healthcare_professional",
                                            label = "Healthcare professional",
                                            choices = c("Practice GP", 
                                                        "Practice nurse", 
                                                        "Hospital doctors", 
                                                        "Qualified nurses", 
                                                        "Community-based scientific and professional staff",
                                                        "Training costs"),
                                            selected = "Practice GP"),
                                conditionalPanel(
                                  condition = "input.pssru_healthcare_professional == 'Practice GP' || 
                                  input.pssru_healthcare_professional == 'Practice nurse' ||
                                  input.pssru_healthcare_professional == 'Hospital doctors'||
                                  input.pssru_healthcare_professional == 'Qualified nurses'",
                                  radioButtons("pssru_qualification_cost",
                                               label = "Qualification cost",
                                               choices = c("Include" = 1, "Exclude" = 2),
                                               selected = 1),
                                ),
                                conditionalPanel(
                                  condition = "input.pssru_healthcare_professional == 'Practice GP'",
                                  radioButtons("pssru_direct_cost",
                                               label = "Direct care staff cost",
                                               choices = c("Include" = 1, "Exclude" = 2),
                                               selected = 1)
                                ),                 conditionalPanel(
                                  condition = "input.pssru_healthcare_professional == 'Practice nurse'",
                                  p("Ratio of direct to indirect time = 1:0.30. ",
                                    a("See PSSRU 2015.", 
                                      href = "https://www.pssru.ac.uk/pub/uc/uc2015/full.pdf",
                                      target = "_blank"),
                                  )
                                ),  
                                conditionalPanel(
                                  condition = "input.pssru_healthcare_professional == 'Community-based scientific and professional staff'",
                                  helpText("To calculate the cost per hour, including qualifications for scientific and professional staff, the appropriate expected annual cost shown in the 'Training cost' section should be divided by the number of working hours. This can then be added to the cost per working hour."),
                                ),
                                conditionalPanel(
                                  condition = "input.pssru_healthcare_professional == 'Training costs'",
                                  radioButtons("pssru_training_hcp",
                                               label = "Select",
                                               choices = c("Training costs of health and social care professionals, excluding doctors" = 1, 
                                                           "Training costs of doctors (after discounting)" = 2),
                                               selected = 1)
                                )
                              ),
                              h3(textOutput("PSSRU_title")),
                              card_body(
                                layout_column_wrap(
                                  width = NULL,
                                  style = css(grid_template_columns = "3fr 1fr"),
                                  uiOutput("pssru_dynamic_link"),
                                  csvDownloadButton("pssru_table", filename = "pssru_extract.csv")
                                )
                              ),
                              reactableOutput("pssru_table")
                            ),
                          )
                )
              )
              ),
    nav_panel("About",
              card(
                includeMarkdown(rprojroot::find_package_root_file("R", "about.md"))
                )
              )
  )
  
  # Define server logic required to draw a histogram
  server <- function(input, output, session) {
  
    # PSSRU
    pssru_ui_outputs <- reactive({
      generate_PSSRU_tables(
        qual = input$pssru_qualification_cost,
        direct = input$pssru_direct_cost,
        year = input$pssru_year,
        training_HCP = input$pssru_training_hcp
      )
    })
    
    pssru_selected_data <- reactive({
      switch(input$pssru_healthcare_professional,
             "Practice nurse" = pssru_ui_outputs()$practice_nurse,
             "Practice GP" = pssru_ui_outputs()$practice_GP,
             "Hospital doctors" = pssru_ui_outputs()$hospital_doctors,
             "Community-based scientific and professional staff" = pssru_ui_outputs()$HCP_table,
             "Qualified nurses" = pssru_ui_outputs()$qualified_nurse,
             "Training costs" = pssru_ui_outputs()$training_costs
      )
    })
    
    output$pssru_table <- renderReactable({
      reactable(pssru_selected_data(),
                searchable = T,
                defaultPageSize = 10)
    })

    output$pssru_dynamic_link <- renderUI({
      withTags({
        div(p("Access the full PSSRU ",
              a(href=pssru_ui_outputs()$URL, 
                paste("Unit Costs of Health and Social Care ", str_extract(pssru_ui_outputs()$source, "\\d{4}$"), " report"), 
                target = "_blank",
                .noWS = "outside"),
              " here."
              )
        )
      })
    })
    
    output$PSSRU_title <- renderText({
      input$pssru_healthcare_professional
    })
      
    
    # Drug Tariff
    drug_tariff_df <- reactive(get(paste0("drug_tariff_", input$drug_tariff_section)))
    drug_tariff_df_colspec <- reactive(drug_tariff_col_spec[[input$drug_tariff_section]])
    drug_tariff_section_name <- reactive(glue::glue("Drug Tariff - {names(drug_tariff_sections)[[stringr::str_which(drug_tariff_sections, input$drug_tariff_section)]]}"))
    drug_tariff_df_date <- reactive({
      fs::path_package("extdata", package = "COSTmos") %>%
        list.files() %>%
        stringr::str_subset(pattern = input$drug_tariff_section) %>%
        stringr::str_sort(decreasing = T, numeric = T) %>%
        purrr::pluck(1) %>%
        stringr::str_extract("\\d{6}(?=\\.csv)") %>%
        lubridate::ym()
    })
    drug_tariff_df_date_caption <- reactive(glue::glue("{format(drug_tariff_df_date(), '%B %Y')}. Access the latest version of the Drug Tariff from the "))
    
    output$drug_tariff_title <- renderText(drug_tariff_section_name())
    
    output$drug_tariff_date_caption <- renderUI({
      withTags({
        div(
          p(
            drug_tariff_df_date_caption(),
            a(href="https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff", 
              "NHSBSA website", 
              target = "_blank", 
              .noWS = "outside"),
            "."
            )
        )
      })
    })
    
    output$drug_tariff_table <- renderReactable({
      reactable(drug_tariff_df(),
                searchable = T,
                defaultPageSize = 10,
                columns = drug_tariff_df_colspec())
    })

    output$drug_tariff_download_button <- renderUI({
      csvDownloadButton("drug_tariff_table",
                        filename = paste0("drug_tariff_extract_", gsub("/", "-", drug_tariff_df_date_caption()), ".csv"))
    })
      
    #PCA
    
    PCA_df <- reactive({
      if (input$PCA_section == "All") {
        PCA
      } else {
        PCA_list[[input$PCA_section]]
      }
    })
    
    PCA_df_colspec <- reactive({PCA_col_spec})
    
    output$PCA_table <- renderReactable({
    
    data <- PCA_df()

    if (is.null(data) || nrow(data) == 0) {
      return(reactable(data = data.frame(Message = "No data available")))
    }
    

    columns <- PCA_df_colspec() 

    reactable(data,
              searchable = TRUE,
              defaultPageSize = 10,
              columns = columns)
  })
  
  PCA_year <- reactive({
      fs::path_package("extdata", package = "COSTmos") %>%
         list.files() %>%
         stringr::str_subset(pattern = "PCA") %>%
         stringr::str_extract("\\d{6}(?=\\.csv)") %>%
         gsub("(.{4})", "\\1/", x = .)
  })
    
  output$PCA_caption<- renderUI({
    withTags({
      div(p("Calendar PCA ", PCA_year(), ". Access the latest version of the PCA from the ",
            a(href="https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england",
              "NHSBSA website", 
              target = "_blank",
              .noWS = "outside"),
            "."
      )
      )
    })
  })
  
  output$PCA_download_button <- renderUI({
    csvDownloadButton("PCA_table", 
                      filename = paste0("PCA_extract_", gsub("/", "-", PCA_year()), ".csv"))
  })
  
  }
  # Run the application 
  shinyApp(ui = ui, server = server)
}
