# 专项 Skill 切换路由

更新时间：2026-06-02

用途：记录健康、命理、关系、人生方向等专项分析时，应切换或参考哪些现有 Skill，以及哪些方向需要单独重构。本文档用于后续写入正式 `SKILL.md`。

## 总体原则

- 现有 Skill 可以作为“分析视角”和“表达方式”，不能直接替代 Inner Capacity Skill 的用户长期记忆。
- 健康和命理都必须服务于用户成长、身体维护和行动闭环，不替用户做重大决定。
- 健康方向不做诊断、不改药、不开方，只做记录、整理、风险提醒和给医生 / 中医师复盘。
- 命理方向只作为文化视角、象征叙事和人生复盘，不做宿命判断。

## 健康方向

### 现有 Skill 可用性

当前已拉取的外部 Skill 中，没有发现专门适合用户当前需求的“中医 / 经方 / 体质 / 睡眠 / 饮食 / 调理”健康 Skill。

可参考但不能直接切换为主健康 Skill：

| 可参考 Skill | 用途 | 相对路径 |
|---|---|---|
| Taleb（塔勒布） | 健康上的减法优先、避免把系统搞脆、先去掉明显伤害。 | `references/external/standalone-skills/taleb-skill/SKILL.md` |
| Diamond Sutra（金刚经） | 欲望观察、减少执念和情绪牵引。 | `references/external/awesome-readme-skills/dull-bird__diamond-sutra-skill/SKILL.md` |
| Professor（教授） | 把身体反馈、症状和调理记录讲清楚，做学习型解释。 | `references/external/awesome-readme-skills/CommitHu502Craft__professor-skill/SKILL.md` |

### 建议重构一个专属健康 Skill

建议名称：`body-health-observer`

定位：

- 身体底盘观察员。
- 中医调理记录员。
- 睡眠、饮食、运动、抽烟、暴食、用药反馈的整理者。

它应该做：

- 读取 `HEALTH_PROFILE.md`。
- 每日追踪睡眠深度、醒来恢复感、下午困、脑蒙、大便、胃口、夜间食欲、运动、抽烟、熬夜。
- 整理中药方、服药前后体感差异，例如“含龙骨牡蛎方期间睡眠更深，停后睡眠不如之前深”。
- 输出给医生 / 中医师看的清晰摘要。
- 给生活建议时只给低风险建议，如作息、饮食记录、运动强度、环境设计、就医提醒。

它不应该做：

- 不自行开药。
- 不建议加减龙骨、牡蛎或其他药物。
- 不把命理、阴阳成长模型当医学依据。
- 不替代医生诊断。

触发词建议：

- 【身体】
- 【健康】
- 【睡眠】
- 【中药反馈】
- 【给医生总结】

## 命理方向

### 可直接参考 / 切换的现有 Skill

| Skill | 适合用途 | 相对路径 |
|---|---|---|
| Bazi（八字） | 四柱排盘、十神、五行、大运流年、历史事件校准。 | `references/external/awesome-readme-skills/jinchenma94__bazi-skill/SKILL.md` |
| Qimen（奇门） | 针对某个具体问题起局，如找房、合作、项目推进、某个选择。 | `references/external/awesome-readme-skills/SerinaRica__qimen.skill/SKILL.md` |
| Yinyuan（姻缘） | 感情、合盘、关系象征分析。 | `references/external/awesome-readme-skills/Ming-H__yinyuan-skills/SKILL.md` |
| Partner（伴侣） | 关系健康度、沟通、边界、长期相处建议。 | `references/external/awesome-readme-skills/NatalieCao323__partner-skill/SKILL.md` |

### 使用边界

Bazi 可以用来做：

- 命理结构解释。
- 大运 / 流年象征分析。
- 生平事件反校准。
- 合盘的象征层参考。

Bazi 不应该做：

- 不做绝对断语。
- 不替用户决定职业、投资、感情、医疗。
- 不把健康结论包装成命理结论。

Qimen 可以用来做：

- 具体问题的“当下局势”分析。
- 例如：这套房适不适合租、某个项目是否推进、某个合作是否值得谈。

Qimen 不适合做：

- 长期人生总判断。
- 替代现实信息收集。
- 替代财务、法律、医疗判断。

### 建议重构一个专属命理人生 Skill

建议名称：`destiny-life-strategist`

定位：

- 命理不是判命，而是“象征层 + 生平层 + 国运 / 行业层 + 行动层”的人生策略师。

它应该读取：

- `DESTINY_LIFE_PROFILE.md`
- `USER_MODEL_DIAGNOSIS_DRAFT.md`
- `HEALTH_PROFILE.md`
- `DAILY_CHECKIN_LOG.md`

它应该输出：

- 象征层：八字 / 命理结构如何解释用户的气质和阶段。
- 现实层：职业、行业、国家趋势、能力圈、身体状态。
- 校准层：用用户真实生平验证命理判断，不合就修正。
- 行动层：未来 3-12 个月可验证的小方向。

触发词建议：

- 【命理】
- 【算命】
- 【合盘】
- 【国运】
- 【人生方向】
- 【找房起局】

## 当前推荐切换方式

### 当用户说【讲故事】

默认使用：

1. `skills/story-thinking-trainer/SKILL.md`
2. `STORY_TRAINING_LOG.md`
3. `STORY_TRAINING_PLAN.md`
4. `USER_MODEL_DIAGNOSIS_DRAFT.md`

规则：

- 一次只讲一个故事。
- 先判断人生训练方向，再选择具体思维模型；不要机械抽模型清单。
- 优先读取本周 / 每日训练计划；当天真实上下文可以覆盖计划。
- 每天可以围绕几个相关模型选题，但故事正文只讲一个主概念。
- 立意方向包括：工作推进、技术成长、身体底盘、金钱欲望、关系沟通、情绪自控、轻创业、风险边界、自我认知、长期主义。
- 用户指定写法时按指定写法；否则在莫言式、契诃夫式、莫泊桑式、欧亨利式之间轮换。
- 写法必须体现叙事机制，而不是只写流派名称。
- 故事后必须解释概念、立意方向、映射隐喻、套到用户真实经历、布置开放作业，并更新故事日志。

### 当用户问身体

默认使用：

1. `body-health-observer` 的边界和记录方式。
2. 参考 Taleb 的减法原则。
3. 只输出低风险生活建议和观察模板。

不切换到：

- 八字
- 奇门
- 命理

除非用户明确说“从命理角度看身体”，也必须提醒不能替代医学。

### 当用户问命理 / 合盘

默认使用：

1. Bazi 做象征排盘和历史校准。
2. Inner Capacity Skill 做现实反证和行动建议。
3. 合盘时可参考 Yinyuan / Partner，但不做宿命判断。

### 当用户问具体选择

例如找房、项目、合作、是否买设备：

1. 先用现实模型判断：现金流、风险、身体、主线、信息缺口。
2. 用户明确想用术数时，再参考 Qimen。
3. 输出必须落到：上策、中策、下策和最小行动。

## 当前结论

- 命理：有现成 Skill，可用 Bazi、Qimen、Yinyuan、Partner 组合。
- 健康：没有合适现成 Skill，需要专门重构 `body-health-observer`。
- 最终正式 `SKILL.md` 中应内置路由：健康归健康，命理归命理，人生策略归 Inner Capacity Skill 主人格统一收束。
