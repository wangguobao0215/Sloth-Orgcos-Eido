---
name: sloth-orgcos-blueprint-eido
description: "OrgCOS T2 Industry Blueprint manager for loading, validating, and customizing industry preset packages. Manages industry-specific entity extensions, attribute extensions, governance parameter overrides, and domain-specific APIs via YAML blueprint files. Supports industry community contributions and version management. Use when the user mentions industry blueprint, manufacturing blueprint, financial blueprint, industry presets, or blueprint customization."
version: 1.0.0
description_zh: "OrgCOS T2 行业蓝图管理——加载、验证、定制行业预置包，管理实体扩展、属性扩展、治理参数覆写和行业专用 API。"
name_zh: "树懒 · 组织认知 · 蓝图"
---

# OrgCOS T2 行业蓝图管理


> <p align="center"><img src="assets/qrcode.jpg" width="120" /><br/><sub>扫码关注 <b>树懒老K</b> · 获取更多 AI 技能</sub><br/><i>慢一点，深一度</i></p>

## 定位

T2 行业蓝图是 OrgCOS 三层架构中**可销售的行业解决方案包**——它承载了行业 know-how，让 OrgCOS 不需要每个企业从零开始。

**类比：** 如果 T1 内核是 Linux Kernel，T2 蓝图就是 Ubuntu/CentOS 等发行版——预装了行业最常用的软件包和配置。

**商业价值：** 蓝图是可独立定价的资产。制造业蓝图、金融业蓝图、零售业蓝图——每个都是独立的产品 SKU。

## 触发词

行业蓝图、制造业蓝图、金融业蓝图、零售业蓝图、行业预置、蓝图加载、蓝图定制、蓝图验证

## 依赖

```yaml
dependencies:
  - name: orgcos-kernel
    version: "^1.0.0"
    note: 蓝图必须遵循 T1 内核定义的 4 类扩展点
```

## 蓝图文件格式

蓝图以 YAML 文件为载体，遵循 T1 内核定义的扩展点规范：

```yaml
# 制造业行业蓝图示例
blueprint:
  id: manufacturing-v1
  name: 制造业 OrgCOS 蓝图
  version: "1.2.0"
  industry: manufacturing
  description: 面向离散/流程制造企业的 OrgCOS 行业预置包
  kernel_compatibility: "^1.0.0"
  author: OrgCOS Industry Team
  last_updated: "2026-10-15"

# 1. 实体类型扩展（schema.extend.entity）
entity_extensions:
  - type: WorkOrder
    description: 生产工单
    attributes:
      - { name: order_no, type: string, required: true }
      - { name: product_ref, type: entity_ref, target: Product, required: true }
      - { name: quantity, type: integer, required: true }
      - { name: status, type: enum, values: [planned, in_progress, completed, cancelled] }
      - { name: priority, type: enum, values: [normal, urgent, critical] }
      - { name: scheduled_start, type: datetime }
      - { name: actual_end, type: datetime }
    relations:
      - { type: PRODUCES, target: Product }
      - { type: ASSIGNED_TO, target: OrgUnit }
      - { type: CONSUMES, target: Material }

  - type: BOM
    description: 物料清单
    attributes:
      - { name: product_ref, type: entity_ref, target: Product, required: true }
      - { name: level, type: integer }
      - { name: components, type: array }
    relations:
      - { type: COMPOSED_OF, target: Material }

  - type: ProcessRoute
    description: 工艺路线
    attributes:
      - { name: product_ref, type: entity_ref, target: Product }
      - { name: steps, type: array }
      - { name: cycle_time, type: duration }

  - type: Material
    description: 原材料/零部件
    attributes:
      - { name: name, type: string, required: true }
      - { name: spec, type: string }
      - { name: unit, type: string }
      - { name: lead_time, type: duration }

# 2. 属性扩展（schema.extend.attribute）
attribute_extensions:
  - entity: Customer
    attributes:
      - { name: production_capacity, type: string, description: "客户产能规模" }
      - { name: factory_count, type: integer }
      - { name: quality_certifications, type: "array[string]" }
  - entity: Product
    attributes:
      - { name: bom_complexity, type: enum, values: [simple, medium, complex] }
      - { name: customization_level, type: enum, values: [standard, configurable, fully_custom] }

# 3. 规则覆写（governance.override）
governance_overrides:
  G1_expiration_decay:
    decay_rate: 0.05       # 制造业知识衰减慢（vs 默认 0.1）
    rationale: "制造工艺知识更新周期较长"
  G4_coverage_audit:
    coverage_targets:
      L1: 0.85             # 制造业对 L1 本体要求更高
      L3: 0.80             # 流程覆盖率要求高
    audit_frequency: semi_annual

# 4. API 扩展（api.extend）
api_extensions:
  - endpoint: /ext/manufacturing/bom-check
    method: POST
    description: BOM 完整性检查
    body:
      product_id: string
      max_depth: integer
    response:
      complete: boolean
      missing_materials: "array[string]"

  - endpoint: /ext/manufacturing/capacity-check
    method: GET
    description: 产能查询
    params:
      org_unit_id: string
      date_range: "string"

# 5. 预填数据
seed_data:
  common_processes:
    - { name: "来料检验", domain: "quality" }
    - { name: "生产排程", domain: "planning" }
    - { name: "首件检验", domain: "quality" }
    - { name: "成品入库", domain: "logistics" }
  common_roles:
    - "生产计划员"
    - "工艺工程师"
    - "质量检验员"
    - "物料管理员"
  competitive_landscape_template:
    key_players: ["请填写行业头部企业"]
    differentiators: ["请填写常见差异化维度"]
```

## 蓝图管理操作

### 加载蓝图

```
用户: "帮我加载制造业蓝图"
技能:
  1. 读取 manufacturing-blueprint.yaml
  2. 验证与 T1 内核的兼容性（kernel_compatibility 字段）
  3. 将扩展注入项目 Schema
  4. 输出加载报告
```

### 验证蓝图

```bash
# 验证蓝图文件是否符合 T1 扩展点规范
blueprint-validate --file manufacturing-blueprint.yaml
```

校验内容：
- 实体扩展是否继承了 governance 元数据要求
- 属性扩展是否尝试覆盖标准属性（不允许）
- 规则覆写是否尝试删除 G1-G5（不允许，只能调参）
- API 扩展是否遵循 /ext/{domain}/ 命名规范

### 定制蓝图

```
用户: "基于制造业蓝图，为 XX 企业定制"
技能:
  1. 加载基础蓝图
  2. 引导用户选择要启用的扩展（全部/部分）
  3. 引导用户添加企业特有扩展
  4. 生成定制化蓝图文件
  5. 保存到 output/blueprint/custom-blueprint.yaml
```

## 可用蓝图列表

| 蓝图 ID | 行业 | 版本 | 状态 | 实体扩展数 |
|---------|------|------|------|-----------|
| manufacturing-v1 | 制造业 | 1.2.0 | 可用 | 4 |
| financial-v1 | 金融业 | 0.9.0 | Beta | 6 |
| retail-v1 | 零售业 | 0.8.0 | 规划中 | 3 |
| healthcare-v1 | 医疗健康 | 0.5.0 | 规划中 | 5 |
| none | 无行业预置 | - | 始终可用 | 0 |

## 蓝图社区贡献

蓝图支持社区贡献模式，但所有贡献必须经过审核流程才能合并到官方蓝图库。

### 贡献提交要求

```yaml
# 贡献者蓝图提交格式
contribution:
  blueprint_file: industry-blueprint.yaml
  test_cases: test-cases.json
  documentation: README.md
  license: Apache-2.0
  contributor_info:
    name: "贡献者姓名/组织"
    contact: "email@example.com"
    industry_experience: "5年以上制造业经验"
    references: ["某制造企业CTO推荐", "行业峰会分享"]
```

**提交材料清单：**
1. **蓝图 YAML 文件：** 完整的行业蓝图定义
2. **测试用例：** 至少 10 个测试场景，覆盖核心实体和关系
3. **文档：** README.md 说明蓝图的适用场景、使用方法和已知限制
4. **行业验证报告：** 至少 3 家企业的实际应用反馈
5. **兼容性测试：** 与最新 T1 内核的兼容性测试结果

### 贡献审核流程（4 步）

```
Step 1: 形式审查 → Step 2: 技术审核 → Step 3: 行业专家评审 → Step 4: 合并决策
```

**Step 1: 形式审查（自动化）**
```yaml
checks:
  - yaml_syntax_valid: "YAML 格式正确，无语法错误"
  - required_fields_present: "所有必填字段已填写"
  - test_cases_count: "测试用例 ≥ 10 个"
  - documentation_complete: "README 包含适用场景/使用方法/限制"
  - license_compatible: "许可证与 Apache-2.0 兼容"
  - kernel_compatibility: "kernel_compatibility 字段与当前内核版本匹配"

result:
  - pass: "进入 Step 2"
  - fail: "退回给贡献者，说明缺失项"
```

**Step 2: 技术审核（自动化 + 人工）**
```yaml
checks:
  - blueprint_validate: "通过 blueprint-validate 工具校验"
  - no_standard_attribute_override: "未尝试覆盖 T1 标准属性"
  - governance_inheritance: "所有实体扩展继承了 governance 元数据"
  - no_rule_deletion: "未尝试删除 G1-G5 规则"
  - api_naming_convention: "API 扩展端点以 /ext/{domain}/ 为前缀"
  - no_circular_references: "实体关系无循环引用"
  - seed_data_confidence: "预填数据的 confidence 在 0.5-0.6 范围"

result:
  - pass: "进入 Step 3"
  - fail_with_fixable_issues: "退回修改，说明技术问题"
  - fail_with_design_issues: "进入 Step 3，由专家评审决定"
```

**Step 3: 行业专家评审（人工）**

邀请 2-3 位行业专家（来自 OrgCOS 顾问委员会）评审：
```yaml
review_criteria:
  - industry_accuracy: "实体/属性/关系是否准确反映行业实际？"
    weight: 0.30
  - completeness: "是否覆盖了行业核心概念？是否有明显遗漏？"
    weight: 0.25
  - practical_value: "蓝图是否具有实际应用价值？能否加速企业 OrgCOS 构建？"
    weight: 0.25
  - maintainability: "蓝图是否易于维护和扩展？结构是否清晰？"
    weight: 0.20

scoring:
  - ≥ 0.80: "推荐合并"
  - 0.60-0.79: "建议修改后合并"
  - < 0.60: "拒绝合并"

review_process:
  - 每位专家独立评审，提交评分和书面意见
  - 如果专家意见分歧大（分数差距 > 0.20），召开评审会议讨论
  - 综合专家意见，形成最终评审结论
```

**Step 4: 合并决策**
```yaml
decision_options:
  - merge: "直接合并到官方蓝图库，分配版本号"
  - merge_with_changes: "要求贡献者按专家意见修改后合并"
  - reject: "拒绝合并，说明原因（如：行业覆盖不足、设计缺陷）"
  - fork: "建议作为社区分支维护（非官方蓝图）"

post_merge:
  - assign_version: "分配语义版本号（如 manufacturing-v1.3.0）"
  - publish_to_registry: "发布到 OrgCOS Blueprint Registry"
  - notify_contributor: "通知贡献者合并结果"
  - update_documentation: "更新官方文档和示例"
```

### 审核 SLA

| 阶段 | SLA | 责任人 |
|------|-----|--------|
| Step 1 形式审查 | 3 个工作日 | 自动化 + 运营团队 |
| Step 2 技术审核 | 5 个工作日 | 技术委员会 |
| Step 3 专家评审 | 10 个工作日 | 行业专家 |
| Step 4 合并决策 | 2 个工作日 | 蓝图维护者 |
| **总计** | **≤ 20 个工作日** | - |

### 贡献者激励

- **认可：** 在蓝图文档和 OrgCOS 官网致谢贡献者
- **权限：** 获得该蓝图的维护者权限（可审核后续的 PR）
- **商业分成：** 如果蓝图产生商业销售，贡献者可获得分成（具体比例另行约定）

### 反馈机制

- **审核进度查询：** 贡献者可通过 `blueprint-contribution-status <submission-id>` 查询审核进度
- **反馈意见：** 每个审核阶段的反馈意见会通过邮件发送给贡献者
- **申诉渠道：** 如果贡献者对拒绝决定有异议，可向 OrgCOS 顾问委员会申诉

## 输出目录

```
output/
└── blueprint/
    ├── loaded-blueprint.yaml     # 加载的蓝图（副本）
    ├── custom-blueprint.yaml     # 定制化蓝图
    └── validation-report.json    # 验证报告
```

## Pitfalls

- 蓝图版本必须与 T1 内核版本兼容——检查 `kernel_compatibility` 字段
- 不要在一个蓝图中混合多个行业的扩展——每个蓝图专注一个行业
- governance_overrides 只能调参，不能删除规则——这是 T1 内核的硬约束
- 预填数据（seed_data）的 confidence 应设为 0.5-0.6——预填数据需要企业实践验证
- API 扩展端点必须以 `/ext/{domain}/` 为前缀，避免与标准 API 冲突

## Verification

1. 蓝图 YAML 通过 yamllint 格式检查
2. 蓝图通过 blueprint-validate 校验
3. 所有实体扩展继承 governance 元数据
4. 规则覆写不违反 T1 硬约束
5. API 扩展端点命名符合规范
