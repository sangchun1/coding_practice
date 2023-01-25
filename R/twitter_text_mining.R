library(multilinguer)
library(KoNLP)
library(dplyr)
library(ggplot2)
library(memoise)
library(rJava)
library(stringr)

# ���� �����ϱ�
useNIADic()

# ������ �ε�
twitter <- read.csv("twitter.csv",
                    header = T,
                    fileEncoding = "UTF-8")

twitter <- rename(twitter,
                  no = ��ȣ,
                  id = �����̸�,
                  date = �ۼ���,
                  tw = ����)

# Ư������ ����
twitter$���� <- str_replace_all(twitter$����, "\\W", " ")

# ���� ����
nouns <- extractNoun(twitter$����)

# ������ ���� list�� ���ڿ� ���ͷ� ��ȯ, �ܾ ��ǥ ����
wordcount <- table(unlist(nouns))

# ������ ���������� ��ȯ
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

# ������ ����
df_word <- rename(df_word,
                  word = Var1,
                  freq = Freq)

# �� ���� �̻� �ܾ� ����
df_word <- filter(df_word, nchar(word) >= 2)

# ���� 20�� ����
top20 <- df_word %>% 
  arrange(desc(freq)) %>% 
  head(20)
top20

# �ܾ� �� ���� �׷��� �����
library(ggplot2)
order <- arrange(top20, freq)$word # �� ���� ���� ����
ggplot(data = top20, aes(x = word, y = freq)) +
  ylim(0, 2500) + 
  geom_col() +
  coord_flip() +
  scale_x_discrete(limit = order) + # �󵵼� ���� ����
  geom_text(aes(label = freq), hjust = 0.1) # �� ǥ��

# ����Ŭ���� �����
library(wordcloud)
library(RColorBrewer)

# Dark2 �����Ͽ��� 8�� ���� ����
pal <- brewer.pal(9, "Blues")[5:9] # ���� ��� ����
set.seed(2023)

wordcloud(words = df_word$word, # �ܾ�
          freq = df_word$freq, # ��
          min.freq = 10, # �ּ� �ܾ� ��
          max.words = 150, # ǥ�� �ܾ� ��
          random.order = F, # ���� �ܾ� �߾� ��ġ
          rot.per = 0, # ȸ�� �ܾ� ����
          scale = c(6, 0.5), # �ܾ� ũ�� ����
          colors = pal) # ���� ���