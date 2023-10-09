library(shiny)
library(leaflet)
library(leaflet.extras)
library(glue)

shinyServer(function(input, output, session) {
  
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
