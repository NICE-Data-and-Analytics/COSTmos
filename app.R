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

source("./Scripts/Main.R")
source("./Scripts/PSSRU.R")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("NICE project X"),
    
    navlistPanel(
      widths = c(2, 10),  
      "Reference Prices",
      tabPanel("Drug prices"),
      tabPanel("NHS Collection Costs"),
      tabPanel("Healthcare professionals unit costs",
        sidebarLayout(
            sidebarPanel(
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

  UI_outputs <- reactive({
    generate_PSSRU_tables(
      qual = input$qualification_cost,
      direct = input$direct_cost
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
    datatable(selected_data(), options = list(pageLength = 10))
  })
  
  # output$table <- renderDT({
  #     
  #   switch(input$healthcare_professional,
  #          "Practice nurse" = {
  #            datatable(UI_outputs()$practice_nurse, options = list(pageLength = 10))
  #            },
  #          "Practice GP" = {
  #            datatable(UI_outputs()$practice_GP, options = list(pageLength = 10))
  #          },
  #          "Hospital doctors" = {
  #            datatable(UI_outputs()$hospital_doctors, options = list(pageLength = 10))
  #          })
  #   })
  
  #download buttons
  output$healthcare_professional <- downloadHandler(
    filename = function() {
      paste(input$healthcare_professional, Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(selected_data(), file, row.names = FALSE)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
