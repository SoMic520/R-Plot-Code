# 14. 二维密度图
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
plot_data <- tibble::tibble(
  x = c(rnorm(220, -1.0, 0.85), rnorm(200, 1.2, 0.9)),
  y = c(rnorm(220, -0.8, 0.7), rnorm(200, 1.5, 0.8))
)

p <- ggplot(plot_data, aes(x, y)) +
  stat_density_2d_filled(aes(fill = after_stat(level)), contour_var = "density", alpha = 0.8) +
  geom_point(size = 0.7, alpha = 0.35, color = "grey20") +
  scale_fill_viridis_d(option = "C") +
  labs(title = "2D Density Map", subtitle = "Cluster structure in bivariate space", x = "Feature 1", y = "Feature 2", fill = "Density") +
  theme_pub()

print(p)
save_pub(p, "density2d_publication", width = 180, height = 140, dpi = 600)
