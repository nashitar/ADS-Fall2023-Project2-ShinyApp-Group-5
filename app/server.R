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

if (!require("readr")) {
  install.packages("readr")
  library(readr)
}
if (!require("stringr")) {
  install.packages("stringr")
  library(stringr)
}
if (!require("plotly")) {
  install.packages("plotly")
  library(plotly)
}


#Data Processing
raw_data <- read_csv("../out/cleaned_dataset_FemaWebDeclarationAreas.csv") %>% filter_all(all_vars(!is.na(.)))
raw_data2 <- read_csv("../out/DisasterDeclarationsSummariesCleaned.csv") %>% filter_all(all_vars(!is.na(.)))
# Group by the column and then summarize, Other, Terrorist, Typhoon are 3 categories that appear too less 
# count_data <- raw_data2 %>%
#   group_by(declarationType) %>%
#   summarise(Count = n())
# print(count_data)
raw_data3 <- read_csv("../out/DisasterDeclarationsSummariesCleaned.csv")


# set.seed(123)  # Setting a seed ensures reproducibility of the random sample
# subset_data <- raw_data %>% sample_n(1000)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  rv <- reactiveValues(update = 0)
  observeEvent(input$StackedBCFilter, {
    rv$update <- input$StackedBCFilter
  })
  
  output$box <- renderPlot({
    library(tidyverse)
    print(rv$update)
    
    if (rv$update == 1) { 
      ggplot(raw_data %>%
               
               # Extract the year from the entryDate
               mutate(Year = substr(entryDate, 1, 4)) %>%
               filter(stateName %in% c("California", "Texas", "Oklahoma")) %>%
               
               
               # Group by the Year and stateName, and count the number of rows
               group_by(Year, stateName) %>%
               summarise(Total = n()) %>%
               ungroup(),
             
             aes(x = Year, y = Total, fill = stateName), environment = environment()) +
        geom_bar(position = "stack", stat = "identity") +
        ylab("Total") +
        labs(title = "Disaster Count Distribution of the top 3 States Over Time")
    }
    else if (rv$update == 2){
      ggplot(raw_data2 %>%
               
               # Extract the year from the entryDate
               mutate(Year = substr(declarationDate, 1, 4)) %>%
               filter(!incidentType %in% c("Other", "Terrorist", "Typhoon")) %>%
               
               group_by(Year, incidentType) %>%
               summarise(Total = n()) %>%
               ungroup(),
             
             aes(x = Year, y = Total, fill = incidentType), environment = environment()) +
        geom_bar(position = "stack", stat = "identity") +
        ylab("Total") +
        labs(title = "Disater Count Distribution of Incident Type Over Time")
    }
    else if (rv$update == 3){
      ggplot(raw_data3 %>%
               mutate(Year = substr(declarationDate, 1, 4)) %>%
               
               group_by(Year, declarationType) %>%
               summarise(Total = n()) %>%
               filter(Total > 1000) %>%
               ungroup(),
             
             aes(x = Year, y = Total, fill = declarationType), environment = environment()) +
        geom_bar(position = "stack", stat = "identity") +
        ylab("Total") +
        labs(title = "Disaster Count Distribution of Declaration Type Over Time")
    }
  })
  
  
  ## Map Tab section
  
  # Hardcode the file paths and column names
  lat_col <- "latitude"
  lon_col <- "longitude"
  incident_type_col <- "incidentType"
  declaration_year_col <- "declarationYear"
  
  # Create a reactive filter for declaration year
  filtered_data_year <- reactive({
    year_range <- input$year_filter
    
    df <- data.frame()
    if (!is.null(year_range)) {
      for (i in year_range[1]:year_range[2]) {
        filename <- glue('../out/DisasterDeclarationsSummaries{i}.csv')
        temp <- read.csv(filename)
        
        # Filter out rows with missing or invalid lat/lon values
        temp <- temp[!is.na(temp[[lat_col]]) & !is.na(temp[[lon_col]]), ]
        
        df <- rbind(df, temp)
      }
    }
    
    return(df)
  })
  
  # Create a reactive filter for incident type
  filtered_data_incident_type <- reactive({
    incident_type <- input$incident_type_filter
    
    df <- data.frame()
    if (incident_type != "All") {
      filename <- glue('../out/DisasterDeclarationsSummaries{incident_type}.csv')
      temp <- read.csv(filename)
      
      # Filter out rows with missing or invalid lat/lon values
      temp <- temp[!is.na(temp[[lat_col]]) & !is.na(temp[[lon_col]]), ]
      
      df <- rbind(df, temp)
    } else {
      filename <- glue('../out/DisasterDeclarationsSummariesCleaned.csv')
      temp <- read.csv(filename)
      
      # Filter out rows with missing or invalid lat/lon values
      temp <- temp[!is.na(temp[[lat_col]]) & !is.na(temp[[lon_col]]), ]
      
      df <- rbind(df, temp)
    }
    
    return(df)
  })
  
  # Render the map for year filter
  output$map_year <- renderLeaflet({
    data <- filtered_data_year()
    
    leaflet() %>%
      addTiles() %>%
      addHeatmap(data = data,
                 lat = ~data[[lat_col]],
                 lng = ~data[[lon_col]],
                 radius = 10,  
                 intensity = 10,  
                 blur = 10)
  })
  
  # Render the map for incident type filter
  output$map_incident_type <- renderLeaflet({
    data <- filtered_data_incident_type()
    
    leaflet() %>%
      addTiles() %>%
      addHeatmap(data = data,
                 lat = ~data[[lat_col]],
                 lng = ~data[[lon_col]],
                 radius = 10,  
                 intensity = 10,  
                 blur = 10)
  })
  
})


