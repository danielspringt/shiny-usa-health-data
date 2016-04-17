library(shiny) #installiert auf aws
library(leaflet) #installiert auf aws
library(RColorBrewer) #installiert auf aws
library(dplyr) #installiert auf aws
library(rgdal) #installiert auf aws
library(reshape2) #installiert auf aws

# State <- c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
#            "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", 
#            "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", 
#            "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", 
#            "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", 
#            "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", 
#            "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", 
#            "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
#            "West Virginia", "Wisconsin", "Wyoming")
# 
# Population <- c(4849377, 736732, 6731484, 2966369, 38802500, 5355866, 3596677, 
#                 935614, 658893, 19893297, 10097343, 1419561, 1634464, 12880580, 
#                 6596855, 3107126, 2904021, 4413457, 4649676, 1330089, 5976407, 
#                 6745408, 9909877, 5457173, 2994079, 6063589, 1023579, 1881503, 
#                 2839099, 1326813, 8938175, 2085572, 19746227, 9943964, 739482, 
#                 11594163, 3878051, 3970239, 12787209, 1055173, 4832482, 853175, 
#                 6549352, 26956958, 2942902, 626562, 8326289, 7061530, 1850326, 
#                 5757564, 584153)
# 
# us_pop <- data.frame(state=State, pop=Population,stringsAsFactors=F)

# csv Daten einlesen

# <FASTFOOD>
generic_fastfood_state <- read.csv("data/generic_fastfood_state.csv",stringsAsFactors=F)

location_Mc <- read.csv("data/location_fastfood_MC.csv", stringsAsFactors=F)
location_BK <- read.csv("data/location_fastfood_BK.csv", stringsAsFactors=F)
location_Taco <- read.csv("data/location_fastfood_Taco.csv", stringsAsFactors=F)
location_Pizza <- read.csv("data/location_fastfood_PizzaHut.csv", stringsAsFactors=F)

chips_tax <- read.csv("data/chips.csv", stringsAsFactors=F)
# </FASTFOOD>

# <KRANKHEITEN>
cancer_1k_wide <- read.csv("data/wide_cancer_1k.csv", stringsAsFactors=F)
cancer_wide <- read.csv("data/wide_cancer.csv", stringsAsFactors=F)
cancer_wide <- merge(cancer_1k_wide, cancer_wide, by.x="State", by.y="State") %>% select(-State_Abb.x, -State_Abb.y)
cancer_long <- read.csv("data/long_cancer_states.csv", stringsAsFactors=F)

# _to do clean up
    obesity <-  read.csv("data/obesity_state.csv", stringsAsFactors=F)
    
    obesity_melt <- melt(obesity, id.vars = "State")
    obesity_melt$Type <- "obesity"
    
    obesity_year <- obesity_melt$variable
    obesity_year <- gsub('obesity_State_09', "2009", obesity_year)
    obesity_year <- gsub('obesity_State_10', "2010", obesity_year)
    obesity_year <- gsub('obesity_State_12', "2012", obesity_year)
    obesity_melt$variable <- obesity_year
    
    
    diabetes <-  read.csv("data/diabetes_state.csv", stringsAsFactors=F)
    
    diabetes_melt <- melt(diabetes, id.vars = "State")
    diabetes_melt$Type <- "diabetes"
    
    diabetes_year <- diabetes_melt$variable
    diabetes_year <- gsub('diabetes_State_09', "2009", diabetes_year)
    diabetes_year <- gsub('diabetes_State_10', "2010", diabetes_year)
    diabetes_melt$variable <- diabetes_year
    
    diaobes <- rbind(diabetes_melt, obesity_melt) %>% select(State_Abb=State, Year=variable, Count=value, Type)
    diaobes$State <- state.name[match(diaobes$State_Abb,state.abb)]
    
    
    diaobes[8,]$State <- "District of Columbia"
    diaobes[40,]$State <- "Puerto Rico"
    diaobes[60,]$State <- "District of Columbia"
    diaobes[92,]$State <- "Puerto Rico"
    diaobes[112,]$State <- "District of Columbia"
    diaobes[144,]$State <- "Puerto Rico"
    diaobes[164,]$State <- "District of Columbia"
    diaobes[196,]$State <- "Puerto Rico"
    diaobes[216,]$State <- "District of Columbia"
    diaobes[248,]$State <- "Puerto Rico"

# </KRANKHEITEN>

# <FITNESS>
fitness <-  read.csv("data/fitness_state.csv", stringsAsFactors=F) %>% select(-State)
# </FITNESS>

# State SpatialPolygonsDataFrame
# Spalten - GEO_ID, STATE, NAME, LSAD, CENSUSAREA

us_states_spdf <- readOGR("./mapdata/us_states_20m.geojson","OGRGeoJSON")
# Puerto Rico entfernen
# us_states <- us_states[!us_states$NAME %in% c("Puerto Rico"),] # ohne PR

# Countie SpatialPolygonsDataFrame
#us_counties <- readOGR("./mapdata/us_county_20m.geojson","OGRGeoJSON")
#us_counties <- us_counties[!us_counties$STATE %in% c(72),] # ohne PR

#spatialpolygondataframe erweitern
generic_us_state_spdf <- merge(us_states_spdf, generic_fastfood_state, by.x="NAME", by.y="State")
generic_us_state_spdf <- merge(generic_us_state_spdf, cancer_wide, by.x="NAME", by.y="State")
generic_us_state_spdf <- merge(generic_us_state_spdf, diabetes, by.x="State_Abb", by.y="State")
generic_us_state_spdf <- merge(generic_us_state_spdf, obesity, by.x="State_Abb", by.y="State")
generic_us_state_spdf <- merge(generic_us_state_spdf, fitness, by.x="State_Abb", by.y="State_Abb")
generic_us_state_spdf <- merge(generic_us_state_spdf, chips_tax, by.x="State_Abb", by.y="State")


# tmp checks
# head(generic_us_state_spdf@data)
# unique(generic_us_state_spdf$State_Abb)

################## Leaflet ColorRamps #########################

paletteCol <- colorQuantile("YlOrBr", NULL, n = 9)

pal <- colorNumeric("Reds", NULL, n = 9)

pal2 <- colorNumeric("Greens", NULL, n = 9)


################## MapBox Info #########################

# access_token = pk.eyJ1IjoiZGFubWFlIiwiYSI6IjZlNjNiNzFkZDk2ZWM4MzQzMjM0YTRmNzkyZDRmZWM2In0.-G9P3ssDVAsvkjybFTkueA
# mapboxID = danmae.ml52b4lo
# urlTemplate string = 'https://{s}.tiles.mapbox.com/v4/danmae.ml4ndcd2/{z}/{x}/{y}.png?access_token=<your access token>').addTo(map);

mb_tiles <- 'https://{s}.tiles.mapbox.com/v4/danmae.ml52b4lo/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZGFubWFlIiwiYSI6IjZlNjNiNzFkZDk2ZWM4MzQzMjM0YTRmNzkyZDRmZWM2In0.-G9P3ssDVAsvkjybFTkueA'

mb_attribution <- 'Mapbox <a href="http://mapbox.com/about/maps" target="_blank">Terms &amp; Feedback</a>'


################## Popup Funktionen #########################

#### obesity_State_09  obesity_State_10	obesity_State_12
#### diabetes_State_09  diabetes_State_10
#### Tax_Store  Tax_Automat
#### fitness_facilities_State_2007  fitness_facilities_State_2011	fitness_facilities_State_2007_1k	fitness_facilities_State_2011_1k
state_popup_fastfood_07 <- paste0("<strong>State: </strong>", 
                      generic_us_state_spdf$NAME,
                      "<br><strong>Fastfood Restaurants:</strong><br>", 
                      generic_us_state_spdf$fastfood_State_2007,
                      "<br><strong>Fastfood Restaurants/1k:</strong><br>",
                      generic_us_state_spdf$fastfood_State_2007_1k,
                      "<br><strong>Fitness Center:</strong>",
                      generic_us_state_spdf$fitness_facilities_State_2007,
                      "<br><strong>Fitness Center/1k:</strong><br>",
                      generic_us_state_spdf$fitness_facilities_State_2007_1k)

state_popup_fastfood_11 <- paste0("<strong>State: </strong>", 
                                  generic_us_state_spdf$NAME,
                                  "<br><strong>Fastfood Restaurants:</strong><br>", 
                                  generic_us_state_spdf$fastfood_state_2011,
                                  "<br><strong>Fastfood Restaurants/1k:</strong><br>",
                                  generic_us_state_spdf$fastfood_state_2011_1k,
                                  "<br><strong>Fitness Center:</strong>",
                                  generic_us_state_spdf$fitness_facilities_State_2011,
                                  "<br><strong>Fitness Center/1k:</strong><br>",
                                  generic_us_state_spdf$fitness_facilities_State_2011_1k)