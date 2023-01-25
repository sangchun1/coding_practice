# 수집 대상 지역 설정
loc <- read.csv("sigun_code.csv", fileEncoding = "UTF-8") # 지역 코드
loc$code <- as.character(loc$code) # 행정구역명 문자 변환
head(loc, 2) # 확인

# 수집 기간 설정
datelist <- seq(from = as.Date('2021-01-01'), # 시작
                to = as.Date('2021-12-31'), # 종료
                by = '1 month') # 단위
datelist <- format(datelist, format = '%Y%m') # 형식 변환(YYYY-MM-DD => YYYYMM)
datelist[1:3] # 확인

# 인증키 입력
service_key <- "#---#"

# 요청 목록 만들기
url_list <- list() # 빈 리스트 만들기
cnt <- 0 # 반복문 제어 변수 초기값 설정

# 요청 목록 채우기
for (i in 1:nrow(loc)) { # 외부 반복: 25개 자치구
  for (j in 1:length(datelist)) { # 내부 반복: 12개월
    cnt <- cnt + 1 # 반복 누적 세기
    #---# 요청 목록 채우기 (25 X 12 = 300)
    url_list[cnt] <- paste0("http://openapi.molit.go.kr:8081/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcAptTrade?",
                            "LAWD_CD=", loc[i,1], # 지역 코드
                            "&DEAL_YMD=", datelist[j], # 수집 월
                            "&numOfRows=", 100, # 가져올 최대 자료 수
                            "&serviceKey=", service_key) # 인증키
  }
  Sys.sleep(0.1) # 0.1초간 멈춤
  msg <- paste0("[", i, "/", nrow(loc), "] ", loc[i,3], "의 크롤링 목록이 생성됨 => 총 [", cnt, "] 건") # 알림 메세지
  cat(msg, "\n\n")
}

# 요청 목록 동작 확인
length(url_list) # 요청 목록 개수 확인
browseURL(paste0(url_list[1])) # 정상 동작 확인(웹 브라우저 실행)

# 임시 저장 리스트 생성
library(XML)
library(data.table)
library(stringr)

raw_data <- list() # XML 임시 저장소
root_Node <- list() # 거래 내역 추출 임시 저장소
total <- list() # 거래 내역 정리 임시 저장소
dir.create("02_raw_data")

# URL 요청 - XML 응답
for(i in 1:length(url_list)) { # 요청 목록(url_list) 반복
  raw_data[[i]] <- xmlTreeParse(url_list[i], useInternalNodes = TRUE, encoding = "utf-8") # 결과 저장
  root_Node[[i]] <- xmlRoot(raw_data[[i]]) # xmlRoot로 루트 노드 이하 추출
  
  # 전체 거래 건수 확인
  items <- root_Node[[i]][[2]][['items']] # 전체 거래 내역(items) 추출
  size <- xmlSize(items) # 전체 거래 건수 확인
  
  # 거래 내역 추출
  item <- list() # 전체 거래 내역(items) 저장 임시 리스트 생성
  item_temp_dt <- data.table() # 세부 거래 내역(items) 저장 임시 테이블 생성
  Sys.sleep(.1) # 0.1초 멈첨
  for(m in 1:size) { # 전체 거래 건수(size)만큼 반복
    #---# 세부 거래 내역 분리
    item_temp <- xmlSApply(items[[m]], xmlValue) 
    item_temp_dt <- data.table(year = item_temp[4], # 거래 연도
                               month = item_temp[7], # 거래 월
                               day = item_temp[8], # 거래 일
                               price = item_temp[1], # 거래 금액
                               code = item_temp[12], # 지역 코드
                               dong_nm = item_temp[5], # 법정동
                               jibun = item_temp[11], # 지번
                               con_year = item_temp[3], # 건축연도
                               apt_nm = item_temp[6], # 아파트 이름
                               area = item_temp[9], # 전용면적
                               floor = item_temp[13]) # 층수
    item[[m]] <- item_temp_dt  } # 분리된 거래 내역 순서대로 저장
  apt_bind <- rbindlist(item) # 통합 저장
  
  # 응답 내역 저장
  region_nm <- subset(loc, code == str_sub(url_list[i], 115, 119))$addr_1 # 지역명
  month <- str_sub(url_list[i], 130, 135) #연월(YYYYMM)
  path <- as.character(paste0("./02_raw_data/", region_nm, "_", month, ".csv"))
  write.csv(apt_bind, path) # CSV 저장
  msg <- paste0("[", i, "/", length(url_list), "] 수집한 데이터를 [", path, "]에 저장 합니다.") # 알림 메세지
  cat(msg, "\n\n")
}

# CSV 파일 통합
files <- dir("./02_raw_data")
library(plyr)
apt_price <- ldply(as.list(paste0("./02_raw_data/", files)), read.csv) # 결합
tail(apt_price, 2) # 확인

# 통합 데이터 저장하기
# RDATA와 CSV 형식으로 저장
dir.create("./03_integrated") # 새로운 폴더 생성
save(apt_price, file = "./03_integrated/03_apt_price.rdata") # 저장
write.csv(apt_price, "./03_integrated/03_apt_price.csv")