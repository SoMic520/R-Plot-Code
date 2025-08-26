# tools/build_readme_table.R
dir.create("tools", showWarnings = FALSE)

library(stringr)
library(glue)

code_dir <- "Code"
files <- list.files(code_dir, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)

parse_meta <- function(path) {
  # 仅读取前 60 行，提取形如 # Title:, # Function:, # Input:, # Output:, # Note:
  lines <- readLines(path, n = 60L, warn = FALSE)
  get_field <- function(key) {
    m <- str_match(lines, glue("^\\s*#\\s*{key}\\s*:\\s*(.+)$"))
    m <- m[!is.na(m[,2]), 2]
    if (length(m) == 0) "" else str_trim(m[1])
  }
  rel <- str_replace(path, "^\\./?", "")
  data.frame(
    script = rel,
    title  = get_field("Title|标题|功能"),
    input  = get_field("Input|输入"),
    output = get_field("Output|输出"),
    note   = get_field("Note|备注"),
    stringsAsFactors = FALSE
  )
}

tbl <- do.call(rbind, lapply(files, parse_meta))
if (nrow(tbl) == 0) {
  tbl <- data.frame(
    script = "(暂未检测到 .R 文件)",
    title = "", input = "", output = "", note = ""
  )
}

# 生成 markdown 表格
md_rows <- apply(tbl, 1, function(r) {
  glue("| `{r[['script']]}` | {r[['title']]} | {r[['input']]} | {r[['output']]} | {r[['note']]} |")
})
md_table <- c(
  "| 脚本 | 功能简介 | 主要输入 | 主要输出 | 备注 |",
  "|---|---|---|---|---|",
  md_rows
)

# 将表格写入 README：定位“脚本清单（自动生成）”一节下的占位标记
readme <- readLines("README.md", warn = FALSE)
start_tag <- which(str_detect(readme, "^<!-- SCRIPTS_TABLE_START -->$"))
end_tag   <- which(str_detect(readme, "^<!-- SCRIPTS_TABLE_END -->$"))

if (length(start_tag) == 1 && length(end_tag) == 1 && end_tag > start_tag) {
  new_readme <- c(
    readme[1:start_tag],
    md_table,
    readme[end_tag:length(readme)]
  )
  writeLines(new_readme, "README.md", useBytes = TRUE)
  message("已更新 README.md 的脚本清单表格 ✅")
} else {
  cat(paste(md_table, collapse = "\n"))
  message("\n未找到标记，已在控制台输出表格，请手动粘贴至 README.md 对应位置。")
}
