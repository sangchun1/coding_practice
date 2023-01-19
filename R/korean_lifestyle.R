# https://drive.google.com/uc?export=download&confirm=p1Up&id=1BzTA2OG4oVa0g_XyuuVcHl883L19vRGa

install.packages("foreign") # foreign 패키지 설치
install.packages("readxl")
library(foreign) # SPSS 파일 로드
library(dplyr) # 전처리
library(ggplot2) # 시각화
library(readxl) # 엑셀 파일 불러오기

# 데이터 불러오기
raw_welfare <- read.spss(file = "Koweps_hpc10_2015_beta1.sav",
                         to.data.frame = T)
welfare <- raw_welfare

# 데이터 검토하기
head(welfare)
tail(welfare)
View(welfare)
dim(welfare)
str(welfare)
summary(welfare)

# 변수명 바꾸기
welfare <- rename(welfare,
                  sex = h10_g3, # 성별
                  birth = h10_g4, # 태어난 연도
                  marriage = h10_g10, # 혼인 상태
                  religion = h10_g11, # 종교
                  income = p1002_8aq1, # 월급
                  code_job = h10_eco9, # 직종 코드
                  code_region = h10_reg7) # 지역 코드


#### "성별에 따라 월급이 다를까?"
###성별 변수 검토 및 전처리
## 1. 변수 검토하기
class(welfare$sex)
table(welfare$sex)
## 2. 전처리
# 이상치 확인
table(welfare$sex)
# 이상치 결측 처리
welfare$sex <- ifelse(welfare$sex == 9, NA, welfare$sex)
# 결측치 확인
table(is.na(welfare$sex))
# 성별 항목 이름 부여
welfare$sex <- ifelse(welfare$sex == 1, "male", "female")
table(welfare$sex)
qplot(welfare$sex)

### 월급 변수 검토 및 전처리
## 1. 변수 검토하기
class(welfare$income)
summary(welfare$income)
qplot(welfare$income)
## 2. 전처리
# 이상치 확인
summary(welfare$income)
# 이상치 결측 처리
welfare$income <- ifelse(welfare$income %in% c(0, 9999), NA, welfare$income)
#결측치 확인
table(is.na(welfare$income))

### 성별에 따른 월급 차이 분석하기
## 1. 성별 월급 평균표 만들기
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(sex) %>% 
  summarise(mean_income = mean(income))
sex_income
## 2. 그래프 만들기
ggplot(data = sex_income, aes(x=sex, y=mean_income)) + 
  geom_col()


#### "몇 살 때 월급을 가장 많이 받을까?"
### 변수 검토 및 전처리
## 1. 변수 검토하기
class(welfare$birth)
summary(welfare$birth)
qplot(welfare$birth)
## 2. 전처리
# 이상치 확인
summary(welfare$birth)
# 결측치 확인
table(is.na(welfare$birth))
# 이상치 결측 처리
welfare$birth <- ifelse(welfare$birth == 9999, NA, welfare$birth)
table(is.na(welfare$birth))
## 3. 파생변수 만들기 - 나이
welfare$age <- 2015 - welfare$birth + 1
summary(welfare$age)

### 나이와 월급의 관계 분석하기
## 1. 나이에 따른 월급 평균표 만들기
age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))
head(age_income)
## 2. 그래프 만들기
ggplot(data = age_income, aes(x=age, y=mean_income)) + geom_line()


#### "어떤 연령대의 월급이 가장 많을까?"
### 연령대 변수 검토 및 전처리하기
# 파생변수 만들기 - 연령대
welfare <- welfare %>% 
  mutate(ageg = ifelse(age < 30, 'young',
                       ifelse(age <= 59, 'middle', "old")))
table(welfare$ageg)
qplot(welfare$ageg)

### 연령대에 따른 월급 차이 분석하기
## 1. 연령대별 월급 평균표 만들기
ageg_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg) %>% 
  summarise(mean_income = mean(income))
ageg_income
## 2. 그래프 만들기
ggplot(data = ageg_income, aes(x=ageg, y=mean_income)) + geom_col()
# 막대 정렬 : 초년, 중년, 노년 나이 순
ggplot(data = ageg_income, aes(x = ageg, y = mean_income)) +
  geom_col() +
  scale_x_discrete(limits = c("young", "middle", "old"))


#### "성별 월급 차이는 연령대별로 다를까?"
### 연령대 및 성별 월급 차이 분석하기
## 1. 연령대 및 성별 월급 평균표 만들기
sex_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(ageg, sex) %>% 
  summarise(mean_income = mean(income))
sex_income
## 2. 그래프 만들기
ggplot(data = sex_income, aes(x = ageg, y = mean_income, fill = sex)) + 
  geom_col() +
  scale_x_discrete(limits = c('young', 'middle', 'old'))
# 성별 막대 분리
ggplot(data = sex_income, aes(x = ageg, y = mean_income, fill = sex)) +
  geom_col(position = "dodge") +
  scale_x_discrete(limits = c("young", "middle", "old"))

### 나이 및 성별 월급 차이 분석하기
## 1. 성별 연령별 월급 평균표 만들기
sex_age <- welfare %>%
  filter(!is.na(income)) %>%
  group_by(age, sex) %>%
  summarise(mean_income = mean(income))
head(sex_age)
## 2. 그래프 만들기
ggplot(data = sex_age, aes(x = age, y = mean_income, col = sex)) + geom_line()
