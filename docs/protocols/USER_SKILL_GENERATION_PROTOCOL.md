# 用户专属 Skill 生成协议

用途：把 50 题评估、用户模型诊断、外部思维模型推荐和后续对话路由连接成闭环。

## 核心闭环

```text
未初始化
-> 答题中
-> 已答完，待分析
-> 已提取用户已有思维模型
-> 已从蒸馏库生成高杠杆扩展候选
-> 待用户讨论与批准模型组合
-> 已批准，待生成用户 Skill
-> 已生成用户 Skill
-> 后续对话优先读取用户 Skill
```

## 思维模型共同评审门槛

本系统的核心不是根据对话和问题做归纳后直接生成对话 Skill。归纳只是输入；核心价值是识别用户已有思维模型，并从人物蒸馏库中寻找现阶段最可能产生乘数效应的扩展模型，与用户讨论后再生成版本。

每次生成新对话版本前必须完成：

1. **已有模型识别**：从对话、题目和真实行动中列出用户已经在使用的模型，并标注已验证、正在形成和待验证。
2. **版本差异检查**：说明哪些旧模型保留、增强、降权或建议移除。未经用户确认，不得因新版简洁而删除旧模型。
3. **人物蒸馏库检索**：读取 `docs/inventory/PERSONA_SKILL_INDEX.md`、`docs/inventory/EXTERNAL_SKILL_MODELS.md` 和相关人物 Skill。按用户当前阶段寻找少数高杠杆模型，不按题目或盲区机械一一对应。
4. **候选说明**：每个模型必须给出人物来源、本地路径、补足盲区、使用场景、禁用边界，以及为何现在比其他模型更值得加入。
5. **用户讨论**：让用户对候选模型做批准、试用、拒绝或暂缓决定。不得把 Agent 推荐自动视为用户接受。
6. **批准后生成**：只有用户明确批准模型组合后，才能新建或重构对话 Skill。
7. **行为验证**：批准只代表同意试用，不代表用户已经拥有。后续必须用真实事件和结果验证，才能写入“用户已有模型”。

如果共同评审尚未完成，状态必须标记为待评审或草案，不得宣称正式新版本已经完成。

用户专属 Skill 不应只有一个文件。

它分成两条线：

- **分析 / 校准 Skill**：记录当前对用户理解到了多少，允许随着每次对话、回答、作业和真实行动持续修正，并维护 `0% -> 100%` 的校准分数。
- **对话 / 执行 Skill**：在某个校准分数上生成出来的版本化对话 Skill，负责后续 Agent 怎么听、怎么判断、怎么回应、怎么训练、怎么落动作。

分析 Skill 是活的校准层；对话 Skill 是版本化执行层。达到 100% 校准时，不覆盖旧对话 Skill，而是生成下一版对话 Skill。

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
- `user-space/skills/inner-capacity-personal/SKILL.md`（分析 / 校准 Skill）
- `user-space/skills/inner-capacity-dialogue-v*/SKILL.md`（对话 / 执行 Skill，版本化）

模板：

- `templates/user-space/USER_MODEL.md`
- `templates/user-space/skills/inner-capacity-personal/SKILL.md`

## Skill Frontmatter 规则

所有 `SKILL.md` 的 YAML frontmatter 只能包含：

- `name`
- `description`

`version`、`role`、`source_analysis_skill`、`source_calibration_score`、`calibration_score`、`generated_at` 等运行元数据必须写入正文，例如 `## 元数据` 或 `## 校准状态`。

生成或更新用户专属 Skill 后，必须运行 `skill-creator` 的 `quick_validate.py` 验证 Skill 目录。验证失败时，不得标记为已生成。

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
  "user_skill_path": "user-space/skills/inner-capacity-dialogue-v0.1.0/SKILL.md",
  "analysis_skill_path": "user-space/skills/inner-capacity-personal/SKILL.md",
  "analysis_skill_role": "calibration",
  "analysis_calibration_score": 5,
  "analysis_calibration_scale": "0-100",
  "conversation_skill_path": "user-space/skills/inner-capacity-dialogue-v0.1.0/SKILL.md",
  "conversation_skill_role": "dialogue",
  "conversation_skill_version": "0.1.0"
}
```

推荐阶段值：

| stage | 含义 |
|---|---|
| `onboarding` | 尚未完成初始化 |
| `assessment_in_progress` | 50 题进行中 |
| `assessment_completed_pending_evaluation` | 50 题已答完，未生成分析 |
| `evaluation_completed_pending_skill` | 已生成用户模型分析，未生成用户专属 Skill |
| `model_expansion_pending_review` | 已识别模型并生成扩展候选，等待用户讨论 |
| `model_expansion_approved_pending_skill` | 用户已批准扩展组合，等待生成对话 Skill |
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
4. 如果 `evaluation_completed=true` 但模型扩展尚未评审：
   - 先完整列出用户已有模型。
   - 从本地人物蒸馏库生成少数高杠杆候选，说明来源与边界。
   - 将状态置为 `model_expansion_pending_review`，等待用户讨论；不得直接生成对话 Skill。
5. 如果用户已经批准模型组合但 `user_skill_generated=false`：
   - 将状态置为 `model_expansion_approved_pending_skill`。
   - 根据用户已有模型和批准的扩展组合生成版本化对话 Skill。
6. 如果 `user_skill_generated=true` 但文件不存在：
   - 状态文件失真。
   - 重新生成对话 Skill 或修正状态。
7. 如果 `analysis_skill_path` 存在但 `conversation_skill_path` 不存在：
   - 说明只有分析 / 校准 Skill，没有生成对话 / 执行 Skill。
   - 新建版本化对话 Skill，不覆盖分析 Skill。
8. 如果两个 Skill 都存在：
   - 后续对话先读取分析 / 校准 Skill，再读取当前版本对话 Skill，再按健康、命理、故事、支线任务等专项协议分流。

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
分析 / 校准 Skill：{已存在 / 缺失}，校准分数：{0-100 或 未设置}
对话 / 执行 Skill：{已生成 / 未生成 / 状态失真}，版本：{version 或 无}
当前主 Skill：{conversation_skill_path 或 user_skill_path 或 无}

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

用户模型必须分开记录：

- 用户已有思维模型及证据等级。
- Agent从蒸馏库推荐的候选模型。
- 用户已批准试用的扩展模型。
- 用户拒绝或暂缓的模型。

不得把“批准试用的扩展模型”直接写成“用户已经拥有的思维模型”。

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
- 优先寻找能形成完整判断链或产生乘数效应的少数组合，不按每个问题机械匹配一个人物。
- 推荐后必须进入用户讨论门槛；未经批准不得写入正式对话 Skill。

## 分析 / 校准 Skill 内容

`user-space/skills/inner-capacity-personal/SKILL.md` 至少包含：

1. YAML frontmatter：
   - `name`
   - `description`
2. 正文 `## 元数据`：
   - `role: calibration`
   - `calibration_score: 0-100`
   - `calibration_scale: 0-100`
   - `last_calibrated_at`
   - `current_conversation_skill`
3. 校准分数：`0-100`。
4. 当前阶段判断。
5. 用户已有思维模型。
6. 推荐扩展模型组合。
7. 已验证证据与待验证假设。
8. 需要继续校准的问题。

分析 / 校准 Skill 可以在每次重要对话、每日检查、故事作业、真实行动反馈后更新。

## 对话 / 执行 Skill 内容

`user-space/skills/inner-capacity-dialogue-v*/SKILL.md` 至少包含：

1. YAML frontmatter：
   - `name`
   - `description`
2. 正文 `## 元数据`：
   - `version`
   - `role: conversation`
   - `source_analysis_skill`
   - `source_calibration_score`
   - `calibration_scale`
   - `generated_at`
3. 双 Skill 架构说明。
4. 启用顺序。
5. 默认回答流程。
6. 场景路由：
   - 工作推进
   - 技术成长
   - 身体底盘
   - 金钱欲望
   - 关系沟通
   - 情绪自控
   - 风险边界
   - 长期主义
7. 输出风格。
8. 不纵容清单。
9. 校准与版本规则。

对话 / 执行 Skill 不应在日常校准中被频繁修改。只有当分析 Skill 的校准分数达到 100%，或用户明确要求生成新版本时，才新建下一版对话 Skill。

## 输出规则

生成或更新用户专属 Skill 后，必须告诉用户：

- 当前状态是什么。
- 读取了哪些来源。
- 生成到了哪个路径。
- 后续如果切换不到，应检查 `analysis_skill_path`、`conversation_skill_path`、`conversation_skill_version` 和 `user_skill_path`。

## 边界

- 用户专属 Skill 属于私人数据，默认不提交公开仓库。
- 不能把用户隐私写入公开 `docs/`。
- 不能把外部人物模型直接套到用户身上。
- 不能把诊断写成宿命判断。
- 用户明确拒绝某个模型或表达方式时，后续应从 Skill 中降权或移除。
