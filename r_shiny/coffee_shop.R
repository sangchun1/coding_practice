# 01_library

library(shiny) ; library(leaflet)
library(leaflet.extras) ; library(dplyr)
library(ggplot2) ; library(sf)

# 03_Data load

load("./01_code/coffee/coffee_shop.rdata")
bnd <- st_read("./01_code/sigun_bnd/seoul.shp")

# 04_Shiny_UI

ui <- bootstrapPage(
  #---#
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  #---#
  leafletOutput("map", width = "100%", height = "100%"),
  #---#
  absolutePanel(top = 10, right = 10,
    #---#
    selectInput(
      inputId = "sel_brand",
      label = tags$span(
        style = "color: black;", "SELECT BRAND"),
      choices = unique(coffee_shop$brand),
      selected = unique(coffee_shop$brand)[2]),
    #---#
    sliderInput(
      inputId = "range",
      label = tags$span(
        style = "color: black;", "SELECT METRO ACCESS RANGE"),
      min = 0,
      max = 100,
      value = c(60, 80),
      step = 10),
    #---#
    plotOutput("density", height = 230),
  )
)

# 05_Shiny_Server

server <- function(input, output, session) {
  #---#
  brand_sel = reactive({
    brand_sel = subset(coffee_shop,
      brand == input$sel_brand &
      metro_idx >= input$range[1] &
      metro_idx <= input$range[2]
    )
  })
  #---#
  plot_sel = reactive({
    plot_sel = subset(coffee_shop,
                      brand == input$sel_brand
    )
  })
  #---#
  output$density <- renderPlot({
    ggplot(data = with(density(plot_sel()$metro_idx),
      data.frame(x, y)), mapping = aes(x = x, y = y)) +
      geom_line() +
      xlim(0, 100) +
      xlab("Access Range") + ylab("Frequency") +
      geom_vline(xintercept = input$range[1], color = 'red', size = 0.5) +
      geom_vline(xintercept = input$range[2], color = 'red', size = 0.5) +
      theme(axis.text.y = element_blank(),
            axis.ticks.y = element_blank())
  })
  #---#
  output$map <- renderLeaflet({
    leaflet(brand_sel(), width = "100%", height = "100%") %>% 
      addTiles() %>% 
      addPolygons(data=bnd, weight = 3, color = "black", fill = NA) %>%
      setView(lng = 127.0381, lat = 37.59512, zoom = 11) %>% 
      addPulseMarkers(lng = ~x, lat = ~y,
                      label = ~name,
                      icon = makePulseIcon())
  })
}

# 06_Shiny_App

shinyApp(ui, server)
