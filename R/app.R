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
                                padding = c(0, 10),
                                layout_column_wrap(
                                  width = NULL,
                                  style = css(grid_template_columns = "3fr 1fr"),
                                  uiOutput("drug_tariff_caption"),
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
                                padding = c(0, 10),
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
                nav_panel("National Cost Collection",
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
                                padding = c(0, 10),
                                layout_column_wrap(
                                  width = NULL,
                                  style = css(grid_template_columns = "3fr 1fr"),
                                  uiOutput("ncc_caption"),
                                  uiOutput("ncc_download_button")
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
                              h3(textOutput("pssru_title")),
                              card_body(
                                padding = c(0, 10),
                                layout_column_wrap(
                                  width = NULL,
                                  style = css(grid_template_columns = "3fr 1fr"),
                                  uiOutput("pssru_caption"),
                                  uiOutput("pssru_download_button")
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
  
    # PSSRU SERVER LOGIC ---------------------------------------------
    
    # Filtered data
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
    
    # Table
    output$pssru_table <- renderReactable({
      reactable(pssru_selected_data(),
                searchable = T,
                defaultPageSize = 10)
    })
    
    # Get version
    pssru_year <- reactive(input$pssru_year)

    # Caption
    output$pssru_caption <- renderUI({
      withTags({
        div(p("Year: ", pssru_year()),
            p("Access the latest version of the Unit Costs of Health and Social Care manual from the ",
              a(href="https://www.pssru.ac.uk/unitcostsreport/",
                "PSSRU website", 
                target = "_blank",
                .noWS = "outside"),
              "."
              )
        )
      })
    })
    
    # Title
    output$pssru_title <- renderText({
      glue::glue("Unit Costs of Health and Social Care - {input$pssru_healthcare_professional}")
    })
    
    # Download button
    output$pssru_download_button <- renderUI({
      csvDownloadButton("pssru_table",
                        filename = paste0("unit_costs_hsc_extract_",
                                          stringr::str_to_lower(
                                            stringr::str_replace_all(
                                              input$pssru_healthcare_professional, " ", "_"
                                              )
                                            ),
                                          "_",
                                          pssru_year(),
                                          ".csv"))
    })
      
    
    # DRUG TARIFF SERVER LOGIC ---------------------------------------------
    
    # Filtered data
    drug_tariff_df <- reactive(get(paste0("drug_tariff_", input$drug_tariff_section)))
    
    # Table
    drug_tariff_df_colspec <- reactive(drug_tariff_col_spec[[input$drug_tariff_section]])
    
    output$drug_tariff_table <- renderReactable({
      reactable(drug_tariff_df(),
                searchable = T,
                defaultPageSize = 10,
                columns = drug_tariff_df_colspec())
    })
    
    # Title
    output$drug_tariff_title <- renderText(glue::glue("Drug Tariff - {names(drug_tariff_sections)[[stringr::str_which(drug_tariff_sections, input$drug_tariff_section)]]}"))
    
    # Get version
    drug_tariff_df_date <- reactive({
      fs::path_package("extdata", package = "COSTmos") |>
        list.files() |>
        stringr::str_subset(pattern = input$drug_tariff_section) |>
        stringr::str_sort(decreasing = T, numeric = T) |>
        purrr::pluck(1) |>
        stringr::str_extract("\\d{6}(?=\\.csv)") |>
        lubridate::ym()
    })
    
    # Caption
    drug_tariff_df_date_caption <- reactive(glue::glue("Release: {format(drug_tariff_df_date(), '%B %Y')}"))
    
    output$drug_tariff_caption <- renderUI({
      withTags({
        div(
          p(drug_tariff_df_date_caption()),
          p("Access the latest version of the Drug Tariff from the ",
            a(href="https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff", 
              "NHSBSA website", 
              target = "_blank", 
              .noWS = "outside"),
            "."
            )
        )
      })
    })
    
    # Download button
    output$drug_tariff_download_button <- renderUI({
      csvDownloadButton("drug_tariff_table",
                        filename = paste0("drug_tariff_extract_",
                                          input$drug_tariff_section,
                                          "_",
                                          stringr::str_to_lower(
                                            stringr::str_replace_all(
                                              format(drug_tariff_df_date(), "%b %Y"), " ", "_")), 
                                          ".csv"))
    })
      
    # PCA SERVER LOGIC ---------------------------------------------
    
    # Filtered data
    PCA_df <- reactive({
      if (input$PCA_section == "All") {
        PCA
      } else {
        PCA_list[[input$PCA_section]]
      }
    })
    
    PCA_df_colspec <- reactive({PCA_col_spec})
    
    # Table
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
    
    # Get year
    PCA_year <- reactive({
      fs::path_package("extdata", package = "COSTmos") |>
        list.files() |>
        stringr::str_subset(pattern = "PCA") |>
        stringr::str_extract("\\d{4}(?=\\.csv)")
    })
    
    # Caption
    output$PCA_caption<- renderUI({
      withTags({
        div(p("Calendar year: ", PCA_year()), 
            p("Access the latest version of the Prescription Cost Analysis from the ",
              a(href="https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england",
                "NHSBSA website", 
                target = "_blank",
                .noWS = "outside"),
              "."
        )
        )
      })
    })
    
    # Download button
    output$PCA_download_button <- renderUI({
      csvDownloadButton("PCA_table", 
                        filename = paste0("pca_extract_", PCA_year(), ".csv"))
    })
    
    
    # NATIONAL COST COLLECTION SERVER LOGIC -----------------------------------
    
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
        defaultPageSize = 10,
        columns = list(
          Activity = colDef(format = colFormat(separators = T)),
          `Unit cost` = colDef(name = "Unit cost (£)",
                               cell = function(value) {
                                 format(round(value, 2), nsmall = 2, big.mark = ",")
                               }),
          `Cost` = colDef(name = "Cost (£)",
                          cell = function(value) {
                            format(round(value, 2), nsmall = 2, big.mark = ",")
                          })
        )
      )
    })
    
    # Get year
    ncc_date <- reactive({
      fs::path_package("extdata", package = "COSTmos") |>
        list.files() |>
        stringr::str_subset(pattern = "ncc") |>
        stringr::str_sort(decreasing = T, numeric = T) |>
        purrr::pluck(1) |>
        stringr::str_extract("\\d{4}_\\d{2}(?=\\.csv)")
    })
 
    # Caption
    output$ncc_caption <- renderUI({
      withTags({
        div(
          p(glue::glue("Financial year: {stringr::str_replace_all(ncc_date(), '_', '/')}")),
          p("Access the latest version of the National Cost Collection from the ",
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
    
    # Download button
    output$ncc_download_button <- renderUI({
      
      sc <- input$ncc_service_code
      label <- if (is.null(sc) || identical(sc, "_ALL_")) NA_character_ else paste0(stringr::str_to_lower(stringr::str_replace_all(sc, " ", "_")), "_")
      
      csvDownloadButton("ncc_table",
                        filename = glue::glue("ncc_extract_{label}{ncc_date()}.csv", .na = ""))
    })
    
  }

  # Run the application 
  shinyApp(ui = ui, server = server)
}
