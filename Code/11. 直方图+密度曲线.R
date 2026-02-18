# 11. 直方图+密度曲线
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
plot_data <- tibble::tibble(value = c(rnorm(350, 5.8, 0.85), rnorm(120, 7.1, 0.6)))

p <- ggplot(plot_data, aes(value)) +
  geom_histogram(aes(y = after_stat(density)), bins = 28, fill = "#88CCEE", color = "white", alpha = 0.86) +
  geom_density(color = "#332288", linewidth = 1.05) +
  geom_vline(xintercept = mean(plot_data$value), linetype = 2, linewidth = 0.65) +
  annotate("text", x = mean(plot_data$value) + 0.12, y = 0.42, label = sprintf("Mean = %.2f", mean(plot_data$value)), hjust = 0, size = 3.6) +
  labs(title = "Histogram with Kernel Density", subtitle = "Distribution quality check", x = "Measurement", y = "Density") +
  theme_pub()

print(p)
save_pub(p, "hist_density_publication", width = 180, height = 140, dpi = 600)
