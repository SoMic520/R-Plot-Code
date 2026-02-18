# 19. 桑基图（ggalluvial）
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
  ~baseline, ~visit1, ~outcome, ~n,
  "A", "Follow-up", "Complete", 42,
  "A", "Follow-up", "Dropout", 8,
  "B", "Follow-up", "Complete", 31,
  "B", "Follow-up", "Dropout", 14,
  "C", "Follow-up", "Complete", 25,
  "C", "Follow-up", "Dropout", 10
)

p <- ggplot(plot_data, aes(axis1 = baseline, axis2 = visit1, axis3 = outcome, y = n)) +
  ggalluvial::geom_alluvium(aes(fill = baseline), alpha = 0.78, width = 0.2) +
  ggalluvial::geom_stratum(width = 0.22, fill = "grey94", color = "grey35") +
  ggalluvial::geom_text(stat = "stratum", aes(label = after_stat(stratum)), size = 3.2) +
  ggalluvial::scale_x_discrete(limits = c("Baseline", "Visit 1", "Outcome"), expand = c(0.08, 0.08)) +
  scale_fill_pub() +
  labs(title = "Alluvial (Sankey-style) Plot", subtitle = "Patient flow across stages", x = NULL, y = "Count", fill = "Baseline") +
  theme_pub()

print(p)
save_pub(p, "alluvial_publication", width = 180, height = 140, dpi = 600)
