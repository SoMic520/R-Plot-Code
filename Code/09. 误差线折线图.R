# 09. 误差线折线图
# 出版级版本：统一主题、颜色体系与导出规格（PDF/TIFF/PNG）。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(scales)
  library(RColorBrewer)
  library(ggpubr)
  library(viridis)
})

if (file.exists("Code/00. 出版级绘图主题与导出函数.R")) {
  source("Code/00. 出版级绘图主题与导出函数.R")
} else {
  stop("请先确保存在 Code/00. 出版级绘图主题与导出函数.R")
}

set.seed(2025)
raw_data <- tidyr::crossing(
  day = seq(0, 28, by = 4),
  treatment = factor(c("Control", "Drug A", "Drug B"), levels = c("Control", "Drug A", "Drug B")),
  rep = 1:18
) |>
  dplyr::mutate(value = 15 + day * 0.55 + as.numeric(treatment) * 1.8 + rnorm(dplyr::n(), 0, 1.4))

plot_data <- raw_data |>
  dplyr::group_by(day, treatment) |>
  dplyr::summarise(mean = mean(value), se = sd(value)/sqrt(dplyr::n()), .groups = "drop")

p <- ggplot(plot_data, aes(day, mean, color = treatment)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 2.3) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.2, linewidth = 0.45) +
  scale_color_pub() +
  scale_x_continuous(breaks = seq(0, 28, 4)) +
  labs(title = "Longitudinal Response Curves", subtitle = "Mean ± SE", x = "Day", y = "Outcome value") +
  theme_pub()

print(p)
save_pub(p, "line_errorbar_publication", width = 180, height = 140, dpi = 600)
