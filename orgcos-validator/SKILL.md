---
name: sloth-orgcos-validator-eido
description: "OrgCOS quality validation tool performing triple-dimension checks (completeness, consistency, accuracy) across all layers, generating quality reports with actionable fix suggestions. Supports phase quality gates (dispatched by orgcos-architect) and standalone audits (manually triggered). Use when the user mentions quality check, consistency validation, completeness verification, OrgCOS audit, or quality gate."
version: 1.0.0
description_zh: "OrgCOS 质量验证工具——执行跨层完整性、一致性、准确性三重校验，生成质量报告和可操作修复建议。"
name_zh: "树懒 · 组织认知 · 质检"
---

# OrgCOS 质量验证工具


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

质量验证器是 OrgCOS 技能家族的**质量守门人**——它在每个阶段结束后执行质量门禁，确保数据质量达标后才进入下一阶段。

**与 orgcos-governance 的区别：**
- governance 关注单条 Entry 的治理元数据和规则执行
- validator 关注全局视角的跨层一致性、完整性和整体质量

## 触发词

质量检查、一致性校验、完整性验证、OrgCOS 审计、质量门禁、quality gate、质量报告

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
  - name: orgcos-governance
    version: "^1.0.0"
    note: 调用治理引擎获取规则执行结果
```

## 三重校验维度

### 维度一：完整性（Completeness）

检查 OrgCOS 各层各域是否有足够的 Context Entry 覆盖。

```yaml
completeness_checks:
  - check: layer_coverage
    description: "各层 Entry 数量是否达到最低覆盖率"
    thresholds:
      L1: 0.80    # 本体层要求最高
      L2: 0.60
      L3: 0.70
      L4: 0.60
      L5: 0.40    # 案例库需要长期积累
      L6: 0.50
    severity: warning

  - check: domain_coverage
    description: "每个业务域是否都有 Entry"
    method: "检查 P0 优先级实体是否全部建模"
    severity: warning

  - check: mandatory_fields
    description: "所有 Entry 的必填治理元数据是否完整"
    fields: [owner, modifier, valid_from, valid_until, confidence, version, source]
    severity: error
```

### 维度二：一致性（Consistency）

检查跨层引用是否有效、战略传导链是否完整。

```yaml
consistency_checks:
  - check: strategy_traceability
    description: "L3 流程是否可追溯到 L2 战略"
    method: "对每条 L3 Entry，检查是否有 related_decisions 字段指向 L2 Entry"
    threshold: 0.80    # 80% 追溯率
    severity: error

  - check: cross_layer_references
    description: "跨层引用是否指向有效的 Entry"
    method: "检查所有 related_entities / related_decisions 引用是否存在且有效"
    severity: error

  - check: term_consistency
    description: "同一术语在不同层的定义是否一致"
    method: "LLM 语义比对 L4 术语定义与其他层使用的一致性"
    severity: warning

  - check: entity_relation_integrity
    description: "关系两端的实体是否都存在"
    method: "图遍历检查孤立关系"
    severity: error
```

### 维度三：准确性（Accuracy）

检查治理元数据质量、confidence 分布合理性。

```yaml
accuracy_checks:
  - check: confidence_distribution
    description: "confidence 分布是否合理"
    rules:
      - "不应有 > 30% 的 Entry confidence > 0.9（过度自信）"
      - "不应有 > 20% 的 Entry confidence < 0.3（低质量过多）"
    severity: warning

  - check: expired_entries
    description: "过期 Entry 占比"
    threshold: 0.15    # 不超过 15% 过期
    severity: warning

  - check: evidence_adequacy
    description: "高 confidence Entry 是否有足够证据支撑"
    rule: "confidence > 0.8 的 Entry，evidence_count 应 ≥ 2"
    severity: warning

  - check: anti_patterns
    description: "反模式检测"
    patterns:
      - name: "god_entity"
        description: "单个实体属性 > 15 个"
        severity: warning
      - name: "island_layer"
        description: "某层与其他层无任何关联"
        severity: error
      - name: "zombie_entry"
        description: "confidence < 0.2 且 6 个月未更新"
        severity: warning
      - name: "strategy_orphan"
        description: "L3 流程无法追溯到 L2 战略"
        severity: warning
```

## 质量门禁标准

| 档次 | 条件 | 处理 |
|------|------|------|
| **通过** | 完整性 ≥ 80%，一致性 ≥ 90%，无 Error | 进入下一阶段 |
| **条件通过** | 完整性 ≥ 60%，无 Error | 记录 Warning，继续执行 |
| **未通过** | 完整性 < 60% 或存在 Error | 暂停，要求用户修正 |

## 质量报告输出

```json
{
  "report_id": "qa-20261103-P3",
  "phase": "P3",
  "timestamp": "2026-11-03T14:30:00+08:00",
  "verdict": "conditional_pass",
  "summary": {
    "completeness": { "score": 0.75, "status": "warning" },
    "consistency": { "score": 0.92, "status": "pass" },
    "accuracy": { "score": 0.85, "status": "pass" }
  },
  "errors": [],
  "warnings": [
    {
      "check": "layer_coverage",
      "detail": "L4 语义层覆盖率 55%，低于目标 60%",
      "suggestion": "建议补充 3-5 个跨系统术语映射"
    },
    {
      "check": "anti_patterns",
      "detail": "检测到 1 个 God Entity：Customer（18 个属性）",
      "suggestion": "建议拆分为 Customer + CustomerProfile 两个实体"
    }
  ],
  "statistics": {
    "total_entries": 67,
    "by_layer": { "L1": 35, "L2": 8, "L3": 5, "L4": 12, "L5": 5, "L6": 2 },
    "avg_confidence": 0.72,
    "expired_count": 3,
    "anti_pattern_count": 1
  }
}
```

## 输出目录

```
output/
└── governance/
    └── qa-reports/
        ├── qa-{date}-P{phase}.json     # 阶段质量门禁报告
        └── qa-{date}-final.json        # 最终质量报告
```

## Pitfalls

- 质量门禁"条件通过"不等于"没问题"——Warning 必须在最终报告中标注
- 不要把覆盖率目标设得太高——L5 案例库 40% 就足够，因为案例需要长期积累
- 反模式检测是"建议"而非"错误"——有些"God Entity"可能是合理的
- 质量报告应该对非技术用户可读——避免使用过于技术化的术语

## Verification

1. 质量报告 JSON 格式通过 Schema 校验
2. 门禁判定（pass/conditional_pass/fail）逻辑正确
3. 统计数据与实际 Entry 数量一致
4. 修复建议具有可操作性（不空泛）
