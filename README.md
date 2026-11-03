<p align="center">
  <img src="sloth-orgcos-kernel-eido/assets/sloth-avatar-round.png" width="120" />
</p>

<h1 align="center">Sloth-Orgcos-Eido</h1>

<p align="center">
  <strong>树懒 · 组织认知 — Organizational Cognitive Operating System</strong><br/>
  12 个 AI 技能协同，覆盖六层架构设计、治理引擎、知识转化与报告生成。
</p>

<p align="center">
  <img src="sloth-orgcos-kernel-eido/assets/qrcode.jpg" width="140" /><br/>
  <sub>扫码关注 <strong>树懒老K</strong> · 获取更多 AI 技能</sub><br/>
  <em>慢一点，深一度</em>
</p>

---

本目录包含 OrgCOS 的完整技能家族，共 **12 个技能**，覆盖组织认知操作系统的六层架构设计、T1 通用内核、T2 行业蓝图、治理引擎、SECI 知识转化、质量验证和报告生成。

## 技能总览

| # | 技能名 | 类别 | 职责 | 用户可触发 | 版本 |
|---|--------|------|------|-----------|------|
| 1 | `sloth-sloth-orgcos-architect-eido-eido` | 主控 | 全流程编排入口，调度所有子技能 | 是（主入口） | 1.0.0 |
| 2 | `sloth-sloth-orgcos-kernel-eido-eido` | 内核 | T1 通用内核约束集（Schema/规则/API规范） | 否（被依赖） | 1.0.0 |
| 3 | `sloth-orgcos-ontology-eido` | 层级 | L1 本体层 + L4 语义层采集 | 是 | 1.0.0 |
| 4 | `sloth-orgcos-strategy-ops-eido` | 层级 | L2 战略层 + L3 运作层采集 | 是 | 1.0.0 |
| 5 | `sloth-orgcos-memory-char-eido` | 层级 | L5 记忆层 + L6 性格层采集 | 是 | 1.0.0 |
| 6 | `sloth-orgcos-governance-eido` | 引擎 | 治理引擎（G1-G5 规则 + 12 字段校验） | 是 | 1.0.0 |
| 7 | `sloth-orgcos-seci-eido` | 引擎 | SECI 知识转化引擎（8 周螺旋） | 是 | 1.0.0 |
| 8 | `sloth-orgcos-blueprint-eido` | 扩展 | T2 行业蓝图管理（加载/验证/定制） | 是 | 1.0.0 |
| 9 | `sloth-orgcos-validator-eido` | 工具 | 质量验证（三重校验 + 质量门禁） | 是 | 1.0.0 |
| 10 | `sloth-orgcos-api-eido` | 工具 | AI 消费 API 标准化（4 端点 + SDK） | 是 | 1.0.0 |
| 11 | `sloth-orgcos-report-eido` | 工具 | 报告生成（4 种类型 HTML 报告） | 是 | 1.0.0 |
| 12 | `sloth-orgcos-pipeline-eido` | 编排 | 后台编排引擎（技能调度 + 错误恢复） | 是 | 1.0.0 |

## 依赖关系图

```
                          ┌──────────────────┐
                          │  sloth-orgcos-architect-eido │ ← 用户主入口
                          │   (主控技能)      │
                          └────────┬─────────┘
                                   │ 调度 10 个子技能
         ┌─────────────┬───────────┼───────────┬──────────────┐
         ▼             ▼           ▼           ▼              ▼
   ┌──────────┐  ┌───────────┐  ┌─────────┐  ┌──────────┐  ┌──────────┐
   │ ontology │  │ strategy- │  │ memory- │  │governance│  │  seci    │
   │ L1+L4   │  │ ops L2+L3 │  │char L5+L6│  │ 治理引擎  │  │ SECI引擎 │
   └────┬─────┘  └─────┬─────┘  └────┬────┘  └────┬─────┘  └────┬─────┘
        │              │             │             │             │
        └──────────────┴─────────────┴─────────────┴─────────────┘
                               │ 依赖
                    ┌──────────┴──────────┐
                    │    sloth-orgcos-kernel-eido    │ ← 所有技能的基础
                    │     (T1 内核)       │
                    └─────────────────────┘

   独立技能: blueprint(T2蓝图) · validator(质量) · api(API) · report(报告) · pipeline(编排)
```

## 快速开始

### 完整构建（推荐）
```
用户: "帮我做 OrgCOS"
→ sloth-orgcos-architect-eido 接管，8 阶段全流程引导
```

### 单独使用
```
用户: "帮我做本体建模"           → orgcos-ontology
用户: "帮我梳理战略和流程"        → orgcos-strategy-ops
用户: "启动一轮 SECI 知识转化"    → orgcos-seci
用户: "跑一轮治理审计"           → orgcos-governance
用户: "生成全景概览报告"          → orgcos-report
```

## 8 阶段全流程

```
P0 项目启动 → P1 内核初始化 → P2 蓝图加载 → P3 L1+L4 基础层
→ P4 L2+L3 决策层 → P5 L5+L6 判断层 → P6 跨层校验 → P7 交付报告
```

| 阶段 | 调度技能 | 质量门禁 |
|------|---------|---------|
| P0 | sloth-orgcos-architect-eido | 项目配置完整 |
| P1 | sloth-orgcos-kernel-eido | 内核文件完整 |
| P2 | orgcos-blueprint | 蓝图兼容性通过 |
| P3 | orgcos-ontology | 覆盖率 ≥ 60% |
| P4 | orgcos-strategy-ops | L3→L2 追溯率 ≥ 80% |
| P5 | orgcos-memory-char + orgcos-seci | 案例数 ≥ 20 |
| P6 | orgcos-governance + orgcos-validator | 无 Error |
| P7 | orgcos-report + orgcos-api | 报告生成 |

## 核心概念

### OrgCOS 六层架构
- **L1 本体层**：企业中有哪些实体和关系？
- **L2 战略层**：我们选择做什么、不做什么？
- **L3 运作层**：我们实际怎么做事？
- **L4 语义层**：我们使用的术语到底什么意思？
- **L5 记忆层**：我们经历过什么、学到了什么？
- **L6 性格层**：我们的行为风格是什么？

### 三层产品架构
- **T1 通用内核** (~95% 通用)：Schema + 治理规则 + API 规范
- **T2 行业蓝图** (~60% 通用)：行业特有实体/属性/规则预置包
- **T3 企业实例** (~10% 通用)：企业真实数据

### Context Entry（上下文条目）
OrgCOS 的基本数据单元，每条 Entry 包含：
- 层级标识（L1-L6）
- 内容载荷（层级特定）
- 12 字段治理元数据（T1 强制）

## 文件结构

```
orgcos-skills/
├── README.md                          ← 本文件（家族导航）
├── LICENSE                            ← MIT 许可证
├── CHANGELOG.md                       ← 家族版本日志
├── sloth-orgcos-kernel-eido/                     ← T1 内核（基础约束）
│   ├── SKILL.md
│   ├── README.md / README_EN.md
│   ├── LICENSE / CHANGELOG.md / .gitignore
│   ├── assets/                        ← 品牌资源（3 文件）
│   └── kernel/                        ← 核心配置文件
│       ├── schema/
│       │   ├── context-entry.schema.json
│       │   └── governance-meta.schema.json
│       ├── entity-relation/
│       │   ├── entities.yaml
│       │   └── relations.yaml
│       └── governance/
│           └── rules.yaml
├── sloth-orgcos-architect-eido/                  ← 主控技能
│   ├── SKILL.md + README.md/EN + LICENSE + CHANGELOG.md + .gitignore + assets/
├── orgcos-ontology/                   ← L1+L4
│   ├── (同上标准 7 件套)
├── orgcos-strategy-ops/               ← L2+L3
├── orgcos-memory-char/                ← L5+L6
├── orgcos-governance/                 ← 治理引擎
├── orgcos-seci/                       ← SECI 引擎
├── orgcos-blueprint/                  ← 行业蓝图
├── orgcos-validator/                  ← 质量验证
├── orgcos-api/                        ← API 标准化
├── orgcos-report/                     ← 报告生成
└── orgcos-pipeline/                   ← 编排引擎
```

> 每个技能目录均包含标准 7 件套：`SKILL.md` + `README.md` + `README_EN.md` + `LICENSE` + `CHANGELOG.md` + `.gitignore` + `assets/`，已通过 Sloth-Eido Family Convention v1.4 合规审计。

## 实施路线图

| 期次 | 时间 | 交付技能 | 里程碑价值 |
|------|------|---------|-----------|
| 第一期 | 第 1-2 月 | kernel + ontology + governance + architect | L1+L4 本体建模可用 |
| 第二期 | 第 3-4 月 | strategy-ops + seci + blueprint | L2+L3 + SECI + 制造业蓝图 |
| 第三期 | 第 5-6 月 | memory-char + validator + api + report + pipeline | 完整 6 层 + 全工具链 |

## 相关文档

- `OrgCOS详细设计方案.html` — 六层架构完整设计
- `OrgCOS-T1通用内核详细设计.html` — T1 内核技术规格
- `通用OrgCOS可行性辩论.html` — 三层架构可行性论证
- `OrgCOS技能体系产品化圆桌辩论.html` — 技能家族架构设计辩论
