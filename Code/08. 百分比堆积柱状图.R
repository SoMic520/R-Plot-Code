# 08. 百分比堆积柱状图
# 百分比堆积柱状图（组成比例变化）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
plot_data <- tidyr::crossing(
  treatment = c("Control", "DrugA", "DrugB"),
  timepoint = c("Week 0", "Week 4", "Week 8"),
  subtype = c("Type I", "Type II", "Type III")
) |>
  mutate(value = round(runif(n(), 15, 90), 1))

p <- ggplot(plot_data, aes(treatment, value, fill = subtype)) +
geom_col(position = "fill", width = 0.65, color = "grey15") +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "百分比堆积柱状图（组成比例变化）",
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
ggsave("stacked_percent_bar_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
