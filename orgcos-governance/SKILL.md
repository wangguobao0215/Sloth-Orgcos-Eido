---
name: sloth-orgcos-governance-eido
description: "OrgCOS Governance Engine executing 12-field governance metadata validation and 6 auto-governance rules (G1 expiration decay, G2 challenge alert, G3 conflict detection, G4 coverage audit, G5 consistency check, G6 knowledge freshness assessment) with a deterministic-code + LLM-assisted hybrid architecture. Supports automatic triggering on Entry changes and manual audit mode. Use when the user mentions governance audit, metadata validation, expiration check, conflict detection, coverage audit, consistency check, or knowledge freshness."
version: 1.0.0
description_zh: "OrgCOS 治理引擎——执行 12 字段治理元数据校验和 G1-G6 六条自动治理规则，采用确定性代码 + LLM 混合架构。"
name_zh: "树懒 · 组织认知 · 治理"
---

# OrgCOS 治理引擎


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

治理引擎是 OrgCOS 的**免疫系统**——确保每一条 Context Entry 的可信度、时效性和一致性。它不是一个"附加功能"，而是 OrgCOS 数据质量的守门人。

**架构哲学：** 确定性规则用代码执行（快、准、可测试），语义判断用 LLM 辅助（灵活但有误判风险）。

## 触发词

治理审计、元数据校验、过期检查、冲突检测、覆盖率审计、一致性校验、governance audit、数据质量检查

## 两种触发模式

### 模式 A：校验模式（被调度）

当其他技能创建或修改 Context Entry 时，自动调用治理引擎进行校验。

```yaml
# 被调用接口
governance-validate:
  input: Context Entry JSON 或 JSON 数组
  output: ValidationResult
  blocking: true  # 校验不通过则阻止 Entry 入库
```

### 模式 B：审计模式（用户触发）

用户手动触发全面治理审计。

```yaml
# 用户触发接口
governance-audit:
  input: output/ 目录路径
  output: 治理审计报告（HTML + JSON）
  blocking: false
```

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
    imports:
      - governance/rules.yaml
      - governance/conflict-hierarchy.yaml
      - schema/governance-meta.schema.json
```

## 12 字段治理元数据校验

### 校验规则

| 字段 | 校验内容 | 严重级别 |
|------|---------|---------|
| owner | 非空，role 格式合法 | Error |
| modifier | 非空数组（≥ 1），role 格式合法 | Error |
| valid_from | 合法日期，≤ today | Error |
| valid_until | 合法日期或 event 字符串 | Error |
| confidence | Float 0.0-1.0，不允许默认 1.0 | Error |
| evidence_count | Integer ≥ 0 | Warning |
| version | SemVer 格式合法 | Error |
| source | Enum 值合法 | Error |
| changelog | Array，每项含 who/when/what | Warning |
| conflict_resolution | RuleRef 格式或 null | Warning |
| last_challenged | 合法日期或 null | Info |
| challenge_count | Integer ≥ 0 | Info |

**6 个 Error 级字段缺失 → 校验不通过，阻止入库。**

## 6 条自动治理规则

### G1: 过期降权（Expiration Decay）

```yaml
rule_id: G1
name: 过期降权
trigger: NOW > valid_until AND entry not renewed
action:
  - confidence = confidence - (months_expired × decay_rate)
  - confidence = max(confidence, min_confidence)
  - append_warning: "此信息已过期（过期{months}个月），可信度已降至{confidence}"
params:
  decay_rate: 0.1        # 每月衰减量
  min_confidence: 0.1    # 最低可信度
needs_llm: false
implementation: Python 时间计算
```

**执行示例：**
- Entry confidence = 0.85, valid_until = 2026-06-01, now = 2026-11-03
- months_expired = 5
- new_confidence = 0.85 - (5 × 0.1) = 0.35

### G2: 挑战预警（Challenge Alert）

```yaml
rule_id: G2
name: 挑战预警
trigger: challenge_count >= challenge_threshold AND entry not modified after last_challenged
action:
  - create_review_task:
      assignee: owner
      message: "条目 {entry_id} 已被挑战 {challenge_count} 次但未修改，请确认或修订"
      priority: high
      sla_days: 7
params:
  challenge_threshold: 3
needs_llm: false
implementation: Python 计数器 + 任务创建
```

### G3: 冲突检测（Conflict Detection）

```yaml
rule_id: G3
name: 冲突检测
trigger: 新 Entry 入库时，与同域已有 Entry 进行语义比对
action:
  - if has_conflict:
      if has_resolution_rule:
        apply_resolution_rule()
      else:
        mark_as: "conflict_pending"
        escalate_to: governance_committee
        sla_days: 7
resolution_hierarchy:
  # 跨层冲突：按层级优先级
  cross_layer: L2 > L3 > L1 > L4 > L5 > L6
  
  # 同层冲突：confidence_then_recency 策略
  same_layer:
    strategy: confidence_then_recency
    algorithm:
      step_1: "比较两条 Entry 的 confidence 值"
      step_2: "如果 confidence 差距 > 0.15，选择 confidence 更高的"
      step_3: "如果 confidence 差距 ≤ 0.15，比较 valid_from（更新的优先）"
      step_4: "如果 valid_from 相同，比较 evidence_count（证据更多的优先）"
      step_5: "如果以上均相同，标记为 true_conflict，需人工仲裁"
    
    # 同层冲突的特殊场景
    special_cases:
      - scenario: "L5 案例与 L2 战略矛盾"
        resolution: "标记为 strategic_drift，升级至治理委员会"
        rationale: "L5 案例可能揭示 L2 战略已过时或执行偏差"
      
      - scenario: "L6 宣称理论 vs 使用理论冲突"
        resolution: "以 theory_in_use 为准（见 orgcos-memory-char 定义）"
        rationale: "AI 应与实际行为模式保持一致"
      
      - scenario: "同一 owner 的两条 Entry 冲突"
        resolution: "以 version 更新的为准"
        rationale: "同一人的新观点覆盖旧观点"
      
      - scenario: "不同 owner 的 Entry 冲突且 confidence 相同"
        resolution: "按 owner 角色权威性排序（见下文 role_authority）"
        rationale: "角色权威性作为次要仲裁依据"

# 角色权威性排序（仅用于同层同 confidence 冲突的最终仲裁）
role_authority:
  - governance_committee  # 最高
  - c_level_executive
  - vp_director
  - senior_manager
  - manager
  - team_lead
  - individual_contributor
  - external_consultant   # 最低

needs_llm: true
implementation: LLM 语义分析两条 Context 是否矛盾
```

**LLM 判断逻辑：**
```
给定两条 Context Entry，判断它们对同一场景是否给出矛盾的指导意见。
- Entry A: {content}
- Entry B: {content}
- 判断维度：是否矛盾？矛盾程度（高/中/低）？建议仲裁方式？
```

**同层冲突解决示例：**

```
Entry A: confidence=0.80, valid_from=2026-08-01, evidence_count=5
Entry B: confidence=0.70, valid_from=2026-10-01, evidence_count=3

Step 1: confidence 差距 = 0.80 - 0.70 = 0.10
Step 2: 0.10 ≤ 0.15，进入 Step 3
Step 3: Entry B valid_from 更新，选择 Entry B

但如果：
Entry A: confidence=0.85, valid_from=2026-08-01
Entry B: confidence=0.70, valid_from=2026-10-01

Step 2: 0.15 > 0.15 不成立，但 0.85 > 0.70 明显，选择 Entry A
（实际实现中，confidence 差距 > 0.15 是主要判据）
```

**注意：** LLM 误判时，标记为"待人工确认"而非直接执行仲裁。

### G4: 覆盖率审计（Coverage Audit）

```yaml
rule_id: G4
name: 覆盖率审计
trigger: 定期扫描（默认季度）或手动触发
action:
  - scan_all_layers_and_domains()
  - calculate_coverage():
      per_layer: entry_count / expected_count
      per_domain: entry_count / expected_count
  - generate_gap_report:
      sorted_by: priority (P0 > P1 > P2)
      include: "缺少覆盖的层/域" + "建议优先补充的内容"
params:
  audit_frequency: quarterly
  coverage_targets:
    L1: 0.80
    L2: 0.60
    L3: 0.70
    L4: 0.60
    L5: 0.40  # 案例库需要长期积累
    L6: 0.50
needs_llm: partial  # 覆盖率计算纯代码，优先级排序用LLM
implementation: Python 统计 + LLM 排序建议
```

### G5: 一致性校验（Consistency Check）

```yaml
rule_id: G5
name: 一致性校验
trigger: 新 Entry 入库 + 定期扫描
action:
  - for each L3_entry:
      check_traceability_to_L2()
      if not_traceable:
        mark_as: pending_alignment
  - for each cross_layer_reference:
      verify_reference_valid()
      if invalid:
        mark_as: broken_reference
params:
  traceability_required:
    L3_to_L2: mandatory
    L5_to_L3: recommended
    L6_to_L5: optional
needs_llm: true
implementation: LLM 判断 L3 流程是否可追溯到 L2 战略规则
```

### G6: 知识新鲜度评估（Knowledge Freshness Assessment）

```yaml
rule_id: G6
name: 知识新鲜度评估
trigger: 定期扫描（默认月度）或手动触发
action:
  - for each entry:
      calculate_freshness_score()
      generate_freshness_report()
params:
  scoring_model: "weighted_composite"
  weights:
    age: 0.40
    challenge_frequency: 0.25
    evidence_currency: 0.20
    domain_volatility: 0.15
needs_llm: false
implementation: Python 加权计算
```

**新鲜度评分模型：**

新鲜度不是简单的"距离过期还有多久"，而是综合多个维度的加权评分：

```
freshness_score = w1 × age_score 
                + w2 × challenge_score 
                + w3 × evidence_score 
                + w4 × volatility_score
```

**各维度计算：**

| 维度 | 权重 | 计算方式 | 说明 |
|------|------|---------|------|
| `age_score` | 40% | `(valid_until - today) / (valid_until - valid_from)` | 剩余有效期占比 |
| `challenge_score` | 25% | `1 - (challenge_count / max_expected_challenges)` | 挑战频率（被频繁挑战说明可能过时） |
| `evidence_score` | 20% | `(today - last_evidence_update) / 365` | 证据的时效性（最近一次证据更新的距今时间） |
| `volatility_score` | 15% | 查表（见下文领域易变性分级） | 领域本身的易变程度 |

**领域易变性分级：**
```yaml
domain_volatility:
  low:      # 易变性低的领域，知识衰减速
    domains: [core_values, brand_identity, legal_compliance]
    decay_rate: 0.05  # 每年衰减 5%
  
  medium:   # 易变性中等的领域
    domains: [operational_processes, customer_segments, product_features]
    decay_rate: 0.15  # 每年衰减 15%
  
  high:     # 易变性高的领域
    domains: [technology_stack, market_trends, competitive_landscape]
    decay_rate: 0.30  # 每年衰减 30%
  
  very_high:  # 极快变化的领域
    domains: [regulatory_changes, emerging_markets, disruptive_technologies]
    decay_rate: 0.50  # 每年衰减 50%
```

**新鲜度等级：**
| 分数范围 | 等级 | 颜色标识 | 处理建议 |
|---------|------|---------|---------|
| 0.80-1.00 | 新鲜 | 🟢 绿色 | 正常使用，无需干预 |
| 0.60-0.79 | 良好 | 🔵 蓝色 | 正常使用，建议季度复核 |
| 0.40-0.59 | 老化 | 🟡 黄色 | 建议尽快复核，可能需更新 |
| 0.20-0.39 | 陈旧 | 🟠 橙色 | 必须立即复核，暂停用于关键决策 |
| 0.00-0.19 | 过期 | 🔴 红色 | 停止使用，等待更新或归档 |

**新鲜度报告输出：**
```json
{
  "report_id": "freshness-20261103",
  "generated_at": "2026-11-03T14:00:00+08:00",
  "summary": {
    "total_entries": 234,
    "fresh": 89,
    "good": 67,
    "aging": 42,
    "stale": 28,
    "expired": 8
  },
  "by_layer": {
    "L1": {"fresh": 35, "good": 20, "aging": 8, "stale": 2, "expired": 0},
    "L2": {"fresh": 12, "good": 18, "aging": 15, "stale": 8, "expired": 2},
    "L3": {"fresh": 20, "good": 15, "aging": 10, "stale": 12, "expired": 3},
    "L4": {"fresh": 15, "good": 10, "aging": 5, "stale": 4, "expired": 1},
    "L5": {"fresh": 5, "good": 3, "aging": 3, "stale": 2, "expired": 2},
    "L6": {"fresh": 2, "good": 1, "aging": 1, "stale": 0, "expired": 0}
  },
  "high_risk_entries": [
    {
      "entry_id": "ctx-L2-strategy-015",
      "freshness_score": 0.22,
      "risk_factors": [
        "age_score=0.10 (剩余有效期仅 2 个月)",
        "challenge_score=0.30 (已被挑战 4 次)",
        "volatility_score=0.40 (市场趋势领域，高易变)"
      ],
      "recommendation": "立即复核，考虑更新或归档"
    }
  ],
  "trends": {
    "improving": 15,
    "stable": 180,
    "declining": 39
  }
}
```

**与 G1 过期降权的关系：**
- G1 是硬规则：超过 `valid_until` 就强制降权
- G6 是软评估：在有效期内也能识别"虽然没过期但已经老化"的知识
- 两者互补：G6 可以提前预警，避免等到过期才发现问题

**实际应用场景：**
1. **决策支持：** 当 AI 系统引用 Context Entry 时，优先使用新鲜度 ≥ 0.60 的条目
2. **审计优先级：** 审计时优先复核新鲜度 < 0.40 的条目
3. **知识更新规划：** 基于新鲜度分布制定季度知识更新计划

## 治理报告输出

```json
{
  "report_id": "gov-audit-20261103",
  "audit_time": "2026-11-03T14:00:00+08:00",
  "summary": {
    "total_entries": 234,
    "passed": 198,
    "warnings": 28,
    "errors": 8
  },
  "rule_results": {
    "G1_expiration": { "affected": 12, "decayed": 8, "expired_critical": 2 },
    "G2_challenge": { "alerts_created": 3, "pending_review": 1 },
    "G3_conflict": { "conflicts_detected": 5, "resolved": 3, "pending": 2 },
    "G4_coverage": {
      "L1": 0.85, "L2": 0.72, "L3": 0.68,
      "L4": 0.55, "L5": 0.30, "L6": 0.45
    },
    "G5_consistency": { "pending_alignment": 7, "broken_references": 1 }
  },
  "recommendations": [
    { "priority": "high", "action": "L5 覆盖率仅 30%，建议启动 SECI 螺旋" },
    { "priority": "medium", "action": "8 条过期条目需要续期或归档" },
    { "priority": "medium", "action": "7 条 L3 流程缺乏 L2 战略追溯" }
  ]
}
```

## 输出目录

```
output/
└── governance/
    ├── audit-reports/
    │   └── gov-audit-{date}.json
    ├── validation-logs/
    │   └── validate-{date}.jsonl    # 逐条校验日志
    └── tasks/
        └── review-tasks.json        # G2 生成的审查任务
```

## Pitfalls

- G3 冲突检测的 LLM 误判率约 15-20%——始终将冲突结果标记为"待确认"
- G1 过期降权不要将 confidence 降至 0——min_confidence=0.1 确保信息仍可被搜索到
- G5 一致性校验的 L3→L2 追溯不要求 1:1 映射——多对多关系是正常的
- 审计模式不要过于频繁——季度审计足够，过于频繁会造成"审计疲劳"
- 治理规则参数可通过 T2 蓝图的 governance.override 调整，但 G1-G5 本身不可删除

## Verification

1. G1 时间计算精确到月（误差不超过 ±1 天）
2. G2 任务创建后 7 天内有响应
3. G3 误判率 < 25%（通过人工抽检 100 条验证）
4. G4 覆盖率计算结果与手动统计一致
5. G5 L3→L2 追溯结果通过 orgcos-validator 交叉验证
