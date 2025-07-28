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
              selectInput("year",
                          label = "Select year",
                          choices = c("2023", "2024", "2025"),
                          selected = "2024"),  
              selectInput("healthcare_professional",
                            label = "healthcare professional",
                            choices = c("Practice GP", 
                                        "Practice nurse", 
                                        "Hospital doctors", 
                                        "Qualified nurses", 
                                        "Community-based scientific and professional staff",
                                        "Training costs"),
                            selected = "Practice GP"),
              conditionalPanel(
                condition = "input.healthcare_professional == 'Practice GP' ||
                            input.healthcare_professional == 'Practice nurse' ||
                            input.healthcare_professional == 'Hospital doctors'||
                input.healthcare_professional == 'Qualified nurses'",
              radioButtons("qualification_cost",
                             label = "Qualification cost (excluding individual/productivity)",
                             choices = c("Include qualification cost" = 1, "Exclude qualification cost" = 2),
                             selected = 1),
              ),
              conditionalPanel(
                condition = "input.healthcare_professional == 'Practice GP'",
                radioButtons("direct_cost",
                               label = "Direct care staff cost",
                               choices = c("Include direct care staff costs" = 1, "Exclude direct care staff costs" = 2),
                               selected = 1),
              ),
              conditionalPanel(
                condition = "input.healthcare_professional == 'Community-based scientific and professional staff'",
                helpText("To calculate the cost per hour, including qualifications for scientific and professional staff, the appropriate expected annual cost shown in the 'Training cost' section should be divided by the number of working hours. This can then be added to the cost per working hour."),
              ),
                conditionalPanel(
                  condition = "input.healthcare_professional == 'Training costs'",
                  radioButtons("training_HCP",
                               label = "Select",
                               choices = c("Training cost of health and social care professionals (excluding doctors)" = 1, 
                                           "Training costs of doctors (after discounting)" = 2),
                               selected = 1)
                  )
            ),
    
            # Show a plot of the generated distribution
            mainPanel(
              DTOutput("table"),
              downloadButton("healthcare_professional", "Download Table"),
             uiOutput("dynamic_link")
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
      direct = input$direct_cost,
      year = input$year,
      training_HCP = input$training_HCP
    )
  })
  
  selected_data <- reactive({
    switch(input$healthcare_professional,
           "Practice nurse" = UI_outputs()$practice_nurse,
           "Practice GP" = UI_outputs()$practice_GP,
           "Hospital doctors" = UI_outputs()$hospital_doctors,
           "Community-based scientific and professional staff" = UI_outputs()$HCP_table,
           "Qualified nurses" = UI_outputs()$qualified_nurse,
           "Training costs" = UI_outputs()$training_costs
           
    )
  })
  
  output$table <- renderDT({
    datatable(selected_data(), caption = paste(input$healthcare_professional, UI_outputs()$source), options = list(pageLength = 15))
  })
  
  
  #download buttons
  output$healthcare_professional <- downloadHandler(
    filename = function() {
      paste(input$healthcare_professional, UI_outputs()$source, ".csv", sep = " ")
    },
    content = function(file) {
      write.csv(selected_data(), file, row.names = FALSE)
    })
  
 output$dynamic_link <- renderUI({
   dat <- UI_outputs()          # safe to call inside renderUI
   tags$a(href = dat$URL, paste("Link to",dat$source), target = "_blank")
 })
}

# Run the application 
shinyApp(ui = ui, server = server)
