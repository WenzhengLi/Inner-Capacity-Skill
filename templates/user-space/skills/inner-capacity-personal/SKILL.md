---
name: inner-capacity-personal
description: Private user-specific analysis/calibration Skill generated after the 50-question assessment and user model evaluation are complete. Use to calibrate the user's model before loading the versioned conversation/execution Skill; do not use as the executable dialogue Skill when conversation_skill_path exists.
---

# Inner Capacity Personal Skill

状态：模板，等待根据用户 50 题回答和模型分析生成。

## 启用条件

读取 `user-space/state.json`：

- `assessment_completed=true`
- `evaluation_completed=true`
- `user_skill_generated=true`
- `analysis_skill_path` 指向本文件
- `conversation_skill_path` 指向版本化对话 / 执行 Skill

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

## 校准工作流

1. 先理解用户当前真实问题。
2. 判断它属于工作、技术、身体、金钱、关系、情绪、风险、自我认知、长期主义或支线任务。
3. 读取相关私人记录和公开协议，更新对用户模型的判断。
4. 将可执行回应交给 `conversation_skill_path` 指向的版本化对话 / 执行 Skill。
5. 如果 `conversation_skill_path` 缺失，按 `docs/protocols/USER_SKILL_GENERATION_PROTOCOL.md` 生成对话 / 执行 Skill，而不是用本文件替代。

## 不纵容清单

待生成。

## 继续校准的问题

待生成。

## 执行前检查

使用本 Skill 前，先确认：

1. Router 已判断任务类型（`skills/agent-router/SKILL.md` 或 `docs/protocols/AGENT_ROUTER_PROTOCOL.md`）。
2. 普通成长对话必须先读本 Skill 校准用户模型，再读取 `conversation_skill_path` 指向的对话 / 执行 Skill 回答。
3. 涉及以下情况时，必须走任务单（见 `docs/protocols/AGENT_ROUTER_PROTOCOL.md` 第四步）：
   - 写入文件（故事日志自动记录除外）。
   - 公开仓库提交。
   - 重写或修改 Skill 文件。
   - 健康、命理、财务、法律、重大关系判断。

## 完成证明

每次使用本 Skill 回答后：

1. 如果执行了文件改动，输出文件列表。
2. 如果没有改文件，明确说明"本次未修改任何文件，仅提供分析/建议"。
3. 如果跳过了某些动作，说明原因。
4. 说明下一步建议。
