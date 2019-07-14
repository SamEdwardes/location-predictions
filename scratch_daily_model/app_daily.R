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

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Location Predictions Based on Weather"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("PRCP", "Preciptation", min = 0, max = 1400, value = 24),
      sliderInput("SNOW", "Snow", min = 0, max = 600, value = 7),
      sliderInput("SNWD", "Snow Depth", min = 0, max = 3000, value = 0),
      sliderInput("TMAX", "Temperature Max", min = -100, max = 200, value = 64),
      sliderInput("TMIN", "Temperature Min", min = -100, max = 200, value = 64),
      numericInput("month", "Month", min = 20190101, max = 20190711, value = 20190101)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
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
  model <- readRDS("model_rf_daily.rds")
  
  
  # create the location prediction
  prediction_cordinates <- reactive({
    # read the data
    PRCP <- input$PRCP
    SNOW <- input$SNOW
    SNWD <- input$SNWD
    TMAX <- input$TMAX
    TMIN <- input$TMIN
    date <- input$month
    # turn into dataframe
    test <- data.frame(PRCP, SNOW, SNWD, TMAX, TMIN, date)
    test
  })
  
  
  # predict the location
  prediction_result <- reactive({
    df <- prediction_cordinates()
    prediction <- predict(model$finalModel, newdata = df, type = "class")
    prediction
  })
  
  
  # load the station data to get coordinates
  stations <- as.tibble(fread("data/cdn_stations.csv"))
  
  
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
      fitBounds(-126, 50, -65, 61)
    })

}

# Run the application 
shinyApp(ui = ui, server = server)