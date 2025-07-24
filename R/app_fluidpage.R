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

costmos_fluidpage_app <- function(...) {
  
  # Define UI for application that draws a histogram
  ui <- fluidPage(
  
      # Application title
      titlePanel("COSTmos"),
      
      navlistPanel(
        widths = c(2, 10),  
        "Data sets",
        tabPanel("Drug Tariff",
          sidebarLayout(
            sidebarPanel(
              selectInput("drug_tariff_section",
                          label = "Select section",
                          choices = drug_tariff_sections),
              width = 2
            ),
            mainPanel(
              h3(textOutput("drug_tariff_title")),
              textOutput("drug_tariff_date_caption"),
              reactableOutput("drug_tariff_table")
            )
          )
                 ),
        tabPanel("NHS Collection Costs"),
        tabPanel("Healthcare professionals unit costs",
          sidebarLayout(
              sidebarPanel(
                selectInput("year",
                            label = "Select year",
                            choices = c("2023", "2024", "2025"),
                            selected = "2024"),  
                selectInput("healthcare_professional",
                              label = "healthcare professional",
                              choices = c("Practice GP", "Practice nurse", "Hospital doctors", "Other healthcare professionals"),
                              selected = "Practice nurse"),
                radioButtons("qualification_cost",
                               label = "Qualification cost (excluding individual/productivity)",
                               choices = c("Include qualification cost" = 1, "Exclude qualification cost" = 2),
                               selected = 1),
                conditionalPanel(
                  condition = "input.healthcare_professional == 'Practice GP'",
                  radioButtons("direct_cost",
                                 label = "Direct care staff cost",
                                 choices = c("Include direct care staff costs" = 1, "Exclude direct care staff costs" = 2),
                                 selected = 1)
                    ),
              ),
      
              # Show a plot of the generated distribution
              mainPanel(
                DTOutput("table"),
                downloadButton("healthcare_professional", "Download Table")
              )
          )
        )
      )
  )
  
  # Define server logic required to draw a histogram
  server <- function(input, output, session) {
  
    # output$drug_tariff_table <- renderReactable({
    #   reactable(iris)
    # })
    # 
    UI_outputs <- reactive({
      generate_PSSRU_tables(
        qual = input$qualification_cost,
        direct = input$direct_cost,
        year = input$year
      )
    })
    
    selected_data <- reactive({
      switch(input$healthcare_professional,
             "Practice nurse" = UI_outputs()$practice_nurse,
             "Practice GP" = UI_outputs()$practice_GP,
             "Hospital doctors" = UI_outputs()$hospital_doctors,
             "Other healthcare professionals" = UI_outputs()$other_healthcare_professionals
      )
    })
    
    output$table <- renderDT({
      datatable(selected_data(), caption = paste(input$healthcare_professional, UI_outputs()$source), options = list(pageLength = 10))
    })
    
    
    #download buttons
    output$healthcare_professional <- downloadHandler(
      filename = function() {
        paste(input$healthcare_professional, UI_outputs()$source, ".csv", sep = " ")
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
      fs::path_package("extdata", package = "costmos") %>%
        list.files() %>%
        stringr::str_subset(pattern = input$drug_tariff_section) %>%
        stringr::str_sort(decreasing = T, numeric = T) %>%
        purrr::pluck(1) %>%
        stringr::str_extract("\\d{6}(?=\\.csv)") %>%
        lubridate::ym()
    })
    drug_tariff_df_date_caption <- reactive(glue::glue("{format(drug_tariff_df_date(), '%B %Y')}. Access and download the latest version from the NHSBSA website."))
    
    output$drug_tariff_title <- renderText(drug_tariff_section_name())
    
    output$drug_tariff_date_caption <- renderText(drug_tariff_df_date_caption())
    
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
