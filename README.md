# R-Plot-Code

#**专为高校与科研人员打造的科研绘图代码合集（R 语言）**

提供常见学术期刊风格图形的可复用脚本与模板，覆盖数据读取、整理到可视化的完整链路，支持一键复现与自定义主题。

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache--2.0-blue.svg)](LICENSE)
[![R](https://img.shields.io/badge/Lang-R-276DC3)](#)
[![CI](https://github.com/SoMic520/R-Plot-Code/actions/workflows/auto-readme.yml/badge.svg)](https://github.com/SoMic520/R-Plot-Code/actions/workflows/auto-readme.yml)

---

## 目录（Table of Contents）
- [项目简介](#项目简介)
- [目录结构](#目录结构)
- [快速开始-quick-start](#快速开始-quick-start)
- [脚本清单（自动生成）](#脚本清单自动生成)
- [通用参数与主题](#通用参数与主题)
- [数据格式建议](#数据格式建议)
- [复现实验-reproducibility](#复现实验-reproducibility)
- [常见问题-faq](#常见问题-faq)
- [贡献-contributing](#贡献-contributing)
- [许可证-license](#许可证-license)
- [致谢-acknowledgement](#致谢-acknowledgement)

---

## 项目简介
- 代码语言：**R（100%）**  
- 许可证：**Apache-2.0**（可商用、可修改与再发布，需保留版权与许可声明）  
- 适用场景：论文制图、课题汇报、项目可视化、学术海报等  
- 设计目标：**规范化**（统一主题）、**可复现**（固定依赖）、**可复用**（模块化函数）、**易扩展**（新图表可平滑接入）

---

## 目录结构

> 下方为“自动生成区间”。**已预置目录树**，即使 CI 未运行也能正常显示；CI 运行后会自动替换为最新目录树。

<!-- AUTO-TREE:BEGIN -->
```text
.
├─ Code/            # 绘图脚本与可复用函数（按图表类型或主题分组）
├─ Run Guide/       # 运行指引、示例数据与说明（如适用）
├─ tools/           # 自动生成 README 的脚本
├─ LICENSE          # Apache-2.0 许可证
└─ README.md        # 项目说明（本文件）
```
<!-- AUTO-TREE:END -->

---

## 快速开始 (Quick Start)

### 1) 环境准备
建议 R ≥ 4.2，并安装常用依赖（按需增减）：
```r
install.packages(c(
  "ggplot2","tidyverse","dplyr","readr","readxl",
  "data.table","ggpubr","patchwork","cowplot",
  "scales","stringr","forcats","here",
  "sf","rgeos","sp","rgdal","ggsci"
))
```
> 若 `Code/` 内有自定义函数（如 `utils_theme.R`, `utils_plot.R`），请在脚本开头 `source()` 引入，或封装为包统一管理。

### 2) 克隆仓库
```bash
git clone https://github.com/SoMic520/R-Plot-Code.git
cd R-Plot-Code
```

### 3) 运行脚本
以柱状图脚本为例（假设存在 `Code/01_barplot.R`）：
```r
# 在仓库根目录的 R 控制台执行
source("Code/01_barplot.R")
```
- 如脚本依赖示例数据，请将数据放在 `Run Guide/` 或脚本同级目录，并在脚本内配置相对路径  
- 推荐使用 `here::here()` 保持路径稳健

---

## 脚本清单（自动生成）

> 下方为“自动生成区间”。**已预置示例表格**，即使 CI 未运行也能正常显示；CI 运行后会自动替换为扫描 `Code/` 目录得到的最新清单。

<!-- AUTO-INDEX:BEGIN -->
| 脚本 | 相对路径 | 行数 | 大小KB | 最近提交时间 |
|---|---|---:|---:|---|
| （示例）柱状图 | Code/01_barplot.R | — | — | — |
| （示例）箱线图 | Code/02_boxplot.R | — | — | — |
| （示例）热图   | Code/03_heatmap.R | — | — | — |
<!-- AUTO-INDEX:END -->

---

## 通用参数与主题
- **主题（Theme）**：建议集中在 `utils_theme.R` 中维护期刊风格主题（字号、线宽、字体、图例等），通过 `theme_set()` 或自定义 `theme_pub()` 统一调用  
- **配色（Palette）**：优先 `ggsci`（期刊友好），或 `scale_*_manual()` 配合品牌色  
- **导出（Export）**：统一 `ggsave(filename, width, height, dpi, device="pdf/png")`；尺寸按期刊版式（常见：单栏 85 mm、双栏 170 mm）  
- **字体（Fonts）**：中文可配合系统字体与 `showtext`；导出 PDF 建议嵌入字体，避免投稿替换失败

---

## 数据格式建议
- 表头命名清晰、无空格；分类变量建议设为 `factor`  
- 数值变量保留合适小数位  
- 若脚本依赖特定列名（如 `group`, `treatment`, `value`），请在脚本注释或本 README 中明确

---

## 复现实验 (Reproducibility)
- 固定随机种子：`set.seed(123)`  
- 记录依赖：在关键脚本末尾 `sessionInfo()` 输出到日志  
- 提供最小可运行示例（MRE）与示例数据，置于 `Run Guide/` 并在脚本开头说明

---

## 常见问题 (FAQ)
**Q1：路径报错怎么办？**  
A：确认工作目录在仓库根目录，或使用 `here::here()` 生成稳健路径。

**Q2：字体缺失？**  
A：在系统安装并通过 `extrafont/showtext` 注册；导出 PDF 时尽量嵌入字体。

**Q3：包安装失败？**  
A：更换 CRAN 镜像，或使用 `pak::pak()` 处理二进制依赖。

**Q4：空间数据读取失败？**  
A：确认 GDAL/PROJ 等依赖正确安装（Windows 建议优先用 `sf` 的二进制包）。

---

## 贡献 (Contributing)
欢迎提交 PR / Issue 改进脚本、补充示例与中文注释：
1. Fork 本仓库并创建特性分支  
2. 附上最小可重现数据与渲染结果  
3. 遵循统一的代码风格与主题规范

---

## 许可证 (License)
本项目采用 **Apache-2.0** 许可证，详见 [LICENSE](LICENSE)。

---

## 致谢 (Acknowledgement)
感谢所有对科研图形规范化与复现性做出贡献的同学与老师。若你的工作基于本仓库代码，引用或在致谢中标注本仓库链接将帮助更多人受益。
