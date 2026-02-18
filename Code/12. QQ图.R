# 12. QQ图
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
plot_data <- tibble::tibble(value = rt(180, df = 7))

p <- ggplot(plot_data, aes(sample = value)) +
  stat_qq(size = 1.35, alpha = 0.7, color = "#0072B2") +
  stat_qq_line(linewidth = 0.95, color = "#D55E00") +
  labs(title = "Q-Q Plot for Normality Assessment", subtitle = "Tail deviation is visually inspectable", x = "Theoretical quantiles", y = "Sample quantiles") +
  theme_pub()

print(p)
save_pub(p, "qq_publication", width = 180, height = 140, dpi = 600)
