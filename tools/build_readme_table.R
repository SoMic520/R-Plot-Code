suppressWarnings({
  suppressPackageStartupMessages({
    requireNamespace("stringr", quietly = TRUE)
    requireNamespace("glue", quietly = TRUE)
  })
})
library(stringr)
library(glue)

CFG <- list(
  readme_path     = "README.md"，
  scan_dir        = "Code"，
  start_markers   = c("<!-- SCRIPTS_TABLE_START -->","<!--SCRIPTS_TABLE_START-->"),
  end_markers     = c("<!-- SCRIPTS_TABLE_END -->"，"<!--SCRIPTS_TABLE_END-->"),
  section_title_regex = "^##\\s*脚本清单（自动生成）|^##\\s*脚本清单|^##\\s*Scripts?\\s*List"，
  header_nlines   = 120,
  dry_run         = FALSE
)

read_utf8  <- function(path, ...) readLines(path, encoding = "UTF-8", warn = FALSE, ...)
write_utf8 <- function(lines, path) writeLines(enc2utf8(lines), path, useBytes = TRUE)

list_r_files <- function(root) {
  if (!dir.exists(root)) return(character(0))
  f <- list.files(root, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
  f[order(tolower(f))]
}

parse_meta <- function(path, n = CFG$header_nlines) {
  lines <- read_utf8(path); header <- utils::head(lines, n)
  key_map <- list(
    title  = c("title","标题","功能","function"),
    input  = c("input","输入"),
    output = c("output","输出"),
    note   = c("note"，"备注")
  )
  grab <- function(keys) {
    pat <- glue("^\\s*#+'?\\s*({paste(keys, collapse='|')})\\s*[:：]\\s*(.+)\\s*$")
    m <- stringr::str_match(header, regex(pat, ignore_case = TRUE))
    v <- m[,3]; v <- v[!is.na(v)]
    if (length(v) == 0) "" else str_trim(v[1])
  }
  data.frame(
    script = gsub("^\\./?", "", path),
    title  = grab(key_map$title),
    input  = grab(key_map$input),
    output = grab(key_map$output),
    note   = grab(key_map$note),
    stringsAsFactors = FALSE
  )
}

render_table <- function(df) {
  if (!nrow(df)) df <- data.frame(script="(未检测到 .R 文件)", title="", input="", output="", note="")
  header <- c("| 脚本 | 功能简介 | 主要输入 | 主要输出 | 备注 |","|---|---|---|---|---|")
  rows <- apply(df, 1, function(r) glue("| `{r[['script']]}` | {r[['title']]} | {r[['input']]} | {r[['output']]} | {r[['note']]} |"))
  c(header, rows)
}

patch_readme <- function(readme_lines, table_lines) {
  for (sm in CFG$start_markers) for (em in CFG$end_markers) {
    s <- which(str_detect(readme_lines, fixed(sm)))
    e <- which(str_detect(readme_lines, fixed(em)))
    if (length(s)==1 && length(e)==1 && e>s) {
      return(c(readme_lines[1:s], table_lines, readme_lines[e:length(readme_lines)]))
    }
  }
  sec <- which(str_detect(readme_lines, regex(CFG$section_title_regex)))
  if (length(sec)>=1) return(append(readme_lines, values=c("", table_lines, ""), after=sec[1]))
  c(readme_lines, "", "## 脚本清单（自动生成）", "", table_lines, "")
}

main <- function() {
  files <- list_r_files(CFG$scan_dir)
  metas <- if (length(files)) do.call(rbind, lapply(files, parse_meta)) else data.frame()
  if (nrow(metas)) metas$script <- gsub("\\\\", "/", metas$script)
  md_table <- render_table(metas)

  readme <- if (file.exists(CFG$readme_path)) read_utf8(CFG$readme_path) else c("# R-Plot-Code","","## 脚本清单（自动生成）","<!-- SCRIPTS_TABLE_START -->","<!-- SCRIPTS_TABLE_END -->")
  new_readme <- patch_readme(readme, md_table)

  write_utf8(new_readme, CFG$readme_path)
  message(glue("已更新 {CFG$readme_path} 的脚本清单表格 ✅"))
}
tryCatch(main(), error=function(e){ message("构建失败：", conditionMessage(e)); quit(status=1) })
