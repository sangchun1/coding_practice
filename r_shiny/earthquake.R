# 12-3 지진 발생 분석하기
# 1단계 데이터 준비하기
load("./01_code/earthquake/earthquake_16_21.rdata") # 지진 발생 자료
head(quakes, 2)

# 2단계 사용자 화면 구축하기
library(shiny)
library(leaflet)
library(ggplot2)
library(ggpmisc)

ui <- bootstrapPage(
  #---# 사용자 화면 페이지 스타일 설정
  tags$style(type = "text/css", "html, body {width:100%;height:100%"),
  #---# 지도 생성
  leafletOutput("map", width = "100%", height = "100%"),
  #---# 메뉴 패널
  absolutePanel(top = 10, right = 10,
    #---# 슬라이드 입력(진도)
    sliderInput(
      inputId = "range", # 입력 아이디
      label = "진도", # 라벨
      min = min(quakes$mag), # 선택 범위 최솟값
      max = max(quakes$mag), # 선택 범위 최댓값
      value = range(quakes$mag), # 기본 선택 범위
      step = 0.5 # 단계
    ),
    #---# 슬라이드 입력(기간)
    sliderInput(
      inputId = "time", # 입력 아이디
      label = "기간", # 라벨
      sep = "",
      min = min(quakes$year), # 선택 범위 최솟값
      max = max(quakes$year),
      value = range(quakes$year),
      step = 1
    ),
    #---# 출력: 빈도 히스토그램
    plotOutput("histCentile", height = 230),
    #---# 출력: 빈도 - 깊이 산점도
    plotOutput("depth", height = 230),
    p(span("자료 출처: 기상청", align = "center",
           style = "color:black;background-color:white"))
  )
)

# 3단계 서버 구현하기
server <- function(input, output, session) {
  #---# 반응식
  filteredData <- reactive({
    quakes[quakes$mag >= input$range[1] & quakes$mag <= input$range[2] &
             quakes$year >= input$time[1] & quakes$year <= input$time[2],]
  })
  output$map <- renderLeaflet({
    leaflet(quakes) %>% addTiles() %>% 
      fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat))
  })
  #---# 히스토그램
  output$histCentile <- renderPlot({
    if (nrow(filteredData()) == 0)
      return(NULL)
    centileBreaks <- hist(plot = FALSE, filteredData()$mag, breaks = 20)$breaks
    hist(filteredData()$mag,
         breaks = centileBreaks,
         main = "지진 발생 정보", xlab = "진도", ylab = "빈도",
         col = 'blue', border = 'grey')
  })
  #---# 회귀 분석
  output$depth <- renderPlot({
    ggplot(filteredData(), aes(x = mag, y = -depth)) +
      geom_point(size = 3, col = "red") +
      geom_smooth(method = "lm", col = "blue") + # 회귀선
      xlab('진도') + ylab('깊이') +
      stat_poly_eq(aes(label = paste(..eq.label..)), # 회귀식
        label.x = "right", label.y = "top",
        formula = y ~ x, parse = TRUE, size = 5, col = "black")
  })
  #---# 입력값 변경에 따른 지도 업데이트
  observe({
    leafletProxy("map", data = filteredData()) %>% clearShapes() %>% 
    addCircles(
      radius = ~log((quakes$mag))^20, # 원 크기 설정
      weight = 1, color = "grey70",
      fillColor = "red", fillOpacity = 0.6, popup = ~paste(mag)
    )
  })
}

# 4단계 애플리케이션 실행하기
shinyApp(ui = ui, server = server)
