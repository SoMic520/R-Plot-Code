# 21. 棒棒糖图
# 棒棒糖图（排序比较）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
plot_data <- tibble::tibble(
  item = paste0("菌属", LETTERS[1:15]),
  value = round(runif(15, 5, 40), 1)
) |>
  arrange(value)

p <- ggplot(plot_data, aes(x = reorder(item, value), y = value, color = value)) +
geom_segment(aes(xend = reorder(item, value), y = 0, yend = value), linewidth = 1) +
  geom_point(size = 3) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "棒棒糖图（排序比较）",
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
ggsave("lollipop_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
