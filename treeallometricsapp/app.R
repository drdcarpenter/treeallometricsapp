#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(UTreeAllometrics)
library(bslib)
library(bsicons)

# Define UI for application
ui <- page_sidebar(
  title = "Urban Tree Allometric Equations",
  sidebar = sidebar(
    title = "Apply allometric equations",
    selectInput(
      inputId = "species",
      label = "Select species",
      choices = UTreeAllometrics::treespecies$species
    ),
    
    numericInput("height", "Height (m)", value = 3),
    numericInput("dbh", "DBH (cm)", value = 12),
    numericInput("crownr", "Crown radius (m)", value = 3),
    
    radioButtons("equation",
                 "Apply allometric equations",
                 choices = c("dbh_from_height", "dbh_from_crownr",
                             "height_from_dbh", "height_from_crownr",
                             "crownr_from_height", "crownr_from_dbh")),
    
    actionButton("calculate",
                 label = "Calculate",
                 icon = icon("calculator", lib = "font-awesome"))
    
  ),
  
  card(
    card_header("Results"),
    
    value_box(
      title = "Selected species",
      value = textOutput("species")
    ),
    
    value_box(
      title = "Predicted DBH (cm)",
      value = textOutput("dbh"),
      showcase = bsicons::bs_icon("bullseye")
    ),
    
    value_box(
      title = "Predicted height (m)",
      value = textOutput("height"),
      showcase = bsicons::bs_icon("tree-fill")
    ),
    
    value_box(
      title = "Predicted crown radius (m)",
      value = textOutput("crownr"),
      showcase = bsicons::bs_icon("egg-fried")
    )
    
  )
)

# Define server logic
server <- function(input, output, session) {
  
  dbh <- reactive({
    switch(
      input$equation,
      dbh_from_crownr = dbh_from_crownr(input$species, input$crownr),
      dbh_from_height = dbh_from_height(input$species, input$height)
    )
  })
  
  height <- reactive({
  
     switch(
       input$equation,
       height_from_crownr = height_from_crownr(input$species, input$crownr),
       height_from_dbh = height_from_dbh(input$species, input$dbh)
     )

   })
  
  crownr <- reactive({

    switch(
      input$equation,
      crownr_from_dbh = crownr_from_dbh(input$species, input$dbh),
      crownr_from_height = crownr_from_height(input$species, input$height)
    )

  })
  
  species <- reactive({input$species})
  
  output$dbh <- renderText({dbh()})
  
  output$height <- renderText({height()})
  
  output$crownr <- renderText({crownr()})
  
  output$species <- renderText({species()})

    
}

# Run the application 
shinyApp(ui = ui, server = server)
