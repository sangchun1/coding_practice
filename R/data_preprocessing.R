setwd('C:/workspace/R')
options(warn=-1)

# 1단계 불필요한 정보 지우기
# 1-1 아파트 실거래 자료 불러오기
load("./03_integrated/03_apt_price.rdata") # 실거래 자료 불러오기
head(apt_price, 2) # 자료 확인

# 1-2 결측값과 공백 제거하기
table(is.na(apt_price)) # 결측값 확인
apt_price <- na.omit(apt_price) # 결측값 제거
table(is.na(apt_price)) # 결측값 확인

head(apt_price$price, 2) # 매매가 확인
library(stringr) # 문자열 처리 패키지 실행
apt_price <- as.data.frame(apply(apt_price, 2, str_trim)) # 공백제거
head(apt_price$price, 2) # 매매가 확인

# 2단계 항목별 데이터 다듬기
# 2-1 매매 연월일 만들기
library(lubridate)
library(dplyr)
apt_price <- apt_price %>% mutate(ymd = make_date(year, month, day)) # 연월일
apt_price$ym <- floor_date(apt_price$ymd, "month") # 연월
head(apt_price, 2) # 자료 확인

# 2-2 매매가 변환하기
head(apt_price$price, 3) # 매매가 확인
apt_price$price <- apt_price$price %>% sub(",", "",.) %>% as.numeric() # 쉼표 제거
head(apt_price$price, 3) # 매매가 확인

# 2-3 주소 조합하기
head(apt_price$apt_nm, 30) # 아파트 이름 현황
apt_price$apt_nm <- gsub("\\(.*", "", apt_price$apt_nm) # 괄호 이후 삭제
head(apt_price$apt_nm, 30)
loc <- read.csv("sigun_code.csv", fileEncoding = 'UTF-8') # 지역 코드 불러오기
apt_price <- merge(apt_price, loc, by = 'code') # 지역명 결합하기
apt_price$juso_jibun <- paste0(apt_price$addr_2, " ", apt_price$dong, " ", apt_price$jibun, " ", apt_price$apt_nm) # 주소 조합
head(apt_price, 2) # 자료 확인

# 2-4 건축 연도, 면적 변환하기
head(apt_price$con_year, 3) # 건축 연도 확인
apt_price$con_year <- apt_price$con_year %>% as.numeric() # 건축 연도 숫자 변환
head(apt_price$con_year, 3) # 건축 연도 확인

# 2-5 전용 면적 변환하기
head(apt_price$area, 3) # 전용 면적 확인
apt_price$area <- apt_price$area %>% as.numeric() %>% round(0) # 전용 면적 변환
head(apt_price$area, 3) # 전용 면적 확인
# 평당 매매가 만들기
apt_price$py <- round(((apt_price$price/apt_price$area) * 3.3), 0) # 평당 가격
head(apt_price$py, 3) # 평당 매매가 확인

# 2-6 층수 변환하기
min(apt_price$floor) # 층수 확인
apt_price$floor <- apt_price$floor %>% as.numeric() %>% abs() # 층수 변환
min(apt_price$floor) # 층수 확인
# 카운트 변수 추가
apt_price$cnt <- 1 # 모든 데이터에 숫자 1 할당
head(apt_price, 2) # 자료 확인

# 3단계 전처리 데이터 저장하기
# 3-1 필요한 칼럼만 추출하기
apt_price <- apt_price %>% select(ymd, ym, year, code, addr_1, apt_nm,
                                  juso_jibun, price, con_year, area, floor, py, cnt) # 칼럼 추출
head(apt_price, 2) # 자료 확인

# 3-2 전처리 데이터 저장하기
dir.create("./04_pre_process") # 새로운 폴더 생성
save(apt_price, file = "./04_pre_process/04_pre_process.rdata") # 저장
write.csv(apt_price, "./04_pre_process/04_pre_process.csv")
