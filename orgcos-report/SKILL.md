---
name: sloth-orgcos-report-eido
description: "OrgCOS report generation tool creating single-file HTML visualization reports from OrgCOS data. Supports 5 report types (Panorama overview, Domain Deep-dive, Quality Audit, Org Portrait, Governance Dashboard) following brand standards (#074973/#0A6B8C/#04314f/#35a7d6) with sidebar navigation and fluid content layout. Use when the user mentions OrgCOS report, panorama, quality report, org portrait report, or governance dashboard."
version: 1.0.0
description_zh: "OrgCOS 报告生成工具——从 OrgCOS 数据生成单文件 HTML 可视化报告，含 5 种报告类型和品牌标准。"
name_zh: "树懒 · 组织认知 · 报告"
---

# OrgCOS 报告生成工具

> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

将 OrgCOS 的结构化数据（JSON）转化为美观、可读的单文件 HTML 报告——让管理层、领域专家、治理委员会能快速理解 OrgCOS 的状态和价值。

**设计原则：**
- 单文件 HTML，无外部依赖，可离线打开和分享
- 侧边栏导航 + 内容区布局，方便长报告阅读
- 遵循品牌标准（色彩、字体、Logo）

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
    note: 引用品牌标准（色彩/字体/Logo）和数据 Schema
```

## 触发词

OrgCOS 报告、全景概览、层级深潜报告、质量审计报告、组织画像、治理仪表盘、生成报告、HTML 报告

## 5 种报告类型

### 1. 全景概览（Panorama）

**受众：** 管理层
**内容：**
- 概览卡片：总 Entry 数、各层覆盖率、平均 confidence、成熟度等级
- 6 层架构图：各层 Entry 数量和覆盖率可视化
- 领域分布：按业务域统计 Entry 分布
- 关键统计：最近更新时间、活跃贡献者、治理健康度
- 成熟度雷达图：6 层成熟度评分

### 2. 层级深潜（Domain Deep-dive）

**受众：** 领域专家
**内容：**
- 单层详细分析（用户选择具体层级）
- 实体关系图：该层所有实体和关系的可视化
- Entry 列表：该层所有 Context Entry 的详细卡片
- 战略传导链（L3 层）：L3→L2 追溯可视化
- 术语映射表（L4 层）：跨系统术语对照表
- 案例时间线（L5 层）：案例按时间排列

### 3. 质量审计（Quality Audit）

**受众：** 治理委员会
**内容：**
- 三重校验结果（完整性/一致性/准确性）
- 治理规则执行统计（G1-G5）
- 反模式检测结果
- 修复建议（按优先级排序）
- 历史趋势（与前次审计对比）

### 4. 组织画像（Org Portrait）

**受众：** HR/OD 团队
**内容：**
- 性格维度雷达图：6 个性格维度的可视化
- 行为模式卡片：典型行为示例
- 沟通风格指南：与组织交互的建议
- 文化 DNA：组织的核心价值观和行为准则

### 5. 治理仪表盘（Governance Dashboard）

**受众：** 治理委员会、数据治理负责人
**内容：**
- **实时健康度评分：** 综合 G1-G5 规则执行结果的 0-100 分评分，分为优秀(≥90)/良好(70-89)/警告(50-69)/危险(<50) 四档
- **G1 过期监控：** 过期 Entry 数量、本月降权 Entry、即将过期 Entry（7 天内）
- **G2 挑战统计：** 待审查任务数、平均响应时间、超 SLA 任务
- **G3 冲突热力图：** 按层/域展示冲突密度，高冲突区域标红
- **G4 覆盖率趋势：** 6 层覆盖率的月度趋势折线图，目标线对比
- **G5 一致性指标：** L3→L2 追溯率、跨层引用完整性、断链数量
- **治理任务看板：** 待处理/进行中/已完成的治理任务分类展示
- **Entry 新鲜度分布：** 按 last_updated 时间分桶（7天内/30天内/90天内/过期）
- **Top 10 风险 Entry：** confidence 最低、challenge_count 最高、过期最久的 Entry

**数据源：**
- `output/governance/audit-reports/` 下的最新审计报告
- `output/governance/tasks/review-tasks.json`
- 各层 Context Entry 的 governance 元数据

**刷新频率：**
- 自动模式：每次 governance-audit 执行后自动生成新版本
- 手动模式：用户触发 `生成治理仪表盘报告`

**示例布局：**
```
┌─────────────────────────────────────────────────────────────┐
│  治理健康度: 78/100 [良好]     上次审计: 2026-11-03 14:00   │
├─────────────┬──────────────┬──────────────┬────────────────┤
│  G1 过期    │  G2 挑战     │  G3 冲突     │  G4 覆盖率     │
│  12 过期    │  3 待审查     │  5 冲突      │  L1:85% L2:72% │
│  2 即将过期 │  1 超 SLA     │  2 待解决    │  L3:68% L4:55% │
│             │              │              │  L5:30% L6:45% │
├─────────────┴──────────────┴──────────────┴────────────────┤
│  G5 一致性: L3→L2 追溯率 78% | 断链 7 条 | 破损引用 1 处  │
├─────────────────────────────────────────────────────────────┤
│  覆盖率趋势图（6 层 × 12 月）                               │
│  [折线图：各层覆盖率随时间变化，叠加目标线]                   │
├─────────────────────────────────────────────────────────────┤
│  Top 10 风险 Entry                                          │
│  1. ctx-L5-project-023  confidence=0.15  过期 8 个月        │
│  2. ctx-L2-strategy-007  challenge_count=5  未响应          │
│  ...                                                        │
├─────────────────────────────────────────────────────────────┤
│  治理任务看板                                               │
│  待处理: 5 | 进行中: 3 | 已完成: 12                         │
└─────────────────────────────────────────────────────────────┘
```

## 品牌标准

```yaml
colors:
  primary: "#074973"
  secondary: "#0A6B8C"
  deep: "#04314f"
  accent: "#35a7d6"

fonts:
  heading: "'PingFang SC', '微软雅黑', sans-serif"
  code: "'JetBrains Mono', 'Consolas', monospace"

layout:
  sidebar_width: 272px
  sidebar_background: "#04314f"
  content_padding: "40px 60px"

logo: hub-spoke 6-node SVG
doc_id_format: "ecp-orgcos-{type}-v{N}"
signature: "树懒老K · AI研习社"
```

## 报告生成流程

```
用户: "生成全景概览报告"
技能:
  1. 读取 output/ 目录下所有 JSON 数据
  2. 计算统计数据
  3. 选择报告模板（全景/深潜/审计/画像）
  4. 渲染 HTML（侧边栏 + 内容区）
  5. 保存到 output/reports/
  6. 提供文件链接
```

## 输出目录

```
output/
└── reports/
    ├── panorama-v{N}.html          # 全景概览
    ├── deep-dive-{layer}-v{N}.html # 层级深潜
    ├── quality-audit-v{N}.html     # 质量审计
    ├── org-portrait-v{N}.html      # 组织画像
    └── governance-dashboard-v{N}.html  # 治理仪表盘
```

## Pitfalls

- 报告文件大小控制在 500KB 以内——避免嵌入过多数据导致加载缓慢
- 全景概览不要显示所有 Entry——只显示摘要和 Top 10，详细数据通过深潜报告查看
- 质量审计报告中的"修复建议"必须具体可操作——不要写"建议改善覆盖率"这种空话
- HTML 报告必须通过 W3C 验证，确保在主流浏览器中正确渲染

## Verification

1. HTML 报告可在 Chrome/Edge/Firefox 中正常打开
2. 侧边栏导航链接正确，IntersectionObserver 工作正常
3. 统计数据与 JSON 源数据一致
4. 品牌标准（色彩/字体/Logo）正确应用
5. 文件大小 ≤ 500KB
