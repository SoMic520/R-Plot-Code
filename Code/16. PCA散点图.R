# 16. PCA散点图
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
mat <- matrix(rnorm(180 * 60), nrow = 180)
group <- factor(rep(c("Control", "Drug A", "Drug B"), each = 60), levels = c("Control", "Drug A", "Drug B"))
pc <- prcomp(mat, scale. = TRUE)
plot_data <- tibble::tibble(PC1 = pc$x[, 1], PC2 = pc$x[, 2], group = group)
var_exp <- (pc$sdev^2) / sum(pc$sdev^2)

p <- ggplot(plot_data, aes(PC1, PC2, color = group, fill = group)) +
  geom_point(size = 2.2, alpha = 0.83) +
  stat_ellipse(geom = "polygon", alpha = 0.17, color = NA) +
  scale_color_pub() +
  scale_fill_pub() +
  labs(title = "PCA Score Plot", subtitle = "Group separation in reduced dimension",
       x = sprintf("PC1 (%.1f%%)", var_exp[1] * 100), y = sprintf("PC2 (%.1f%%)", var_exp[2] * 100)) +
  theme_pub()

print(p)
save_pub(p, "pca_publication", width = 180, height = 140, dpi = 600)
