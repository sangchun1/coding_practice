# ��Ű�� �غ��ϱ�
install.packages("mapproj")
install.packages("ggiraphExtra")
library(ggiraphExtra)

# �̱� �ֺ� ���� ������ �غ��ϱ�
str(USArrests)
head(USArrests)

# �� �̸� ���� �� �ҹ��ڷ� ����
library(tibble)
crime <- rownames_to_column(USArrests, var = "state")
crime$state <- tolower(crime$state)
str(crime)

# �̱� �� ���� ������ �غ��ϱ�
install.packages("maps")
library(ggplot2)
states_map <- map_data("state")
str(states_map)

# �ܰ� ���е� �����
ggChoropleth(data = crime, # ������ ǥ���� ������
             aes(fill = Murder, # ����� ǥ���� ����
                 map_id = state), # ���� ���� ����
             map = states_map) # ���� ������

# ���ͷ�Ƽ�� �ܰ� ���е� �����
ggChoropleth(data = crime, # ������ ǥ���� ������
             aes(fill = Murder, # ����� ǥ���� ����
                 map_id = state), # ���� ���� ����
             map = states_map, # ���� ������
             interactive = T) # ���ͷ�Ƽ��

ggChoropleth(data = crime, # ������ ǥ���� ������
             aes(fill = Assault, # ����� ǥ���� ����
                 map_id = state), # ���� ���� ����
             map = states_map, # ���� ������
             interactive = T) # ���ͷ�Ƽ��

ggChoropleth(data = crime, # ������ ǥ���� ������
             aes(fill = Rape, # ����� ǥ���� ����
                 map_id = state), # ���� ���� ����
             map = states_map, # ���� ������
             interactive = T) # ���ͷ�Ƽ��

crime <- crime %>% 
  mutate(tot = Murder + Assault + Rape)

crime <- crime %>% 
  mutate(crime_ratio = tot/UrbanPop)

ggChoropleth(data = crime, # ������ ǥ���� ������
             aes(fill = tot, # ����� ǥ���� ����
                 map_id = state), # ���� ���� ����
             map = states_map, # ���� ������
             interactive = T) # ���ͷ�Ƽ��

ggChoropleth(data = crime, # ������ ǥ���� ������
             aes(fill = crime_ratio, # ����� ǥ���� ����
                 map_id = state), # ���� ���� ����
             map = states_map, # ���� ������
             interactive = T) # ���ͷ�Ƽ��