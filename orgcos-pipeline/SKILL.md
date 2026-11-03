---
name: sloth-orgcos-pipeline-eido
description: "OrgCOS orchestration engine chaining all orgcos-* skills for end-to-end OrgCOS construction. Supports full-flow, resume-from-breakpoint, and single-phase execution modes with skill dispatch, error recovery, state management, and optional Feishu sync. Acts as the backend execution engine for orgcos-architect. Use when the user mentions OrgCOS full flow, one-click build, resume construction, or orchestration execution."
version: 1.0.0
description_zh: "OrgCOS 全流程编排引擎——串联所有 orgcos-* 技能完成端到端构建，含技能调度、错误恢复、状态管理和飞书同步。"
name_zh: "树懒 · 组织认知 · 编排"
---

# OrgCOS 全流程编排引擎


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

orgcos-pipeline 是 OrgCOS 技能家族的**后台编排引擎**——它不负责与用户交互（那是 orgcos-architect 的工作），而是负责技能调度、数据传递、错误恢复和状态管理。

**与 orgcos-architect 的关系：**
- orgcos-architect = 前台（用户交互、引导式问答、决策建议）
- orgcos-pipeline = 后台（技能调度、状态管理、错误恢复）

## 触发词

OrgCOS 全流程、一键构建、断点续建、编排执行、pipeline

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
  - name: orgcos-blueprint
    version: "^1.0.0"
  - name: orgcos-ontology
    version: "^1.0.0"
  - name: orgcos-strategy-ops
    version: "^1.0.0"
  - name: orgcos-memory-char
    version: "^1.0.0"
  - name: orgcos-governance
    version: "^1.0.0"
  - name: orgcos-seci
    version: "^1.0.0"
  - name: orgcos-validator
    version: "^1.0.0"
  - name: orgcos-api
    version: "^1.0.0"
  - name: orgcos-report
    version: "^1.0.0"
  note: "pipeline 是 architect 的后台执行引擎，两者为前台/后台协作关系，不构成循环依赖"
```

## 三种执行模式

### 模式 A：全流程

```yaml
mode: full
phases: [P0, P1, P2, P3, P4, P5, P6, P7]
behavior: 顺序执行，每个阶段结束后执行质量门禁
on_gate_fail: pause_and_notify
```

### 模式 B：断点续建

```yaml
mode: resume
project_state: output/project-state.json
behavior: 读取状态文件，从中断阶段继续
on_gate_fail: pause_and_notify
```

### 模式 C：单阶段

```yaml
mode: single_phase
target_phase: P3
behavior: 只执行指定阶段，跳过前后阶段
on_gate_fail: report_only
```

## 阶段编排详情

| 阶段 | 调度技能 | 输入 | 输出 | 门禁 |
|------|---------|------|------|------|
| P0 | orgcos-architect | 用户交互 | project-config.json | 配置完整 |
| P1 | orgcos-kernel | 配置 | schema/ | 内核完整 |
| P2 | orgcos-blueprint | 配置 + schema | blueprint/ | 兼容性 |
| P3 | orgcos-ontology | schema + blueprint | L1/ + L4/ | 覆盖率 ≥ 60% |
| P4 | orgcos-strategy-ops | L1 + L4 | L2/ + L3/ | 追溯率 ≥ 80% |
| P5 | orgcos-memory-char + orgcos-seci | L1-L4 | L5/ + L6/ | 案例数 ≥ 20 |
| P6 | orgcos-governance + orgcos-validator | all layers | governance/ | 无 Error |
| P7 | orgcos-report + orgcos-api | all data | reports/ + api/ | 报告生成 |

## 阶段间数据传递

```yaml
# 每个阶段的输出是下一阶段的输入
data_flow:
  P0_output: project-config.json
  P1_input: project-config.json
  P1_output: schema/

  P2_input: project-config.json + schema/
  P2_output: blueprint/

  P3_input: schema/ + blueprint/
  P3_output: L1-ontology/ + L4-semantics/

  P4_input: L1/ + L4/ + blueprint/
  P4_output: L2-strategy/ + L3-operations/

  P5_input: L1-L4/
  P5_output: L5-memory/ + L6-character/

  P6_input: all layers
  P6_output: governance/

  P7_input: all data
  P7_output: reports/ + api/
```

## 错误恢复策略

| 错误类型 | 恢复策略 |
|---------|---------|
| 子技能执行超时 | 记录超时日志，跳过该步骤，标记为 warning |
| 质量门禁未通过 | 暂停流程，等待用户修正，支持从当前阶段重启 |
| 数据格式错误 | 调用 kernel-validate 定位错误，提供修复建议 |
| 飞书同步失败 | 跳过同步步骤，记录错误，不影响主流程 |
| LLM API 失败 | 重试 3 次，间隔递增，仍失败则标记为手动处理 |
| 跨层事件传播失败 | 进入事件恢复流程（见下文） |

### 跨层事件传播失败恢复（Cross-Layer Event Propagation Failure Recovery）

**场景：** 当某层 Context Entry 发生变更时，需要通过 event bus 通知相关层的 Entry 进行级联更新。如果传播失败，需要有恢复机制。

**典型失败场景：**
1. L2 战略变更 → 通知 L3 流程更新 → L3 Entry owner 7 天内未响应
2. L4 术语定义变更 → 通知 L1/L2/L3 更新映射 → 部分 Entry 引用已删除的术语
3. L1 实体删除 → 通知所有层清理引用 → 某些 Entry 仍引用已删除实体（破损引用）

**事件传播失败类型：**

| 失败类型 | 定义 | 严重程度 | 恢复策略 |
|---------|------|---------|---------|
| `timeout` | 接收方未在 SLA 内响应 | 中 | 发送提醒，升级至 governance_committee |
| `broken_reference` | 引用的实体/术语已删除 | 高 | 立即标记 Entry 为 `broken`，暂停用于 AI 推理 |
| `conflict` | 级联更新导致与现有 Entry 冲突 | 高 | 调用 G3 冲突检测，按 conflict-hierarchy 解决 |
| `partial_propagation` | 部分接收方成功，部分失败 | 中 | 记录失败列表，重试 3 次后人工介入 |

**恢复流程（4 步）：**

```
Step 1: 失败检测 → Step 2: 影响评估 → Step 3: 恢复执行 → Step 4: 验证确认
```

**Step 1: 失败检测**
```python
# 监听 event bus 的 ACK/NACK
event_result = event_bus.wait_for_ack(event_id, timeout=sla_days)
if event_result.status == "timeout" or event_result.status == "nack":
    trigger_recovery(event_id, event_result)
```

**Step 2: 影响评估**
```json
{
  "event_id": "EVT-20261103-001",
  "event_type": "STRATEGY_CHANGE",
  "source_entry": "ctx-L2-strategy-015",
  "propagation_status": {
    "total_targets": 12,
    "acknowledged": 8,
    "timeout": 3,
    "nack": 1,
    "failed_targets": [
      {"entry_id": "ctx-L3-ops-023", "reason": "timeout", "owner": "运营总监"},
      {"entry_id": "ctx-L3-ops-045", "reason": "timeout", "owner": "生产经理"},
      {"entry_id": "ctx-L5-project-012", "reason": "nack", "owner": "项目经理", "nack_reason": "该案例已归档，无需更新"}
    ]
  },
  "impact_assessment": {
    "severity": "medium",
    "affected_layers": ["L3", "L5"],
    "business_impact": "2 条 L3 流程可能仍引用过时的战略规则"
  }
}
```

**Step 3: 恢复执行**

根据失败类型选择恢复策略：

```yaml
recovery_strategies:
  timeout:
    - action: "send_reminder"
      target: owner
      message: "您的 Entry {entry_id} 需要响应战略变更 {event_id}，SLA 已超期"
      channel: [email, feishu, sms]
    - action: "escalate_if_no_response"
      condition: "reminder 发送后 3 天仍无响应"
      escalate_to: governance_committee
      sla_days: 2
  
  broken_reference:
    - action: "mark_as_broken"
      entry_status: "broken_reference"
      block_ai_usage: true  # 暂停用于 AI 推理
    - action: "create_fix_task"
      assignee: owner
      priority: high
      sla_days: 3
      message: "Entry {entry_id} 引用了已删除的实体 {ref_id}，请修复引用或归档"
  
  conflict:
    - action: "invoke_governance_g3"
      use_resolution_hierarchy: true
    - action: "if_unresolvable"
      escalate_to: governance_committee
      include: ["source_entry", "target_entry", "conflict_details"]
  
  partial_propagation:
    - action: "retry_failed_targets"
      max_retries: 3
      retry_interval: [1day, 3days, 7days]
    - action: "if_still_fails"
      mark_as: "propagation_incomplete"
      notify: governance_committee
```

**Step 4: 验证确认**

恢复操作完成后：
```python
# 验证所有失败目标已处理
remaining_failures = check_propagation_status(event_id)
if remaining_failures == 0:
    mark_event_as_resolved(event_id)
    update_governance_dashboard()
else:
    escalate_to_manual_intervention(remaining_failures)
```

**事件恢复日志：**
```json
{
  "event_id": "EVT-20261103-001",
  "recovery_log": [
    {
      "timestamp": "2026-11-03T14:00:00+08:00",
      "action": "send_reminder",
      "target": "ctx-L3-ops-023",
      "result": "owner_responded",
      "resolution": "owner 确认已更新 L3 流程以匹配新战略"
    },
    {
      "timestamp": "2026-11-03T14:00:00+08:00",
      "action": "send_reminder",
      "target": "ctx-L3-ops-045",
      "result": "escalated",
      "resolution": "owner 7 天未响应，已升级至治理委员会"
    },
    {
      "timestamp": "2026-11-03T14:00:00+08:00",
      "action": "accept_nack",
      "target": "ctx-L5-project-012",
      "result": "acknowledged",
      "resolution": "NACK 理由合理（案例已归档），无需进一步处理"
    }
  ],
  "final_status": "partially_resolved",
  "pending_items": 1
}
```

**预防措施：**
1. **事件订阅验证：** 在发布事件前，验证所有潜在接收方的订阅关系是否有效
2. **SLA 提醒：** 在 SLA 到期前 2 天发送提醒，避免超时
3. **引用完整性检查：** 在删除实体前，扫描所有层的引用关系，提前预警
4. **事件幂等性：** 确保事件可以安全重发，不会导致重复处理

## 飞书同步（可选）

如果配置了飞书应用凭证，P7 结束后可自动同步到飞书多维表格：

```yaml
feishu_sync:
  enabled: true
  app_id: ${FEISHU_APP_ID}
  app_secret: ${FEISHU_APP_SECRET}
  bitable_id: ${BITABLE_ID}
  sync_mode: incremental   # full / incremental
```

## 状态管理

每个执行阶段更新 `project-state.json`：

```json
{
  "pipeline_run": {
    "run_id": "run-20261103-001",
    "mode": "full",
    "started_at": "2026-11-03T10:00:00+08:00",
    "current_phase": "P4",
    "phase_log": [
      { "phase": "P0", "status": "completed", "duration_min": 15 },
      { "phase": "P1", "status": "completed", "duration_min": 2 },
      { "phase": "P2", "status": "completed", "duration_min": 5 },
      { "phase": "P3", "status": "completed", "duration_min": 120, "gate": "passed" },
      { "phase": "P4", "status": "in_progress", "started_at": "..." }
    ]
  }
}
```

## 输出目录

```
output/
├── project-config.json
├── project-state.json
├── pipeline-log.jsonl           # 执行日志（逐行 JSON）
├── schema/                      # P1
├── blueprint/                   # P2
├── L1-ontology/                 # P3
├── L4-semantics/                # P3
├── L2-strategy/                 # P4
├── L3-operations/               # P4
├── L5-memory/                   # P5
├── L6-character/                # P5
├── governance/                  # P6
├── api/                         # P7
└── reports/                     # P7
```

## Pitfalls

- pipeline 不应该自行修复数据质量问题——那是用户和子技能的责任
- 断点续建时必须先验证已完成阶段的数据是否仍然有效
- 飞书同步失败不应阻塞主流程——同步是可选的附加步骤
- 执行日志要足够详细，以便排查问题——每个技能调用的输入/输出/耗时都要记录
- 不要在全流程模式中跳过质量门禁——即使"条件通过"也要记录

## Verification

1. 全流程模式能完成 P0-P7 所有阶段
2. 断点续建能从任意阶段正确恢复
3. 单阶段模式只执行指定阶段
4. 错误恢复策略按预期工作
5. project-state.json 在每个阶段切换时正确更新
6. 执行日志完整记录每个步骤
