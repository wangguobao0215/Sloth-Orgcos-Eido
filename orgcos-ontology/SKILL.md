---
name: sloth-orgcos-ontology-eido
description: "OrgCOS L1 Ontology + L4 Semantics collection skill for enterprise entity-relation modeling and cross-system terminology alignment. Covers a 6-step workflow: business capability mapping, entity discovery, relation modeling, terminology harvesting, cross-system mapping, and disambiguation confirmation. Compatible with ontology-architect legacy data import. Use when the user mentions ontology modeling, entity relations, terminology alignment, semantic layer, or concept model."
version: 1.0.0
description_zh: "OrgCOS L1 本体层 + L4 语义层采集——企业实体关系建模与跨系统术语语义对齐，含六步流程和旧数据兼容导入。"
name_zh: "树懒 · 组织认知 · 本体"
---

# OrgCOS L1 本体层 + L4 语义层


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

本技能负责 OrgCOS 六层架构中两个基础设施层的上下文采集：

- **L1 本体层**：回答"企业和世界中存在哪些实体？它们之间是什么关系？"
- **L4 语义层**：回答"我们使用的术语到底是什么意思？同一个词在不同系统中含义一样吗？"

L1 和 L4 合并的原因：语义映射必须基于本体定义，本体定义需要语义映射来消除歧义。两者紧密耦合，减少数据传递成本。

## 触发词

本体建模、实体关系建模、术语对齐、语义层、概念模型、能力地图、跨系统术语、语义消歧

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
    imports:
      - schema/context-entry.schema.json
      - entity-relation/entities.yaml
      - entity-relation/relations.yaml
```

## 采集流程（6 步）

```
L1-1 业务能力地图 → L1-2 实体发现 → L1-3 关系建模
→ L4-1 术语采集 → L4-2 跨系统映射 → L4-3 消歧确认
```

### L1-1: 业务能力地图

**目标：** 梳理企业的核心业务能力，作为实体发现的框架。

**方法：**
1. 引导用户列出企业的一级业务能力（通常 8-15 个）
2. 对每个能力分解二级子能力
3. 标注能力的战略重要性（核心 / 支撑 / 通用）
4. 标注能力的成熟度（领先 / 合格 / 待提升）

**输出：** `output/L1-ontology/capability-map.json`

### L1-2: 实体发现

**目标：** 在每个业务能力域下发现关键实体。

**方法：**
1. 以 T1 内核的 10 类通用实体为基线
2. 通过行业蓝图加载行业特有实体（如制造业的 WorkOrder、BOM）
3. 引导用户发现企业特有实体
4. 为每个实体定义核心属性（≥ 3 个）

**实体分类优先级：**
- P0：3+ 应用共享的实体（最先建模）
- P1：2 个应用共享的实体
- P2：单一应用内的实体

**输出：** `output/L1-ontology/entities.json`

### L1-3: 关系建模

**目标：** 定义实体之间的关系。

**方法：**
1. 以 T1 内核的 7 类通用关系为基线
2. 发现行业特有关系（如制造业的 PRODUCES、CONSUMES）
3. 标注关系的基数（1:1 / 1:N / N:M）
4. 标注关系的方向性和可选性

**输出：** `output/L1-ontology/relations.json`

### L4-1: 术语采集

**目标：** 收集企业内部的关键业务术语及其定义。

**方法：**
1. 从已发现的实体和属性中提取术语
2. 引导用户定义每个术语的标准含义
3. 收集同义词和近义词
4. 标注术语的歧义风险等级

**输出：** `output/L4-semantics/terms.json`

### L4-2: 跨系统映射

**目标：** 映射同一术语在不同 IT 系统中的实现。

**方法：**
1. 列出企业使用的主要 IT 系统（CRM、ERP、HR 等）
2. 对每个关键术语，标注在各系统中的字段名和含义
3. 识别含义不一致的术语

**输出：** `output/L4-semantics/cross-system-mapping.json`

### L4-3: 消歧确认

**目标：** 解决术语歧义，达成语义共识。

**方法：**
1. 展示歧义术语列表
2. 引导用户确认标准定义
3. 记录各系统的映射关系
4. 生成消歧决策记录

**输出：** `output/L4-semantics/disambiguation.json`

### L4-4: 术语变更审批流程（Term Change Approval Workflow）

**目标：** 确保术语定义的变更经过充分评估和审批，避免"静默漂移"导致跨系统理解不一致。

**触发条件：**
- 用户修改已有术语的 `standard_definition`
- 用户删除术语的某个 `system_mapping`
- 用户将术语的 `ambiguity_risk` 从 low/medium 改为 high

**审批流程（4 步）：**

```
Step 1: 变更申请 → Step 2: 影响评估 → Step 3: 审批决策 → Step 4: 通知传播
```

**Step 1: 变更申请**
```json
{
  "change_request_id": "CR-L4-20261103-001",
  "term": "大客户",
  "change_type": "definition_update",
  "old_value": "年合同金额 ≥ 500 万 或 战略级客户",
  "new_value": "年合同金额 ≥ 300 万 或 战略级客户或行业头部",
  "requested_by": {"role": "销售运营总监", "name": "..."},
  "rationale": "市场下行，降低金额门槛以扩大客户池",
  "timestamp": "2026-11-03T10:00:00+08:00"
}
```

**Step 2: 影响评估**

自动分析变更的影响范围：
```json
{
  "impact_assessment": {
    "affected_systems": ["CRM", "ERP", "BI报表"],
    "affected_entries": 23,  // 引用该术语的其他 Context Entry
    "affected_layers": ["L1", "L2", "L3"],
    "breaking_change": true,  // 是否破坏现有逻辑
    "risk_level": "high",
    "downstream_effects": [
      "CRM 客户分级规则需更新（S级门槛从 500万降至 300万）",
      "BI 报表中的'大客户营收占比'历史数据需重新计算",
      "L2 战略决策 D-001 的'大客户聚焦'定义需确认是否调整"
    ]
  }
}
```

**Step 3: 审批决策**

根据风险等级决定审批角色：
| 风险等级 | 审批角色 | SLA |
|---------|---------|-----|
| low | 数据治理负责人 | 2 天 |
| medium | 数据治理委员会 | 5 天 |
| high | CTO + 数据治理委员会 | 7 天 |

**审批结果：**
- **approved**：执行变更，更新所有受影响的 Entry
- **rejected**：拒绝变更，记录原因
- **conditional**：批准但附加条件（如"需同步更新 BI 报表逻辑"）

**Step 4: 通知传播**

变更批准后：
1. 更新 L4 术语条目，version +1
2. 通过 event bus 发布 `TERM_CHANGE` 事件（见 orgcos-kernel protocol/event-types.yaml）
3. 通知所有受影响 Entry 的 owner，要求 7 天内确认或修订
4. 更新 `output/L4-semantics/change-log.json`

**变更日志示例：**
```json
{
  "change_id": "CR-L4-20261103-001",
  "term": "大客户",
  "approved_at": "2026-11-05T14:00:00+08:00",
  "approved_by": "数据治理委员会",
  "propagation_status": {
    "notified_entries": 23,
    "confirmed_within_sla": 18,
    "pending_confirmation": 5,
    "escalated_to_governance": 0
  }
}
```

## Context Entry 示例

### L1 实体条目
```json
{
  "entry_id": "ctx-L1-crm-001",
  "layer": "L1",
  "type": "entity",
  "domain": "crm",
  "content": {
    "entity_type": "Customer",
    "name": "客户",
    "attributes": [
      { "name": "name", "type": "string", "required": true },
      { "name": "tier", "type": "enum", "values": ["S", "A", "B", "C"] },
      { "name": "industry", "type": "string" },
      { "name": "production_capacity", "type": "string", "note": "制造业扩展" }
    ],
    "priority": "P0"
  },
  "governance": {
    "owner": { "role": "CRM产品负责人", "name": "..." },
    "modifier": [{ "role": "CRM产品负责人", "name": "..." }],
    "valid_from": "2026-11-03",
    "valid_until": "2027-11-03",
    "confidence": 0.85,
    "evidence_count": 3,
    "version": "1.0.0",
    "changelog": [],
    "source": "workshop"
  }
}
```

### L4 术语条目
```json
{
  "entry_id": "ctx-L4-crm-001",
  "layer": "L4",
  "type": "term",
  "domain": "crm",
  "content": {
    "term": "大客户",
    "standard_definition": "年合同金额 ≥ 500 万 或 战略级客户",
    "synonyms": ["KA", "战略客户", "VIP客户"],
    "system_mappings": [
      { "system": "CRM", "field": "customer_tier", "value": "S" },
      { "system": "ERP", "field": "customer_group", "value": "KEY_ACCOUNT" }
    ],
    "ambiguity_risk": "medium",
    "disambiguation_note": "CRM 中 KA 包含 A 级潜力客户，ERP 中仅指已签约大客户"
  },
  "governance": {
    "owner": { "role": "数据治理负责人", "name": "..." },
    "modifier": [{ "role": "数据治理负责人", "name": "..." }],
    "valid_from": "2026-11-03",
    "valid_until": "2027-11-03",
    "confidence": 0.90,
    "evidence_count": 2,
    "version": "1.0.0",
    "changelog": [],
    "source": "workshop"
  }
}
```

## 兼容模式

支持从 ontology-architect v2.x 导入旧数据：

```bash
# 导入旧格式本体数据
orgcos-ontology --import-legacy path/to/old-ontology/output/json/
```

导入时自动执行：
1. 将旧 JSON 格式转换为新的 Context Entry 结构
2. 补充缺失的治理元数据字段（owner/valid_from/confidence 需用户确认）
3. 校验转换后的数据符合 T1 内核约束

### 架构迁移脚本详细说明

**迁移脚本位置：** `scripts/migrate_from_architect.py`

**迁移流程（5 步）：**

```
Step 1: 扫描旧数据 → Step 2: 结构转换 → Step 3: 元数据补全
→ Step 4: T1 内核校验 → Step 5: 生成迁移报告
```

**Step 1: 扫描旧数据**
```python
# 扫描 ontology-architect 的输出目录
legacy_data = scan_legacy_dir("path/to/old-ontology/output/json/")
# 识别文件类型：entities.json / relations.json / terms.json / mappings.json
```

**Step 2: 结构转换**
```python
# 旧格式 → Context Entry 格式的字段映射
field_mapping = {
    # 旧字段 → 新字段
    "entity_name": "content.name",
    "entity_type": "content.entity_type",
    "attributes": "content.attributes",
    "description": "content.description",
    
    # 新增字段（需默认值）
    "layer": "L1",  # 或 L4
    "type": "entity",  # 或 term/relation
    "domain": extract_domain(filename),
    
    # 治理元数据（需用户确认）
    "governance.owner": "待确认",
    "governance.valid_from": today(),
    "governance.confidence": 0.5,  # 保守默认值
    "governance.version": "1.0.0"
}
```

**Step 3: 元数据补全**

对于缺失的治理字段，迁移脚本会：
1. 生成 `migration-pending.json`，列出所有需用户确认的字段
2. 提供交互式补全界面或批量导入 CSV
3. 记录补全来源（`source: "migration_inferred"` 或 `"migration_confirmed"`）

**Step 4: T1 内核校验**
```python
# 调用 orgcos-kernel 的校验器
validation_result = kernel_validate(converted_entries)
if validation_result.errors > 0:
    print(f"迁移失败：{validation_result.errors} 个校验错误")
    # 生成错误报告，不写入 output/
else:
    write_to_output(converted_entries)
```

**Step 5: 生成迁移报告**
```json
{
  "migration_id": "mig-20261103-001",
  "source": "ontology-architect v2.3.1",
  "timestamp": "2026-11-03T14:00:00+08:00",
  "summary": {
    "entities_migrated": 45,
    "relations_migrated": 78,
    "terms_migrated": 120,
    "warnings": 12,
    "errors": 0
  },
  "pending_confirmations": [
    {"entry_id": "ctx-L1-crm-001", "field": "owner", "suggested": "CRM产品负责人"},
    {"entry_id": "ctx-L4-hr-005", "field": "confidence", "suggested": 0.7}
  ],
  "rollback_command": "orgcos-ontology --rollback mig-20261103-001"
}
```

**回滚策略：**
```bash
# 如果迁移后发现问题，可回滚到迁移前状态
orgcos-ontology --rollback mig-20261103-001
```

回滚操作：
1. 删除本次迁移写入的所有 Context Entry
2. 恢复 output/ 目录到迁移前快照（需提前备份）
3. 记录回滚日志到 `migration-rollback.log`

**迁移验证清单：**
- [ ] 所有迁移的 Entry 通过 kernel-validate
- [ ] 治理元数据的 owner 字段已全部确认
- [ ] confidence 值已根据数据质量调整（旧数据不应默认 1.0）
- [ ] 跨层引用（L1→L4、L4→L1）已正确建立
- [ ] 迁移报告已归档到 `output/migration/`

## 输出目录

```
output/
├── L1-ontology/
│   ├── capability-map.json
│   ├── entities.json
│   ├── relations.json
│   └── neo4j-init.cypher        # Neo4j 初始化脚本
└── L4-semantics/
    ├── terms.json
    ├── cross-system-mapping.json
    └── disambiguation.json
```

## Pitfalls

- 不要试图一次性穷举所有实体——按 P0/P1/P2 优先级分批建模
- 实体属性不要超过 15 个（"上帝实体"是反模式），拆分为关联实体
- L4 术语映射不要只采集"标准定义"，必须采集"各系统中的实际含义"
- confidence 初始值不应 > 0.9——新采集的实体需要实践验证

## Verification

1. 所有 Context Entry 通过 orgcos-kernel 的 `kernel-validate` 校验
2. 12 字段治理元数据完整（6 个必填字段无缺失）
3. P0 实体覆盖率 ≥ 80%（参照行业蓝图基准）
4. 术语歧义列表已全部标记处理状态（已消歧 / 待确认 / 接受歧义）
