# 13. 双变量散点回归图
# 散点图 + 线性回归拟合
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
plot_data <- tibble::tibble(
  x = rnorm(280, 0, 1.2),
  y = 0.7 * x + rnorm(280, 0, 1)
)

p <- ggplot(plot_data, aes(x, y)) +
geom_point(size = 2.2, alpha = 0.75) +
  geom_smooth(method = "lm", se = TRUE, linewidth = 1) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "散点图 + 线性回归拟合",
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
ggsave("scatter_regression_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
