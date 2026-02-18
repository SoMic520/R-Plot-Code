# 18. 树图（Treemap）
# Treemap（层级占比可视化）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(treemapify)
})

set.seed(123)
plot_data <- tibble::tibble(
  group = rep(c("细菌门A", "细菌门B", "细菌门C", "细菌门D"), each = 3),
  subgroup = paste0("亚类", 1:12),
  abundance = round(runif(12, 5, 30), 1)
)

p <- ggplot(plot_data, aes(area = abundance, fill = group, label = paste0(subgroup, "\n", abundance))) +
treemapify::geom_treemap(color = "white", linewidth = 1) +
  treemapify::geom_treemap_text(place = "centre", reflow = TRUE, grow = TRUE) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "Treemap（层级占比可视化）",
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
ggsave("treemap_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
