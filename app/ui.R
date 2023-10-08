
if (!require("shiny")) {
  install.packages("shiny")
  library(shiny)
}
if (!require("shinyWidgets")) {
  install.packages("shinyWidgets")
  library(shinyWidgets)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}
if (!require("leaflet.extras")) {
  install.packages("leaflet.extras")
  library(leaflet.extras)
}

library(shiny)
library(leaflet)
library(leaflet.extras)

shinyUI(fluidPage(
  
  titlePanel("Disaster Declarations Summaries"),
  
  mainPanel(
    sliderInput("year_filter", "Filter by Declaration Year", 
                min = 2012,
                max = 2023,
                value = c(2012, 2023)),
    
    selectInput("incident_type_filter", "Filter by Incident Type", 
                c("All", "Fire", "Flood", "Hurricane", "Severe Storm", "Winter Storm", "Tornado", "Snowstorm", "Earthquake", "Biological")),
    
    leafletOutput("map")
  )
))
