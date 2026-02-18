# 24. 极坐标玫瑰图
# 极坐标玫瑰图（周期性模式）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

plot_data <- tibble::tibble(
  month = factor(month.abb, levels = month.abb),
  value = c(12, 14, 16, 22, 30, 40, 48, 45, 34, 26, 18, 13)
)

p <- ggplot(plot_data, aes(x = month, y = value, fill = month)) +
geom_col(width = 1, color = "white", alpha = 0.9) +
  coord_polar(start = 0) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "极坐标玫瑰图（周期性模式）",
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
ggsave("rose_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
