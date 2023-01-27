# 3단계 회귀 분석: 이 지역은 일년에 얼마나 오를까?
# 3-1 월별 거래가 요약하기
# 월별 평당 거래가 요약
load("./08_chart/all.rdata") # 전체 지역
load("./08_chart/sel.rdata") # 관심 지역
library(dplyr)
library(lubridate)
all <- all %>% group_by(month = floor_date(ymd, "month")) %>% 
  summarise(all_py = mean(py)) # 전체 지역 카운팅
sel <- sel %>% group_by(month = floor_date(ymd, "month")) %>% 
  summarise(sel_py = mean(py)) # 관심 지역 카운팅

# 3-2 회귀식 모델링하기
fit_all <- lm(all$all_py ~ all$month) # 전체 지역 호귀식
fit_sel <- lm(sel$sel_py ~ sel$month) # 관심 지역 호귀식
coef_all <- round(summary(fit_all)$coefficients[2], 1) * 365 # 전체 회귀 계수
coef_sel <- round(summary(fit_sel)$coefficients[2], 1) * 365 # 관심 회귀 계수

# 3-3 그래프 그리기
# 회귀 분석 그리기
#---# 분가별 평당 가격 변화 주석 만들기
library(grid)
grob_1 <- grobTree(textGrob(paste0("전체 지역: ", coef_all, "만원(평당)"), x = 0.05,
                            y = 0.88, hjust = 0, gp = gpar(col = "blue", fontsize = 13, fontface = "italic")))
grob_2 <- grobTree(textGrob(paste0("관심 지역: ", coef_sel, "만원(평당)"), x = 0.05,
                            y = 0.95, hjust = 0, gp = gpar(col = "red", fontsize = 16, fontface = "bold")))
#---# 관심 지역 회귀선 그리기
library(ggpmisc)
gg <- ggplot(sel, aes(x = month, y = sel_py)) + 
  geom_line(color = "red", size = 1.5) + xlab('월') + ylab('가격') +
  theme(axis.text.x = element_text(angle = 90)) + 
          stat_smooth(method = 'lm', colour = "dark grey", linetype = "dashed") +
          theme_bw()
#---# 전체 지역 회귀선 그리기
gg + geom_line(data = all, aes(x = month, y = all_py), color = "blue", size = 1.5) +
  #---# 주석 추가하기
  annotation_custom(grob_1) + 
  annotation_custom(grob_2)
rm(list = ls()) # 메모리 정리하기