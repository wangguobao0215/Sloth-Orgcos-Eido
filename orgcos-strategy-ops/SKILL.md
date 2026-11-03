---
name: sloth-orgcos-strategy-ops-eido
description: "OrgCOS L2 Strategy + L3 Operations collection skill for strategic tradeoff decision logging and dual-version process modeling (official_flow vs actual_flow). Covers a 5-step workflow: strategic choice identification, tradeoff decision recording, strategy traceability chain, dual-version process collection, and deviation analysis. Use when the user mentions strategic analysis, tradeoff decisions, process mapping, process truth, operations layer, or SOP analysis."
version: 1.0.0
description_zh: "OrgCOS L2 战略层 + L3 运作层采集——战略取舍决策库与 official_flow/actual_flow 双版本流程建模，含五步流程。"
name_zh: "树懒 · 组织认知 · 战略"
---

# OrgCOS L2 战略层 + L3 运作层


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

本技能负责 OrgCOS 六层架构中两个决策骨架层的上下文采集：

- **L2 战略层**：回答"我们选择成为什么？选择不成为什么？"
- **L3 运作层**：回答"我们实际是怎么做事的？"

L2 和 L3 合并的原因：每条 L3 流程必须可追溯到一条 L2 战略规则（战略传导链）。合并后可以在采集流程的同时验证战略对齐度。

## 触发词

战略分析、战略取舍、战略决策、流程梳理、流程真相、运作层、SOP分析、official_flow、actual_flow、流程偏差

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
  - name: orgcos-ontology
    version: "^1.0.0"
    note: L2/L3 需要引用 L1 已建模的实体和关系
```

## 核心创新：双版本流程

| 版本 | 定义 | 采集方式 | 价值 |
|------|------|---------|------|
| official_flow | 制度文件规定的标准流程 | 解析 SOP 文档、制度文件 | 合规基准 |
| actual_flow | 员工实际执行的流程 | 深度访谈、行为日志分析 | 真实效率 |

两者的差异（gap）是 OrgCOS 最有价值的发现之一——它揭示了"组织以为自己怎么做"和"组织实际怎么做"之间的鸿沟。

## L2 战略层采集模块

L2 战略层包含四个子模块，按顺序完成：

### L2-M1: 战略身份（Strategic Identity）

**目标：** 明确企业的战略身份定位——"我们是谁"和"我们不是什么"。

**采集内容：**
- **身份声明**（Identity Statement）：一句话描述企业核心身份
- **身份边界**（Identity Boundaries）：明确"我们不做的事"清单
- **身份演化**（Identity Evolution）：近 5 年身份的变化轨迹

**示例：**
```json
{
  "identity_statement": "我们是大客户深度服务专家，不是市场覆盖型渠道商",
  "identity_boundaries": [
    "不做标准品零售",
    "不做海外市场",
    "不做 500 万以下小单"
  ],
  "identity_evolution": [
    {"year": 2020, "identity": "设备供应商"},
    {"year": 2022, "identity": "解决方案提供商"},
    {"year": 2024, "identity": "大客户战略伙伴"}
  ]
}
```

### L2-M2: 竞争定位图（Competitive Positioning Map）

**目标：** 在关键维度上可视化企业与竞争对手的相对位置。

**采集维度（至少选 2 个）：**
- 价格定位（高/中/低）
- 服务深度（深/中/浅）
- 技术领先性（领先/跟随/落后）
- 客户类型（大客户/中小客户/混合）
- 交付速度（快/中/慢）

**输出格式：** 二维或三维定位矩阵，标注企业和 2-3 个主要竞争对手的相对位置。

### L2-M3: 战略取舍决策库（Tradeoff Decision Library）

即下文 L2-1 至 L2-2 的完整流程。

### L2-M4: 战略传导链（Strategy Propagation Chain）

即下文 L2-3 的完整流程。

### L2-M5: 负面案例库（Negative Case Library）

**目标：** 记录战略决策失败、被推翻或被证明错误的案例——这些"负面知识"比成功经验更有价值（Porter, 1996）。

**为什么需要负面案例库：**
- 避免"幸存者偏差"——只记录成功案例会误导未来决策
- 失败案例提供更深的战略洞察（"为什么这个看似合理的决策失败了？"）
- 帮助 AI 系统在类似场景下发出风险预警

**负面案例条目结构：**
```json
{
  "entry_id": "ctx-L2-negative-001",
  "layer": "L2",
  "type": "decision",
  "domain": "strategy",
  "content": {
    "decision_id": "D-NEG-001",
    "title": "2024年进入东南亚市场的决策",
    "original_decision": {
      "chose": "通过代理商模式快速进入越南市场",
      "rationale": "国内增长放缓，东南亚是蓝海市场",
      "confidence_at_time": 0.75
    },
    "outcome": {
      "result": "failure",
      "details": "代理商缺乏技术支持能力，客户投诉率 40%，18 个月后退出市场",
      "loss": "直接损失 800 万 + 品牌声誉损害"
    },
    "root_cause_analysis": {
      "category": "capability_gap",
      "explanation": "高估了代理商的技术服务能力，低估了本地化交付的复杂性",
      "blind_spot": "未做代理商能力验证就签约"
    },
    "lessons_learned": [
      "进入新市场前必须验证合作伙伴的核心能力（至少 3 个标杆客户验证）",
      "高复杂度产品不适合纯代理商模式，需要混合模式（代理商+自有技术团队）",
      "新市场试水应限制投入规模（≤ 500 万），验证模式后再扩大"
    ],
    "counterfactual": "如果当时选择先做 6 个月的技术能力认证，可以避免 80% 的损失",
    "related_decisions": ["D-001"],
    "applied_to_future": "此教训已纳入 D-015（新市场进入决策流程）的 mandatory_checklist"
  },
  "governance": {
    "owner": {"role": "战略发展VP", "name": "..."},
    "valid_from": "2025-06-01",
    "valid_until": "2028-06-01",
    "confidence": 0.90,
    "version": "1.0.0"
  }
}
```

**负面案例分类：**
| 类别 | 定义 | 示例 |
|------|------|------|
| `capability_gap` | 高估了组织或合作伙伴的能力 | 代理商缺乏技术能力 |
| `market_misread` | 对市场趋势或客户需求的误判 | 以为客户需要低价，实际需要定制化 |
| `timing_error` | 进入或退出时机错误 | 过早进入尚未成熟的市场 |
| `execution_failure` | 战略正确但执行不力 | 直销团队搭建失败 |
| `external_shock` | 外部不可控因素导致失败 | 政策变化、疫情 |
| `hubris` | 过度自信导致的冒险决策 | 忽视竞争对手的技术突破 |

**采集方法：**
1. 定期（半年度）复盘近 2 年的重大战略决策，找出失败案例
2. 对失败案例做"5 个为什么"根因分析
3. 提取可操作的教训（不是空泛的"加强市场调研"）
4. 关联到当前有效的战略决策，标注"此决策需警惕 {root_cause}"

**负面案例库规模指引：**
- 最小：5 条（覆盖主要战略领域）
- 推荐：15-20 条（覆盖近 5 年的重大失败）
- 上限：无（越多越好，但需保证质量）

---

## 采集流程（5 步）

```
L2-1 战略选择识别 → L2-2 取舍决策记录 → L2-3 战略传导链
→ L3-1 official_flow + actual_flow 双版本采集
→ L3-2 偏差分析与战略对齐
```

### L2-1: 战略选择识别

**目标：** 识别企业当前阶段的关键战略选择。

**方法：**
1. 引导高管回顾近 2 年的重大决策（≥ 10 个）
2. 对每个决策标注：选择了什么 / 放弃了什么
3. 区分"主动取舍"和"被动接受"
4. 识别战略的"不可为清单"（NOT-TO-DO list）

**访谈问题示例：**
- "过去一年，你们拒绝了哪些看起来不错的机会？为什么？"
- "如果资源只能做三件事，你们选哪三件？放弃什么？"
- "竞争对手在做但你们选择不做的事情有哪些？"

**输出：** `output/L2-strategy/choices.json`

### L2-2: 取舍决策记录

**目标：** 将每个战略取舍结构化为标准决策条目。

**决策条目结构：**
```json
{
  "entry_id": "ctx-L2-strategy-001",
  "layer": "L2",
  "type": "decision",
  "domain": "strategy",
  "content": {
    "decision_id": "D-001",
    "title": "聚焦大客户直销，放弃渠道分销",
    "chose": "大客户直销模式",
    "rejected": "渠道分销模式",
    "rationale": "大客户需求复杂，需要深度服务，渠道模式无法提供定制化体验",
    "trade_offs": {
      "gained": ["客户深度", "高毛利", "强关系"],
      "lost": ["市场覆盖面", "增长速度"],
      "accepted_risk": "营收增速低于行业平均"
    },
    "review_trigger": "当大客户增速连续 2 季度 < 10% 时重新评估",
    "related_entities": ["Customer", "SalesChannel"],
    "confidence": 0.85
  },
  "governance": { "..." : "12字段治理元数据" }
}
```

**输出：** `output/L2-strategy/decisions.json`

### L2-3: 战略传导链

**目标：** 验证每条战略决策是否已传导到具体的运作流程。

**方法：**
1. 对每条 L2 战略决策，查找对应的 L3 流程
2. 标注传导状态：已传导 / 部分传导 / 未传导
3. 未传导的战略决策标记为 `pending_alignment`

**输出：** `output/L2-strategy/propagation-chain.json`

### L3-1: 双版本流程采集

**目标：** 同时采集 official_flow（标准流程）和 actual_flow（实际流程）。

**L3 运作层采集覆盖 8 类内容范畴：**

| # | 范畴 | 说明 | 采集优先级 |
|---|------|------|-----------|
| 1 | 核心业务流程 | 直接创造客户价值的端到端流程 | 最高 |
| 2 | 决策审批流程 | 关键决策的权限分配和审批路径 | 高 |
| 3 | 资源配置流程 | 预算、人力、设备的分配机制 | 高 |
| 4 | 质量控制流程 | 质量标准、检验节点、异常处理 | 中 |
| 5 | 跨部门协调流程 | 部门间信息传递、冲突解决机制 | 中 |
| 6 | 知识管理流程 | 经验沉淀、案例库更新、最佳实践传播 | 中 |
| 7 | 风险管控流程 | 风险识别、评估、应对和监控 | 高 |
| 8 | 变革管理流程 | 组织变革、流程优化、制度更新的触发和执行 | 低 |

**决策授权矩阵（Decision Authority Matrix）：**

每个 L3 流程必须明确定义决策授权，格式如下：

```json
{
  "process_id": "P-001",
  "process_name": "大客户报价审批",
  "decision_authority": [
    {
      "decision_type": "标准报价（折扣 ≤ 15%）",
      "authority_level": "销售经理",
      "approval_required": false,
      "escalation_trigger": "折扣 > 15%"
    },
    {
      "decision_type": "特殊报价（折扣 15%-30%）",
      "authority_level": "销售总监",
      "approval_required": true,
      "approval_role": "VP销售"
    },
    {
      "decision_type": "战略报价（折扣 > 30%）",
      "authority_level": "CEO",
      "approval_required": true,
      "approval_role": "CEO办公会"
    }
  ],
  "actual_authority_observed": "销售总监实际可批 25% 折扣（潜规则）",
  "authority_gap": "官方授权 vs 实际授权存在 10% 偏差"
}
```

**official_flow 采集：**
1. 收集现有 SOP 文档、制度文件
2. 提取流程步骤、角色、审批节点
3. 结构化为标准流程模型

**actual_flow 采集（通过流程真相访谈）：**
1. 选择 5-10 个关键流程
2. 对流程参与者进行深度访谈
3. 记录实际步骤、绕行规则、非正式审批
4. 标注"为什么这样做"的原因

**访谈问题示例：**
- "这个流程你实际执行的步骤和 SOP 写的一样吗？哪里不同？"
- "你在什么情况下会跳过某个审批步骤？"
- "有没有你自己发明的'捷径'？为什么需要这个捷径？"

**输出：** `output/L3-operations/official-flows.json` + `actual-flows.json`

### L3-2: 偏差分析与战略对齐

**目标：** 分析 official_flow 与 actual_flow 的偏差，验证 L3→L2 战略对齐。

**偏差类型：**
| 类型 | 说明 | 处理方式 |
|------|------|---------|
| 合理绕行 | actual 比 official 更高效 | 建议更新 official_flow |
| 风险绕行 | actual 跳过了风控步骤 | 标记为风险，建议修正 |
| 冗余步骤 | official 有但 actual 从不执行 | 建议精简 official_flow |
| 战略断链 | L3 流程无法追溯到 L2 战略 | 标记 pending_alignment |

**输出：** `output/L3-operations/gap-analysis.json`

## 输出目录

```
output/
├── L2-strategy/
│   ├── choices.json              # 战略选择列表
│   ├── decisions.json            # 结构化取舍决策
│   ├── propagation-chain.json    # 战略传导链
│   └── not-to-do-list.json       # 不可为清单
└── L3-operations/
    ├── official-flows.json       # 标准流程
    ├── actual-flows.json         # 实际流程
    └── gap-analysis.json         # 偏差分析
```

## Pitfalls

- actual_flow 采集需要心理安全环境——受访者需要相信"说真话不会被惩罚"
- 不要把 official_flow 和 actual_flow 的差异都视为"错误"——很多绕行是合理的效率优化
- 战略传导链不是 1:1 映射——一条 L2 战略可能对应多条 L3 流程，反之亦然
- L2 战略决策的 confidence 不应默认很高——需要实践验证后才能提升

## Verification

1. 所有 Context Entry 通过 kernel-validate 校验
2. L3 流程 → L2 战略追溯率 ≥ 80%
3. official_flow / actual_flow 双版本完整率 ≥ 70%
4. 偏差分析覆盖所有关键流程（≥ 5 个）
5. 每条 L2 战略决策至少关联 1 个 L1 实体
