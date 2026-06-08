# 用户专属 Skill 生成协议

用途：把 50 题评估、用户模型诊断、外部思维模型推荐和后续对话路由连接成闭环。

## 核心闭环

```text
未初始化
-> 答题中
-> 已答完，待分析
-> 已分析，待生成用户 Skill
-> 已生成用户 Skill
-> 后续对话优先读取用户 Skill
```

用户专属 Skill 不是重新训练模型，而是把用户画像、当前思维模型、推荐扩展模型、沟通边界和路由规则写成一个私人 `SKILL.md`，供后续 Agent 对话时优先读取。

## 文件位置

公开内核：

- `docs/protocols/ASSESSMENT_PROTOCOL.md`
- `docs/core/DISTILLATION_METHOD.md`
- `docs/inventory/PERSONA_SKILL_INDEX.md`
- `docs/inventory/EXTERNAL_SKILL_MODELS.md`

私人输出：

- `user-space/state.json`
- `user-space/ASSESSMENT_ANSWERS.md` 或 `user-space/legacy/ASSESSMENT_QUESTIONS_WITH_PERSONAL_ANSWERS.md`
- `user-space/USER_MODEL.md`
- `user-space/USER_MODEL_DIAGNOSIS_DRAFT.md`
- `user-space/skills/inner-capacity-personal/SKILL.md`

模板：

- `templates/user-space/USER_MODEL.md`
- `templates/user-space/skills/inner-capacity-personal/SKILL.md`

## 状态字段

`user-space/state.json` 应至少包含：

```json
{
  "stage": "personal_skill_ready",
  "answered_count": 50,
  "assessment_completed": true,
  "evaluation_completed": true,
  "model_recommendation_completed": true,
  "user_skill_generated": true,
  "user_skill_path": "user-space/skills/inner-capacity-personal/SKILL.md"
}
```

推荐阶段值：

| stage | 含义 |
|---|---|
| `onboarding` | 尚未完成初始化 |
| `assessment_in_progress` | 50 题进行中 |
| `assessment_completed_pending_evaluation` | 50 题已答完，未生成分析 |
| `evaluation_completed_pending_skill` | 已生成用户模型分析，未生成用户专属 Skill |
| `personal_skill_ready` | 用户专属 Skill 已生成，可作为默认对话路由 |

## 切换判断

每次用户进入主对话、说“开始”、问“为什么没切换到我的 Skill”、或请求成长建议时，按此顺序判断：

1. 如果 `user-space/state.json` 不存在：
   - 检查是否存在旧版 50 题回答。
   - 如果旧版回答完整，创建状态并进入 `evaluation_completed_pending_skill` 或 `personal_skill_ready`。
   - 如果没有完整回答，进入初始化或继续答题。
2. 如果 `answered_count < 50` 或 `assessment_completed=false`：
   - 说明题没有答完。
   - 输出当前进度，并继续出 3 题。
3. 如果 `assessment_completed=true` 但 `evaluation_completed=false`：
   - 说明题答完了，但没有进行模型分析。
   - 读取答案并生成 `user-space/USER_MODEL.md` 或诊断草案。
4. 如果 `evaluation_completed=true` 但 `user_skill_generated=false`：
   - 说明分析完成了，但没有生成用户专属 Skill。
   - 根据用户模型和本地外部模型索引生成私人 Skill。
5. 如果 `user_skill_generated=true` 但文件不存在：
   - 状态文件失真。
   - 重新生成 Skill 或修正状态。
6. 如果 Skill 存在：
   - 后续对话优先读取该 Skill，再按健康、命理、故事、支线任务等专项协议分流。

## 主线进度查询

当用户说以下任一指令时，输出主线进度：

- `查看主线进度`
- `查看 Skill 进度`
- `检查 Skill 状态`
- `检查我的模型状态`
- `我现在到哪一步了`

读取：

- `user-space/state.json`
- `user-space/skills/inner-capacity-personal/SKILL.md`
- `user-space/USER_MODEL.md` 或 `user-space/USER_MODEL_DIAGNOSIS_DRAFT.md`
- 评估回答文件，如 `user-space/ASSESSMENT_ANSWERS.md` 或 `user-space/legacy/ASSESSMENT_QUESTIONS_WITH_PERSONAL_ANSWERS.md`

输出格式：

```text
主线进度：{stage}

50 题：{answered_count}/{total_questions}，{已完成 / 进行中}
用户模型分析：{已完成 / 未完成}
外部模型推荐：{已完成 / 未完成}
用户专属 Skill：{已生成 / 未生成 / 状态失真}
当前主 Skill：{user_skill_path 或 无}

下一步：
{继续答题 / 生成用户模型 / 生成用户专属 Skill / 进入日常成长与专项训练}
```

如果 `state.json` 与实际文件不一致，以实际文件为准，并提示需要修正状态。

## 生成用户模型

分析 50 题时至少输出：

- 用户已有思维模型。
- 用户主要欲望和恐惧。
- 价值排序。
- 判断方式。
- 行动模式。
- 关系模式。
- 身体底盘。
- 金钱模式。
- 风险边界。
- 当前成长阶段。
- 主要短板。

保存到：

- 正式版：`user-space/USER_MODEL.md`
- 草案版：`user-space/USER_MODEL_DIAGNOSIS_DRAFT.md`

## 推荐外部模型组合

根据 `docs/inventory/PERSONA_SKILL_INDEX.md` 和 `docs/inventory/EXTERNAL_SKILL_MODELS.md`，推荐 3-7 个模型作为组合包。

推荐时必须说明：

| 字段 | 说明 |
|---|---|
| 模型名 | 如费曼、段永平、芒格、塔勒布、张一鸣 |
| 补足盲区 | 它解决用户哪类短板 |
| 使用场景 | 什么时候切换这个视角 |
| 禁用边界 | 什么情况下不能滥用 |

推荐原则：

- 不堆满名人模型。
- 优先补用户当前最大短板。
- 每个模型必须有明确用途。
- 模型组合必须服务用户自己的主线，而不是把用户变成别人。

## 用户专属 Skill 内容

`user-space/skills/inner-capacity-personal/SKILL.md` 至少包含：

1. YAML frontmatter：
   - `name`
   - `description`
2. 当前阶段判断。
3. 用户已有思维模型。
4. 推荐扩展模型组合。
5. 默认对话工作流。
6. 场景路由：
   - 工作推进
   - 技术成长
   - 身体底盘
   - 金钱欲望
   - 关系沟通
   - 情绪自控
   - 风险边界
   - 长期主义
7. 不纵容清单。
8. 需要继续校准的问题。

## 输出规则

生成或更新用户专属 Skill 后，必须告诉用户：

- 当前状态是什么。
- 读取了哪些来源。
- 生成到了哪个路径。
- 后续如果切换不到，应该检查哪个状态字段。

## 边界

- 用户专属 Skill 属于私人数据，默认不提交公开仓库。
- 不能把用户隐私写入公开 `docs/`。
- 不能把外部人物模型直接套到用户身上。
- 不能把诊断写成宿命判断。
- 用户明确拒绝某个模型或表达方式时，后续应从 Skill 中降权或移除。
