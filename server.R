library(shiny)
library(leaflet)
library(RColorBrewer)
library(ggplot2) 
library(sp) 
#library(lattice) lattice Plots zwar schön aber Style buggy

source('helper.R')

shinyServer(function(input, output, session) {
  
  output$map <- renderLeaflet({
  # https://rstudio.github.io/leaflet/
  
  leaflet(data=generic_us_state_spdf) %>%
    addTiles(
      urlTemplate = mb_tiles,
      attribution = mb_attribution
    ) %>%
    # <Placeholder Polygons>
    
    # </Placeholder Polygons>
    #_to do dynmaische Legende
    addLegend(position="bottomright", 
              pal = pal, 
              values = ~fastfood_State_2007_1k, 
              title="Legende", 
              opacity = 1) %>%
    
  setView(lng = -93.85, lat = 37.45, zoom = 4) %>%
    addLayersControl(    
      baseGroups = c("Fastfood'07", "Fastfood'11", "FitnessCenters'07", "FitnessCenters'11"),
      overlayGroups = c("McDonald's", "BurgerKing", "TacoBell"),
      options = layersControlOptions(collapsed = FALSE)
      
    ) %>%   
    hideGroup(c("McDonald's", "BurgerKing", "TacoBell", "Fastfood'11"))
   
  }) ### </output$map>
  
  
 
  observe({
    
    leafletProxy("map")%>%
      
      addPolygons(data=generic_us_state_spdf,
                  fillColor = ~pal(fastfood_State_2007_1k),
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 2,
                  popup = state_popup_fastfood_07,
                  group = "Fastfood'07") %>%
      
      addPolygons(data=generic_us_state_spdf,
                  fillColor = ~pal(fastfood_state_2011_1k),
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 2,
                  popup = state_popup_fastfood_11,
                  group = "Fastfood'11") %>%
      
      addPolygons(data=generic_us_state_spdf,
                  fillColor = ~pal2(fitness_facilities_State_2007_1k),
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 2,
                  popup = state_popup_fastfood_07,
                  group = "FitnessCenters'07") %>%
      
      addPolygons(data=generic_us_state_spdf,
                  fillColor = ~pal2(fitness_facilities_State_2011_1k),
                  fillOpacity = 0.8, 
                  color = "#BDBDC3", 
                  weight = 2,
                  popup = state_popup_fastfood_11,
                  group = "FitnessCenters'11") %>%
      
      addMarkers(data = location_Mc, lng =~lon, lat =~lat, popup = ~as.character(Type), 
                 clusterOptions = markerClusterOptions(), group="McDonald's") %>%
      addMarkers(data = location_BK,lng =~lon, lat =~lat, popup = ~as.character(Type), 
                 clusterOptions = markerClusterOptions(), group="BurgerKing") %>%
      addMarkers(data = location_Taco,lng =~lon, lat =~lat, popup = ~as.character(Type), 
                 clusterOptions = markerClusterOptions(), group="TacoBell")
    
  })

 
  
    
    
    ###### Plot in Drag-Panel ######

  output$textOut <- renderText({ 
    
    event <- input$map_shape_click
    if (is.null(event))
      return()
    coords <- as.data.frame(cbind(event$lng, event$lat))
        points <- SpatialPoints(coords)
        proj4string(points) <- proj4string(us_states_spdf)
        stateName <- as.character(over(points, us_states_spdf)$NAME)
        stateName
      
    })
  
  output$cancerplot <- renderPlot({
    
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    coords <- as.data.frame(cbind(event$lng, event$lat))
    points <- SpatialPoints(coords)   
    proj4string(points) <- proj4string(us_states_spdf)
    stateName <- as.character(over(points, us_states_spdf)$NAME)
  
    filter_cancer <- filter(cancer_long, State==stateName)      
    cancer <- ggplot()+  
    geom_bar(data = filter_cancer, stat="identity",position="dodge",width=.5,aes(x = Year, y=Count_1k, fill=Type))+
    scale_fill_manual(values = c("#9D92A9", "#451054","#BC006B"))+                      
    geom_hline(yintercept=c(0.1, 0.7)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
            panel.background = element_blank(), axis.line = element_line(colour = "black"),
          legend.position = "bottom")  
    cancer    
  })
  
  output$diaobplot <- renderPlot({
    
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    coords <- as.data.frame(cbind(event$lng, event$lat))
    points <- SpatialPoints(coords)   
    proj4string(points) <- proj4string(us_states_spdf)
    stateName <- as.character(over(points, us_states_spdf)$NAME)
    
    filter_diaobes <- filter(diaobes, State==stateName)      
    diabet_obesity <- ggplot()+  
      geom_bar(data = filter_diaobes, stat="identity",position="dodge",width=.5,aes(x = Year, y=Count, fill=Type))+
      scale_fill_manual(values = c('#8CDA00','#00B02E'))+
      geom_hline(yintercept=c(10, 30))+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
            panel.background = element_blank(), axis.line = element_line(colour = "black"),
            legend.position = "bottom") 
    
#       Lattice-Plot test
#     diabet_obesity <- barchart(Count~Year,
#                                data=filter_diaobes,
#                                groups=Type, 
#                                col = c('#8CDA00','#00B02E'),
#                                border = 'white',
#                                auto.key=TRUE,
#                                scales=list(x=list(rot=90,cex=0.8)))
    diabet_obesity    
  })
  


})