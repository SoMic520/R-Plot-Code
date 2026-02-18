# 05. 箱线图+抖动点
# 箱线图 + 抖动点（展示分布与离群值）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
plot_data <- tidyr::crossing(
  group = c("Control", "TreatmentA", "TreatmentB"),
  batch = c("Batch1", "Batch2"),
  rep = 1:45
) |>
  mutate(value = rnorm(n(), mean = c(5.6, 6.3, 7.2)[as.numeric(factor(group))], sd = 0.9))

p <- ggplot(plot_data, aes(group, value, fill = group)) +
geom_boxplot(width = 0.55, outlier.shape = NA, alpha = 0.7) +
  geom_jitter(width = 0.12, size = 1.8, alpha = 0.75) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "white") +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "箱线图 + 抖动点（展示分布与离群值）",
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
ggsave("box_jitter_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
