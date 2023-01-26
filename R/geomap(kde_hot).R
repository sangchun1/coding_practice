# 2단계 요즘 뜨는 지역은 어디일까?
# 2-1 데이터 준비하기
load("./06_geodataframe/06_apt_price.rdata") # 실거래 불러오기
grid <- st_read("./01_code/sigun_grid/seoul.shp") # 서울시 1km 그리드 불러오기
apt_price <- st_join(apt_price, grid, join = st_intersects) # 실거래 + 그리드 결합
head(apt_price, 2)

# 2-2 이전/이후 데이터 세트 만들기
kde_before <- subset(apt_price, ymd < "2021-07-01") # 이전 데이터 필터링
kde_before <- aggregate(kde_before$py, by = list(kde_before$ID), mean) # 평균 가격
colnames(kde_before) <- c("ID", "before") # 칼럼명 변경

kde_after <- subset(apt_price, ymd > "2021-07-01") # 이후 데이터 필터링
kde_after <- aggregate(kde_after$py, by = list(kde_after$ID), mean) # 평균 가격
colnames(kde_after) <- c("ID", "after") # 칼럼명 변경

kde_diff <- merge(kde_before, kde_after, by = "ID") # 이전 + 이후 데이터 결합
kde_diff$diff <- round((((kde_diff$after - kde_diff$before) /
                           kde_diff$before) * 100), 0) # 변화율 계산
head(kde_diff, 2) # 변화율 확인

# 2-3 가격이 오른 지역 찾기
library(sf)
kde_diff <- kde_diff[kde_diff$diff > 0,] # 상승 지역만 추출
kde_hot <- merge(grid, kde_diff, by = "ID") # 그리드에 상승 지역 결합
library(ggplot2)
library(dplyr)
kde_hot %>% # 그래프 시각화
  ggplot(aes(fill = diff)) +
  geom_sf() +
  scale_fill_gradient(low = 'white', high = 'red')

# 2-4 지도 경계 그리기
# sp형으로 변환과 그리드별 중심 좌표 추출
library(sp)
kde_hot_sp <- as(st_geometry(kde_hot), "Spatial") # sf형 => sp형 변환
x <- coordinates(kde_hot_sp)[,1] # 그리드 중심 x, y 좌표 추출
y <- coordinates(kde_hot_sp)[,2] 

# 기준 경계 설정
l1 <- bbox(kde_hot_sp)[1,1] - (bbox(kde_hot_sp)[1,1] * 0.0001)
l2 <- bbox(kde_hot_sp)[1,2] + (bbox(kde_hot_sp)[1,2] * 0.0001)
l3 <- bbox(kde_hot_sp)[2,1] - (bbox(kde_hot_sp)[2,1] * 0.0001)
l4 <- bbox(kde_hot_sp)[2,2] + (bbox(kde_hot_sp)[2,2] * 0.0001)

# 지도 경계선 그리기
library(spatstat)
win <- owin(xrange = c(l1, l2), yrange = c(l3, l4))
plot(win) # 지도 경계선 확인

# 2-5 밀도 그래프 표시하기
p <- ppp(x, y, window = win, marks = kde_hot$diff) # 경계선 위에 좌표값 포인트 생성
d <- density.ppp(p, weights = kde_hot$diff, # 커널 밀도 함수로 변환
                 sigma = bw.diggle(p),
                 kernel = 'gaussian')
plot(d) # 밀도 그래프 확인

# 2-6 래스터 이미지로 변환하기
# 노이즈 제거와 래스터 이미지로 변환
d[d < quantile(d)[4] + (quantile(d)[4] * 0.1)] <- NA # 노이즈 제거
library(raster)
raster_hot <- raster(d) # 래스터 변환
plot(raster_hot)

# 2-7 불필요한 부분 자르기
# 서울시 외곽선 자르기
bnd <- st_read("./01_code/sigun_bnd/seoul.shp") # 서울시 경계선 불러오기
raster_hot <- crop(raster_hot, extent(bnd)) # 외곽선 자르기
crs(raster_hot) <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84
                            +towgs84=0,0,0") # 좌표계 정의
plot(raster_hot) # 지도확인
plot(bnd, col = NA, border = "red", add = TRUE)

# 2-8 지도 그리기
library(leaflet)
leaflet() %>% 
  #---# 기본 지도 불러오기
  addProviderTiles(providers$CartoDB.Positron) %>% 
  #---# 서울시 경계선 불러오기
  addPolygons(data = bnd, weight = 3, color = "red", fill = NA) %>% 
  #---# 래스터 이미지 불러오기
  addRasterImage(raster_hot,
                 colors = colorNumeric(c("blue", "green", "yellow", "red"),
                                       values(raster_hot), na.color = "transparent"), opacity = 0.4)

# 2-9 평균 가격 변화율 정보 저장하기
save(raster_hot, file = "./07_map/07_kde_hot.rdata") # 급등지 레스터 저장
rm(list = ls()) # 메모리 정리