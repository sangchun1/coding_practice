setwd("C:/workspace/R")

# 1단계 주소와 좌표 결합하기
# 1-1 데이터 불러오기
load("./04_pre_process/04_pre_process.rdata") # 주소 불러오기
load("./05_geocoding/05_juso_geocoding.rdata") # 좌표 불러오기

# 1-2 주소와 좌표 결합하기
library(dplyr)
apt_price <- left_join(apt_price, juso_geocoding,
                       by = c("juso_jibun" = "apt_juso")) # 결합
apt_price <- na.omit(apt_price) # 결측치 제거

# 2단계 지오 데이터프레임 만들기
# 2-1 지오 데이터프레임 생성하기
library(sp)
coordinates(apt_price) <- ~coord_x + coord_y # 좌푯값 할당
proj4string(apt_price) <- "+proj=longlat +datum=WGS84 +no_defs" # 좌표계(CRS) 정의
library(sf)
apt_price <- st_as_sf(apt_price) # sp형 => sf형 변환

# 2-2 지오 데이터프레임 시각화
plot(apt_price$geometry, axes = T, pch = 1) # 플롯 그리기
library(leaflet) # 지도 그리기 라이브러리
leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(data = apt_price[1:1000,], label = ~apt_nm) # 1,000개만 그리기

# 2-3 지오 데이터프레임 저장하기
dir.create("06_geodataframe") # 새로운 폴더 생성
save(apt_price, file = "./06_geodataframe/06_apt_price.rdata") # rdata 저장
write.csv(apt_price, "./06_geodataframe/06_apt_price.csv") # csv 저장