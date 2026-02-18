# 19. 桑基图（ggalluvial）
# 桑基图（流程转化）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(ggalluvial)
})

plot_data <- tibble::tribble(
  ~stage1, ~stage2, ~stage3, ~n,
  "A组", "访视1", "完成", 32,
  "A组", "访视1", "脱落", 8,
  "B组", "访视1", "完成", 26,
  "B组", "访视1", "脱落", 14,
  "C组", "访视1", "完成", 20,
  "C组", "访视1", "脱落", 10
)

p <- ggplot(plot_data,
            aes(axis1 = stage1, axis2 = stage2, axis3 = stage3, y = n)) +
ggalluvial::geom_alluvium(aes(fill = stage1), alpha = 0.75) +
  ggalluvial::geom_stratum(width = 0.28, fill = "grey90", color = "grey30") +
  ggalluvial::geom_text(stat = "stratum", aes(label = after_stat(stratum)), size = 3) +
  ggalluvial::scale_x_discrete(limits = c("基线分组", "中期访视", "结局"), expand = c(.08, .08)) +
  labs(
    title = "桑基图（流程转化）",
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
ggsave("alluvial_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
