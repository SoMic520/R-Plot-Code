# 10. 面积图
# 出版级版本：统一主题、颜色体系与导出规格（PDF/TIFF/PNG）。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(scales)
  library(RColorBrewer)
  library(ggpubr)
  library(viridis)
})

if (file.exists("Code/00. 出版级绘图主题与导出函数.R")) {
  source("Code/00. 出版级绘图主题与导出函数.R")
} else {
  stop("请先确保存在 Code/00. 出版级绘图主题与导出函数.R")
}

set.seed(2025)
plot_data <- tidyr::crossing(
  day = 1:45,
  group = factor(c("Control", "Intervention"), levels = c("Control", "Intervention"))
) |>
  dplyr::mutate(value = ifelse(group == "Control", 30 + sin(day / 4) * 4, 34 + cos(day / 5) * 5) + rnorm(dplyr::n(), 0, 1.0))

p <- ggplot(plot_data, aes(day, value, fill = group, color = group)) +
  geom_area(alpha = 0.28, position = "identity") +
  geom_line(linewidth = 0.82) +
  scale_fill_pub() +
  scale_color_pub() +
  labs(title = "Area Plot for Temporal Profiles", subtitle = "Two-group trajectories over time", x = "Day", y = "Value") +
  theme_pub()

print(p)
save_pub(p, "area_publication", width = 180, height = 140, dpi = 600)
