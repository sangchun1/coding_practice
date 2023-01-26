# 1단계 관심 지역 데이터만 추출하기
# 1-1 데이터 준비하기
library(sf)
load("./06_geodataframe/06_apt_price.rdata") # 실거래 데이터
load("./07_map/07_kde_high.rdata") # 최고가 래스터 이미지
grid <- st_read("./01_code/sigun_grid/seoul.shp") # 서울시 그리드

# 1-2 서울에서 가장 비싼 지역 찾기
# 관심 지역 그리드 찾기
library(tmap)
tmap_mode('view')
#---# 그리드 그리기
tm_shape(grid) + tm_borders() + tm_text("ID", col = "red") +
  #---# 래스터 이미지 그리기
  tm_shape(raster_high) + 
  #---# 래스터 이미지 색상 패턴 설정
  tm_raster(palette = c("blue", "green", "yellow", "red"), alpha = .4) +
  #---# 기본 지도 설정
  tm_basemap(server = c('OpenStreetMap'))

# 1-3 전체 지역/관심 지역 저장하기
library(dplyr)
apt_price <- st_join(apt_price, grid, join = st_intersects) # 실거래 + 그리드 결합
apt_price <- apt_price %>% st_drop_geometry() # 실거래에서 공간 속성 지우기
all <- apt_price # 전체 지역(all) 추출
sel <- apt_price %>% filter(ID == 81497) # 관심 지역(sel) 추출
dir.create("08_chart") # 새로운 폴더 생성
save(all, file = "./08_chart/all.rdata") # 저장
save(sel, file = "./08_chart/sel.rdata")
rm(list = ls())