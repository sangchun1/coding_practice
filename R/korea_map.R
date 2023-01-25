# �б��� �غ��ϱ�
install.packages("stringi")
install.packages("devtools")
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)

# ���ѹα� �õ��� �α� ������ �غ��ϱ�
str(changeCode(korpop1))

# �����ڷ� ���� �� ���ڵ� ����
library(dplyr)
korpop1 <- rename(korpop1, pop = ���α�_��, name = ����������_���鵿)
korpop1$name <- iconv(korpop1$name, "UTF-8", "CP949")

# ���ѹα� �õ� ���� ������ �غ��ϱ�
str(changeCode(kormap1))

# �ܰ豸�е� �����
library(ggiraphExtra)
library(ggplot2)
ggChoropleth(data = korpop1, # ������ ǥ���� ������
             aes(fill = pop, # ����� ǥ���� ����
                 map_id = code, # ���� ���� ����
                 tooltip = name), # ���� ���� ǥ���� ������
             map = kormap1, # ���� ������
             interactive = T) # ���ͷ�Ƽ��

## ���ѹα� �õ��� ���� ȯ�� �� �ܰ� ���е� �����
str(changeCode(tbc))
tbc$name <- iconv(tbc$name, "UTF-8", "CP949")
ggChoropleth(data = tbc,
             aes(fill = NewPts,
                 map_id = code,
                 tooltip = name),
             map = kormap1,
             interactive = T)