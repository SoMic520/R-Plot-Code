# 00. 出版级绘图主题与导出函数
# 用法：source("Code/00. 出版级绘图主题与导出函数.R")

suppressPackageStartupMessages({
  library(ggplot2)
  library(scales)
  library(RColorBrewer)
})

theme_pub <- function(base_size = 12, base_family = "sans") {
  theme_classic(base_size = base_size, base_family = base_family) +
    theme(
      plot.title = element_text(face = "bold", size = base_size + 1.5, hjust = 0.5),
      plot.subtitle = element_text(size = base_size, color = "grey25", hjust = 0.5),
      axis.title = element_text(face = "bold", size = base_size),
      axis.text = element_text(color = "black", size = base_size - 1),
      axis.line = element_line(linewidth = 0.6, color = "black"),
      axis.ticks = element_line(linewidth = 0.5, color = "black"),
      legend.position = "top",
      legend.title = element_text(face = "bold", size = base_size - 0.5),
      legend.text = element_text(size = base_size - 1),
      legend.key.height = unit(0.35, "cm"),
      legend.key.width = unit(0.6, "cm"),
      panel.grid.major = element_line(color = "grey92", linewidth = 0.3),
      panel.grid.minor = element_blank(),
      strip.background = element_rect(fill = "grey95", color = "grey85"),
      strip.text = element_text(face = "bold", size = base_size - 0.5),
      plot.margin = margin(6, 10, 6, 6)
    )
}

scale_color_pub <- function() {
  scale_color_brewer(palette = "Dark2")
}

scale_fill_pub <- function() {
  scale_fill_brewer(palette = "Set2")
}

save_pub <- function(plot, filename_prefix, width = 180, height = 140, dpi = 600) {
  width_in <- width / 25.4
  height_in <- height / 25.4
  ggsave(paste0(filename_prefix, ".pdf"), plot = plot, width = width_in, height = height_in, device = cairo_pdf)
  ggsave(paste0(filename_prefix, ".tiff"), plot = plot, width = width_in, height = height_in, dpi = dpi, compression = "lzw")
  ggsave(paste0(filename_prefix, ".png"), plot = plot, width = width_in, height = height_in, dpi = 320)
}
