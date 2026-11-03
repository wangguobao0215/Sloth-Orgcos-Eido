---
name: sloth-orgcos-kernel-eido
description: "OrgCOS T1 Universal Kernel defining the immutable core constraint set for the Organizational Cognitive Operating System: Schema Registry (Context Entry + 12-field governance metadata), Entity-Relation Standard (10 universal entity types, 7 relation types), Governance Engine (5 auto-governance rules G1-G5), Cross-Layer Coordination Protocol, and AI Consumption API Gateway (4 standard endpoints). Use when building or extending any orgcos-* skill, as all other skills depend on this kernel."
version: 1.0.0
description_zh: "OrgCOS T1 通用内核——定义组织认知操作系统不可修改的核心约束集，含 Schema 注册表、实体关系标准、治理引擎、跨层协调协议和 AI 消费 API 网关。"
name_zh: "树懒 · 组织认知 · 内核"
---

# OrgCOS T1 通用内核


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

OrgCOS T1 通用内核是整个组织认知操作系统的"宪法"——定义了所有层级、所有技能必须遵守的约束集。
T1 内核约占 OrgCOS 整体设计的 95-98% 通用性，不随行业或企业变化。

**本技能不直接被用户触发**，而是被其他 orgcos-* 技能作为依赖调用。

## 核心输出

本技能提供以下标准化定义文件，供其他技能引用：

```
kernel/
├── schema/                    # E0: Schema Registry
│   ├── context-entry.schema.json    # Context Entry 通用结构
│   ├── governance-meta.schema.json  # 12 字段治理元数据 JSON Schema
│   ├── layer-schemas/               # L1-L6 各层类型定义
│   │   ├── L1-ontology.json
│   │   ├── L2-strategy.json
│   │   ├── L3-operations.json
│   │   ├── L4-semantics.json
│   │   ├── L5-memory.json
│   │   └── L6-character.json
│   └── extension-points.yaml        # 4 类扩展点定义
├── entity-relation/           # E1: 实体关系标准
│   ├── entities.yaml                # 10 类通用实体定义
│   ├── relations.yaml               # 7 类通用关系定义
│   └── neo4j-constraints.cypher     # Neo4j 约束语句
├── governance/                # E2: 治理引擎规则定义
│   ├── rules.yaml                   # G1-G5 五条规则定义
│   └── conflict-hierarchy.yaml      # 冲突仲裁优先级
├── seci/                      # E3: SECI 标准定义
│   ├── spiral-definition.yaml       # 8 周螺旋定义
│   ├── mode-toolkits/               # 4 模式标准工具包
│   │   ├── socialization.yaml
│   │   ├── externalization.yaml
│   │   ├── combination.yaml
│   │   └── internalization.yaml
│   └── interview-templates/         # 5 类访谈模板
│       ├── strategic-tradeoff.yaml
│       ├── process-truth.yaml
│       ├── failure-retrospective.yaml
│       ├── org-character.yaml
│       └── semantic-alignment.yaml
├── protocol/                  # E4: 跨层协调协议
│   ├── event-types.yaml             # 8 类事件类型
│   ├── propagation-rules.yaml       # 传播规则
│   └── consistency-rules.yaml       # 一致性校验规则
└── api/                       # E5: AI 消费 API 规范
    ├── openapi.yaml                 # OpenAPI 3.0 规范
    ├── graph-query.yaml
    ├── term-resolve.yaml
    ├── semantic-search.yaml
    └── context-assemble.yaml
```

## E0: Schema Registry

### Context Entry 通用结构

所有 Context Entry（上下文条目）必须遵循以下结构：

```json
{
  "entry_id": "ctx-{layer}-{domain}-{seq}",
  "layer": "L1|L2|L3|L4|L5|L6",
  "type": "entity|relation|process|term|case|trait|rule|decision",
  "domain": "string",
  "content": {},
  "governance": {
    "owner": { "role": "string", "name": "string" },
    "modifier": [{ "role": "string", "name": "string" }],
    "valid_from": "YYYY-MM-DD",
    "valid_until": "YYYY-MM-DD | event:string",
    "confidence": 0.0-1.0,
    "evidence_count": 0,
    "conflict_resolution": "rule-ref | null",
    "version": "semver",
    "changelog": [],
    "source": "workshop|survey|system_log|document|interview",
    "last_challenged": "YYYY-MM-DD | null",
    "challenge_count": 0
  }
}
```

### 12 字段治理元数据

| # | 字段 | 类型 | 必填 | 说明 |
|---|------|------|------|------|
| 1 | owner | RoleRef | 是 | 准确性负责人 |
| 2 | modifier | RoleRef[] | 是 | 修改权限人（≥1） |
| 3 | valid_from | Date | 是 | 生效日期 |
| 4 | valid_until | Date/Event | 是 | 过期日期或触发事件 |
| 5 | confidence | Float 0-1 | 是 | 可信度评分 |
| 6 | evidence_count | Integer | 否 | 支撑证据数量 |
| 7 | conflict_resolution | RuleRef | 否 | 冲突仲裁规则 |
| 8 | version | SemVer | 是 | 版本号（自增） |
| 9 | changelog | ChangeEntry[] | 自动 | 变更历史 |
| 10 | source | Enum | 是 | 数据来源类型 |
| 11 | last_challenged | Date | 否 | 最近被质疑日期 |
| 12 | challenge_count | Integer | 否 | 被质疑次数 |

## E1: 实体关系标准

### 10 类通用实体

| 实体 | 说明 | 通用属性 |
|------|------|---------|
| Enterprise | 企业 | name, industry, scale, stage |
| OrgUnit | 组织单元 | name, type, parent_ref |
| Role | 角色 | title, responsibilities, authority_scope |
| Person | 人员 | name, expertise, tenure |
| Customer | 客户 | name, tier, industry, relationship_depth |
| Product | 产品/服务 | name, category, lifecycle_stage |
| Partner | 合作伙伴 | name, partnership_type, strategic_value |
| Competitor | 竞争对手 | name, threat_level, differentiation |
| Market | 市场 | name, size, growth_rate, maturity |
| Capability | 能力 | name, maturity_level, strategic_importance |

### 7 类通用关系

| 关系 | 方向 | 说明 |
|------|------|------|
| BELONGS_TO | Entity → OrgUnit | 归属关系 |
| REPORTS_TO | Person/Role → Person/Role | 汇报关系 |
| HAS_ROLE | Person → Role | 角色分配 |
| COMPETES_WITH | Enterprise → Enterprise | 竞争关系 |
| SUPPLIES | Enterprise → Enterprise | 供应关系 |
| OPERATES_IN | Enterprise → Market | 市场参与 |
| INFLUENCES | Entity → Entity | 影响关系 |

## E2: 治理规则

### 5 条自动治理规则

| 规则 | 名称 | 触发条件 | 自动行为 | LLM 依赖 |
|------|------|---------|---------|---------|
| G1 | 过期降权 | NOW > valid_until 且未续期 | confidence 每月衰减 decay_rate(默认0.1) | 否 |
| G2 | 挑战预警 | challenge_count ≥ 3 且未修改 | 自动创建审查任务给 owner | 否 |
| G3 | 冲突检测 | 两条 Entry 对同一场景给出矛盾指导 | 按 conflict_resolution 仲裁，无规则则上报 | 是 |
| G4 | 覆盖率审计 | 定期扫描（季度） | 生成"上下文缺口报告" | 部分 |
| G5 | 一致性校验 | 新 Entry 入库 + 定期 | 检查 L3 是否可追溯到 L2 战略规则 | 是 |

### 冲突仲裁默认优先级

L2 战略 > L3 运作 > L1 本体 > L4 语义 > L5 记忆 > L6 性格

同层冲突：confidence 高者胜 → 时间新者胜 → 不可仲裁则上报治理委员会（7 天 SLA）。

## E3: SECI 标准定义

### 季度 8 周螺旋

| 阶段 | 周次 | 模式 | 转化方向 | 核心活动 |
|------|------|------|---------|---------|
| S | 1-2 | 社会化 | 隐性→隐性 | 协作网络分析、行为观察、ONA 问卷 |
| E | 3-4 | 外化 | 隐性→显性 | 结构化访谈、专家决策模式采集 |
| C | 5-6 | 组合化 | 显性→显性 | 知识图谱整合、关系建议、战略对齐 |
| I | 7-8 | 内化 | 显性→隐性 | Few-shot 生成、Prompt 编译、RAG 索引重建 |

### 5 类标准访谈

1. **战略取舍访谈**（L2）：聚焦"选择做什么/不做什么"
2. **流程真相访谈**（L3）：聚焦"实际怎么做"vs"制度规定怎么做"
3. **失败复盘访谈**（L5）：聚焦"从失败中学到什么"
4. **组织性格访谈**（L6）：聚焦"我们的行为风格是什么"
5. **语义对齐访谈**（L4）：聚焦"同一个词在不同系统中的含义"

每类访谈标准配置 10 个核心问题，每轮螺旋预期产出 30-50 条 Context Entry。

## E4: 跨层协调协议

### 8 类事件类型

| 事件 | 触发层 | 传播方向 | 说明 |
|------|--------|---------|------|
| entity.created | L1 | → L4 | 新实体创建，触发语义映射 |
| strategy.changed | L2 | → L3, L5 | 战略变更，触发流程对齐和案例更新 |
| process.deviation | L3 | → L2, L5 | 流程偏差，触发战略审查和案例记录 |
| term.conflict | L4 | → L1 | 术语冲突，触发本体修订 |
| case.challenged | L5 | → L2, L3 | 案例被质疑，触发战略/流程审查 |
| character.shift | L6 | → L5 | 性格漂移，触发案例库检查 |
| governance.alert | E2 | → all | 治理告警，传播到所有相关层 |
| coverage.gap | E2 | → all | 覆盖率缺口，触发对应层补充 |

## E5: AI 消费 API 规范

### 4 标准端点

```yaml
endpoints:
  - name: graph_query
    method: GET
    path: /api/v1/graph/query
    description: 图查询 — 实体、关系、路径
    params: [entity_type, entity_id, relation_type, depth, direction]

  - name: term_resolve
    method: GET
    path: /api/v1/semantics/resolve
    description: 术语解析 — 标准定义 + 系统映射
    params: [term, source_system, target_system]

  - name: semantic_search
    method: POST
    path: /api/v1/memory/search
    description: 语义搜索 — 跨 L5 案例 + L6 性格
    body: { query, top_k, filters, include_character }

  - name: context_assemble
    method: POST
    path: /api/v1/context/assemble
    description: 多层上下文组装 — 核心 AI 消费接口
    body:
      scenario: { role, customer_industry, customer_tier, task }
      options: { max_layers, include_memory, memory_top_k, include_character, perspective, min_confidence }
```

## 4 类扩展点

| 扩展点 | 标识符 | 机制 | 约束 |
|--------|--------|------|------|
| 实体类型扩展 | schema.extend.entity | 在 10 标准类型上增加行业类型 | 必须继承 governance 元数据 |
| 属性扩展 | schema.extend.attribute | 为标准实体增加行业属性 | 不能覆盖标准属性 |
| 规则覆写 | governance.override | 调整治理规则参数 | 不能删除 G1-G5，只能调参 |
| API 扩展 | api.extend | 增加行业专用端点 | 命名遵循 /ext/{domain}/ 前缀 |

## 技术栈

| 组件 | 选型 | 用途 |
|------|------|------|
| 图数据库 | Neo4j 5.x | 实体关系存储与查询 |
| 关系数据库 | PostgreSQL 16 | 治理元数据、版本管理 |
| 向量数据库 | Milvus 2.x | L5 案例语义检索 |
| 事件总线 | NATS JetStream | 跨层事件传播 |
| API 网关 | FastAPI / Python | REST API 服务 |
| Schema 管理 | Apicurio Registry | Schema 版本管理 |

## 被依赖方式

其他 orgcos-* 技能通过以下方式引用本内核：

```yaml
# 在其他技能的 SKILL.md 中声明依赖
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
    imports:
      - schema/context-entry.schema.json
      - governance/rules.yaml
      - entity-relation/entities.yaml
```

## 版本管理

遵循 SemVer：
- MAJOR：不兼容的 Schema 变更（极少发生）
- MINOR：新增扩展点或事件类型
- PATCH：参数默认值调整、文档修正

## 验证方式

本技能提供 `kernel-validate` 命令，校验任意 Context Entry 是否符合 T1 内核约束：

```bash
# 校验单个 Entry
kernel-validate --entry path/to/entry.json

# 校验整个目录
kernel-validate --dir path/to/entries/ --strict
```

## Pitfalls

- 内核定义不可随意修改。如需调整，必须通过 T2 蓝图的扩展点机制（governance.override / schema.extend）
- 12 字段治理元数据中，6 个字段标记为"必填"，缺少任何一个都会导致校验失败
- confidence 字段必须由采集技能在创建时赋值，不允许默认为 1.0（过度自信是反模式）
- G3 冲突检测依赖 LLM，存在误判风险——冲突结果标记为"待确认"而非直接执行

## Verification

1. 所有 JSON Schema 文件通过 `ajv` 验证
2. YAML 配置文件通过 `yamllint` 格式检查
3. 10 类实体 + 7 类关系定义与 OrgCOS 详细设计方案一致
4. 5 条治理规则参数与 T1 内核设计文档一致
5. 4 个 API 端点定义通过 OpenAPI 3.0 规范校验
