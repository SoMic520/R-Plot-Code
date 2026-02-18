# 06. 小提琴图+箱线图
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
  group = factor(c("Control", "Drug A", "Drug B"), levels = c("Control", "Drug A", "Drug B")),
  rep = 1:60
) |>
  dplyr::mutate(value = rnorm(dplyr::n(), mean = c(4.6, 5.7, 6.0)[as.numeric(group)], sd = c(0.6, 0.85, 1.0)[as.numeric(group)]))

p <- ggplot(plot_data, aes(group, value, fill = group)) +
  geom_violin(trim = FALSE, alpha = 0.55, color = "grey25", linewidth = 0.45) +
  geom_boxplot(width = 0.15, outlier.shape = NA, alpha = 0.95, color = "grey10", fill = "white") +
  stat_summary(fun = mean, geom = "point", shape = 21, fill = "#D55E00", color = "black", size = 2.6) +
  scale_fill_pub() +
  labs(title = "Violin + Boxplot", subtitle = "Distribution width and robust summary", x = NULL, y = "Expression (log2 TPM)") +
  theme_pub()

print(p)
save_pub(p, "violin_box_publication", width = 180, height = 140, dpi = 600)
