# tools/build_readme_table.R
# 作用：
# 1) 生成 Code/ 下的 .R 脚本清单，写入 README.md 的 AUTO-INDEX 区间
# 2) 生成仓库“目录结构”（两层深度），写入 README.md 的 AUTO-TREE 区间
# 纯 base R；UTF-8 写入；无需第三方包。

readme <- "README.md"

# ---------- 通用工具 ----------
read_utf8 <- function(path) readLines(path, warn = FALSE, encoding = "UTF-8")
write_utf8 <- function(lines, path) {
  con <- file(path, open = "w", encoding = "UTF-8")
  writeLines(lines, con, sep = "\n", useBytes = TRUE)
  close(con)
}
replace_block <- function(lines, begin_tag, end_tag, new_block_lines, add_title = NULL) {
  b <- which(trimws(lines) == begin_tag)
  e <- which(trimws(lines) == end_tag)
  if (length(b) != 1L || length(e) != 1L || b >= e) {
    add <- c(
      if (!is.null(add_title)) add_title else NULL,
      begin_tag,
      new_block_lines,
      end_tag,
      ""
    )
    c(lines, "", add)
  } else {
    before <- if (b > 1) lines[1:b] else lines[b]     # 含 begin_tag
    after  <- if (e < length(lines)) lines[e:length(lines)] else lines[e]  # 含 end_tag
    c(before, new_block_lines, after)
  }
}
safe_read_lines <- function(f) {
  tryCatch(length(readLines(f, warn = FALSE)), error = function(e) 0L)
}
last_commit_time <- function(path) {
  cmd <- paste("git", "log", "-1", "--date=iso-local", "--format=%ad", "--", shQuote(path))
  out <- tryCatch(system(cmd, intern = TRUE), error = function(e) character(0))
  if (length(out) == 0) "" else out[1]
}

# ---------- 1) 脚本清单（AUTO-INDEX） ----------
index_dir   <- "Code"
index_begin <- "<!-- AUTO-INDEX:BEGIN -->"
index_end   <- "<!-- AUTO-INDEX:END -->"

if (dir.exists(index_dir)) {
  files_all <- list.files(index_dir, pattern = "\\.[Rr]$", recursive = TRUE, full.names = TRUE)
} else {
  files_all <- character(0)
}
mk_index_table <- function(files) {
  if (length(files) == 0) {
    return(c("- 目前未在 `Code/` 目录下发现任何 `.R` 脚本；提交脚本后，Actions 将自动更新本表。"))
  }
  lines <- vapply(files, safe_read_lines, integer(1))
  sizes <- file.info(files)$size
  lastc <- vapply(files, last_commit_time, character(1))
  header <- c(
    "| 脚本 | 相对路径 | 行数 | 大小KB | 最近提交时间 |",
    "|---|---|---:|---:|---|"
  )
  rows <- mapply(function(f, ln, sz, lc) {
    name <- basename(f); sizekb <- sprintf(\"%.1f\", as.numeric(sz)/1024)
    paste0(\"| \", name, \" | \", f, \" | \", ln, \" | \", sizekb, \" | \", lc, \" |\")
  }, files, lines, sizes, lastc, USE.NAMES = FALSE)
  c(header, rows)
}
index_block <- mk_index_table(files_all)

# ---------- 2) 目录结构（AUTO-TREE，展示到第二层） ----------
tree_begin <- "<!-- AUTO-TREE:BEGIN -->"
tree_end   <- "<!-- AUTO-TREE:END -->"

exclude_dirs <- c(".git", ".github", "README_files", "renv", "packrat", ".Rproj.user")
is_excluded <- function(name) any(name %in% exclude_dirs)

top <- list.files(".", all.files = FALSE, no.. = TRUE)
top <- top[!is_excluded(top)]
top_info <- file.info(top)
ord <- order(!top_info$isdir, tolower(rownames(top_info)))
top <- top[ord]
top_info <- top_info[ord, , drop = FALSE]

lines_tree <- c(".")
n1 <- length(top)
for (i in seq_len(n1)) {
  name1 <- top[i]
  isdir1 <- top_info$isdir[i]
  connector1 <- if (i == n1) "└─ " else "├─ "
  display1 <- if (isdir1) paste0(name1, "/") else name1
  lines_tree <- c(lines_tree, paste0(connector1, display1))

  if (isdir1) {
    sub <- list.files(file.path(".", name1), all.files = FALSE, no.. = TRUE, recursive = FALSE)
    sub <- sub[!is_excluded(sub)]
    if (length(sub)) {
      sub_info <- file.info(file.path(name1, sub))
      ord2 <- order(!sub_info$isdir, tolower(rownames(sub_info)))
      sub <- sub[ord2]
      sub_info <- sub_info[ord2, , drop = FALSE]
      n2 <- length(sub)
      for (j in seq_len(n2)) {
        name2 <- sub[j]
        isdir2 <- sub_info$isdir[j]
        branch <- if (i == n1) "   " else "│  "
        connector2 <- if (j == n2) "└─ " else "├─ "
        display2 <- if (isdir2) paste0(name2, "/") else name2
        lines_tree <- c(lines_tree, paste0(branch, connector2, display2))
      }
    }
  }
}
tree_block <- c("```text", lines_tree, "```")

# ---------- 写回 README ----------
if (!file.exists(readme)) {
  skeleton <- c(
    "# R-Plot-Code",
    "",
    "## 目录结构",
    "<!-- AUTO-TREE:BEGIN -->",
    "(生成中……)",
    "<!-- AUTO-TREE:END -->",
    "",
    "## 脚本清单（自动生成）",
    "<!-- AUTO-INDEX:BEGIN -->",
    "(生成中……)",
    "<!-- AUTO-INDEX:END -->",
    ""
  )
  write_utf8(skeleton, readme)
}

lines <- read_utf8(readme)
lines <- replace_block(lines, index_begin, index_end, index_block, add_title = "## 脚本清单（自动生成）")
lines <- replace_block(lines, tree_begin,  tree_end,  tree_block,  add_title = "## 目录结构")

write_utf8(lines, readme)
message("README.md 已按标记区间写入：脚本清单 & 目录结构。")
