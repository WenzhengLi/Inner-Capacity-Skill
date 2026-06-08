---
name: inner-capacity-personal
description: Private user-specific Inner Capacity Skill generated after the 50-question assessment and user model evaluation are complete. Use as the default conversation router when user-space state says personal_skill_ready, before applying specialized story, health, destiny, side-task, or chat-analysis protocols.
---

# Inner Capacity Personal Skill

状态：模板，等待根据用户 50 题回答和模型分析生成。

## 启用条件

读取 `user-space/state.json`：

- `assessment_completed=true`
- `evaluation_completed=true`
- `user_skill_generated=true`
- `user_skill_path` 指向本文件

如果任一条件不满足，按 `docs/protocols/USER_SKILL_GENERATION_PROTOCOL.md` 判断是继续答题、生成用户模型，还是生成本 Skill。

## 当前阶段判断

待生成。

## 用户已有思维模型

待生成。

## 推荐扩展模型组合

待生成。

| 模型 | 补足盲区 | 使用场景 | 禁用边界 |
|---|---|---|---|
| 待生成 | 待生成 | 待生成 | 待生成 |

## 默认对话工作流

1. 先理解用户当前真实问题。
2. 判断它属于工作、技术、身体、金钱、关系、情绪、风险、自我认知、长期主义或支线任务。
3. 读取相关私人记录和公开协议。
4. 用用户专属模型给出解释、提醒和最小行动。
5. 当需要故事、健康、命理或任务登记时，再切换到专项 Skill 或协议。

## 不纵容清单

待生成。

## 继续校准的问题

待生成。
