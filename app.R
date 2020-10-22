library(shiny)
library(leaflet)
library(DT)
library(dplyr)
library(readxl)

mapr <- read_excel("baidumap_coffee.xlsx")
mapraw<-mapr

chinese <- read_excel("Chinese.xlsx")
CH<-chinese$CH
names(mapr)<-c("city","kw","name","location","phonenum","lng","lat")

mapr$location<-paste(CH[5],mapr$location,sep="")
mapr$phonenum<-paste(CH[6],mapr$phonenum,sep="")
mapr_building<-mapr[mapr$kw %in% c(CH[7],CH[8]),]
mapr_coffee<-mapr[!mapr$kw %in% c(CH[7],CH[8]),]
icon.coffee <- makeAwesomeIcon(icon = 'coffee', markerColor = 'beige', library='fa', iconColor = 'black')
icon.building <- makeAwesomeIcon(icon = 'building', markerColor = 'blue', library='fa', iconColor = 'black')


ui<-navbarPage(CH[1], id="main",
           tabPanel(CH[2], leafletOutput("mymap", height=1000)),
           tabPanel(CH[3], DT::dataTableOutput("data")),
           tabPanel(CH[4],includeMarkdown("README.md")))

server <- function(input, output, session) {
  

  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addAwesomeMarkers(lng=mapr_building$lng, lat=mapr_building$lat, popup=paste(mapr_building$name,mapr_building$location,mapr_building$phonenum,sep = "<br/>"),icon = icon.building) %>%
      addAwesomeMarkers(lng=mapr_coffee$lng, lat=mapr_coffee$lat, popup=paste(mapr_coffee$name,mapr_coffee$location,mapr_coffee$phonenum,sep = "<br/>"),icon = icon.coffee)
  })
  
  output$data <-DT::renderDataTable(datatable(
      mapraw,filter = 'top'
  ))
}

shinyApp(ui, server)
