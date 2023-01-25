# ��Ű�� ��ġ �� �ε�
install.packages('multilinguer')
library(multilinguer)
install_jdk()
install.packages(c('stringr', 'hash', 'tau', 'Sejong',
                   'RSQLite', 'devtools'), type = 'binary')
install.packages('remotes')
remotes::install_github("haven-jeon/KoNLP",
                        upgrade = "never",
                        INSTALL_opts = c("--no-multiarch"))
library(KoNLP)
library(dplyr)
library(ggplot2)
library(memoise)
library(rJava)

# ���� �����ϱ�
useNIADic()

# ������ �ҷ�����
txt <- readLines("hiphop.txt")
head(txt)
library(stringr)

# Ư������ ����
txt
txt <- str_replace_all(txt, "\\W", " ")

# ���� ���� ����ϴ� ���� ����
extractNoun('���ѹα��� ����� �ѹݵ��� �� �μӵ����� �Ѵ�')
nouns <- extractNoun(txt)

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

# top20�� ����
top20 <- df_word %>% arrange(desc(freq)) %>% head(20)

# ����Ŭ���� �����
install.packages('wordcloud')
library(wordcloud)
library(RColorBrewer)

# Dark2 �����Ͽ��� 8�� ���� ����
pal <- brewer.pal(8, "Dark2")
set.seed(2023)

wordcloud(words = df_word$word, # �ܾ�
          freq = df_word$freq, # ��
          min.freq = 2, # �ּ� �ܾ� ��
          max.words = 200, # ǥ�� �ܾ� ��
          random.order = F, # ���� �ܾ� �߾� ��ġ
          rot.per = .1, # ȸ�� �ܾ� ����
          scale = c(4, 0.3), # �ܾ� ũ�� ����
          colors = pal) # ���� ���

# �ܾ� ���� �ٲٱ�
pal <- brewer.pal(9, "Blues")[5:9] # ���� ��� ����
set.seed(2023)

wordcloud(words = df_word$word, # �ܾ�
          freq = df_word$freq, # ��
          min.freq = 2, # �ּ� �ܾ� ��
          max.words = 200, # ǥ�� �ܾ� ��
          random.order = F, # ���� �ܾ� �߾� ��ġ
          rot.per = .1, # ȸ�� �ܾ� ����
          scale = c(4, 0.3), # �ܾ� ũ�� ����
          colors = pal) # ���� ���