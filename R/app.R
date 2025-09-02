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
                                  csvDownloadButton("drug_tariff_table", filename = "drug_tariff_extract.csv")
                                  )
                                ),
                              reactableOutput("drug_tariff_table")
                            )
                          )
                          ),
                nav_panel("NHS Collection Costs",
                          card(
                            layout_sidebar(
                              fillable = TRUE,
                              sidebar = sidebar(
                                selectInput(
                                  "ncc_service_code",
                                  label = "Service Code",
                                  choices = c("All" = "_ALL_") # remaining choices defined on load
                                )
                              ),
                              h3(textOutput("ncc_title")),
                              card_body(
                                layout_column_wrap(
                                  width = NULL,
                                  style = css(grid_template_columns = "3fr 1fr"),
                                  uiOutput("ncc_dynamic_link"),
                                  csvDownloadButton("ncc_table", filename = "ncc_2023_24_extract.csv")
                                )
                              ),
                              reactableOutput("ncc_table")
                            )
                          )
                ),
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
                                            selected = "Practice nurse"),
                                conditionalPanel(
                                  condition = "input.pssru_healthcare_professional == 'Practice GP' || 
                                  input.pssru_healthcare_professional == 'Practice nurse' ||
                                  input.pssru_healthcare_professional == 'Hospital doctors'||
                                  input.pssru_healthcare_professional == 'Qualified nurses'",
                                  radioButtons("pssru_qualification_cost",
                                               label = "Qualification cost (excluding individual/productivity)",
                                               choices = c("Include" = 1, "Exclude" = 2),
                                               selected = 1),
                                ),
                                conditionalPanel(
                                  condition = "input.pssru_healthcare_professional == 'Practice GP'",
                                  radioButtons("pssru_direct_cost",
                                               label = "Direct care staff cost",
                                               choices = c("Include" = 1, "Exclude" = 2),
                                               selected = 1)
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
    
    # COST COLLECTION SERVER LOGIC
    
    # Expect a CSV file saved inst/extdata/ncc_2023_24.csv
    
    ncc_df <- reactive({
      ext_path <- fs::path_package("extdata", package = "COSTmos")
      file <- fs::path(ext_path, "ncc_2023_24.csv")
      validate(need(fs::file_exists(file), paste0("CSV not found: ", file)))
      readr::read_csv(file, show_col_types = FALSE)
    })
    
    # Populate Service Code choices (with "All")
    observeEvent(ncc_df(), {
      df <- ncc_df()
      # Assumes CSV has clean "Service Code" column with alphabetic values
      levels <- sort(unique(df[["Service Code"]]))
      updateSelectInput(
        session, "ncc_service_code",
        choices  = c("All" = "_ALL_", levels),
        selected = "_ALL_"
      )
    }, ignoreInit = FALSE)
    

    # Filtered data
    ncc_filtered <- reactive({
      sc <- input$ncc_service_code
      req(sc)
      df <- ncc_df()
      
      if (identical(sc, "_ALL_")) return(df)
      
      df[df[["Service Code"]] == sc, , drop = FALSE]
    })
    
    # Title
    output$ncc_title <- renderText({
      sc <- input$ncc_service_code
      label <- if (is.null(sc) || identical(sc, "_ALL_")) "All" else sc
      paste0("National Cost Collection — Service Code: ", label)
    })
    
    # Table
    output$ncc_table <- renderReactable({
      reactable(
        ncc_filtered(),
        searchable = TRUE,
        defaultPageSize = 10
      )
    })
 
    output$ncc_dynamic_link <- renderUI({
      withTags({
        div(
          p(
            "Access the National Cost Collection data (2023/24) on the ",
            a(
              href = "https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/",
              "NHS England website",
              target = "_blank",
              .noWS = "outside"
            ),
            "."
          )
        )
      })
    })
    
    
  }
  
  # Run the application 
  shinyApp(ui = ui, server = server)
}
