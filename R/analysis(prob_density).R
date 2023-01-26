# 2단계 확률 밀도 함수: 이 지역 아파트는 비싼 편일까?
# 2-1 확률 밀도 분포도 변환하기
# 그래프 준비하기
load("./08_chart/all.rdata") # 전체 지역
load("./08_chart/sel.rdata") # 관심 지역
max_all <- density(all$py) ; max_all <- max(max_all$y)
max_sel <- density(sel$py) ; max_sel <- max(max_sel$y)
plot_high <- max(max_all, max_sel) # y축 최댓값 찾기
rm(list = c("max_all", "max_sel"))
avg_all <- mean(all$py) # 전체 지역 평당 평균가 계산
avg_sel <- mean(sel$py) # 관심 지역 평당 평균가 계산
avg_all ; avg_sel ; plot_high # 전체/관심 평균 가격과 y축 최댓값 확인

# 2-2 그래프 그리기
plot(stats::density(all$py), ylim = c(0, plot_high),
     col = "blue", lwd = 3, main = NA) # 전체 지역 밀도 함수 띄우기
abline(v = mean(all$py), lwd = 2, col = "blue", lty = 2) # 전체 지역 평균 수직선 그리기
text(avg_all + (avg_all) * 0.15, plot_high * 0.1,
     sprintf("%.0f", avg_all), srt = 0.2, col = "blue") # 전체 지역 평균 텍스트 입력
lines(stats::density(sel$py), col = 'red', lwd = 3) # 관심 지역 확률 밀도 함수 띄우기
abline(v = avg_sel, lwd = 2, col = "red", lty = 2) # 관심 지역 평균 수직선 그리기
text(avg_sel + avg_sel * 0.15, plot_high * 0.1,
     sprintf("%.0f", avg_sel), srt = 0.2, col = "red") # 관심 지역 평균 텍스트 입력