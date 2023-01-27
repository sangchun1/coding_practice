setwd("C:/workspace/R")

# 1단계 어느 지역이 제일 비쌀까?
# 1-1 지역별 평균 가격 구하기
load("./06_geodataframe/06_apt_price.rdata") # 실거래 자료 불러오기
library(sf)
grid <- st_read("./01_code/sigun_grid/seoul.shp") # 서울시 1km 그리드 불러오기
apt_price <- st_join(apt_price, grid, join = st_intersects) # 실거래+그리드 결합
head(apt_price, 2)

# 그리드별 평균 가격(평당) 계산
kde_high <- aggregate(apt_price$py, by=list(apt_price$ID), mean) # 그리드별 평균 가격
colnames(kde_high) <- c("ID", "avg_price") # 칼럼명 변경
head(kde_high, 2) # 평균가 확인

# 1-2 평균 가격 표시하기
kde_high <- merge(grid, kde_high, by="ID") # ID 기준으로 결합
library(ggplot2)
library(dplyr)
kde_high %>% ggplot(aes(fill = avg_price)) + # 그래프 시각화
  geom_sf() +
  scale_fill_gradient(low = 'white', high = 'red')

# 1-3 지도 경계 그리기
# sp형으로 변환과 그리드별 중심 좌표 추출
library(sp)
kde_high_sp <- as(st_geometry(kde_high), "Spatial") # sf형 => sp형 변환
x <- coordinates(kde_high_sp)[,1] # 그리드 중심 x, y 좌표 추출
y <- coordinates(kde_high_sp)[,2] 

# 기준 경계 설정
l1 <- bbox(kde_high_sp)[1,1] - (bbox(kde_high_sp)[1,1] * 0.0001)
l2 <- bbox(kde_high_sp)[1,2] + (bbox(kde_high_sp)[1,2] * 0.0001)
l3 <- bbox(kde_high_sp)[2,1] - (bbox(kde_high_sp)[2,1] * 0.0001)
l4 <- bbox(kde_high_sp)[2,2] + (bbox(kde_high_sp)[2,2] * 0.0001)

# 지도 경계선 그리기
library(spatstat)
win <- owin(xrange = c(l1, l2), yrange = c(l3, l4))
plot(win) # 지도 경계선 확인
rm(list = c("kde_high_sp", "apt_price", "l1", "l2", "l3", "l4")) # 변수 정리

# 1-4 밀도 그래프 표시하기
p <- ppp(x, y, window = win) # 경계선 위에 좌표값 포인트 생성
d <- density.ppp(p, weights = kde_high$avg_price, # 커널 밀도 함수로 변환
                 sigma = bw.diggle(p),
                 kernel = 'gaussian')
plot(d) # 밀도 그래프 확인
rm(list = c("x", "y", "win", "p")) # 변수 정리

# 1-5 래스터 이미지로 변환하기
# 노이즈 제거와 래스터 이미지로 변환
d[d < quantile(d)[4] + (quantile(d)[4] * 0.1)] <- NA # 노이즈 제거
library(raster)
raster_high <- raster(d) # 래스터 변환
plot(raster_high)

# 1-6 불필요한 부분 자르기
# 서울시 외곽선 자르기
bnd <- st_read("./01_code/sigun_bnd/seoul.shp") # 서울시 경계선 불러오기
raster_high <- crop(raster_high, extent(bnd)) # 외곽선 자르기
crs(raster_high) <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84
                            +towgs84=0,0,0") # 좌표계 정의
plot(raster_high) # 지도확인
plot(bnd, col = NA, border = "red", add = TRUE)

# 1-7 지도 그리기
# 지도 위에 래스터 이미지 올리기
library(leaflet)
leaflet() %>% 
  #---# 기본 지도 불러오기
  addProviderTiles(providers$CartoDB.Positron) %>% 
  #---# 서울시 경계선 불러오기
  addPolygons(data = bnd, weight = 3, color = "red", fill = NA) %>% 
  #---# 래스터 이미지 불러오기
  addRasterImage(raster_high,
                 colors = colorNumeric(c("blue", "green", "yellow", "red"),
                                       values(raster_high), na.color = "transparent"), opacity = 0.4)

# 1-8 평균 가격 정보 저장하기
dir.create("07_map") # 새로운 폴더 생성
save(raster_high, file = "./07_map/07_kde_high.rdata") # 최고가 래스터 저장
rm(list = ls()) # 메모리 정리