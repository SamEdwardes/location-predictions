#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(tidyverse)
library(data.table)
library(randomForest)
library(caret)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Location Predictions Based on Weather"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("PRCP", "Preciptation", min = 0, max = 260, value = 24),
      sliderInput("SNOW", "Snow", min = 0, max = 88, value = 0),
      sliderInput("SNWD", "Snow Depth", min = 0, max = 200, value = 0),
      sliderInput("TMAX", "Temperature Max", min = -30, max = 200, value = 70),
      sliderInput("TMIN", "Temperature Min", min = --30, max = 200, value = 50),
      numericInput("month", "Month", min = 1, max = 7, value = 7),
      p("The source code for the app can be found on github:"),
      a(href = "https://github.com/SamEdwardes/location-predictions", "GitHub.com/SamEdwardes/location-predictions")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3("Instructions"),
      p("This tool was created as part of the Developing Data Products course from Coursera. The purpose of this tool is to demonstrate how Shiny can be used to deploy a data science project."),
      p("To use the tool, adjust the sliders to the left, and the tool will automatically predict your location. Please note that the focus of this demo was on demonstrating how to use Shiny. The prediction algorithm has not been reviewed nor tested by anyone else, and will likely not produce reliable predictions. The model was build on Canadian weather station data from January 2019 to July 2019."),
      h3("Prediction Inputs from Sidebar"),
      verbatimTextOutput("prediction_input"),
      h3("Prediction Results (station id)"),
      verbatimTextOutput("prediction_result"),
      h3("Prediction Result (station details)"),
      verbatimTextOutput("prediction_result_cords"),
      h3("Map"),
      leafletOutput("map")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # load the model
  model <- readRDS("model_rf_monthly.rds")
  
  
  # create the location prediction
  prediction_cordinates <- reactive({
    # read the data
    PRCP <- input$PRCP
    SNOW <- input$SNOW
    SNWD <- input$SNWD
    TMAX <- input$TMAX
    TMIN <- input$TMIN
    month <- input$month
    # turn into dataframe
    test <- data.frame(PRCP, SNOW, SNWD, TMAX, TMIN, month)
    test
  })
  
  
  # predict the location
  prediction_result <- reactive({
    df <- prediction_cordinates()
    prediction <- predict(model$finalModel, newdata = df, type = "class")
    prediction
  })
  
  
  # load the station data to get coordinates
  stations <- as_tibble(fread("cdn_stations.csv"))
  
  
  # get the cordinates
  prediction_result_cords <- reactive({
    stations %>% filter(station.id == prediction_result())
  })
  
  
  # Print the results
  output$prediction_input <- renderPrint(prediction_cordinates())
  output$prediction_result <- renderPrint(prediction_result())
  output$prediction_result_cords <- renderPrint(prediction_result_cords())
 
  
  # creating the leaflet map
  output$map <- renderLeaflet({
    # get prediction result cordinates
    df <- prediction_result_cords()
    #create content popup
    df$label <- paste0(paste0("<p>", "Station Name: ", as.character(df$station.name), "<p></p>"),
                       paste0("<p>", "Station ID: ", as.character(df$station.id), "<p></p>"),
                       paste0("<p>", "Lat/Lon: ", as.character(df$Lat)," , ", as.character(df$Lon), "<p></p>"))
    labs <- df$label
    #create the map
    df %>%
      leaflet() %>% 
      addTiles() %>%
      addMarkers(label = lapply(labs, htmltools::HTML)) %>%
      fitBounds(-138, 50, -65, 61)
    })

}

# Run the application 
shinyApp(ui = ui, server = server)