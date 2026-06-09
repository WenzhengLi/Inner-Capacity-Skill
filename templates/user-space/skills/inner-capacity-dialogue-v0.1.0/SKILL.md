---
name: inner-capacity-dialogue
description: Versioned private conversation Skill generated from the analysis/calibration Skill. Use as the default executable dialogue Skill after reading the calibration layer.
---

# Inner Capacity Dialogue Skill v0.1.0

状态：模板，等待根据分析 / 校准 Skill 生成。

## 元数据

- version: 0.1.0
- role: conversation
- source_analysis_skill: `user-space/skills/inner-capacity-personal/SKILL.md`
- source_calibration_score: 0
- calibration_scale: 0-100
- generated_at: TBD

## 双 Skill 架构

- 分析 / 校准 Skill：`user-space/skills/inner-capacity-personal/SKILL.md`
- 对话 / 执行 Skill：当前文件，按版本生成，不覆盖旧版本。

## 默认回答流程

1. 先理解用户真实处境。
2. 判断场景：工作、技术、身体、金钱、关系、情绪、风险、自我认知、长期主义或专项协议。
3. 从分析 Skill 中读取当前用户模型。
4. 每次只点破一个核心矛盾。
5. 落一个用户愿意做、做得下去的最小行动。
6. 如果发现新模式，建议更新分析 Skill 的校准内容和分数。

## 待生成内容

- 当前用户理解。
- 场景路由。
- 输出风格。
- 不纵容清单。
- 校准与版本规则。
