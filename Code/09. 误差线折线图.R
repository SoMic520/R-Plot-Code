# 09. 误差线折线图
# 均值折线图 + 标准误误差线
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
raw_data <- tidyr::crossing(
  treatment = c("Control", "DrugA", "DrugB"),
  day = seq(0, 21, by = 3),
  rep = 1:18
) |>
  mutate(value = 20 + as.numeric(factor(treatment)) * 2 + day * 0.45 + rnorm(n(), 0, 1.8))

plot_data <- raw_data |>
  group_by(treatment, day) |>
  summarise(
    mean_value = mean(value),
    se_value = sd(value) / sqrt(n()),
    .groups = "drop"
  )

p <- ggplot(plot_data, aes(day, mean_value, color = treatment)) +
geom_line(linewidth = 1) +
  geom_point(size = 2.4) +
  geom_errorbar(aes(ymin = mean_value-se_value, ymax = mean_value+se_value), width = 0.18) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "均值折线图 + 标准误误差线",
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
ggsave("line_errorbar_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
