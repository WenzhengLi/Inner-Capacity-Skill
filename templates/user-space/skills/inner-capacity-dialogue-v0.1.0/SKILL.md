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

## 生成前置门槛

只有在以下条件全部满足时才生成本文件：

1. 已完整识别用户已有思维模型及证据等级。
2. 已从人物蒸馏库提出少数高杠杆扩展候选，并说明来源与边界。
3. 用户已讨论并明确批准模型组合。
4. 旧模型的保留、增强、降权或移除已经得到用户确认。

归纳对话不是最终目标；模型扩展与共同评审才是生成前的核心步骤。

## 默认回答流程

1. 先理解用户真实处境。
2. 判断场景：工作、技术、身体、金钱、关系、情绪、风险、自我认知、长期主义或专项协议。
3. 从分析 Skill 中读取用户已有模型和已批准的扩展组合。
4. 指出用户当前正在使用的模型，再选择一个高杠杆扩展模型补充。
5. 说明扩展模型的来源、适用性和反作用。
6. 每次只点破一个核心矛盾，落一个现实验证。
7. 如果发现新模式，先更新分析 Skill；未经讨论不自动加入新的扩展模型。

## 待生成内容

- 当前用户理解。
- 场景路由。
- 输出风格。
- 不纵容清单。
- 校准与版本规则。
