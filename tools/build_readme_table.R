# tools/build_readme_table.R
# 作用：扫描仓库中的 .R 脚本，汇总成表，写到 README.md（覆盖写入）

# 尽量使用基础函数，只有 knitr 用于把数据框转成 Markdown 表格
if (!requireNamespace("knitr", quietly = TRUE)) {
  install.packages("knitr", repos = "https://cloud.r-project.org")
}

# 1) 收集 .R 文件（排除 .git、.github、自身脚本等）
all_files <- list.files(
  path = ".",
  pattern = "\\.[Rr]$",
  recursive = TRUE,
  full.names = TRUE
)
exclude <- grepl("^\\./\\.git", all_files) |
           grepl("^\\./\\.github", all_files) |
           grepl("^\\./renv", all_files) |
           grepl("^\\./README\\.R$", all_files) |
           grepl("^\\./tools/build_readme_table\\.R$", all_files)
r_files <- all_files[!exclude]

# 2) 统计行数、体积、最后一次 git 提交时间（失败则用 NA）
get_last_commit <- function(path) {
  cmd <- paste("git", "log", "-1", "--date=iso-local", "--format=%ad", "--", shQuote(path))
  out <- tryCatch(system(cmd, intern = TRUE), error = function(e) NA_character_)
  if (length(out) == 0) NA_character_ else out[1]
}

info <- if (length(r_files) == 0) {
  data.frame(
    File = character(0), Lines = integer(0),
    SizeKB = numeric(0), LastCommit = character(0),
    stringsAsFactors = FALSE
  )
} else {
  lines <- vapply(r_files, function(f) length(readLines(f, warn = FALSE)), integer(1))
  sizes <- file.info(r_files)$size
  lastc <- vapply(r_files, get_last_commit, character(1))
  data.frame(
    File = r_files,
    Lines = lines,
    SizeKB = round(sizes / 1024, 1),
    LastCommit = lastc,
    stringsAsFactors = FALSE
  )
}

# 3) 生成 Markdown 表格
tbl_md <- if (nrow(info) == 0) {
  "- 目前未找到任何 .R 文件。请将 R 脚本推送到仓库后，工作流会自动更新本 README。"
} else {
  # 为了显示更友好，增加文件名列
  info$Name <- basename(info$File)
  info <- info[, c("Name", "File", "Lines", "SizeKB", "LastCommit")]
  knitr::kable(info, format = "markdown", align = "lrrrr")
}

# 4) 写出 README.md（覆盖写入，UTF-8）
header <- c(
  "# R-Plot-Code 自动生成的 README",
  "",
  paste0("> 最近构建时间：", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
  "",
  "## 仓库 R 脚本索引",
  "",
  "下表由 GitHub Actions 调用 `tools/build_readme_table.R` 自动生成：",
  ""
)
lines <- c(header, tbl_md)

con <- file("README.md", open = "w", encoding = "UTF-8")
writeLines(lines, con, sep = "\n", useBytes = TRUE)
close(con)

message("README.md 已生成/更新。")
