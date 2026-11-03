---
name: sloth-orgcos-memory-char-eido
description: "OrgCOS L5 Memory + L6 Character collection skill for organizational memory management and cultural personality encoding. Covers a 5-step workflow: historical case import, case structuring, organizational personality interview, behavioral pattern encoding, and Prompt template compilation. L5 accumulates continuously; L6 undergoes semi-annual audits. Use when the user mentions case library, organizational memory, cultural audit, organizational personality, behavioral patterns, or Prompt templates."
version: 1.0.0
description_zh: "OrgCOS L5 记忆层 + L6 性格层采集——组织记忆库管理与文化性格编码，含案例导入、性格访谈、Prompt 模板编译五步流程。"
name_zh: "树懒 · 组织认知 · 记忆"
---

# OrgCOS L5 记忆层 + L6 性格层


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

本技能负责 OrgCOS 六层架构中两个判断力层的上下文采集：

- **L5 记忆层**：回答"我们经历过什么？学到了什么？"
- **L6 性格层**：回答"我们的行为风格是什么？"

L5 + L6 构成 OrgCOS 的"判断力层"——让 AI 不仅知道组织的知识，还能以组织的方式思考和表达。

## 触发词

案例库、组织记忆、经验教训、项目复盘、失败复盘、文化审计、组织性格、行为模式、沟通风格、Prompt 模板编译

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
  - name: orgcos-seci
    version: "^1.0.0"
    note: L5 的新案例主要通过 SECI 引擎产出
```

## L5 记忆层

### 目标

构建组织案例库——每条案例记录一个有意义的组织经历，包含情境、决策、结果和教训。案例库是 AI 语义搜索的核心数据源。

### 案例条目结构

L5 记忆层支持 6 种案例类型，覆盖组织经历的完整光谱：

| 案例类型 | 定义 | 典型来源 | 价值 |
|---------|------|---------|------|
| `success` | 成功经验，可复制的模式 | 项目复盘、绩效评估 | 正向标杆 |
| `failure` | 失败教训，需避免的陷阱 | 失败复盘、事故报告 | 风险预警 |
| `inflection` | 转折点，战略或运营的重大转变 | 战略会议、市场事件 | 变革洞察 |
| `practice` | 最佳实践，经验证的优秀做法 | 经验总结、标杆学习 | 操作指南 |
| `antipattern` | 反模式，看似合理但实际有害的做法 | 问题溯源、根因分析 | 负面警示 |
| `case` | 通用案例，不属于以上类型的有意义经历 | 日常积累 | 知识补充 |

```json
{
  "entry_id": "ctx-L5-project-001",
  "layer": "L5",
  "type": "case",
  "domain": "project_delivery",
  "content": {
    "case_type": "success|failure|inflection|practice|antipattern|case",
    "title": "某战略客户的定制化交付",
    "period": "2025-Q3 ~ 2025-Q4",
    "context": {
      "situation": "客户要求 3 个月内完成定制化交付，标准流程需要 6 个月",
      "constraints": ["人力紧张", "技术方案未验证"],
      "stakeholders": ["客户CTO", "交付团队", "产品经理"]
    },
    "decision": {
      "chose": "组建专项小组，采用敏捷冲刺模式",
      "alternatives": ["延长交付周期", "削减定制范围"],
      "key_factors": ["客户关系优先级最高", "团队有类似经验"]
    },
    "outcome": {
      "result": "按时交付，客户满意度 4.5/5",
      "unexpected": "团队疲劳度高，后续 2 周效率下降 30%"
    },
    "lessons": [
      "专项小组模式适合紧急定制项目，但不宜连续使用",
      "应在项目规划中预留团队恢复期"
    ],
    "related_entities": ["Customer:某战略客户", "OrgUnit:交付团队"],
    "related_decisions": ["D-001"],
    "tags": ["定制化交付", "紧急项目", "敏捷"],
    "freshness_score": 0.95,
    "applicable_when": "类似紧急定制化需求场景"
  },
  "governance": { "..." : "12字段治理元数据" }
}
```

**案例类型示例：**

- **success**："通过客户共创工作坊，将需求确认周期从 4 周缩短到 1 周"
- **failure**："因未做技术方案验证就启动交付，导致返工成本超预算 50%"
- **inflection**："2023 年从设备销售转向解决方案销售，客单价提升 3 倍但销售周期延长 2 倍"
- **practice**："每周三下午的'技术茶话会'是跨部门知识共享的有效机制"
- **antipattern**："为了赶工期连续加班超过 4 周，导致核心员工离职率上升 40%"
- **case**："某次客户投诉处理的完整经过和应对策略"

### 采集流程

#### 步骤 1：历史案例导入

**来源：**
- 项目复盘文档
- 失败案例库（如有）
- 关键人物访谈
- SECI 引擎产出（主要来源）

**导入方法：**
1. 收集现有复盘文档
2. LLM 辅助提取结构化案例要素（情境/决策/结果/教训）
3. 人工审核并补充细节
4. 分配治理元数据

#### 步骤 2：案例结构化

**质量标准：**
- 每条案例必须包含完整的 context/decision/outcome/lessons 四段
- lessons 必须是可操作的建议（不是空泛的"加强沟通"）
- 必须关联相关的 L1 实体和 L2 战略决策

#### 步骤 3：案例索引构建

为语义搜索构建索引：
- 案例类型标签（success/failure/learning/turning_point）
- 领域标签（project_delivery/sales/strategy/hr/...）
- 实体关联索引
- 向量嵌入（用于语义相似度匹配）

### 案例库规模指引

| 企业规模 | 最小案例数 | 推荐案例数 | 覆盖领域 |
|---------|-----------|-----------|---------|
| < 500 人 | 20 | 50 | ≥ 3 个领域 |
| 500-5000 | 50 | 150 | ≥ 5 个领域 |
| > 5000 | 150 | 500 | ≥ 8 个领域 |

## L6 性格层

### 目标

编码组织的行为风格——让 AI 能以"组织的方式"思考和表达。性格层的核心输出是 Prompt 模板，注入 AI 系统的 system prompt。

### 性格维度模型

| 维度 | 光谱 | 示例 |
|------|------|------|
| 沟通风格 | 直接 ← → 委婉 | "直接指出问题" vs "委婉暗示" |
| 决策风格 | 数据驱动 ← → 直觉驱动 | "用数据说话" vs "凭经验判断" |
| 风险偏好 | 保守 ← → 激进 | "宁可不赚也不亏" vs "高风险高回报" |
| 冲突处理 | 直面 ← → 回避 | "当面解决" vs "冷处理" |
| 创新态度 | 渐进 ← → 颠覆 | "小步快跑" vs "不破不立" |
| 客户导向 | 产品驱动 ← → 关系驱动 | "产品好自然有客户" vs "关系是基础" |

### 采集流程

#### 步骤 1：组织性格访谈

**方法：** 使用 orgcos-kernel 提供的"组织性格访谈模板"（10 个核心问题）

**关键问题：**
- "当团队意见不一致时，你们通常怎么解决？"
- "你们的销售更倾向于'推销产品'还是'建立关系'？"
- "面对一个新市场，你们的本能反应是'先观察'还是'先进入'？"

#### 步骤 2：行为模式编码

**方法：**
1. 从访谈中提取行为模式标签
2. 为每个性格维度打分（0-100 光谱值）
3. 收集典型行为示例（few-shot 素材）

**性格条目结构：**
```json
{
  "entry_id": "ctx-L6-culture-001",
  "layer": "L6",
  "type": "trait",
  "domain": "culture",
  "content": {
    "dimension": "沟通风格",
    "spectrum_value": 0.75,
    "spectrum_label": "偏直接",
    "description": "团队倾向于直接表达意见，会议中常见激烈讨论但不记仇",
    "behavioral_examples": [
      "周会上直接质疑方案的数据基础",
      "不满意的客户会直接打电话给项目负责人而非走客服渠道"
    ],
    "prompt_guidance": "在与该组织成员交互时，应采用直接、坦率的沟通方式，避免过度委婉导致信息失真"
  },
  "governance": { "..." : "12字段治理元数据" }
}
```

#### 步骤 2.5：宣称理论 vs 使用理论检测（Espoused Theory vs Theory-in-Use）

**目标：** 识别组织"宣称的做法"和"实际的做法"之间的差距——这是组织学习和改进的关键洞察点。

**检测流程：**

1. **双重采集**：对每个性格维度，分别采集：
   - **Espoused Theory**（宣称理论）：组织公开声称的价值观和行为方式
   - **Theory-in-Use**（使用理论）：实际观察到的行为模式

2. **差距评估**：计算每个维度的 `espoused_vs_in_use_gap`：
   ```json
   {
     "dimension": "创新态度",
     "espoused_theory": {
       "statement": "我们鼓励颠覆性创新，容忍失败",
       "spectrum_value": 0.85,
       "evidence": ["CEO年会演讲", "企业文化手册"]
     },
     "theory_in_use": {
       "observed_behavior": "实际决策偏向渐进式改进，颠覆性项目被否决率高",
       "spectrum_value": 0.45,
       "evidence": ["近2年项目审批记录", "创新项目成功率统计"]
     },
     "gap_assessment": {
       "gap_magnitude": 0.40,
       "gap_type": "defensive_routine",
       "interpretation": "组织宣称鼓励创新，但防御性惯例（风险规避、短期业绩压力）抑制了真正的创新行为",
       "ai_should_follow": "theory_in_use",
       "rationale": "AI 应与组织的实际行为模式保持一致，而非理想化的宣称价值观"
     }
   }
   ```

3. **差距类型分类**：
   | 差距类型 | 定义 | 处理建议 |
   |---------|------|---------|
   | `aspirational` | 宣称的是理想目标，当前尚未达到 | Prompt 中引导向宣称方向演进 |
   | `defensive_routine` | 防御性惯例导致言行不一（Argyris） | Prompt 中基于实际行为响应，避免触发防御 |
   | `hypocrisy` | 故意欺骗或粉饰 | 标记为治理风险，升级至治理委员会 |
   | `evolution_lag` | 行为已变但宣称未更新 | 建议更新宣称价值观 |

4. **AI 响应策略**：
   - **默认规则**：`ai_should_follow = "theory_in_use"`（与实际行为一致）
   - **例外规则**：当 `gap_type = "aspirational"` 且组织正在主动推进变革时，可跟随 `espoused_theory`
   - **敏感场景**：当用户询问"你们公司的创新文化如何"时，AI 应基于 `theory_in_use` 如实回答，而非照搬宣传材料

#### 步骤 3：Prompt 模板编译

**目标：** 将性格画像编译为可直接注入 AI 系统的 Prompt 模板。

**输出示例：**
```
# 组织性格 Prompt（自动生成）

你正在为一家具有以下性格特征的组织服务：

沟通风格：直接坦率。在回应中避免过度委婉或暗示，直接表达观点和判断。
决策风格：数据驱动。在给出建议时优先提供数据支撑，直觉判断需要标注为"经验判断"。
风险偏好：偏保守。在评估方案时，先分析风险再讨论收益。
冲突处理：直面解决。遇到分歧时直接讨论而非回避。
...
```

### L6 性格演化日志（Character Evolution Log）

**目标：** 追踪组织性格随时间的变化轨迹——组织性格不是静态的，会随领导层变更、市场压力、文化融合等因素而漂移。

**为什么需要演化日志：**
- 识别性格漂移（Character Drift）：组织的实际行为偏离了宣称的性格
- 捕捉转折点（Inflection Points）：重大事件导致的性格突变
- 预测行为变化：基于历史演化趋势预测未来行为模式
- 验证干预效果：文化变革措施是否真正改变了组织性格

**演化日志条目结构：**
```json
{
  "entry_id": "ctx-L6-evolution-001",
  "layer": "L6",
  "type": "evolution_log",
  "domain": "culture",
  "content": {
    "dimension": "风险偏好",
    "evolution_type": "gradual_shift",
    "timeline": [
      {
        "timestamp": "2023-01-01",
        "spectrum_value": 0.30,
        "label": "偏保守",
        "context": "创始人主导时期，强调稳健经营"
      },
      {
        "timestamp": "2024-06-01",
        "spectrum_value": 0.45,
        "label": "中性偏保守",
        "context": "引入职业经理人，开始尝试新业务"
      },
      {
        "timestamp": "2025-06-01",
        "spectrum_value": 0.65,
        "label": "中性偏激进",
        "context": "市场竞争加剧，董事会要求加速增长"
      }
    ],
    "evolution_drivers": [
      {"driver": "leadership_change", "impact": "high", "description": "新任CEO来自互联网行业，偏好快速试错"},
      {"driver": "market_pressure", "impact": "medium", "description": "竞争对手推出颠覆性产品"},
      {"driver": "investor_expectation", "impact": "high", "description": "投资方要求3年内IPO，需要高增长故事"}
    ],
    "evolution_trajectory": "accelerating",
    "predicted_next_state": {
      "timestamp": "2026-12-01",
      "predicted_value": 0.75,
      "confidence": 0.60,
      "rationale": "如果市场持续增长且CEO连任，风险偏好可能进一步激进"
    },
    "intervention_needed": false,
    "intervention_suggestion": null
  },
  "governance": {
    "owner": {"role": "OD总监", "name": "..."},
    "valid_from": "2025-06-01",
    "valid_until": "2026-12-01",
    "confidence": 0.70,
    "version": "1.0.0"
  }
}
```

**演化类型分类：**
| 演化类型 | 定义 | 触发条件 | 示例 |
|---------|------|---------|------|
| `gradual_shift` | 渐进式漂移 | 多个小事件累积 | 风险偏好逐年提升 0.05/年 |
| `inflection_point` | 转折点 | 重大事件 | CEO 更换、并购、危机 |
| `oscillation` | 震荡 | 内部冲突或外部压力反复 | 激进→保守→激进 |
| `stabilization` | 稳定化 | 文化变革措施生效 | 从混乱走向一致 |
| `drift` | 无意识漂移 | 缺乏文化管理 | 宣称价值观与实际行为逐渐脱节 |

**演化驱动因素：**
- `leadership_change`：领导层变更（CEO/高管更换）
- `market_pressure`：市场竞争压力
- `organizational_crisis`：组织危机（财务/声誉/人才流失）
- `merger_acquisition`：并购整合
- `cultural_intervention`：主动的文化变革项目
- `generational_shift`：员工代际变化（90后/00后成为主力）
- `technology_disruption`：技术颠覆导致的业务模式变化

**演化分析工具：**
1. **趋势线分析：** 对每个性格维度绘制时间序列趋势线
2. **相关性分析：** 识别哪些驱动因素与性格变化相关性最高
3. **预测模型：** 基于历史趋势预测未来 6-12 个月的性格状态
4. **干预建议：** 当检测到负面漂移时，建议文化干预措施

**更新频率：**
- 常规更新：半年度文化审计时更新
- 事件触发：重大事件发生后 30 天内更新
- 主动监测：每季度收集一次员工行为数据（如沟通风格、决策模式）

### L6 更新频率

- 初始构建：与 L5 同步
- 定期更新：半年度文化审计（组织文化可能随领导层变更而漂移）
- 事件触发：重大组织变革时立即审计

## 输出目录

```
output/
├── L5-memory/
│   ├── cases.json                # 案例库
│   ├── case-index.json           # 案例索引（标签+向量）
│   └── import-log.json           # 导入日志
└── L6-character/
    ├── personality-profile.json  # 性格画像（维度评分）
    ├── behavioral-patterns.json  # 行为模式列表
    └── prompt-templates/         # Prompt 模板
        ├── system-prompt.md      # 通用 system prompt
        ├── few-shot-library.json # Few-shot 示例库
        └── style-guide.md        # 风格指南
```

## Pitfalls

- L5 案例不是越多越好——质量远比数量重要。20 条高质量案例胜过 200 条流水账
- 失败案例比成功案例更有价值，但采集难度也更大（需要心理安全环境）
- L6 性格画像不要追求"好"的性格——没有好坏之分，只有适不适合
- Prompt 模板编译后必须在实际对话中验证效果——纸上描述和实际行为可能不同
- 不要把 L6 性格等同于"企业文化口号"——性格是实际行为模式，不是墙上标语

## Verification

1. L5 案例数达到最小规模指引要求
2. 每条案例包含完整的 context/decision/outcome/lessons 四段
3. L6 性格画像覆盖 ≥ 4 个维度
4. Prompt 模板通过实际对话验证（≥ 3 轮测试对话）
5. 所有 Entry 通过 kernel-validate 校验
