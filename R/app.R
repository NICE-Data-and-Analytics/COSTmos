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
library(here)
library(reactable)

costs_app <- function() {
  
  # Define UI for application that draws a histogram
  ui <- fluidPage(
  
      # Application title
      titlePanel("NICE project X"),
      
      navlistPanel(
        widths = c(2, 10),  
        "Reference Prices",
        tabPanel("Drug Tariff",
          sidebarLayout(
            sidebarPanel(
              selectInput("drug_tariff_section",
                          label = "Select section",
                          choices = list("Part VIIIA" = "viiia", "Part VIIIB" = "viiib", "Part VIIID" = "viiid", "Category M" = "cat_m", "Part IX" = "ix"))
            ),
            mainPanel(
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
  }
  
  # Run the application 
  shinyApp(ui = ui, server = server)
}
