# tools/build_readme_table.R
# 精修版：自动扫描 Code/ 下 .R 脚本，抽取元信息，生成 README.md 中的脚本清单表格
# Author: you
# Encoding: UTF-8

suppressWarnings({
  suppressPackageStartupMessages({
    requireNamespace("stringr", quietly = TRUE)
    requireNamespace("glue", quietly = TRUE)
  })
})

library(stringr)
library(glue)

# -----------------------------
# 可配置参数（支持从环境变量覆盖）
# -----------------------------
CFG <- list(
  readme_path     = Sys.getenv("READMETARGET", "README.md"),
  scan_dir        = Sys.getenv("SCANDIR", "Code"),
  # 允许多个起止标记，便于兼容历史文档；逐一尝试
  start_markers   = strsplit(Sys.getenv("STARTMARKERS",
                                        "<!-- SCRIPTS_TABLE_START -->|<!--SCRIPTS_TABLE_START-->"),
                             "\\|")[[1]],
  end_markers     = strsplit(Sys.getenv("ENDMARKERS",
                                        "<!-- SCRIPTS_TABLE_END -->|<!--SCRIPTS_TABLE_END-->"),
                             "\\|")[[1]],
  # 当找不到标记时，自动插入到该章节标题下；若也找不到，则插入到文末
  section_title_regex = Sys.getenv("SECTION_TITLE_REGEX",
                                   "^##\\s*脚本清单（自动生成）|^##\\s*脚本清单|^##\\s*Scripts?\\s*List"),
  # 解析注释的最大行数
  header_nlines   = as.integer(Sys.getenv("HEADER_NLINES", "120")),
  # 干跑模式（只打印，不写回）
  dry_run         = identical(tolower(Sys.getenv("DRYRUN", "false")), "true")
)

# 确保以 UTF-8 读写
read_utf8  <- function(path, ...) readLines(path, encoding = "UTF-8", warn = FALSE, ...)
write_utf8 <- function(lines, path) writeLines(enc2utf8(lines), path, useBytes = TRUE)

# 统一的文件存在性检查
stop_if_missing <- function(path) {
  if (!file.exists(path)) stop(glue("找不到文件：{path}"))
}

# -----------------------------
# 扫描脚本文件
# -----------------------------
list_r_files <- function(root) {
  if (!dir.exists(root)) return(character(0))
  files <- list.files(root, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
  files <- files[order(tolower(files))]
  unname(files)
}

# -----------------------------
# 解析脚本元信息（Title/Input/Output/Note）
# 支持中英文 key 与 roxygen 风格
# -----------------------------
parse_meta <- function(path, n = CFG$header_nlines) {
  lines <- read_utf8(path)
  if (length(lines) == 0) lines <- character(0)
  header <- utils::head(lines, n)

  # 支持的 key（中英文 / roxygen）
  key_map <- list(
    title  = c("title", "标题", "功能", "function"),
    input  = c("input", "输入"),
    output = c("output", "输出"),
    note   = c("note", "备注")
  )

  # 构造正则：支持 "# key: xxx"、"#' key: xxx"、可有空格、大小写不敏感
  grab <- function(keys) {
    # 组装 keys 的 OR
    keys_pat <- paste(keys, collapse = "|")
    # 匹配示例：
    #  # Title: xxx
    #  #' Input: yyy
    #  # 标题：zzz
    #  前缀允许 # 或 #' ，冒号 : 或 ：（中文冒号）
    pat <- glue("^\\s*#+'?\\s*({keys_pat})\\s*[:：]\\s*(.+)\\s*$")
    m   <- str_match(header, regex(pat, ignore_case = TRUE))
    # m[,3] 是取到的值
    val <- m[, 3]
    val <- val[!is.na(val)]
    if (length(val) == 0) "" else str_trim(val[1])
  }

  data.frame(
    script = str_replace(path, "^\\./?", ""),
    title  = grab(key_map$title),
    input  = grab(key_map$input),
    output = grab(key_map$output),
    note   = grab(key_map$note),
    stringsAsFactors = FALSE
  )
}

# -----------------------------
# 生成 Markdown 表格
# -----------------------------
render_table <- function(df) {
  if (nrow(df) == 0) {
    df <- data.frame(
      script = "(未检测到 .R 文件)",
      title = "", input = "", output = "", note = "",
      stringsAsFactors = FALSE
    )
  }
  header <- c(
    "| 脚本 | 功能简介 | 主要输入 | 主要输出 | 备注 |",
    "|---|---|---|---|---|"
  )
  rows <- apply(df, 1, function(r) {
    glue("| `{r[['script']]}` | {r[['title']]} | {r[['input']]} | {r[['output']]} | {r[['note']]} |")
  })
  c(header, rows)
}

# -----------------------------
# 在 README 中替换或插入表格
# -----------------------------
patch_readme <- function(readme_lines, table_lines) {
  # 1) 尝试标记替换
  for (sm in CFG$start_markers) {
    for (em in CFG$end_markers) {
      start_idx <- which(str_detect(readme_lines, fixed(sm)))
      end_idx   <- which(str_detect(readme_lines, fixed(em)))
      if (length(start_idx) == 1 && length(end_idx) == 1 && end_idx > start_idx) {
        message(glue("找到标记：{sm} ... {em}，将替换其间内容"))
        return(c(
          readme_lines[1:start_idx],
          table_lines,
          readme_lines[end_idx:length(readme_lines)]
        ))
      }
    }
  }

  # 2) 若没找到标记，尝试插入到“脚本清单”章节标题后
  sec_idx <- which(str_detect(readme_lines, regex(CFG$section_title_regex)))
  if (length(sec_idx) >= 1) {
    insert_at <- sec_idx[1] + 1
    message("未找到标记，但发现“脚本清单”章节标题，将在其后插入表格")
    return(append(readme_lines, values = c("", table_lines, ""), after = insert_at))
  }

  # 3) 若连章节标题也没有，则附加到文末
  message("未找到标记与章节标题，将表格附加到 README 文末")
  c(readme_lines, "", "## 脚本清单（自动生成）", "", table_lines, "")
}

# -----------------------------
# 主流程
# -----------------------------
main <- function() {
  # 1) 扫描文件
  files <- list_r_files(CFG$scan_dir)

  # 2) 解析元信息
  metas <- do.call(rbind, lapply(files, parse_meta))
  # 规范化路径分隔符（展示更友好）
  if (nrow(metas)) {
    metas$script <- gsub("\\\\"， "/", metas$script)
  }

  # 3) 生成表格
  md_table <- render_table(metas)

  # 读 README
  stop_if_missing(CFG$readme_path)
  readme <- read_utf8(CFG$readme_path)

  # 4) 打补丁
  new_readme <- patch_readme(readme, md_table)

  # 5) 写回或干跑
  if (CFG$dry_run) {
    message("DRYRUN=true：不写回文件，打印新内容预览 ↓↓↓")
    cat(paste(new_readme, collapse = "\n"))
  } else {
    write_utf8(new_readme, CFG$readme_path)
    message(glue("已更新 {CFG$readme_path} 的脚本清单表格 ✅"))
  }
}

# 执行
tryCatch(
  main(),
  error = function(e) {
    message("构建失败：", conditionMessage(e))
    quit(status = 1)
  }
)
