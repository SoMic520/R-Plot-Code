# 06. 小提琴图+箱线图
# 小提琴图 + 箱线图（展示密度与中位数）
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
geom_violin(trim = FALSE, alpha = 0.65, color = "grey25") +
  geom_boxplot(width = 0.16, outlier.shape = NA, fill = "white", alpha = 0.9) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "小提琴图 + 箱线图（展示密度与中位数）",
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
ggsave("violin_box_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
