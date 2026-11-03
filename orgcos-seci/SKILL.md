---
name: sloth-orgcos-seci-eido
description: "OrgCOS SECI Knowledge Conversion Engine guiding an 8-week cognitive spiral through 4 knowledge conversion modes (Socialization, Externalization, Combination, Internalization) with 5 standard interview templates. Features coach mode with state memory, expecting 30-50 high-quality Context Entries per spiral. Use when the user mentions SECI, knowledge conversion, cognitive spiral, interview facilitation, externalization, internalization, or knowledge management workshop."
version: 1.0.0
description_zh: "OrgCOS SECI 知识转化引擎——引导式 8 周认知螺旋，4 种知识转化模式 + 5 类标准访谈模板，教练模式 + 状态记忆。"
name_zh: "树懒 · 组织认知 · 螺旋"
---

# OrgCOS SECI 知识转化引擎


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

SECI 引擎是 OrgCOS 最有深度和商业价值的组件——它将野中郁次郎的 SECI 知识创造理论转化为可执行的 AI 辅助流程。

**核心哲学：** SECI 不是"数据采集工具"，而是"引导人思考的教练"。它的灵魂是引导参与者深度反思，将隐性知识转化为可被 AI 消费的结构化上下文。

**设计原则：**
- 教练模式：每个阶段告诉用户该做什么、提供什么工具、期望什么产出
- 状态记忆：记住螺旋进度，支持断点续跑
- 节奏感：8 周不是死线，是认知节奏——太快则思考不深，太慢则动力消退

## 触发词

SECI、知识转化、认知螺旋、知识管理工作坊、外化、内化、社会化、组合化、引导式访谈、知识萃取

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
    imports:
      - seci/spiral-definition.yaml
      - seci/mode-toolkits/*
      - seci/interview-templates/*
```

## 8 周螺旋全景

```
Week 1-2: 社会化(S) → Week 3-4: 外化(E) → Week 5-6: 组合化(C) → Week 7-8: 内化(I)
隐性→隐性      隐性→显性          显性→显性          显性→隐性
观察与模仿      概念化表达          系统化整合         AI 内化
```

## 螺旋状态管理

每轮螺旋维护一个状态文件：

```json
{
  "spiral_id": "seci-2026-Q4-001",
  "enterprise": "Acme Corp",
  "started_at": "2026-10-01",
  "current_phase": "E",
  "current_week": 3,
  "phase_status": {
    "S": { "status": "completed", "completed_at": "2026-10-14", "entries_produced": 8 },
    "E": { "status": "in_progress", "started_at": "2026-10-15" },
    "C": { "status": "pending" },
    "I": { "status": "pending" }
  },
  "total_entries": 8,
  "target_entries": 40,
  "participants": ["张总", "李经理", "王工程师", "赵销售"],
  "next_action": "执行战略取舍访谈（E阶段第1轮）"
}
```

## S 阶段：社会化（第 1-2 周）

### 目标
隐性 → 隐性：通过观察和互动发现组织中未被言说的隐性知识和关系。

### 教练引导

```
📋 S 阶段任务清单：

本周你需要完成以下活动：

1. 【协作网络分析】填写 ONA 问卷（约 15 分钟）
   → 问题包括："遇到技术难题你第一个找谁？""重要决策前你会和谁商量？"

2. 【行为观察日志】记录 3 个你观察到的"非正式知识传递"场景
   → 例如：午餐时老员工教新人处理客户投诉的技巧

3. 【关系图谱】标注你认为最重要的 5 条"隐性协作关系"
   → 这些关系不在组织图上，但对工作至关重要
```

### 标准工具包

| 工具 | 功能 | 输出 |
|------|------|------|
| ONA 问卷 | 组织网络分析，发现信息流动路径 | 社交网络图谱 JSON |
| 行为观察模板 | 结构化记录非正式知识传递 | 行为模式标签 |
| 隐性关系发现器 | 识别组织图上不存在但实际重要的协作关系 | 隐性关系列表 |

### S 阶段产出

预期 5-10 条 Context Entry，主要类型：
- 隐性关系条目（"张师傅是实际的技术权威，虽然组织架构上李工才是技术负责人"）
- 行为模式观察（"团队习惯在午餐时讨论棘手问题，正式会议上反而不讨论"）

## E 阶段：外化（第 3-4 周）

### 目标
隐性 → 显性：通过结构化访谈，将参与者的隐性知识、经验和判断转化为显性的 Context Entry。

### 教练引导

```
📋 E 阶段任务清单：

本周进入最关键的"外化"阶段——把"只可意会"的知识变成"可以言传"的记录。

你需要安排以下访谈（每次 45-60 分钟）：

1. 【战略取舍访谈】找 1-2 位高管
   → 核心问题："过去一年最重要的三个决策是什么？放弃了什么？"

2. 【流程真相访谈】找 2-3 位一线执行者
   → 核心问题："你实际怎么做的？和 SOP 写的有什么不同？为什么？"

3. 【失败复盘访谈】找 1-2 位经历过项目失败的人
   → 核心问题："那次失败教会了你什么？现在你遇到类似情况怎么做？"
```

### 5 类标准访谈模板

#### 1. 战略取舍访谈（→ L2）

```yaml
template_id: interview-strategic-tradeoff
target: 高管、战略决策者
duration: 60 min
core_questions:
  - "过去一年，你们做的最艰难的战略选择是什么？"
  - "你们拒绝了哪些看起来不错的机会？为什么？"
  - "竞争对手在做但你们选择不做的事情有哪些？"
  - "如果只能做三件事，你们选哪三件？"
  - "你们'不可为清单'上有什么？"
  - "有没有战略决策是事后证明做错了的？"
  - "你们的战略决策主要靠数据还是经验？"
  - "战略调整通常是什么触发的？"
  - "中层管理者理解公司的战略取舍吗？"
  - "你们怎么判断一个战略决策是否还有效？"
output_layer: L2
expected_entries: 5-10
```

#### 2. 流程真相访谈（→ L3）

```yaml
template_id: interview-process-truth
target: 一线执行者、流程参与者
duration: 45 min
core_questions:
  - "这个流程你实际执行的步骤和 SOP 写的一样吗？"
  - "你在什么情况下会跳过某个步骤？"
  - "有没有你自己发明的'捷径'？"
  - "这个流程中最容易卡住的环节是哪个？"
  - "你会找谁来帮你解决卡住的问题？"
  - "新来的人是怎么学会这个流程的？"
  - "有没有'大家都知道但没人写下来'的规则？"
  - "这个流程在过去一年有变化吗？什么导致的？"
  - "如果可以改一个地方，你会改哪里？"
  - "这个流程对客户有什么直接影响？"
output_layer: L3
expected_entries: 5-8
```

#### 3. 失败复盘访谈（→ L5）

```yaml
template_id: interview-failure-retrospective
target: 经历过项目失败或重大挫折的人
duration: 60 min
core_questions:
  - "描述一下那次失败的具体情况"
  - "事前有没有预警信号？为什么没有及时处理？"
  - "当时的决策过程是怎样的？"
  - "如果重来一次，你会在哪里做不同的选择？"
  - "这次失败改变了你的哪些做法？"
  - "团队从这次失败中学到了什么？"
  - "有没有'差点失败但成功挽救'的经历？怎么做到的？"
  - "你们现在有机制来预防类似的失败吗？"
  - "失败后你们怎么对待当事人的？"
  - "这次经验对你个人有什么影响？"
output_layer: L5
expected_entries: 3-5
```

#### 4. 组织性格访谈（→ L6）

```yaml
template_id: interview-org-character
target: 老员工、中层管理者
duration: 45 min
core_questions:
  - "用三个词形容这家公司的'性格'"
  - "当团队意见不一致时，你们通常怎么解决？"
  - "你们更倾向于'先分析再行动'还是'先做起来再调整'？"
  - "新员工最需要适应的是什么？"
  - "这家公司最让你自豪的是什么？"
  - "有没有'在这里大家都这么做但在别的公司不这样'的事？"
  - "你们的销售更倾向于推销产品还是建立关系？"
  - "面对一个新市场，你们的本能反应是观察还是进入？"
  - "这家公司在什么时候最团结？"
  - "如果公司是一个人，你觉得他/她是什么性格？"
output_layer: L6
expected_entries: 3-5
```

#### 5. 语义对齐访谈（→ L4）

```yaml
template_id: interview-semantic-alignment
target: IT 负责人、跨部门协调者
duration: 45 min
core_questions:
  - "有没有某个术语在你们部门和另一个部门的理解不一样？"
  - "CRM 里的'客户'和 ERP 里的'客户'是同一个概念吗？"
  - "你们怎么解决不同系统之间的数据不一致？"
  - "有没有'大家都知道含义但系统里定义不对'的字段？"
  - "新系统上线时，最容易出问题的数据映射是什么？"
  - "你们有没有一个'术语翻译表'？"
  - "哪些术语的含义在过去一年发生了变化？"
  - "跨部门沟通中最常误解的词是什么？"
  - "客户、供应商怎么称呼同一种东西？"
  - "如果统一术语，你觉得最难的三个词是什么？"
output_layer: L4
expected_entries: 5-8
```

### E 阶段产出

预期 15-25 条 Context Entry，分布到 L2/L3/L4/L5/L6 各层。

## C 阶段：组合化（第 5-6 周）

### 目标
显性 → 显性：将 S 和 E 阶段收集的散落知识条目整合为结构化的知识网络。

### 教练引导

```
📋 C 阶段任务清单：

现在你有了一批 Context Entry，但它们还是散落的。
本周我们一起把它们组织成结构化的知识网络。

1. 【关系链接】审查已有的 Entry，标注它们之间的关系
   → 哪些案例支撑了哪条战略决策？
   → 哪些流程使用了哪些术语？

2. 【缺口发现】看看哪些重要的领域还没有 Context Entry
   → 哪个部门的声音最少？哪类经验还没记录？

3. 【战略对齐检查】验证 L3 流程是否都能追溯到 L2 战略
```

### 标准工具包

| 工具 | 功能 | 输出 |
|------|------|------|
| 知识图谱整合器 | 自动建议 Entry 之间的关系链接 | 关系建议列表 |
| 标签/关系自动建议器 | 基于语义相似度建议分类和关联 | 标签建议 |
| L2 战略对齐检查器 | 检查 L3 流程是否可追溯到 L2 | 对齐报告 |

### C 阶段产出

预期 5-10 条新的关联关系，以及对已有 Entry 的修订。

## I 阶段：内化（第 7-8 周）

### 目标
显性 → 隐性：将结构化的 Context Entry 编译为 AI 可消费的格式——Few-shot 示例、Prompt 模板、向量索引。

### 教练引导

```
📋 I 阶段任务清单：

最后阶段——让 AI "内化"你们的组织知识。

1. 【Few-shot 生成】从案例库中选择 5-10 个最有代表性的案例
   → 编译为 few-shot 示例（输入场景 → 期望输出）

2. 【Prompt 编译】从 L6 性格画像生成 system prompt 片段
   → 让 AI 以你们组织的方式思考和表达

3. 【向量索引重建】将新的 Context Entry 加入 Milvus 向量索引
   → 让语义搜索能覆盖最新的知识
```

### 标准工具包

| 工具 | 功能 | 输出 |
|------|------|------|
| Few-shot 生成器 | 从案例库生成 AI 训练示例 | few-shot-library.json |
| Prompt 模板编译器 | 从性格画像编译 system prompt | system-prompt.md |
| RAG 索引重建器 | 重建向量索引 | Milvus collection 更新 |

### I 阶段产出

- 更新的 few-shot-library.json
- 更新的 system-prompt.md
- 重建的向量索引

## 输出目录

```
output/
├── seci/
│   ├── spiral-{id}-state.json     # 螺旋状态
│   ├── phase-S/
│   │   ├── ona-results.json       # ONA 问卷结果
│   │   ├── behavior-logs.json     # 行为观察日志
│   │   └── tacit-relations.json   # 隐性关系
│   ├── phase-E/
│   │   ├── interviews/
│   │   │   ├── strategic-{date}.json
│   │   │   ├── process-{date}.json
│   │   │   ├── failure-{date}.json
│   │   │   ├── character-{date}.json
│   │   │   └── semantic-{date}.json
│   │   └── raw-entries.json       # E 阶段产出的原始 Entry
│   ├── phase-C/
│   │   ├── relation-suggestions.json
│   │   ├── gap-report.json
│   │   └── alignment-check.json
│   └── phase-I/
│       ├── few-shot-library.json
│       ├── prompt-templates/
│       └── index-rebuild-log.json
```

## Pitfalls

- **不要把 SECI 变成填表游戏**——每个阶段的深度反思比产出数量更重要
- **E 阶段访谈不要在会议室进行**——去工作现场，观察真实行为
- **不要跳过 S 阶段**——社会化的观察往往能发现最意想不到的隐性知识
- **I 阶段不能省略**——没有内化，SECI 就只是"知识采集"而不是"知识创造"
- **8 周是参考节奏**——如果团队投入度高，可以适当延长 E 阶段；如果时间紧，可以压缩 S 阶段但不可跳过
- **每轮螺旋预期 30-50 条 Entry**——不要追求 100 条然后降低质量

## Verification

1. 螺旋状态文件正确记录进度
2. 4 个阶段全部完成（不允许跳过任何阶段）
3. 5 类访谈至少各完成 1 轮
4. 最终产出 Context Entry ≥ 30 条
5. Entry 分布覆盖 L2-L6 各层（L1 除外）
6. I 阶段产出 few-shot-library 和 prompt-templates 可被 AI 系统消费
