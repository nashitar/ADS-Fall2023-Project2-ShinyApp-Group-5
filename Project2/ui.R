
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


# Define UI for application that draws a histogram
shinyUI(
  navbarPage(strong("Disaster Distribution",style="color: white;"), 
             theme=shinytheme("cerulean"), # select your themes https://rstudio.github.io/shinythemes/
             #------------------------------- tab panel - Maps ---------------------------------
             
             tabPanel("About",
                      tags$img(
                        src = "https://static01.nyt.com/images/2018/12/13/autossell/13city-resilience2/13city-resilence2-superJumbo.jpg",
                        width = "100%",
                        style = "opacity: 0.90"
                      ),
                      fluidRow(
                        absolutePanel(
                          style = "background-color: white; opacity: 0.70",
                          top = "60%",
                          left = "25%",
                          right = "25%",
                          height = 60,
                          tags$p(
                            style = "padding: 5%; background-color: white; font-family: alegreya; font-size: 120%",
                            "Major storms, earthquakes, fires, and more – when disaster strikes, it gets officially recognized. Here we look at how declared disasters are distributed throughout different locations and how disasters changed over time."
                          ),
                        ),
                        tags$div(style="position: fixed; bottom: 0; width: 100%; padding: 1%; background-color: #2a3f5f; color: white; text-align: center;",
                                 "Developed by Group 5  (Nashita Rahman, Clarence Jiang, Miao Zhang, Yihan Zhang)   ", 
                                 tags$a(href="https://github.com/nashitar/ADS-Fall2023-Project2-ShinyApp-Group-5", "Our GitHub Repository")
                        )
                        
                      )
             ),
             #################### tab 2 ####################
             tabPanel("Natural Disaster Occurrences",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(inputId = "year",
                                      label = "Choose year range:",
                                      choices = c("2013-2023","2002-2012","1991-2001")),
                          
                          selectInput(inputId = "disaster_type", 
                                      label="Select Disaster Type:", 
                                      choices = c("Severe Storm", "Hurricane", "Flood", "Biological", "Fire", "Earthquake", "Drought")),
                          width = 3
                        ),
                        
                        mainPanel(
                          plotOutput("disaster_plot")
                        )
                      )
             ),
             

             #################### tab 3 ####################
             tabPanel(
               "Interactive Plot",
             ),
             #################### tab 4 ####################
             tabPanel(
               "Trend",
               fluidPage(
                 
                 tags$head(
                   tags$style(
                     HTML("
                    .shiny-options-group {
                        display: inline-block;
                        margin-right: 20px;
                    }
                ")
                   )
                 ),
                 
                 # Filter panel on the top
                 fluidRow(
                   column(12, 
                          h2("What Changed As Time Flies?", align = "center", style="color:orange"),
                          h3("Select a filter to see the trends of different disater-relevant features over time:", align = "center", style="color:#045a8d"),
                          radioButtons("StackedBCFilter", label = h3("", align = "center"),
                                       choices = list("Top 3 State with MOST disasters" = 1, "Incident type proportation" = 2, "Declaration type" = 3), 
                                       selected = 1,
                                       inline = TRUE),
                          # Explanation box
                          conditionalPanel(
                            condition = "input.StackedBCFilter == 3",
                            tags$div(style = "margin-top: 15px; padding: 10px; border: 1px solid #ddd; border-radius: 5px; background-color: #f9f9f9;",
                                     "Explanation: Declaration type is a 2 character code that defines if this is a major disaster, fire management, etc. DR means major disaster declaration, which is the natural or man-made disasters. EM means Emergency Declaration that requires federal assistance.")
                          )
                   )
                 ),
                 
                 # Plot in the center
                 fluidRow(
                   column(12, 
                          plotOutput("box")
                   )
                 )
               )
             )
             
             
             ,
             
             tabPanel("Maps",
                      icon = icon("map-marker-alt"), #choose the icon for
                      div(class = 'outer',
                          # side by side plots
                          fluidRow(
                            splitLayout(cellWidths = c("50%", "50%"), 
                                        leafletOutput("left_map",width="100%",height=1200),
                                        leafletOutput("right_map",width="100%",height=1200))),
                          #control panel on the left
                          absolutePanel(id = "control", class = "panel panel-default", fixed = TRUE, draggable = TRUE,
                                        top = 200, left = 50, right = "auto", bottom = "auto", width = 250, height = "auto",
                                        tags$h4('Citi Bike Activity Comparison'), 
                                        tags$br(),
                                        tags$h5('Pre-covid(Left) Right(Right)'), 
                                        prettyRadioButtons(
                                          inputId = "adjust_score",
                                          label = "Score List:", 
                                          choices = c("start_cnt", 
                                                      "end_cnt", 
                                                      "day_diff_absolute",
                                                      "day_diff_percentage"),
                                          inline = TRUE, 
                                          status = "danger",
                                          fill = TRUE
                                        ),
                                        awesomeRadio("adjust_time", 
                                                     label="Time",
                                                     choices =c("Overall",
                                                                "Weekday", 
                                                                "Weekend"), 
                                                     selected = "Overall",
                                                     status = "warning"),
                                        # selectInput('adjust_weather',
                                        #             label = 'Adjust for Weather',
                                        #             choices = c('Yes','No'), 
                                        #             selected = 'Yes'
                                        #             ),
                                        style = "opacity: 0.80"
                                        
                          ), #Panel Control - Closing
                      ) #Maps - Div closing
             ) #tabPanel maps closing
             
             
             
  ) #navbarPage closing  
) #Shiny UI closing    
