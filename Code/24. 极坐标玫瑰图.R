# 24. 极坐标玫瑰图
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

plot_data <- tibble::tibble(
  month = factor(month.abb, levels = month.abb),
  value = c(12, 14, 17, 23, 31, 42, 48, 46, 35, 27, 19, 14)
)

p <- ggplot(plot_data, aes(month, value, fill = month)) +
  geom_col(width = 1, color = "white", linewidth = 0.35, alpha = 0.92) +
  coord_polar(start = 0) +
  scale_fill_viridis_d(option = "D", begin = 0.1, end = 0.95) +
  labs(title = "Rose Plot (Polar Bar)", subtitle = "Seasonality pattern", x = NULL, y = "Count") +
  theme_pub() +
  theme(legend.position = "none")

print(p)
save_pub(p, "rose_publication", width = 180, height = 140, dpi = 600)
