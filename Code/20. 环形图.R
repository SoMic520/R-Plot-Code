# 20. 环形图
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
  ~category, ~value,
  "Firmicutes", 38,
  "Bacteroidetes", 29,
  "Actinobacteria", 15,
  "Proteobacteria", 11,
  "Others", 7
) |>
  dplyr::arrange(dplyr::desc(value)) |>
  dplyr::mutate(frac = value / sum(value),
                ymax = cumsum(frac),
                ymin = dplyr::lag(ymax, default = 0),
                label = paste0(category, " (", scales::percent(frac, accuracy = 1), ")"))

p <- ggplot(plot_data, aes(ymax = ymax, ymin = ymin, xmax = 2, xmin = 1, fill = category)) +
  geom_rect(color = "white", linewidth = 0.6) +
  coord_polar(theta = "y") +
  xlim(0.5, 2.5) +
  scale_fill_brewer(palette = "Set2") +
  annotate("text", x = 0, y = 0, label = "Microbiome
Composition", size = 4.1, fontface = "bold") +
  labs(title = "Donut Chart", subtitle = "Category composition", fill = "Taxa") +
  theme_pub() +
  theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank(), axis.line = element_blank())

print(p)
save_pub(p, "donut_publication", width = 180, height = 140, dpi = 600)
