library(shiny)
library(leaflet)
library(leaflet.extras)

shinyUI(fluidPage(
  
  titlePanel("Disaster Declarations Summaries"),
  
  # Create a tabsetPanel with two tabs
  tabsetPanel(
    tabPanel("Filter by Year",
             sliderInput("year_filter", "Select Year Range", 
                         min = 1953,
                         max = 2023,
                         value = c(1953, 2023)),
             leafletOutput("map_year")),
    
    tabPanel("Filter by Incident Type",
             selectInput("incident_type_filter", "Select Incident Type", 
                         c('All', 'Fire', 'Flood', 'Hurricane', 'SevereStorm', 
                           'WinterStorm', 'Tornado', 'Snowstorm', 'Earthquake', 
                           'Biological', 'MudLandslide', 'CoastalStorm', 
                           'Other', 'SevereIceStorm', 'DamLeveeBreak', 
                           'TropicalStorm', 'Typhoon', 'VolcanicEruption', 
                           'Freezing', 'ToxicSubstances', 'Chemical', 
                           'Terrorist', 'Drought', 'HumanCause', 
                           'FishingLosses', 'Tsunami')),
             leafletOutput("map_incident_type"))
  )
))
