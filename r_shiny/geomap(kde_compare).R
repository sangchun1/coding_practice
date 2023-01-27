# 3단계 우리 동네가 옆 동네보다 비쌀까?
# 3-1 데이터 준비하기
load("./06_geodataframe/06_apt_price.rdata") # 실거래 불러오기
load("./07_map/07_kde_high.rdata") # 최고가 래스터 이미지
load("./07_map/07_kde_hot.rdata") # 급등지 래스터 이미지

library(sf)
bnd <- st_read("./01_code/sigun_bnd/seoul.shp") # 서울시 경계선
grid <- st_read("./01_code/sigun_grid/seoul.shp") # 서울시 그리드 파일

# 3-2 마커 클러스터링 옵션 설정하기
#---# 이상치 설정(하위 10%, 상위 90% 지정)
pcnt_10 <- as.numeric(quantile(apt_price$py, probs = seq(.1, .9, by = .1))[1])
pcnt_90 <- as.numeric(quantile(apt_price$py, probs = seq(.1, .9, by = .1))[9])
#---# 마커 클러스터링 함수 등록
load("./01_code/circle_marker/circle_marker.rdata")
#---# 마커 클러스터링 색상 설정: 상, 중, 하
circle.colors <- sample(x = c("red", "green", "blue"), size = 1000, replace = TRUE)

# 3-3 마커 클러스터링 시각화하기
library(purrr)
leaflet() %>% 
  #---# 오픈스트리트맵 불러오기
  addTiles() %>% 
  #---# 서울시 경계선 불러오기
  addPolygons(data = bnd, weight = 3, color = "red", fill = NA) %>% 
  #---# 최고가 래스터 이미지 불러오기
  addRasterImage(raster_high,
                 colors = colorNumeric(c("blue", "green", "yellow", "red"), values(raster_high),
                                       na.color = "transparent"), opacity = 0.4, group = "2021 최고가") %>% 
  #---# 급등지 래스터 이미지 불러오기
  addRasterImage(raster_hot,
                 colors = colorNumeric(c("blue", "green", "yellow", "red"), values(raster_hot),
                                       na.color = "transparent"), opacity = 0.4, group = "2021 급등지") %>% 
  #---# 최고가/급등지 선택 옵션 추가하기
  addLayersControl(baseGroups = c("2021 최고과", "2021 급등지"),
                   options = layersControlOptions(collapsed = FALSE)) %>% 
  #---# 마커 클러스터링 불러오기
  addCircleMarkers(data = apt_price, lng = unlist(map(apt_price$geometry, 1)),
                   lat = unlist(map(apt_price$geometry, 2)), radius = 10, stroke = FALSE,
                   fillOpacity = 0.6, fillColor = circle.colors, weight = apt_price$py,
                   clusterOptions = markerClusterOptions(iconCreateFunction = JS(avg.formula)))
#---# 메모리 정리하기
rm(list = ls())