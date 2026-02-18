# 05. 箱线图+抖动点
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
  group = factor(c("Control", "Treatment A", "Treatment B"), levels = c("Control", "Treatment A", "Treatment B")),
  rep = 1:55
) |>
  dplyr::mutate(value = rnorm(dplyr::n(), mean = c(5.8, 6.8, 7.4)[as.numeric(group)], sd = 0.75))

p <- ggplot(plot_data, aes(group, value, fill = group)) +
  geom_boxplot(width = 0.55, outlier.shape = NA, alpha = 0.75, color = "grey20") +
  geom_jitter(width = 0.12, size = 1.3, alpha = 0.55, color = "grey10") +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3.1, fill = "white", color = "black") +
  ggpubr::stat_compare_means(comparisons = list(c("Control", "Treatment A"), c("Control", "Treatment B")),
                             method = "wilcox.test", label = "p.signif") +
  scale_fill_pub() +
  labs(title = "Group-wise Distribution with Jittered Points", subtitle = "Median, IQR and individual observations", x = NULL, y = "Biomarker level (a.u.)") +
  theme_pub()

print(p)
save_pub(p, "box_jitter_publication", width = 180, height = 140, dpi = 600)
