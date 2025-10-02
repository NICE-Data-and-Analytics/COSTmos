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
                                selectInput("pca_bnf_chapter",
                                            label = "Select BNF chapter",
                                            choices = pca_bnf_chapter_choice
                                ),
                              ),
                              h3(textOutput("pca_title")),
                              card_body(
                                padding = c(0, 10),
                                layout_column_wrap(
                                  width = NULL,
                                  style = css(grid_template_columns = "3fr 1fr"),
                                  uiOutput("pca_caption"),
                                  uiOutput("pca_download_button")
                                )
                              ),
                              reactableOutput("pca_table")
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
                                selectInput("uchsc_year",
                                            label = "Year",
                                            choices = uchsc_year_choice),  
                                selectInput("uchsc_hcp",
                                            label = "Healthcare professional",
                                            choices = uchsc_hcp_choice),
                                conditionalPanel(
                                  condition = "input.uchsc_hcp == 'gp' || 
                                  input.uchsc_hcp == 'gp_nurse' ||
                                  input.uchsc_hcp == 'hospital_doctor'||
                                  input.uchsc_hcp == 'nurse'",
                                  radioButtons("uchsc_qualification_cost",
                                               label = "Qualification cost",
                                               choices = c("Include" = "including", "Exclude" = "excluding")
                                               ),
                                ),
                                conditionalPanel(
                                  condition = "input.uchsc_hcp == 'gp'",
                                  radioButtons("uchsc_direct_cost",
                                               label = "Direct care staff cost",
                                               choices = c("Include" = "including", "Exclude" = "excluding")
                                               )
                                ),                 
                                conditionalPanel(
                                  condition = "input.uchsc_hcp == 'gp_nurse'",
                                  withTags({
                                    div(
                                      p("Note, only the cost per working hour is from the selected Unit Costs report. All other values are calculated using that figure and the following figures:"),
                                      ul(
                                        li("Ratio of direct to indirect time on face-to-face contacts (1:0.30) and duration of contact from the ", 
                                           a(href="https://www.pssru.ac.uk/project-pages/unit-costs/unit-costs-2015/",
                                             "2015 Unit Costs report",
                                             target = "_blank",
                                             .noWS = "outside")
                                           ),
                                        li("Average duration of nurse face-to-face (10 mins) and telephone (6 mins) consultations from ",
                                           a(href="https://doi.org/10.1136/bmjopen-2017-018261",
                                             "Stevens et al. (2017)",
                                             target = "_blank",
                                             .noWS = "outside")
                                           )
                                      )
                                    )
                                  })
                                ),  
                                conditionalPanel(
                                  condition = "input.uchsc_hcp == 'community_hcp'",
                                  helpText("To calculate the cost per hour including qualifications for scientific and professional staff, the appropriate expected annual cost shown in the 'Training cost' table should be divided by the number of working hours. This can then be added to the cost per working hour.")
                                ),
                                conditionalPanel(
                                  condition = "input.uchsc_hcp == 'training_costs'",
                                  radioButtons("uchsc_training_hcp",
                                               label = "Select",
                                               choices = uchsc_training_costs_choice
                                               )
                                )
                                ),
                              h3(textOutput("uchsc_title")),
                              card_body(
                                padding = c(0, 10),
                                layout_column_wrap(
                                  width = NULL,
                                  style = css(grid_template_columns = "3fr 1fr"),
                                  uiOutput("uchsc_caption"),
                                  uiOutput("uchsc_download_button")
                                )
                              ),
                              reactableOutput("uchsc_table")
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
  
    # UNIT COSTS OF HEALTH AND SOCIAL CARE SERVER LOGIC ---------------------------------------------
    
    # Get year
    ushsc_year <- reactive(input$uchsc_year)
    
    # Make full name to select from lists
    uchsc_hcp_full <- reactive({
      if(input$uchsc_hcp == "training_costs") {
        paste0(input$uchsc_hcp, "_", input$uchsc_training_hcp)
      } else {
        input$uchsc_hcp
      }
    })
    
    # Filtered data
    uchsc_df <- reactive({

      # Get table
      df <- get(paste0("unit_costs_hsc_", uchsc_hcp_full())) |> 
        # Filter to selected year
        dplyr::filter(year == ushsc_year())

      # Filter for inc/exc qualification cost
      if (uchsc_hcp_full() %in% c("gp", "gp_nurse", "hospital_doctor", "nurse")) {
        df <- df |>
          dplyr::filter(qualification_cost == input$uchsc_qualification_cost)
      }

      # Filter for inc/exc direct staff care cost
      if (uchsc_hcp_full() == "gp"){
        df <- df |>
          dplyr::filter(direct_care_staff_cost == input$uchsc_direct_cost)
      }
      
      df
      })
    
    # Table
    uchsc_df_colspec <- reactive(uchsc_col_spec[[uchsc_hcp_full()]])
    
    output$uchsc_table <- renderReactable({
      reactable(uchsc_df(),
                searchable = T,
                defaultPageSize = 10,
                columns = uchsc_df_colspec()
                )
    })

    # Caption
    output$uchsc_caption <- renderUI({
      withTags({
        div(p("Year: ", ushsc_year()),
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
    output$uchsc_title <- renderText({
      if(input$uchsc_hcp == "training_costs") {
        glue::glue("Unit Costs of Health and Social Care - {names(uchsc_training_costs_choice)[uchsc_training_costs_choice == input$uchsc_training_hcp]}")
      } else {
        glue::glue("Unit Costs of Health and Social Care - {names(uchsc_hcp_choice)[uchsc_hcp_choice == input$uchsc_hcp]}")
      }
    })
    
    # Download button
    output$uchsc_download_button <- renderUI({
      csvDownloadButton("uchsc_table",
                        filename = paste0("unit_costs_hsc_extract_",
                                          uchsc_hcp_full(),
                                          "_",
                                          ushsc_year(),
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
      drug_tariff_version |> 
        dplyr::filter(section == input$drug_tariff_section) |>
        dplyr::pull(version_ym) |>
        purrr::pluck(1) |>
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
    pca_filtered <- reactive({
      bnf_c <- input$pca_bnf_chapter
      req(bnf_c)
      
      if (identical(bnf_c, "_ALL_")) {
        df <- pca_calendar_year
      } else {
        df <- pca_calendar_year |> 
          dplyr::filter(bnf_chapter_name == bnf_c)
      }
      
      df
    })
    
    # Title
    output$pca_title <- renderText({
      bnf_c <- input$pca_bnf_chapter
      label <- if (is.null(bnf_c) || identical(bnf_c, "_ALL_")) "" else paste0(" — BNF Chapter: ", bnf_c)
      paste0("Prescription Cost Analysis", label)
    })
    
    # Table
    output$pca_table <- renderReactable({
      reactable(
        pca_filtered(),
        searchable = TRUE,
        defaultPageSize = 10,
        columns = pca_col_spec
      )
    })
    
    # Get year
    pca_year <- reactive({
      pca_version |> 
        dplyr::filter(section == "calendar_year") |>
        dplyr::pull(version) |>
        purrr::pluck(1)
    })
    
    # Caption
    output$pca_caption<- renderUI({
      withTags({
        div(p("Calendar year: ", pca_year()), 
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
    output$pca_download_button <- renderUI({
      
      bnf_c <- input$pca_bnf_chapter
      label <- if (is.null(bnf_c) || identical(bnf_c, "_ALL_")) NA_character_ else paste0(stringr::str_to_lower(stringr::str_replace_all(bnf_c, " ", "_")), "_")
      
      csvDownloadButton("pca_table",
                        filename = glue::glue("pca_calendar_year_extract_{label}{pca_year()}.csv", .na = ""))
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
      label <- if (is.null(sc) || identical(sc, "_ALL_")) "" else paste0(" — Service Code: ", sc)
      paste0("National Cost Collection", label)
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
