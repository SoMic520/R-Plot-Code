# 22. Cleveland点图
# Cleveland 点图（双组比较）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
plot_data <- tibble::tibble(
  item = paste0("指标", sprintf("%02d", 1:12)),
  group_a = round(rnorm(12, 55, 8), 1),
  group_b = round(rnorm(12, 62, 9), 1)
) |>
  mutate(min_value = pmin(group_a, group_b),
         max_value = pmax(group_a, group_b)) |>
  arrange(group_b - group_a)

p <- ggplot(plot_data, aes(y = reorder(item, max_value))) +
geom_segment(aes(x = min_value, xend = max_value, y = item, yend = item), color = "grey70", linewidth = 1.1) +
  geom_point(aes(x = group_a, color = "Group A"), size = 2.8) +
  geom_point(aes(x = group_b, color = "Group B"), size = 2.8) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "Cleveland 点图（双组比较）",
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
ggsave("cleveland_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
