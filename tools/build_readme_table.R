# tools/build_readme_table.R
readme <- "README.md"

read_utf8 <- function(path) readLines(path, warn = FALSE, encoding = "UTF-8")
write_utf8 <- function(lines, path) {
  con <- file(path, open = "w", encoding = "UTF-8")
  writeLines(lines, con, sep = "\n", useBytes = TRUE)
  close(con)
}
replace_block <- function(lines, begin_tag, end_tag, new_block_lines) {
  b <- which(trimws(lines) == begin_tag)
  e <- which(trimws(lines) == end_tag)
  if (length(b) != 1L || length(e) != 1L || b >= e) {
    c(lines, "", begin_tag, new_block_lines, end_tag, "")
  } else {
    before <- if (b > 1) lines[1:b] else lines[b]
    after  <- if (e < length(lines)) lines[e:length(lines)] else lines[e]
    c(before, new_block_lines, after)
  }
}
safe_read_lines <- function(f) tryCatch(length(readLines(f, warn = FALSE)), error = function(e) 0L)
last_commit_time <- function(path) {
  out <- tryCatch(system(paste("git log -1 --date=iso-local --format=%ad --", shQuote(path)), intern = TRUE), error = function(e) "")
  if (length(out)) out[1] else ""
}

# Index table
index_dir <- "Code"
files <- if (dir.exists(index_dir)) list.files(index_dir, pattern = "\\.[Rr]$", recursive = TRUE, full.names = TRUE) else character(0)
if (length(files)) {
  lines <- vapply(files, safe_read_lines, integer(1))
  sizes <- file.info(files)$size
  lastc <- vapply(files, last_commit_time, character(1))
  header <- c("| 脚本 | 相对路径 | 行数 | 大小KB | 最近提交时间 |", "|---|---|---:|---:|---|")
  rows <- mapply(function(f, ln, sz, lc) sprintf("| %s | %s | %d | %.1f | %s |", basename(f), f, ln, as.numeric(sz)/1024, lc), files, lines, sizes, lastc, USE.NAMES = FALSE)
  index_block <- c(header, rows)
} else {
  index_block <- c("| 脚本 | 相对路径 | 行数 | 大小KB | 最近提交时间 |", "|---|---|---:|---:|---|", "| （占位）暂无脚本 | — | — | — | — |")
}

# Tree
exclude <- c(".git",".github","README_files","renv","packrat",".Rproj.user")
top <- list.files(".", all.files = FALSE, no.. = TRUE); top <- top[!(top %in% exclude)]
info <- file.info(top); ord <- order(!info$isdir, tolower(rownames(info))); top <- top[ord]; info <- info[ord,,drop=FALSE]
tree <- c(".")
for (i in seq_along(top)) {
  d1 <- top[i]; isdir <- info$isdir[i]; conn <- if (i==length(top)) "└─ " else "├─ "; show <- if (isdir) paste0(d1,"/") else d1
  tree <- c(tree, paste0(conn, show))
  if (isdir) {
    sub <- list.files(d1, all.files = FALSE, no.. = TRUE); sub <- sub[!(sub %in% exclude)]
    if (length(sub)) {
      si <- file.info(file.path(d1, sub)); ord2 <- order(!si$isdir, tolower(rownames(si))); sub <- sub[ord2]; si <- si[ord2,,drop=FALSE]
      for (j in seq_along(sub)) {
        b <- if (i==length(top)) "   " else "│  "; conn2 <- if (j==length(sub)) "└─ " else "├─ "; show2 <- if (si$isdir[j]) paste0(sub[j],"/") else sub[j]
        tree <- c(tree, paste0(b, conn2, show2))
      }
    }
  }
}
tree_block <- c("```text", tree, "```")

if (!file.exists(readme)) write_utf8(c("# R-Plot-Code","","## 目录结构","<!-- AUTO-TREE:BEGIN -->","(生成中……)","<!-- AUTO-TREE:END -->","","## 脚本清单（自动生成）","<!-- AUTO-INDEX:BEGIN -->","(生成中……)","<!-- AUTO-INDEX:END -->",""), readme)

lines <- read_utf8(readme)
lines <- replace_block(lines, "<!-- AUTO-INDEX:BEGIN -->", "<!-- AUTO-INDEX:END -->", index_block)
lines <- replace_block(lines, "<!-- AUTO-TREE:BEGIN -->",  "<!-- AUTO-TREE:END -->",  tree_block)
write_utf8(lines, readme)
