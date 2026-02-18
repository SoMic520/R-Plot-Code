# 11. 直方图+密度曲线
# 直方图 + 密度曲线（单变量分布）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
plot_data <- tibble::tibble(value = rnorm(450, mean = 6.2, sd = 1.1))

p <- ggplot(plot_data, aes(x = value)) +
geom_histogram(aes(y = after_stat(density)), bins = 24, alpha = 0.65, color = "white") +
  geom_density(linewidth = 1.1) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "直方图 + 密度曲线（单变量分布）",
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
ggsave("hist_density_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
