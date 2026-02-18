# 12. QQ图
# QQ 图（正态性检查）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
})

set.seed(123)
plot_data <- data.frame(value = rnorm(160, mean = 0, sd = 1))

p <- ggplot(plot_data, aes(sample = value)) +
stat_qq(size = 1.4, alpha = 0.7) +
  stat_qq_line(linewidth = 1, color = "#D55E00") +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "QQ 图（正态性检查）",
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
ggsave("qq_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
