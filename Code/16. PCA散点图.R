# 16. PCA散点图
# PCA 前两主成分散点图
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
mat <- matrix(rnorm(120 * 20), nrow = 120, ncol = 20)
group <- rep(c("Control", "TreatmentA", "TreatmentB"), each = 40)
pc <- prcomp(mat, scale. = TRUE)
plot_data <- tibble::tibble(
  PC1 = pc$x[, 1],
  PC2 = pc$x[, 2],
  group = group
)

p <- ggplot(plot_data, aes(PC1, PC2, color = group)) +
geom_point(size = 2.8, alpha = 0.85) +
  stat_ellipse(aes(fill = group), geom = "polygon", alpha = 0.15, color = NA) +
  scale_color_brewer(palette = "Dark2") +
  scale_fill_brewer(palette = "Dark2") +
  labs(
    title = "PCA 前两主成分散点图",
    x = "",
    y = ""
  ) +
  theme_classic(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.title = element_text(face = "bold"),
    legend.position = "top"
  )

print(p)
ggsave("pca_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
