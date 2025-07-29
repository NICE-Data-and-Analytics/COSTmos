#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(DT)
library(reactable)
library(tidyverse)
library(glue)
library(fs)
library(bslib)

costmos_app <- function(...) {
  
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
                                            choices = drug_tariff_sections)
                              ),
                              h3(textOutput("drug_tariff_title")),
                              uiOutput("drug_tariff_date_caption"),
                              reactableOutput("drug_tariff_table")
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
                                            choices = c("2023", "2024", "2025"),
                                            selected = "2024"),  
                                selectInput("pssru_healthcare_professional",
                                            label = "Healthcare professional",
                                            choices = c("Practice GP", "Practice nurse", "Hospital doctors", "Other healthcare professionals"),
                                            selected = "Practice nurse"),
                                radioButtons("pssru_qualification_cost",
                                             label = "Qualification cost (excluding individual/productivity)",
                                             choices = c("Include" = 1, "Exclude" = 2),
                                             selected = 1),
                                conditionalPanel(
                                  condition = "input.pssru_healthcare_professional == 'Practice GP'",
                                  radioButtons("pssru_direct_cost",
                                               label = "Direct care staff cost",
                                               choices = c("Include" = 1, "Exclude" = 2),
                                               selected = 1)
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
  
    pssru_ui_outputs <- reactive({
      generate_pssru_tables(
        qual = input$pssru_qualification_cost,
        direct = input$pssru_direct_cost,
        year = input$pssru_year
      )
    })
    
    pssru_selected_data <- reactive({
      switch(input$pssru_healthcare_professional,
             "Practice nurse" = pssru_ui_outputs()$practice_nurse,
             "Practice GP" = pssru_ui_outputs()$practice_GP,
             "Hospital doctors" = pssru_ui_outputs()$hospital_doctors,
             "Other healthcare professionals" = pssru_ui_outputs()$other_healthcare_professionals
      )
    })
    
    output$pssru_table <- renderReactable({
      reactable(pssru_selected_data())
    })
    
    
    #download buttons
    output$healthcare_professional <- downloadHandler(
      filename = function() {
        paste(input$pssru_healthcare_professional, UI_outputs()$source, ".csv", sep = " ")
      },
      content = function(file) {
        write.csv(selected_data(), file, row.names = FALSE)
      })
    
    # Drug Tariff
    ## Reactive expressions
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
    drug_tariff_df_date_caption <- reactive(glue::glue("{format(drug_tariff_df_date(), '%B %Y')}. Download the latest version of the Drug Tariff from the "))
    
    output$drug_tariff_title <- renderText(drug_tariff_section_name())
    
    output$drug_tariff_date_caption <- renderUI(withTags({
      div(p(drug_tariff_df_date_caption(),
            a(href="https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff", "NHSBSA website"))
      )
    }))
    
    output$drug_tariff_table <- renderReactable({
      reactable(drug_tariff_df(),
                searchable = T,
                defaultPageSize = 10,
                columns = drug_tariff_df_colspec())
    })
  }
  
  # Run the application 
  shinyApp(ui = ui, server = server)
}
