# 4단계 주성분 분석: 이 동네 단지별 특징은 무엇일까?
# 4-1 주성분 분석하기
load("./08_chart/sel.rdata") # 관심 지역
pca_01 <- aggregate(list(sel$con_year, sel$floor, sel$py, sel$area),
                   by = list(sel$apt_nm), mean) # 아파트별 평균값 구하기
colnames(pca_01) <- c("apt_nm", "신축", "층수", "가격", "면적")
m <- prcomp(~ 신축 + 층수 + 가격 + 면적, data = pca_01, scale = T) #주성분 분석
summary(m)

# 4-2 그래프 그리기
library(ggfortify)
autoplot(m, loadings.label = T, loadings.label.size = 6) +
  geom_label(aes(label = pca_01$apt_nm), size = 4)
