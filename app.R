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
                            choices = c("Practice GP", "Practice nurse", "others"),
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
  
  output$table <- renderDT({
      
    switch(input$healthcare_professional,
           "Practice nurse" = {
               datatable(UI_outputs()$practice_nurse, options = list(pageLength = 10), caption = "Nurse")
             },
           "Practice GP" = {
             datatable(UI_outputs()$practice_GP, options = list(pageLength = 10), caption = "Nurse")
           })
    })
  
  #download buttons
  output$healthcare_professional <- downloadHandler(
    filename = function() {
      paste("healthcare_professional", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(UI_outputs(), file)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
