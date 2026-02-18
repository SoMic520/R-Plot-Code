# 15. 火山图
# 火山图（差异分析）
# 说明：本脚本使用模拟数据，运行后会在当前目录导出图片文件。

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

set.seed(123)
plot_data <- tibble::tibble(
  gene = paste0("Gene", 1:350),
  log2FC = rnorm(350, 0, 1.4),
  pvalue = runif(350, 0.0005, 0.2)
) |>
  mutate(category = case_when(
    log2FC >= 1 & pvalue < 0.05 ~ "Up",
    log2FC <= -1 & pvalue < 0.05 ~ "Down",
    TRUE ~ "NS"
  ))

p <- ggplot(plot_data, aes(x = log2FC, y = -log10(pvalue))) +
geom_point(aes(color = category), size = 2, alpha = 0.8) +
  geom_vline(xintercept = c(-1,1), linetype = 2) +
  geom_hline(yintercept = -log10(0.05), linetype = 2) +
  scale_color_manual(values = c("Up" = "#D55E00", "Down" = "#0072B2", "NS" = "grey70")) +
  labs(
    title = "火山图（差异分析）",
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
ggsave("volcano_plot.png", p, width = 7.2, height = 5.2, dpi = 320)
