# 15. 火山图
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
  gene = paste0("Gene", seq_len(1200)),
  log2FC = rnorm(1200, 0, 1.3),
  pvalue = runif(1200, 1e-5, 0.2)
) |>
  dplyr::mutate(category = dplyr::case_when(
    log2FC >= 1 & pvalue < 0.05 ~ "Upregulated",
    log2FC <= -1 & pvalue < 0.05 ~ "Downregulated",
    TRUE ~ "NS"
  ))

p <- ggplot(plot_data, aes(log2FC, -log10(pvalue), color = category)) +
  geom_point(size = 1.6, alpha = 0.78) +
  geom_vline(xintercept = c(-1, 1), linetype = 2, linewidth = 0.5) +
  geom_hline(yintercept = -log10(0.05), linetype = 2, linewidth = 0.5) +
  scale_color_manual(values = c("Upregulated" = "#D55E00", "Downregulated" = "#0072B2", "NS" = "grey70")) +
  labs(title = "Volcano Plot", subtitle = "Differential expression overview", x = "log2(Fold Change)", y = "-log10(p-value)", color = "Category") +
  theme_pub()

print(p)
save_pub(p, "volcano_publication", width = 180, height = 140, dpi = 600)
