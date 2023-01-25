library(multilinguer)
library(KoNLP)
library(dplyr)
library(ggplot2)
library(memoise)
library(rJava)
library(stringr)

# 사전 설정하기
useNIADic()

# 데이터 로드
twitter <- read.csv("twitter.csv",
                    header = T,
                    fileEncoding = "UTF-8")

twitter <- rename(twitter,
                  no = 번호,
                  id = 계정이름,
                  date = 작성일,
                  tw = 내용)

# 특수문자 제거
twitter$내용 <- str_replace_all(twitter$내용, "\\W", " ")

# 명사 추출
nouns <- extractNoun(twitter$내용)

# 추출한 명사 list를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

# 변수명 수정
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# 두 글자 이상 단어 추출
df_word <- filter(df_word, nchar(word) >= 2)

# 상위 20개 추출
top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20

# 단어 빈도 막대 그래프 만들기
library(ggplot2)
order <- arrange(top20, freq)$word # 빈도 순서 변수 생성
ggplot(data = top20, aes(x = word, y = freq)) +
  ylim(0, 2500) + 
  geom_col() +
  coord_flip() +
  scale_x_discrete(limit = order) + # 빈도순 막대 정렬
  geom_text(aes(label = freq), hjust = 0.1) # 빈도 표시

# 워드클라우드 만들기
library(wordcloud)
library(RColorBrewer)

# Dark2 색상목록에서 8개 색상 추출
pal <- brewer.pal(9, "Blues")[5:9] # 색상 목록 생성
set.seed(2023)

wordcloud(words = df_word$word, # 단어
          freq = df_word$freq, # 빈도
          min.freq = 10, # 최소 단어 빈도
          max.words = 150, # 표현 단어 수
          random.order = F, # 고빈도 단어 중앙 배치
          rot.per = 0, # 회전 단어 비율
          scale = c(6, 0.5), # 단어 크기 범위
          colors = pal) # 색상 목록
