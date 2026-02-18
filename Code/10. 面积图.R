# 10. 面积图
# 面积图（连续时间趋势）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
plot_data <- tidyr::crossing(
  time = seq(1, 30, by = 1),
  group = c("Control", "Treatment")
) |>
  mutate(value = ifelse(group == "Control", 25 + sin(time/3) * 3, 28 + cos(time/4) * 4) + rnorm(n(), 0, 1.2))

p <- ggplot(plot_data, aes(time, value, fill = group, color = group)) +
geom_area(alpha = 0.55, position = "identity") +
  geom_line(linewidth = 0.8) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "面积图（连续时间趋势）",
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
ggsave("area_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
