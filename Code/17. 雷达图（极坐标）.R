# 17. 雷达图（极坐标）
# 雷达图（多指标对比）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

plot_data <- tibble::tribble(
  ~metric, ~group, ~value,
  "脂质代谢", "对照组", 0.62,
  "炎症指标", "对照组", 0.48,
  "肠道屏障", "对照组", 0.55,
  "氧化应激", "对照组", 0.44,
  "免疫应答", "对照组", 0.58,
  "脂质代谢", "处理组", 0.78,
  "炎症指标", "处理组", 0.72,
  "肠道屏障", "处理组", 0.70,
  "氧化应激", "处理组", 0.66,
  "免疫应答", "处理组", 0.74
)

p <- ggplot(plot_data, aes(metric, value, group = group, color = group, fill = group)) +
geom_polygon(alpha = 0.2, linewidth = 1) +
  geom_point(size = 2) +
  coord_polar() +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "雷达图（多指标对比）",
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
ggsave("radar_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
