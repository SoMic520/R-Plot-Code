# 20. 环形图
# 环形图（分类占比）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

plot_data <- tibble::tribble(
  ~category, ~value,
  "Firmicutes", 38,
  "Bacteroidetes", 29,
  "Actinobacteria", 12,
  "Proteobacteria", 14,
  "Others", 7
) |>
  arrange(desc(value)) |>
  mutate(label = paste0(category, " (", value, "%)"))

p <- ggplot(plot_data, aes(x = 1, y = value, fill = category)) +
geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  xlim(0.5, 2) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "环形图（分类占比）",
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
ggsave("donut_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
