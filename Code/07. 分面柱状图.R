# 07. 分面柱状图
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
  tissue = factor(c("Liver", "Adipose", "Muscle"), levels = c("Liver", "Adipose", "Muscle")),
  treatment = factor(c("Control", "Intervention"), levels = c("Control", "Intervention")),
  rep = 1:30
) |>
  dplyr::mutate(value = 20 + as.numeric(tissue) * 6 + ifelse(treatment == "Intervention", 5.8, 0) + rnorm(dplyr::n(), 0, 2.8)) |>
  dplyr::group_by(tissue, treatment) |>
  dplyr::summarise(mean = mean(value), se = sd(value)/sqrt(dplyr::n()), .groups = "drop")

p <- ggplot(plot_data, aes(treatment, mean, fill = treatment)) +
  geom_col(width = 0.58, color = "grey20") +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), width = 0.14, linewidth = 0.5) +
  facet_wrap(~ tissue, nrow = 1) +
  scale_fill_pub() +
  labs(title = "Faceted Bar Plot Across Tissues", subtitle = "Mean ± SE", x = NULL, y = "Signal intensity") +
  theme_pub() +
  theme(legend.position = "none")

print(p)
save_pub(p, "facet_bar_publication", width = 180, height = 140, dpi = 600)
