# 22. Cleveland点图
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
  marker = paste0("Marker ", sprintf("%02d", 1:12)),
  control = round(rnorm(12, 52, 6), 1),
  treatment = round(rnorm(12, 61, 7), 1)
) |>
  dplyr::mutate(min_v = pmin(control, treatment), max_v = pmax(control, treatment)) |>
  dplyr::arrange(treatment - control)

p <- ggplot(plot_data, aes(y = reorder(marker, max_v))) +
  geom_segment(aes(x = min_v, xend = max_v, yend = reorder(marker, max_v)), color = "grey73", linewidth = 0.9) +
  geom_point(aes(x = control, color = "Control"), size = 2.8) +
  geom_point(aes(x = treatment, color = "Treatment"), size = 2.8) +
  scale_color_manual(values = c("Control" = "#0072B2", "Treatment" = "#D55E00")) +
  labs(title = "Cleveland Dot Plot", subtitle = "Paired comparison per marker", x = "Score", y = NULL, color = NULL) +
  theme_pub()

print(p)
save_pub(p, "cleveland_publication", width = 180, height = 140, dpi = 600)
