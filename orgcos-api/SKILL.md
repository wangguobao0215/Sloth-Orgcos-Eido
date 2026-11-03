---
name: sloth-orgcos-api-eido
description: "OrgCOS AI Consumption API standardization tool generating OpenAPI 3.0 specifications and client SDKs (Python/TypeScript) from OrgCOS data. Supports 4 standard endpoints (Graph Query, Term Resolve, Semantic Search, Context Assemble) and industry extension endpoints. Use when the user mentions API generation, interface definition, SDK generation, AI consumption interface, or OpenAPI."
version: 1.0.0
description_zh: "OrgCOS AI 消费 API 标准化工具——从 OrgCOS 数据生成 OpenAPI 3.0 规范和 Python/TypeScript SDK。"
name_zh: "树懒 · 组织认知 · 接口"
---

# OrgCOS AI 消费 API 标准化工具


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

本技能将 OrgCOS 的 Context Entry 数据转化为标准化的 AI 消费 API——让 AI 系统能通过标准接口查询组织上下文。

**核心价值：** OrgCOS 的数据如果不通过 API 暴露给 AI 系统，就只是"存在数据库里的文档"。API 是 OrgCOS 从"存储"到"消费"的桥梁。

## 触发词

API 生成、接口定义、SDK、AI 消费接口、OpenAPI、REST API、图查询接口、上下文组装

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
    imports:
      - api/openapi.yaml
      - api/graph-query.yaml
      - api/term-resolve.yaml
      - api/semantic-search.yaml
      - api/context-assemble.yaml
```

## 4 标准端点

### 1. 图查询（Graph Query）

```yaml
endpoint: GET /api/v1/graph/query
description: 查询实体、关系、路径
params:
  entity_type: string        # 实体类型筛选
  entity_id: string          # 指定实体 ID
  relation_type: string      # 关系类型筛选
  depth: integer (1-5)       # 遍历深度
  direction: "in|out|both"   # 遍历方向

example_request:
  GET /api/v1/graph/query?entity_type=Person&entity_id=p-zhang&relation_type=REPORTS_TO&depth=3&direction=out

example_response:
  {
    "entities": [...],
    "relations": [...],
    "paths": [...]
  }
```

### 2. 术语解析（Term Resolve）

```yaml
endpoint: GET /api/v1/semantics/resolve
description: 解析术语的标准定义和跨系统映射
params:
  term: string               # 要解析的术语
  source_system: string      # 来源系统（可选）
  target_system: string      # 目标系统（可选）

example_request:
  GET /api/v1/semantics/resolve?term=大客户&source_system=CRM&target_system=ERP

example_response:
  {
    "term": "大客户",
    "standard_definition": "年合同金额 ≥ 500万 或 战略级客户",
    "system_mappings": [
      { "system": "CRM", "field": "customer_tier", "value": "S" },
      { "system": "ERP", "field": "customer_group", "value": "KEY_ACCOUNT" }
    ],
    "ambiguity_note": "CRM 中 KA 包含 A 级潜力客户，ERP 中仅指已签约大客户"
  }
```

### 3. 语义搜索（Semantic Search）

```yaml
endpoint: POST /api/v1/memory/search
description: 跨 L5 案例库和 L6 性格库的语义搜索
body:
  query: string              # 搜索查询
  top_k: integer (1-20)      # 返回数量
  filters:
    case_type: string        # 案例类型筛选
    domain: string           # 领域筛选
    min_confidence: float    # 最低可信度
  include_character: boolean  # 是否包含 L6 性格

example_request:
  POST /api/v1/memory/search
  {
    "query": "过去怎么处理类似的政府项目紧急交付？",
    "top_k": 5,
    "filters": { "case_type": "success", "min_confidence": 0.6 },
    "include_character": true
  }

example_response:
  {
    "results": [
      {
        "entry_id": "ctx-L5-project-012",
        "score": 0.89,
        "content": { "..." : "案例详情" },
        "relevance_explanation": "同样是政府客户的紧急交付场景"
      }
    ],
    "character_context": {
      "communication_style": "偏直接",
      "risk_appetite": "偏保守"
    }
  }
```

### 4. 上下文组装（Context Assemble）— 核心接口

```yaml
endpoint: POST /api/v1/context/assemble
description: 为特定场景组装多层上下文，AI 系统的核心消费接口
body:
  scenario:
    role: string             # 使用者角色
    customer_industry: string # 客户行业
    customer_tier: string    # 客户级别
    task: string             # 当前任务
  options:
    max_layers: integer (1-6) # 最大层数
    include_memory: boolean   # 是否包含 L5
    memory_top_k: integer     # L5 返回数量
    include_character: boolean # 是否包含 L6
    perspective: string       # 视角（战略/执行/技术）
    min_confidence: float     # 最低可信度

example_request:
  POST /api/v1/context/assemble
  {
    "scenario": {
      "role": "高级售前顾问",
      "customer_industry": "制造业",
      "customer_tier": "S",
      "task": "准备战略客户的数字化方案"
    },
    "options": {
      "max_layers": 6,
      "include_memory": true,
      "memory_top_k": 5,
      "include_character": true,
      "perspective": "strategic",
      "min_confidence": 0.5
    }
  }

example_response:
  {
    "assembled_context": {
      "L1_entities": [
        { "type": "Customer", "name": "XX制造集团", "tier": "S" },
        { "type": "Competitor", "name": "竞品A", "threat_level": "high" }
      ],
      "L2_strategy": [
        { "decision": "聚焦大客户直销", "rationale": "..." }
      ],
      "L3_operations": [
        { "process": "战略客户方案流程", "actual_flow_note": "..." }
      ],
      "L4_semantics": [
        { "term": "数字化", "definition": "该客户语境下指..." }
      ],
      "L5_memories": [
        { "case": "类似制造业客户的成功交付", "score": 0.85 }
      ],
      "L6_character": {
        "communication_style": "直接坦率",
        "prompt_guidance": "..."
      }
    },
    "metadata": {
      "total_entries": 23,
      "avg_confidence": 0.78,
      "warnings": ["L4 覆盖率较低，部分术语未映射"]
    }
  }
```

## SDK 生成

### Python SDK

```python
# 自动生成的 Python 客户端
from orgcos_client import OrgCOSClient

client = OrgCOSClient(base_url="http://localhost:8000")

# 图查询
result = client.graph.query(
    entity_type="Person",
    entity_id="p-zhang",
    relation_type="REPORTS_TO",
    depth=3
)

# 术语解析
term = client.semantics.resolve(term="大客户", source_system="CRM")

# 语义搜索
cases = client.memory.search(
    query="政府项目紧急交付",
    top_k=5,
    min_confidence=0.6
)

# 上下文组装（核心接口）
context = client.context.assemble(
    scenario={
        "role": "高级售前顾问",
        "customer_industry": "制造业",
        "customer_tier": "S",
        "task": "准备数字化方案"
    }
)
```

### TypeScript SDK

```typescript
// 自动生成的 TypeScript 客户端
import { OrgCOSClient } from '@orgcos/client';

const client = new OrgCOSClient({ baseUrl: 'http://localhost:8000' });

// 上下文组装
const context = await client.context.assemble({
  scenario: {
    role: '高级售前顾问',
    customer_industry: '制造业',
    customer_tier: 'S',
    task: '准备数字化方案'
  }
});
```

## 输出目录

```
output/
└── api/
    ├── openapi.yaml           # OpenAPI 3.0 规范
    ├── sdk/
    │   ├── python/            # Python SDK
    │   │   ├── orgcos_client/
    │   │   └── setup.py
    │   └── typescript/        # TypeScript SDK
    │       ├── src/
    │       └── package.json
    └── test/
        ├── test_graph_query.py
        ├── test_term_resolve.py
        ├── test_semantic_search.py
        └── test_context_assemble.py
```

## Pitfalls

- Context Assemble 的响应大小需要控制——设置 max_layers 和 memory_top_k 避免返回过大
- 语义搜索的向量索引需要定期重建（每次 SECI 螺旋 I 阶段后）
- SDK 生成后必须在测试环境中跑通所有端点的 happy path
- API 版本管理遵循 T1 内核的 SemVer——不兼容变更需要 MAJOR 版本升级

## Verification

1. OpenAPI 规范通过 swagger-cli 验证
2. 4 个端点各有 ≥ 3 个测试用例
3. Python SDK 的 happy path 测试通过
4. TypeScript SDK 的 happy path 测试通过
5. Context Assemble 响应包含所有 6 层数据（当 max_layers=6 时）
