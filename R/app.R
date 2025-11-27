#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

#' @importFrom rlang .data

# Overcome check() note about undefined global variables
utils::globalVariables(c("drug_tariff_version", 
                         "ncc", 
                         "ncc_version", 
                         "pca_calendar_year", 
                         "pca_version", 
                         "unit_costs_hsc_gp", 
                         "drug_tariff_viii_a"))

# Overcome check() note about utils not being used
ignore_unused_imports <- function() {
  utils::download.file
}

costmos_app <- function(...) {
  
  # Set some variables
  uchsc_year_choice <- unique(unit_costs_hsc_gp$year) |>
    stringr::str_sort(decreasing = T, numeric = T)
  
  drug_tariff_viii_a_categories <- c("All" = "_ALL_", sort(unique(drug_tariff_viii_a$drug_tariff_category)))
  
  pca_bnf_chapter_choice <- c("All" = "_ALL_", sort(unique(pca_calendar_year$bnf_chapter_name)))
  
  csvDownloadButton <- function(id, filename = "data.csv", label = "Download table as CSV") {
    htmltools::tags$button(
      htmltools::tagList(shiny::icon("download"), label),
      onclick = sprintf("Reactable.downloadDataCSV('%s', '%s')", id, filename)
    )
  }

  # Define UI for application that draws a histogram
  ui <- bslib::page_navbar(
    title = "COSTmos",
    bslib::nav_panel(
      "Data sets",
      bslib::navset_pill_list(
        widths = c(2, 10),
        bslib::nav_panel(
          "Drug Tariff",
          bslib::card(
            bslib::layout_sidebar(
              fillable = T,
              sidebar = bslib::sidebar(
                shiny::selectInput("drug_tariff_section",
                  label = "Section",
                  choices = drug_tariff_sections
                ),
                shiny::conditionalPanel(
                  condition = "input.drug_tariff_section == 'viii_a'",
                  shiny::selectInput("drug_tariff_viii_a_category",
                                      label = "Category",
                                      choices = drug_tariff_viii_a_categories
                  ),
                ),
                shiny::conditionalPanel(
                  condition = "input.drug_tariff_section == 'ix'",
                  shiny::selectInput("drug_tariff_ix_part",
                                     label = "Subsection (e.g. Part IXA)",
                                     choices = drug_tariff_ix_part_choice
                  ),
                ),
              ),
              htmltools::h3(shiny::textOutput("drug_tariff_title")),
              bslib::card_body(
                padding = c(0, 10),
                bslib::layout_column_wrap(
                  width = NULL,
                  style = htmltools::css(grid_template_columns = "3fr 1fr"),
                  shiny::uiOutput("drug_tariff_caption"),
                  shiny::downloadButton("drug_tariff_download_button", "Download CSV")
                )
              ),
              DT::DTOutput("drug_tariff_table")
            )
          )
        ),
        bslib::nav_panel(
          "Prescription Cost Analysis",
          bslib::card(
            bslib::layout_sidebar(
              fillable = T,
              sidebar = bslib::sidebar(
                shiny::selectInput("pca_bnf_chapter",
                  label = "Select BNF chapter",
                  choices = pca_bnf_chapter_choice
                ),
              ),
              htmltools::h3(shiny::textOutput("pca_title")),
              bslib::card_body(
                padding = c(0, 10),
                bslib::layout_column_wrap(
                  width = NULL,
                  style = htmltools::css(grid_template_columns = "3fr 1fr"),
                  shiny::uiOutput("pca_caption"),
                  shiny::uiOutput("pca_download_button")
                )
              ),
              reactable::reactableOutput("pca_table")
            )
          )
        ),
        bslib::nav_panel(
          "National Cost Collection",
          bslib::card(
            bslib::layout_sidebar(
              fillable = TRUE,
              sidebar = bslib::sidebar(
                width = "360px", #to avoid wrapping text
                #small row of links above the checkboxes
                htmltools::div(
                  style="margin-bottom: 0.5rem;",
                  shiny::actionLink("ncc_select_all","Select all"),
                  " | ",
                  shiny::actionLink("ncc_clear_all","Clear all")
                ),
                shiny::checkboxGroupInput(
                  "ncc_service_code",
                  label = "Department Code", 
                  choices = NULL # populated from server
                )
              ),
              htmltools::h3(shiny::textOutput("ncc_title")),
              bslib::card_body(
                padding = c(0, 10),
                bslib::layout_column_wrap(
                  width = NULL,
                  style = htmltools::css(grid_template_columns = "3fr 1fr"),
                  shiny::uiOutput("ncc_caption"),
                  shiny::uiOutput("ncc_download_button")
                )
              ),
              reactable::reactableOutput("ncc_table")
            )
          )
        ),
        bslib::nav_panel(
          "Unit Costs of Health and Social Care",
          bslib::card(
            bslib::layout_sidebar(
              fillable = T,
              sidebar = bslib::sidebar(
                width = "25%",
                shiny::selectInput("uchsc_year",
                  label = "Year",
                  choices = uchsc_year_choice
                ),
                shiny::selectInput("uchsc_hcp",
                  label = "Healthcare professional",
                  choices = uchsc_hcp_choice
                ),
                shiny::conditionalPanel(
                  condition = "input.uchsc_hcp == 'gp' ||
                                  input.uchsc_hcp == 'gp_nurse' ||
                                  input.uchsc_hcp == 'hospital_doctor'||
                                  input.uchsc_hcp == 'nurse'",
                  shiny::radioButtons("uchsc_qualification_cost",
                    label = "Qualification cost",
                    choices = c("Include" = "including", "Exclude" = "excluding")
                  ),
                ),
                shiny::conditionalPanel(
                  condition = "input.uchsc_hcp == 'gp'",
                  shiny::radioButtons("uchsc_direct_cost",
                    label = "Direct care staff cost",
                    choices = c("Include" = "including", "Exclude" = "excluding")
                  ),
                  htmltools::tags$div(
                    htmltools::tags$small("Including direct care staff cost factors in the salary and on-costs of the average number of FTE nurses employed by a FTE GP.")
                  )
                ),
                shiny::conditionalPanel(
                  condition = "input.uchsc_hcp == 'gp_nurse'",
                  shiny::radioButtons("uchsc_direct_indirect_ratio",
                    label = "Ratio of direct to indirect time on face-to-face contacts",
                    choices = c("Include" = "including", "Exclude" = "excluding")
                  ),
                  htmltools::tags$div(
                    htmltools::tags$small("Note, only the cost per working hour excluding the ratio of direct to indirect time is from the selected Unit Costs report. All other values are calculated using that figure and:"),
                    htmltools::tags$ul(
                      htmltools::tags$li(
                        htmltools::tags$small(
                          "The duration of contact per surgery consultation (15.5 mins) from the ",
                          htmltools::tags$a(
                            href = "https://kar.kent.ac.uk/60240/",
                            "2015 Unit Costs report",
                            target = "_blank",
                            .noWS = "outside"
                          )
                        )
                      ),
                      htmltools::tags$li(
                        htmltools::tags$small(
                          "The average duration of nurse face-to-face (10 mins) and telephone (6 mins) consultations from ",
                          htmltools::tags$a(
                            href = "https://doi.org/10.1136/bmjopen-2017-018261",
                            "Stevens et al. (2017)",
                            target = "_blank",
                            .noWS = "outside"
                          )
                        )
                      )
                    ),
                    htmltools::tags$small(
                      "Including the ratio of direct to indirect time on face-to-face contacts factors in the 1:0.30 value for practice nurses from the ",
                      htmltools::tags$a(
                        href = "https://kar.kent.ac.uk/60240/",
                        "2015 Unit Costs report",
                        target = "_blank",
                        .noWS = "outside"
                      ),
                      ", which suggests that each hour spent with a patient requires 1.3 paid hours."
                    )
                  )
                ),
                shiny::conditionalPanel(
                  condition = "input.uchsc_hcp == 'community_hcp'",
                  shiny::helpText("To calculate the cost per hour including qualifications for scientific and professional staff, the appropriate expected annual cost shown in the 'Training cost' table should be divided by the number of working hours. This can then be added to the cost per working hour.")
                ),
                shiny::conditionalPanel(
                  condition = "input.uchsc_hcp == 'training_costs'",
                  shiny::radioButtons("uchsc_training_hcp",
                    label = "Select",
                    choices = uchsc_training_costs_choice
                  )
                )
              ),
              htmltools::h3(shiny::textOutput("uchsc_title")),
              bslib::card_body(
                padding = c(0, 10),
                bslib::layout_column_wrap(
                  width = NULL,
                  style = htmltools::css(grid_template_columns = "3fr 1fr"),
                  shiny::uiOutput("uchsc_caption"),
                  shiny::uiOutput("uchsc_download_button")
                )
              ),
              reactable::reactableOutput("uchsc_table")
            ),
          )
        )
      )
    ),
    bslib::nav_panel(
      "About",
      bslib::card(
        htmltools::includeMarkdown(fs::path_package("COSTmos", "about_dashboard.md"))
      )
    )
  )

  # Define server logic required to draw a histogram
  server <- function(input, output, session) {
    # UNIT COSTS OF HEALTH AND SOCIAL CARE SERVER LOGIC ---------------------------------------------

    # Get year
    ushsc_year <- shiny::reactive(input$uchsc_year)

    # Make full name to select from lists
    uchsc_hcp_full <- shiny::reactive({
      if (input$uchsc_hcp == "training_costs") {
        paste0(input$uchsc_hcp, "_", input$uchsc_training_hcp)
      } else {
        input$uchsc_hcp
      }
    })

    # Filtered data
    uchsc_df <- shiny::reactive({
      # Get table
      df <- get(paste0("unit_costs_hsc_", uchsc_hcp_full())) |>
        # Filter to selected year
        dplyr::filter(.data$year == ushsc_year())

      # Filter for inc/exc qualification cost
      if (uchsc_hcp_full() %in% c("gp", "gp_nurse", "hospital_doctor", "nurse")) {
        df <- df |>
          dplyr::filter(.data$qualification_cost == input$uchsc_qualification_cost)
      }

      # Filter for inc/exc direct staff care cost
      if (uchsc_hcp_full() == "gp") {
        df <- df |>
          dplyr::filter(.data$direct_care_staff_cost == input$uchsc_direct_cost)
      }

      # Filter for inc/exc ratio of direct to indirect time
      if (uchsc_hcp_full() == "gp_nurse") {
        df <- df |>
          dplyr::filter(.data$ratio_direct_to_indirect_time == input$uchsc_direct_indirect_ratio)
      }

      df
    })

    # Table
    uchsc_df_colspec <- shiny::reactive(uchsc_col_spec[[uchsc_hcp_full()]])

    output$uchsc_table <- reactable::renderReactable({
      reactable::reactable(uchsc_df(),
        searchable = T,
        defaultPageSize = 10,
        columns = uchsc_df_colspec()
      )
    })

    # Caption
    output$uchsc_caption <- shiny::renderUI({
      htmltools::tags$div(
        htmltools::tags$p("Year: ", ushsc_year()),
        htmltools::tags$p(
          "Access the latest version of the Unit Costs of Health and Social Care manual from the ",
          htmltools::tags$a(
            href = "https://research.kent.ac.uk/corec/unit-costs-2022-2027/",
            "COReC website",
            target = "_blank",
            .noWS = "outside"
          ),
          "."
        )
      )
    })

    # Title
    output$uchsc_title <- shiny::renderText({
      if (input$uchsc_hcp == "training_costs") {
        glue::glue("Unit Costs of Health and Social Care - {names(uchsc_training_costs_choice)[uchsc_training_costs_choice == input$uchsc_training_hcp]}")
      } else {
        glue::glue("Unit Costs of Health and Social Care - {names(uchsc_hcp_choice)[uchsc_hcp_choice == input$uchsc_hcp]}")
      }
    })

    # Download button
    output$uchsc_download_button <- shiny::renderUI({
      csvDownloadButton("uchsc_table",
        filename = paste0(
          "unit_costs_hsc_extract_",
          uchsc_hcp_full(),
          "_",
          ushsc_year(),
          ".csv"
        )
      )
    })


    # DRUG TARIFF SERVER LOGIC ---------------------------------------------

    # Filtered data
    drug_tariff_df <- shiny::reactive({
      df <- get(paste0("drug_tariff_", input$drug_tariff_section))
      
      if (input$drug_tariff_section == "viii_a") {
        if (input$drug_tariff_viii_a_category != "_ALL_") {
          df <- df |> 
            dplyr::filter(.data$drug_tariff_category == input$drug_tariff_viii_a_category)
        }
      }
      
      if (input$drug_tariff_section == "ix") {
        if (input$drug_tariff_ix_part != "_ALL_") {
          df <- df |> 
            dplyr::filter(stringr::str_detect(.data$drug_tariff_part, input$drug_tariff_ix_part))
        }
      }
      
      df
    })

    # Table
    drug_tariff_df_spec <- shiny::reactive(drug_tariff_df_spec_list[[input$drug_tariff_section]])

    output$drug_tariff_table <- DT::renderDT(
      DT::datatable(drug_tariff_df(), 
                colnames = drug_tariff_df_spec()$colnames,
                options = list(columnDefs = drug_tariff_df_spec()$column_defs)
                )
    )

    # Title
    output$drug_tariff_title <- shiny::renderText(glue::glue("Drug Tariff - {names(drug_tariff_sections)[[stringr::str_which(drug_tariff_sections, input$drug_tariff_section)]]}"))

    # Get version
    drug_tariff_df_date <- shiny::reactive({
      drug_tariff_version |>
        dplyr::filter(.data$section == input$drug_tariff_section) |>
        dplyr::pull("version_ym") |>
        purrr::pluck(1) |>
        lubridate::ym()
    })

    # Caption
    drug_tariff_df_date_caption <- shiny::reactive(glue::glue("Release: {format(drug_tariff_df_date(), '%B %Y')}"))

    output$drug_tariff_caption <- shiny::renderUI({
      htmltools::tags$div(
        htmltools::tags$p(drug_tariff_df_date_caption()),
        htmltools::tags$p(
          "Access the latest version of the Drug Tariff from the ",
          htmltools::tags$a(
            href = "https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff",
            "NHSBSA website",
            target = "_blank",
            .noWS = "outside"
          ),
          "."
        )
      )
    })

    # Download button
    output$drug_tariff_download_button <- shiny::downloadHandler(
      filename = function(){
        paste0(
          "drug_tariff_extract_",
          input$drug_tariff_section,
          "_",
          stringr::str_to_lower(
            stringr::str_replace_all(
              format(drug_tariff_df_date(), "%b %Y"), " ", "_"
            )
          ),
          ".csv"
        )
      },
      content = function(file) {
        s = input$drug_tariff_table_rows_all
        
        write.csv(drug_tariff_df()[s, , drop = FALSE], file, row.names = F)
        }
      )

    # PCA SERVER LOGIC ---------------------------------------------

    # Filtered data
    pca_filtered <- shiny::reactive({
      bnf_c <- input$pca_bnf_chapter
      shiny::req(bnf_c)

      if (identical(bnf_c, "_ALL_")) {
        df <- pca_calendar_year
      } else {
        df <- pca_calendar_year |>
          dplyr::filter(.data$bnf_chapter_name == bnf_c)
      }

      df
    })

    # Title
    output$pca_title <- shiny::renderText({
      bnf_c <- input$pca_bnf_chapter
      label <- if (is.null(bnf_c) || identical(bnf_c, "_ALL_")) "" else paste0(" \u2014 BNF Chapter: ", bnf_c)
      paste0("Prescription Cost Analysis", label)
    })

    # Table
    output$pca_table <- reactable::renderReactable({
      reactable::reactable(
        pca_filtered(),
        searchable = TRUE,
        defaultPageSize = 10,
        columns = pca_col_spec
      )
    })

    # Get year
    pca_year <- shiny::reactive({
      pca_version |>
        dplyr::filter(.data$df == "pca_calendar_year") |>
        dplyr::pull("year") |>
        purrr::pluck(1)
    })

    # Caption
    output$pca_caption <- shiny::renderUI({
      htmltools::tags$div(
        htmltools::tags$p("Calendar year: ", pca_year()),
        htmltools::tags$p(
          "Access the latest version of the Prescription Cost Analysis from the ",
          htmltools::tags$a(
            href = "https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england",
            "NHSBSA website",
            target = "_blank",
            .noWS = "outside"
          ),
          "."
        )
      )
    })

    # Download button
    output$pca_download_button <- shiny::renderUI({
      bnf_c <- input$pca_bnf_chapter
      label <- if (is.null(bnf_c) || identical(bnf_c, "_ALL_")) NA_character_ else paste0(stringr::str_to_lower(stringr::str_replace_all(bnf_c, " ", "_")), "_")

      csvDownloadButton("pca_table",
        filename = glue::glue("pca_calendar_year_extract_{label}{pca_year()}.csv", .na = "")
      )
    })

    # NATIONAL COST COLLECTION SERVER LOGIC -----------------------------------

    ncc_df <- shiny::reactive({
      ncc
    })
    
    # All distinct service codes
    ncc_service_levels <- shiny::reactive({
      df <- ncc_df()
      sort(unique(df[["department_code"]])) 
    })

    # Populate Service Code choices (select all by default)
    shiny::observeEvent(ncc_df(),{
      shiny::updateCheckboxGroupInput(
        session, "ncc_service_code",
        choices = ncc_service_levels(),
        selected = ncc_service_levels()
      )
    }, ignoreInit = FALSE
    )
    
    # NEW: Select all / Clear all buttons --
    
    # When "Select all" actionLink is clicked
    shiny::observeEvent(input$ncc_select_all, {
      shiny::updateCheckboxGroupInput(
        session, "ncc_service_code",
        selected = ncc_service_levels()
      )
    })
    
    # When "Clear all" actionLink is clicked
    shiny::observeEvent(input$ncc_clear_all, {
      shiny::updateCheckboxGroupInput(
        session, "ncc_service_code",
        selected = character(0)   # nothing selected
      )
    })
    
    # Filtered data (vector input now)
    ncc_filtered <- shiny::reactive({
      df <- ncc_df()
      sc <- input$ncc_service_code
      
      # If nothing selected, return empty data frame
      if (is.null(sc) || length(sc) == 0) {
        return(df[0, , drop = FALSE])
      }
      
      #If all selected, return full data
      if (length(sc)==length(ncc_service_levels())){
        return (df)
      }

      df[df[["department_code"]] %in% sc, , drop = FALSE]
    })

    # Title
    output$ncc_title <- shiny::renderText({
      sc <- input$ncc_service_code
      all_sc <- ncc_service_levels()
      
      if (is.null(sc) || length(sc) == 0) {
        # Nothing selected
        return("National Cost Collection \u2014 No department codes selected") 
      }
      
      if (length(sc) == length(all_sc)) {
        # All selected
        return("National Cost Collection \u2014 All department codes") 
      }
      
      # Some selected
      paste0(
        "National Cost Collection \u2014 Department Code: ", 
        paste(sc, collapse = ", ")
      )
    })

    # Table
    output$ncc_table <- reactable::renderReactable({
      reactable::reactable(
        ncc_filtered(),
        searchable = TRUE,
        defaultPageSize = 10,
        columns = list(
          department_code = reactable::colDef(name = "Department Code"), 
          currency_code = reactable::colDef(name = "Currency Code"), 
          currency_desc = reactable::colDef(name = "Currency Description"), 
          activity = reactable::colDef(name = "Activity",
                            format = reactable::colFormat(separators = T)),
          unit_cost = reactable::colDef(name = "Unit cost (\u00a3)",
                               cell = function(value) {
                                 format(round(value, 2), nsmall = 2, big.mark = ",")
                               }),
          cost = reactable::colDef(name = "Cost (\u00a3)",
                          cell = function(value) {
                            format(round(value, 2), nsmall = 2, big.mark = ",")
                          })
        )
      )
    })

    # Get year
    ncc_year <- shiny::reactive({
      ncc_version |>
        dplyr::filter(.data$df == "ncc") |>
        dplyr::pull("year") |>
        purrr::pluck(1)
    })

    # Caption
    output$ncc_caption <- shiny::renderUI({
      htmltools::tags$div(
        htmltools::tags$p(glue::glue("Financial year: {ncc_year()}")),
        htmltools::tags$p(
          "Access the latest version of the National Cost Collection from the ",
          htmltools::tags$a(
            href = "https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/",
            "NHS England website",
            target = "_blank",
            .noWS = "outside"
          ),
          "."
        )
      )
    })

    # Download button - filename reflects selection
    output$ncc_download_button <- shiny::renderUI({
      sc <- input$ncc_service_code
      all_sc <- ncc_service_levels()
      
      label <- if (is.null(sc) || length(sc) == 0 || 
                   length(sc) == length (all_sc)) {
        NA_character_ 
      } else {
        clean_sc <- stringr:: str_to_lower(
          stringr::str_replace_all(sc, " ", "_")
        )
        paste0(paste(clean_sc, collapse = "_"), "_")
      }

      csvDownloadButton("ncc_table",
        filename = glue::glue("ncc_extract_{label}{stringr::str_replace_all(ncc_year(), '_', '/')}.csv", .na = "")
      )
    })
    
  } # end of server

  # Run the application
  shiny::shinyApp(ui = ui, server = server)
}
