# 17. 雷达图（极坐标）
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

plot_data <- tibble::tribble(
  ~metric, ~group, ~value,
  "Lipid", "Control", 0.52,
  "Inflammation", "Control", 0.49,
  "Barrier", "Control", 0.57,
  "Oxidative", "Control", 0.46,
  "Immune", "Control", 0.55,
  "Lipid", "Treatment", 0.76,
  "Inflammation", "Treatment", 0.71,
  "Barrier", "Treatment", 0.73,
  "Oxidative", "Treatment", 0.67,
  "Immune", "Treatment", 0.75
) |>
  dplyr::mutate(metric = factor(metric, levels = c("Lipid", "Inflammation", "Barrier", "Oxidative", "Immune")))

p <- ggplot(plot_data, aes(metric, value, group = group, color = group, fill = group)) +
  geom_polygon(alpha = 0.2, linewidth = 0.9) +
  geom_point(size = 2.2) +
  coord_polar() +
  ylim(0, 1) +
  scale_color_pub() +
  scale_fill_pub() +
  labs(title = "Radar Plot in Polar Coordinates", subtitle = "Multi-endpoint comparison", x = NULL, y = "Normalized score") +
  theme_pub()

print(p)
save_pub(p, "radar_publication", width = 180, height = 140, dpi = 600)
