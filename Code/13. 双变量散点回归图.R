# 13. 双变量散点回归图
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
  x = rnorm(260, 0, 1.2),
  y = 0.82 * x + rnorm(260, 0, 0.95),
  group = factor(sample(c("Control", "Treatment"), 260, replace = TRUE))
)

cor_res <- cor.test(plot_data$x, plot_data$y, method = "spearman")

p <- ggplot(plot_data, aes(x, y, color = group)) +
  geom_point(size = 1.9, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, linewidth = 0.85, color = "black") +
  scale_color_pub() +
  annotate("text", x = min(plot_data$x), y = max(plot_data$y), hjust = 0,
           label = sprintf("Spearman rho = %.2f
p = %.3g", cor_res$estimate, cor_res$p.value), size = 3.5) +
  labs(title = "Scatter Plot with Linear Fit", subtitle = "Effect direction and strength", x = "Predictor", y = "Response") +
  theme_pub()

print(p)
save_pub(p, "scatter_lm_publication", width = 180, height = 140, dpi = 600)
