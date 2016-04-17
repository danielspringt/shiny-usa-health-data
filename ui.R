library(shiny)
library(leaflet)

source('info.R')



shinyUI(navbarPage("R U Fit", id="nav",
                   
                   tabPanel("map",
                            div(class="outer",
                                
                                tags$head(
                                  # Include our custom CSS
                                  includeCSS("style.css")

                                ),
                                
                                leafletOutput("map", width="100%", height="100%"),
                                
                                
                                
                                
                                #  ControlPanel           
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = T, top = 60, left = 20, right = "auto", bottom = "auto",
                                              width = 330, height = "auto",
                                              
                                              h4("Cancer Info"),
                                              textOutput("textOut"),
                                              plotOutput("cancerplot", height = 200),
                                              plotOutput("diaobplot", height = 200)
                                              
#                                               radioButtons("inputArt", label = h3("Krebsart"),
#                                                            choices = list("Brust" = "breast", "Niere" = "kidney",
#                                                                           "Leber" = "liver", "Lunge" ="lung",
#                                                                           "Prostata" = "prostate") ,selected = "breast"),
#                                               h2("Controls"),
#                                               sliderInput("inputJahr", label = h3("Jahr"),
#                                                           min = min(years), max = max(years), value = years[5], step=1)
                                             
                                              
                 
                                ),
                                
                                
                                tags$div(id="cite",
                                         'R U Fit?', ' Daniel Springmann'
                                )
                            )
                   ),
                   tabPanel("Info", info)
                   
                   
                                     
))