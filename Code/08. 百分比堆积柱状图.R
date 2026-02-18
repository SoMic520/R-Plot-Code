# 08. 百分比堆积柱状图
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
plot_data <- tidyr::crossing(
  group = factor(c("Control", "Treatment"), levels = c("Control", "Treatment")),
  cell_type = factor(c("Type I", "Type II", "Type III", "Type IV"), levels = c("Type I", "Type II", "Type III", "Type IV"))
) |>
  dplyr::mutate(count = c(145, 98, 63, 42, 103, 106, 92, 78))

p <- ggplot(plot_data, aes(group, count, fill = cell_type)) +
  geom_col(position = "fill", width = 0.62, color = "white") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1), expand = expansion(mult = c(0, 0.02))) +
  scale_fill_brewer(palette = "Paired") +
  labs(title = "Composition Shift Between Groups", subtitle = "100% stacked bars", x = NULL, y = "Cell proportion") +
  theme_pub()

print(p)
save_pub(p, "stacked_percent_publication", width = 180, height = 140, dpi = 600)
