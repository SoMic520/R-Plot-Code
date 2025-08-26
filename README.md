# R-Plot-Code

**专为高校与科研人员打造的科研绘图代码合集（R 语言）**  
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

> 下方为自动生成区间，请勿手动编辑。

<!-- AUTO-TREE:BEGIN -->
（此处将由 Actions 自动生成目录树）
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
