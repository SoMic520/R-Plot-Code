# 18. 树图（Treemap）
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
  phylum = rep(c("Firmicutes", "Bacteroidetes", "Actinobacteria", "Proteobacteria"), each = 4),
  genus = paste0("Genus_", seq_len(16)),
  abundance = round(runif(16, 6, 28), 1)
)

p <- ggplot(plot_data, aes(area = abundance, fill = phylum, subgroup = phylum, label = paste0(genus, "
", abundance, "%"))) +
  treemapify::geom_treemap(color = "white", linewidth = 0.8) +
  treemapify::geom_treemap_subgroup_border(color = "grey30", linewidth = 0.6) +
  treemapify::geom_treemap_text(place = "centre", reflow = TRUE, grow = FALSE, colour = "black", min.size = 7.5) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Treemap of Taxonomic Abundance", subtitle = "Area encodes relative abundance", fill = "Phylum") +
  theme_pub() +
  theme(axis.line = element_blank(), axis.ticks = element_blank(), axis.text = element_blank(), panel.grid = element_blank())

print(p)
save_pub(p, "treemap_publication", width = 180, height = 140, dpi = 600)
