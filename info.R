url.data1 <- 'http://www.fastfoodmaps.com'
url.data2 <- 'http://wonder.cdc.gov/cancer-v2011.HTML'
url.data3 <- 'http://www.ers.usda.gov/data-products/food-environment-atlas'

url.sourcecode <- 'http://sourcecodelocation'

info <- list(
  br(),
  h4('Projektseminar RUFIT? - Open und Big Data im Healthcare-Bereich'),
  p('Funktionsweise:'),
  br(),
  p('Diese App basiert auf R, Shiny Server, Leaflet und MapBox.',
    'Die Choropleth-Map zeigt die Verteilung von sogenannten',
    '"limited self-service" Restaurants in den USA auf.',
    'Es ist moeglich zwischen den Jahren 2007 und 2011 zu waehlen.',
    'Durch die Radiobuttons koennen gezielt Filialen von ',
    'McDonalds, BurgerKing und TacoBell angezeigt werden (Stand 2007).',
    'Um die Performance der Shiny-App zu verbessern, werden Fastfood-Marker',
    'in Clustern dargestellt. Diese loesen sich auf sobald der Zoom genutzt wird.',
    'Des Weiteren ist es moeglich, die Verteilung von Fitness-Studios in den USA',
    'zu betrachten (Stand 2007 und 2011).',
    'Durch Klick auf einen Staat werden allgemeine Informationen ueber diesen in Form',
    'eines Popups dargestellt. Weitere Informationen ueber Brust-, Prostata-,',
    'Bauchspeicheldr.krebs, Fettleibigkeit und Diabetes erscheinen in einem zusaetzlichen Fenster.'),
  hr(),
  p('Die zugrunde liegenden Daten sind frei zugaenglich'),
  br(),

  tag('ul', list(
    
    tag('li', list('Daten - Fastfood-Standorte', a(href=url.data1, url.data1))),
    tag('li', list('Daten - Fastfood-Verteilung (USDA)', a(href=url.data3, url.data3))),
#     USDA (United States Department of Agriculture - Economic Research Service)
    tag('li', list('Daten - Krebs', a(href=url.data2, url.data2)))
    

  )),
  br(),
  p('Diese shiny-App wurde im Rahmen des Projektseminars SS15 an der Universitaet Wuerzburg entwickelt '),
 
  p('Links', 
    a('Shiny', href='http://shiny.rstudio.com/'), ',',
    a('Leaflet', href='http://leafletjs.com/'), 'und',
    a('Mapbox', href='https://www.mapbox.com/')),
  br(),
  p('Weitere Links',
    a('GitHub', href=url.sourcecode),
    a('USGeoJSON', href='http://eric.clst.org/Stuff/USGeoJSON'),
    a('ggmap', href='http://cran.r-project.org/web/packages/ggmap/index.html'),
    a('ggplot2', href='http://cran.r-project.org/web/packages/ggplot2/index.html'),
    a('shiny', href='http://cran.r-project.org/web/packages/shiny/index.html'),
    a('leaflet', href='http://cran.r-project.org/web/packages/leafletR/index.html'),
    a('RColorBrewer', href='http://cran.r-project.org/web/packages/RColorBrewer/index.html'),
    a('dplyr', href='http://cran.r-project.org/web/packages/dplyr/index.html'),
    a('sp', href='http://cran.r-project.org/web/packages/sp/index.html'),
    a('rgdal', href='http://cran.r-project.org/web/packages/rgdal/index.html'),
    a('reshape2', href='http://cran.r-project.org/web/packages/reshape2/index.html'))
)
