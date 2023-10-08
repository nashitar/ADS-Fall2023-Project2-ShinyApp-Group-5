#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
###############################Install Related Packages #######################
if (!require("shiny")) {
    install.packages("shiny")
    library(shiny)
}
if (!require("leaflet")) {
    install.packages("leaflet")
    library(leaflet)
}
if (!require("leaflet.extras")) {
    install.packages("leaflet.extras")
    library(leaflet.extras)
}
if (!require("dplyr")) {
    install.packages("dplyr")
    library(dplyr)
}
if (!require("magrittr")) {
    install.packages("magrittr")
    library(magrittr)
}
if (!require("mapview")) {
    install.packages("mapview")
    library(mapview)
}
if (!require("leafsync")) {
    install.packages("leafsync")
    library(leafsync)
}

library(shiny)
library(leaflet)
library(leaflet.extras)

shinyServer(function(input, output) {
  
  file_path <- "DisasterDeclarationsSummariesCleaned.csv"
  lat_col <- "latitude"
  lon_col <- "longitude"
  incident_type_col <- "incidentType"
  
  data <- read.csv(file_path)
  
  # Create a reactive filter for declaration year and incident type
  filtered_data <- reactive({
    year_range <- input$year_filter
    incident_type <- input$incident_type_filter
    
    if (is.null(year_range)) {
      year_filtered <- data
    } else {
      year_filtered <- data[data$declarationyear >= year_range[1] & data$declarationyear <= year_range[2], ]
    }
    
    if (incident_type == "All") {
      return(year_filtered)
    } else {
      return(year_filtered[year_filtered$incidentType == incident_type, ])
    }
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addHeatmap(data = filtered_data(),
                 lat = ~data[[lat_col]],
                 lng = ~data[[lon_col]],
                 radius = 6,  
                 intensity = 10, 
                 blur = 10)
  })
  
})
