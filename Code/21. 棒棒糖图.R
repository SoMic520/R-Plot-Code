# 21. 棒棒糖图
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
  taxon = paste0("Genus ", LETTERS[1:14]),
  value = round(runif(14, 8, 45), 1)
) |>
  dplyr::arrange(value)

p <- ggplot(plot_data, aes(y = reorder(taxon, value), x = value)) +
  geom_segment(aes(x = 0, xend = value, yend = reorder(taxon, value)), color = "grey72", linewidth = 0.8) +
  geom_point(aes(color = value), size = 3.1) +
  scale_color_viridis_c(option = "D") +
  labs(title = "Lollipop Plot", subtitle = "Ranked comparison across taxa", x = "Relative abundance (%)", y = NULL, color = "Abundance") +
  theme_pub()

print(p)
save_pub(p, "lollipop_publication", width = 180, height = 140, dpi = 600)
