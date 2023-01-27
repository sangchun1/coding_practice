# 1단계 샤이니 기본 구조 이해하기
library(shiny)
ui <- fluidPage("사용자 인터페이스")
server <- function(input, output, session){ }
shinyApp(ui, server)

# 2단계 샘플 실행해 보기
# 샤이니가 제공하는 샘플 확인하기
library(shiny)
runExample()
# 첫 번째 샘플 실행하기
runExample('01_hello')

# 3단계 사용자 인터페이스 부분
library(shiny)
ui <- fluidPage( # 사용자 인터페이스 시작: fluidPage 정의
  titlePanel("사이니 1번 샘플"), # 제목 입력
  #---# 레이아웃 구성: 사이드바 패널 + 메인 패널
  sidebarLayout( 
    sidebarPanel( # 사이드바 패널 시작
      #---# 입력값: input$bins 저장
      sliderInput(inputId = "bins", # 입력 아이디
                  label = "막대(bin) 개수:", # 텍스트 라벨
                  min = 1, max = 50, # 선택 범위(1-50)
                  value = 30)), # 기본값
    mainPanel( # 메인 패널 시작
      #---# 출력값: output$distPlot 저장
      plotOutput(outputId = "distPlot"))
  ))

# 4단계 서버 부분
server <- function(input, output, session){
  #---# 랜더링한 플롯을 output 인자의 distPlot에 저장
  output$distPlot <- renderPlot({
    x <- faithful$waiting # 분출 대기 시간 정보 저장
    #---# input$bins을 플롯으로 랜더링
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    #---# 히스토그램 그리기
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "다음 분출 때까지 대기 시간(분)",
         main = "대기 시간 히스토그램")
  })
}
#---# 실행
shinyApp(ui, server)
rm(list = ls())

### 입력과 출력하기
# 1단계 입력받기 input$~
# 데이터 입력
library(shiny)
ui <- fluidPage(
  sliderInput("range", "연비", min = 0, max = 35, value = c(0, 10))) # 데이터 입력

server <- function(input, output, session){} # 반응 없음

shinyApp(ui, server) # 실행

# 2단계 출력하기 output$~
library(shiny)
ui <- fluidPage(
  sliderInput("range", "연비", min = 0, max = 35, value = c(0, 10)), # 데이터 입력
  textOutput("value"))

server <- function(input, output, session){
  output$value <- renderText((input$range[1] + input$range[2]))}

shinyApp(ui, server)

# 3단계 랜더링 함수의 중요성 render~()
library(shiny)
ui <- fluidPage(
  sliderInput("range", "연비", min = 0, max = 35, value = c(0, 10)), # 데이터 입력
  textOutput("value")) # 출력

server <- function(input, output, session){
  output$value <- (input$range[1] + input$range[2])} # 랜더링 함수가 없어서 오류 발생

shinyApp(ui, server)

### 반응형 웹 애플리케이션 만들기
# 1단계 데이터 준비하기
library(DT)
library(ggplot2)
mpg <- mpg
head(mpg)

# 2단계 반응식 작성하기
library(shiny)
ui <- fluidPage(
  sliderInput("range", "연비", min = 0, max = 35, value = c(0, 10)), # 데이터 입력
  DT::dataTableOutput("table")) # 출력

server <- function(input, output, session){
  #---# 반응식
  cty_sel = reactive({
    cty_sel = subset(mpg, cty >= input$range[1] & cty <= input$range[2])
    return(cty_sel)})
  #---# 반응 결과 랜더링
  output$table <- DT::renderDataTable(cty_sel())}

shinyApp(ui, server)

#### 레이아웃 정의하기
# 1단계 단일 페이지 레이아웃
library(shiny)
#---# 전체 페이지 정의
ui <- fluidPage(
  #---# 행 row 구성 정의
  fluidRow(
    #---# 첫 번째 열: 빨강(red) 박스로 높이 450 픽셀, 폭 9
    column(9, div(style = "heigh:450px;border: 4px solid red;","폭 9")),
    #---# 두 번째 열: 보라(purple) 박스로 높이 450 픽셀, 폭 3
    column(3, div(style = "heigh:450px;border: 4px solid purple;","폭 3")),
    #---# 세 번쨰 열: 파랑(blue) 박스로 높이 400 픽셀, 폭 12
    column(12, div(style = "heigh:400px;border: 4px solid blue;","폭 12"))))
server <- function(input, output, session){}
shinyApp(ui, server)

# 2단계 탭 페이지 추가하기
ui <- fluidPage(
  fluidRow(
    column(9, div(style = "heigh:450px;border: 4px solid red;","폭 9")),
    column(3, div(style = "heigh:450px;border: 4px solid purple;","폭 3")),
    #---# 탭 패널 1~2번 추가
    tabsetPanel(
      tabPanel("탭1",
               column(4, div(style = "height:300px;border: 4px solid red;","폭 4")),
               column(4, div(style = "height:300px;border: 4px solid red;","폭 4")),
               column(4, div(style = "height:300px;border: 4px solid red;","폭 4")),),
      tabPanel("탭2", div(style = "height:300px;border: 4px solid red;","폭 4")))))
server <- function(input, output, session){}
shinyApp(ui, server)