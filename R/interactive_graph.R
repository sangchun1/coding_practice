# 패키지 준비하기
install.packages("plotly")
library(plotly)

# 그래프 만들기
library(ggplot2)
p <- ggplot(data = mpg, aes(x = displ, y = hwy, col = drv)) + geom_point()

# 인터랙티브 그래프 만들기
ggplotly(p)

# 인터태기브 막대 그래프 만들기
p <- ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")
ggplotly(p)

# 인터랙티브 시계열 그래프 만들기
install.packages("dygraphs")
library(dygraphs)

# 데이터 불러오기
economics <- ggplot2::economics
head(economics)

# 시간 순서 속성을 지니는 데이터 타입 지정
library(xts)
eco <- xts(economics$unemploy, order.by = economics$date)
head(eco)

# 인터랙티브 시계열 그래프 만들기
dygraph(eco) # 그래프 생성

# 날짜 범위 선택 기능
dygraph(eco) %>% dyRangeSelector()

# 여러 값 표현하기
# 저축률
eco_a <- xts(economics$psavert, order.by = economics$date)
# 실업자 수
eco_b <- xts(economics$unemploy/1000, order.by = economics$date)

eco2 <- cbind(eco_a, eco_b)
colnames(eco2) <- c("psavert", "unemploy")
head(eco2)

# 그래프 만들기
dygraph(eco2) %>% dyRangeSelector()
