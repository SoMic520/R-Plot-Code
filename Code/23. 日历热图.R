# 23. 日历热图
# 日历热图（每日值）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(lubridate)
})

set.seed(123)
plot_data <- tibble::tibble(
  date = seq.Date(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "day"),
  value = rpois(366, lambda = 18)
) |>
  mutate(
    month_label = format(date, "%Y-%m"),
    week = lubridate::isoweek(date),
    weekday = factor(weekdays(date),
                     levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
  )

p <- ggplot(plot_data, aes(x = week, y = weekday, fill = value)) +
geom_tile(color = "white") +
  facet_wrap(~ month_label, ncol = 3) +
  scale_fill_brewer(palette = "Set2") +
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "日历热图（每日值）",
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
ggsave("calendar_heatmap.png", p, width = 7.2, height = 5.2, dpi = 320)
