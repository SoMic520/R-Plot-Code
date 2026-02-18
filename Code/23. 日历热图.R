# 23. 日历热图
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
plot_data <- tibble::tibble(
  date = seq.Date(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "day"),
  value = rpois(366, lambda = 18)
) |>
  dplyr::mutate(
    month = format(date, "%Y-%m"),
    week = as.integer(format(date, "%U")) + 1,
    weekday = factor(weekdays(date), levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
  )

p <- ggplot(plot_data, aes(week, weekday, fill = value)) +
  geom_tile(color = "white", linewidth = 0.2) +
  facet_wrap(~ month, ncol = 4) +
  scale_fill_viridis_c(option = "C") +
  labs(title = "Calendar Heatmap", subtitle = "Daily counts through one year", x = "Week of year", y = NULL, fill = "Count") +
  theme_pub(base_size = 10.5) +
  theme(legend.position = "right", strip.text = element_text(size = 8.5))

print(p)
save_pub(p, "calendar_publication", width = 180, height = 140, dpi = 600)
