---
name: sloth-orgcos-architect-eido
description: "OrgCOS master orchestrator guiding users through the full 8-phase (P0-P7) OrgCOS construction workflow with interactive Q&A, decision recommendations, sub-skill dispatch, and quality gates. Supports full-flow, resume-from-breakpoint, and single-step execution modes. Use when the user says 'build OrgCOS', 'enterprise context system', or 'organizational cognitive operating system'."
version: 1.0.0
description_zh: "OrgCOS 全流程主控——引导用户完成 8 阶段 OrgCOS 构建，含交互式问答、决策建议、子技能调度和质量门禁，支持全流程/断点续建/单步执行。"
name_zh: "树懒 · 组织认知 · 主控"
---

# OrgCOS 全流程主控


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

本技能是 OrgCOS 技能家族的**用户唯一入口**。用户只需说"帮我做 OrgCOS"，主控技能自动判断当前状态，调度对应的子技能，并在每个阶段执行质量门禁。

**设计哲学：** 用户不需要理解 T1/T2/T3、6 层架构、12 字段治理元数据等概念。主控技能通过自然对话引导用户完成整个 OrgCOS 构建过程。

## 触发词

OrgCOS、组织认知操作系统、企业上下文系统、组织认知、帮我做OrgCOS、构建组织上下文

## 依赖技能

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
    note: T1 内核（基础约束）
  - name: orgcos-blueprint
    version: "^1.0.0"
    note: T2 行业蓝图
  - name: orgcos-ontology
    version: "^1.0.0"
    note: L1 + L4 本体语义层
  - name: orgcos-strategy-ops
    version: "^1.0.0"
    note: L2 + L3 战略运作层
  - name: orgcos-memory-char
    version: "^1.0.0"
    note: L5 + L6 记忆性格层
  - name: orgcos-governance
    version: "^1.0.0"
    note: 治理引擎
  - name: orgcos-seci
    version: "^1.0.0"
    note: SECI 知识转化
  - name: orgcos-validator
    version: "^1.0.0"
    note: 质量验证
  - name: orgcos-api
    version: "^1.0.0"
    note: AI 消费 API 标准化
  - name: orgcos-report
    version: "^1.0.0"
    note: 报告生成
```

## 三种执行模式

### 模式 A：全流程（新项目）

从 P0 到 P7，8 阶段完整执行。适用于首次构建 OrgCOS 的企业。

### 模式 B：断点续建

读取项目状态文件 `project-state.json`，从上次中断点继续。

### 模式 C：单步执行

用户指定执行某个阶段或某个子技能，如"只做 L2 战略层"。

## 8 阶段编排流程

```
P0 项目启动 → P1 内核初始化 → P2 蓝图加载 → P3 L1+L4 基础层
→ P4 L2+L3 决策层 → P5 L5+L6 判断层 → P6 跨层校验 → P7 交付报告
```

### 交互式决策树引导（Interactive Decision Tree Guidance）

**目标：** 在关键决策点提供结构化的选项引导，帮助用户做出符合 OrgCOS 最佳实践的选择。

**设计理念：**
- 用户不是 OrgCOS 专家，需要主动引导而非被动等待
- 决策点提供 2-4 个推荐选项，附带利弊分析
- 支持用户自定义选项，但提醒可能的风险

**决策树数据结构：**
```json
{
  "decision_point_id": "DP-P2-blueprint-selection",
  "phase": "P2",
  "title": "选择行业蓝图",
  "context": "OrgCOS 提供行业预置蓝图，可加速构建过程。选择合适的蓝图可以节省 60% 的本体建模时间。",
  "options": [
    {
      "id": "manufacturing-v1",
      "label": "制造业蓝图（推荐）",
      "description": "适用于离散/流程制造企业，预置 WorkOrder/BOM/ProcessRoute/Material 等实体",
      "pros": ["覆盖制造业核心概念", "经过 10+ 企业验证", "包含行业最佳实践"],
      "cons": ["可能需要裁剪不适用的扩展"],
      "recommendation": "如果您的企业属于制造业，强烈推荐选择此项"
    },
    {
      "id": "financial-v1",
      "label": "金融业蓝图（Beta）",
      "description": "适用于银行/保险/证券，预置 Account/Product/Transaction/Risk 等实体",
      "pros": ["覆盖金融监管要求", "包含风控模型"],
      "cons": ["仍处于 Beta 阶段，可能有不稳定之处"],
      "recommendation": "适合愿意参与 Beta 测试的金融机构"
    },
    {
      "id": "none",
      "label": "无预置蓝图",
      "description": "从零开始构建，完全自定义",
      "pros": ["完全贴合企业实际", "无历史包袱"],
      "cons": ["构建时间长 3-5 倍", "需要更多领域专家参与"],
      "recommendation": "仅当您的行业无预置蓝图且愿意投入更多时间时选择"
    }
  ],
  "default_option": "manufacturing-v1",
  "user_input_allowed": true,
  "validation_rules": {
    "if_user_custom": "warn: 自定义蓝图需要更多时间验证，建议先用预置蓝图试点"
  }
}
```

**关键决策点清单：**

| 决策点 ID | 阶段 | 决策内容 | 默认推荐 |
|-----------|------|---------|---------|
| DP-P0-scope | P0 | 项目范围（全面/部分/试点） | 试点验证 |
| DP-P2-blueprint | P2 | 行业蓝图选择 | 匹配行业的最新蓝图 |
| DP-P3-entity-priority | P3 | 实体建模优先级（P0/P1/P2） | 先做 P0（3+ 应用共享） |
| DP-P4-process-depth | P4 | 流程采集深度（全面/关键流程） | 关键流程（Top 10） |
| DP-P5-case-source | P5 | 案例来源（SECI 引擎/历史导入/混合） | 混合模式 |
| DP-P6-audit-frequency | P6 | 治理审计频率（月度/季度/半年度） | 季度 |
| DP-P7-report-type | P7 | 报告类型（全景/深潜/审计/画像/仪表盘） | 全景概览 |

**决策引导交互流程：**

```
步骤 1: 展示决策背景和选项
步骤 2: 高亮推荐选项（带"推荐"标签）
步骤 3: 用户选择或自定义
步骤 4: 如果用户选择非推荐选项，温和提醒风险
步骤 5: 确认决策，记录到 project-decisions.json
步骤 6: 根据决策调整后续流程
```

**决策记录格式：**
```json
{
  "decision_id": "DP-P2-blueprint-selection",
  "timestamp": "2026-11-03T10:15:00+08:00",
  "selected_option": "manufacturing-v1",
  "user_rationale": "我们是离散制造企业，这个蓝图最匹配",
  "skipped_options": ["financial-v1", "none"],
  "impact_on_flow": "使用制造业蓝图的预置实体，预计节省 60% 本体建模时间",
  "reversible": true,
  "reversal_condition": "如果发现预置实体覆盖度 < 50%，可切换到自定义模式"
}
```

**智能推荐逻辑：**
```python
def recommend_option(decision_point, project_context):
    """基于项目上下文推荐最佳选项"""
    if decision_point.id == "DP-P2-blueprint":
        industry = project_context.enterprise.industry
        available_blueprints = get_available_blueprints()
        
        if industry in available_blueprints:
            return available_blueprints[industry].latest_stable
        else:
            return "none"  # 无匹配蓝图，建议从零开始
    
    elif decision_point.id == "DP-P0-scope":
        scale = project_context.enterprise.scale
        if scale in ["large", "enterprise"]:
            return "pilot"  # 大企业建议先试点
        else:
            return "full"  # 中小企业建议全面构建
    
    # ... 其他决策点的推荐逻辑
```

**用户反馈收集：**

每个决策点完成后，收集用户反馈以优化推荐算法：
```json
{
  "decision_id": "DP-P2-blueprint-selection",
  "user_satisfaction": 4,  // 1-5 分
  "feedback": "蓝图覆盖度很好，但有些属性需要定制",
  "improvement_suggestion": "希望支持蓝图属性级别的启用/禁用"
}
```

---

### P0: 项目启动

**目标：** 收集企业基础信息，确定项目范围。

**交互流程：**
1. 询问企业名称、行业、规模（员工数）、发展阶段
2. 询问项目目标（全面构建 / 特定层级 / 试点验证）
3. 确认关键干系人和 owner 角色
4. 生成项目配置 `project-config.json`

**输出：**
```json
{
  "project_id": "orgcos-{enterprise}-{date}",
  "enterprise": { "name": "", "industry": "", "scale": "", "stage": "" },
  "scope": { "mode": "full|partial|pilot", "target_layers": [] },
  "stakeholders": { "project_owner": "", "domain_experts": [] },
  "created_at": "ISO-8601"
}
```

### P1: 内核初始化

**调度：** `orgcos-kernel`

**目标：** 加载 T1 内核约束集，初始化项目 Schema。

**操作：**
1. 调用 orgcos-kernel 加载标准 Schema
2. 创建项目级 Schema 目录 `output/schema/`
3. 验证内核文件完整性

**质量门禁：** 内核文件 100% 完整 → 自动通过

### P2: 蓝图加载

**调度：** `orgcos-blueprint`

**目标：** 根据企业行业加载 T2 行业蓝图。

**交互流程：**
1. 展示可用行业蓝图列表
2. 用户选择行业（或选择"无预置蓝图"）
3. 加载蓝图 YAML，注入项目 Schema

**质量门禁：** 蓝图兼容性检查通过

### P3: L1+L4 基础层

**调度：** `orgcos-ontology`

**目标：** 完成本体建模（实体/关系）和语义层对齐。

**子阶段：**
1. L1: 业务能力地图 → 实体发现 → 关系建模
2. L4: 术语采集 → 跨系统映射 → 消歧确认

**质量门禁：**
- 实体覆盖率 ≥ 60%（P0/P1/P2 优先级）
- 所有实体包含 12 字段治理元数据
- 通过 → 进入 P4；条件通过 → 记录警告；未通过 → 暂停修正

### P4: L2+L3 决策层

**调度：** `orgcos-strategy-ops`

**目标：** 完成战略取舍决策库和流程真相双版本建模。

**子阶段：**
1. L2: 战略选择识别 → 取舍决策记录 → 战略传导链
2. L3: official_flow 采集 → actual_flow 采集 → 偏差分析

**质量门禁：**
- L3 流程 → L2 战略追溯率 ≥ 80%
- official_flow / actual_flow 双版本完整

### P5: L5+L6 判断层

**调度：** `orgcos-memory-char` + `orgcos-seci`

**目标：** 构建组织记忆库和性格画像。

**子阶段：**
1. L5: 历史案例导入 → SECI 第一轮螺旋（至少完成 S+E 阶段）
2. L6: 组织性格访谈 → 行为模式编码 → Prompt 模板编译

**质量门禁：**
- L5 案例数 ≥ 20 条
- L6 性格画像覆盖 ≥ 3 个维度

### P6: 跨层校验

**调度：** `orgcos-governance` + `orgcos-validator`

**目标：** 执行全量跨层一致性和完整性校验。

**操作：**
1. 治理引擎全量扫描（G1-G5）
2. 跨层一致性检查
3. 覆盖率审计（G4）
4. 反模式检测

**质量门禁：**
- 通过：完整性 ≥ 80%，一致性 ≥ 90%，无错误
- 条件通过：完整性 ≥ 60%，无错误
- 未通过：存在错误或完整性 < 60%

### P7: 交付报告

**调度：** `orgcos-report`

**目标：** 生成 OrgCOS 全景概览报告。

**输出：**
- 全景概览 HTML 报告
- 质量审计 HTML 报告
- 完整 JSON 数据包

## 项目状态管理

每个项目维护 `project-state.json`：

```json
{
  "project_id": "orgcos-acme-20261103",
  "current_phase": "P4",
  "phase_status": {
    "P0": { "status": "completed", "completed_at": "..." },
    "P1": { "status": "completed", "completed_at": "..." },
    "P2": { "status": "completed", "completed_at": "..." },
    "P3": { "status": "completed", "completed_at": "..." },
    "P4": { "status": "in_progress", "started_at": "..." }
  },
  "quality_gates": {
    "P3": { "result": "passed", "warnings": [] }
  },
  "entry_counts": {
    "L1": 45, "L2": 12, "L3": 8, "L4": 23, "L5": 0, "L6": 0
  }
}
```

## 用户交互示例

```
用户: "帮我做 OrgCOS"
技能: 识别为新项目，进入 P0 项目启动
  → "请问您的企业名称、所在行业、员工规模？"
  → "您希望全面构建还是先做试点？"

用户: "继续上次的 OrgCOS 项目"
技能: 读取 project-state.json，识别断点
  → "上次项目停在 P4（L2+L3 决策层），L2 战略层已完成 60%，
     L3 运作层未开始。要继续吗？"

用户: "只做 L1 本体建模"
技能: 模式 C，直接调度 orgcos-ontology
```

## 输出目录结构

```
output/
├── project-config.json       # P0 项目配置
├── project-state.json        # 项目状态
├── schema/                   # P1 内核 Schema
├── blueprint/                # P2 行业蓝图
├── L1-ontology/              # P3 本体层
├── L2-strategy/              # P4 战略层
├── L3-operations/            # P4 运作层
├── L4-semantics/             # P3 语义层
├── L5-memory/                # P5 记忆层
├── L6-character/             # P5 性格层
├── governance/               # P6 治理报告
├── reports/                  # P7 交付报告
└── sync-state.json           # 同步状态（可选）
```

## Pitfalls

- 不要在 P0 跳过企业基本信息采集——后续所有技能都依赖行业和规模参数
- 质量门禁"条件通过"时记录的警告，必须在最终报告中标注
- 断点续建时必须先验证已完成的阶段数据是否仍然有效（可能已过期）
- 不要在全流程模式中跳过 SECI 阶段——即使只做最小化的 S+E 也比完全跳过好

## Verification

1. P0-P7 每个阶段结束后，检查 output/ 目录下是否生成预期文件
2. 质量门禁结果与 orgcos-validator 输出一致
3. project-state.json 在每次阶段切换时正确更新
4. 断点续建能正确恢复到中断点
