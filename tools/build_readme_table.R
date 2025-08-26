# tools/build_readme_table.R
# 纯 base R：扫描仓库 .R 文件，输出 Markdown 表到 README.md（覆盖写入）

# 1) 收集 .R 文件（排除 .git/.github/自身脚本/renv 等）
all_files <- list.files(
  path = ".",
  pattern = "\\.[Rr]$",
  recursive = TRUE,
  full.names = TRUE
)
exclude <- grepl("^\\./\\.git", all_files) |
           grepl("^\\./\\.github", all_files) |
           grepl("^\\./renv", all_files) |
           grepl("^\\./packrat", all_files) |
           grepl("^\\./README\\.R$", all_files) |
           grepl("^\\./tools/build_readme_table\\.R$", all_files)
r_files <- all_files[!exclude]

# 2) 收集基本信息
get_last_commit <- function(path) {
  cmd <- paste("git", "log", "-1", "--date=iso-local", "--format=%ad", "--", shQuote(path))
  out <- tryCatch(system(cmd, intern = TRUE), error = function(e) NA_character_)
  if (length(out) == 0) NA_character_ else out[1]
}

if (length(r_files) == 0) {
  rows <- character(0)
} else {
  # 逐行读取统计行数；可能有编码问题，出错则当 0 行
  count_lines <- function(f) {
    n <- tryCatch(length(readLines(f, warn = FALSE)), error = function(e) 0L)
    n
  }
  lines <- vapply(r_files, count_lines, integer(1))
  sizes <- file.info(r_files)$size
  lastc <- vapply(r_files, get_last_commit, character(1))

  # Markdown 表格头
  header <- c(
    "| Name | File | Lines | SizeKB | LastCommit |",
    "|---|---|---:|---:|---|"
  )
  rows <- mapply(function(f, ln, sz, lc) {
    name <- basename(f)
    sizekb <- sprintf("%.1f", as.numeric(sz) / 1024)
    paste0("| ", name, " | ", f, " | ", ln, " | ", sizekb, " | ", ifelse(is.na(lc), "", lc), " |")
  }, r_files, lines, sizes, lastc, USE.NAMES = FALSE)
}

# 3) 写出 README.md（覆盖；UTF-8）
header <- c(
  "# R-Plot-Code 自动生成的 README",
  "",
  paste0("> 最近构建时间：", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
  "",
  "## 仓库 R 脚本索引",
  "",
  if (length(rows) == 0) "- 目前未找到任何 .R 文件；请提交代码后，工作流会自动更新此 README。" else ""
)

con <- file("README.md", open = "w", encoding = "UTF-8")
writeLines(header, con, sep = "\n", useBytes = TRUE)
if (length(rows) > 0) {
  writeLines(c("| Name | File | Lines | SizeKB | LastCommit |",
               "|---|---|---:|---:|---|"), con, sep = "\n", useBytes = TRUE)
  writeLines(rows, con, sep = "\n", useBytes = TRUE)
}
close(con)

message("README.md 已生成/更新。")
