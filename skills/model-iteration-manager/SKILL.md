---
name: model-iteration-manager
description: Manage evidence-driven, jointly reviewed iterations of a user's thinking model and versioned dialogue Skill. Use when the user says “迭代下一版”, “再出一轮题”, “重构模型”, “生成3.0”, “沉淀这次迭代逻辑”, or asks to evolve the private model from conversations, assessments, actions, and distilled-persona models. Enforce model preservation, local-library provenance, explicit user approval, validation, and safe activation.
---

# Model Iteration Manager

## 核心原则

把新版生成当作受控状态机，不把对话归纳直接当成新版。

固定闭环：

```text
收集证据
→ 提取已有模型
→ 从蒸馏库寻找高杠杆候选
→ 用户共同评审
→ 生成新版草案
→ 校验
→ 激活
→ 收集行为反馈
```

归纳只是输入。模型扩展、共同评审和现实验证才是核心价值。

## 启动顺序

1. 读取 `skills/agent-router/SKILL.md` 和 `user-space/state.json`。
2. 读取 `docs/protocols/MODEL_ITERATION_PROTOCOL.md`。
3. 读取当前 `USER_MODEL.md`、分析 Skill和对话 Skill。
4. 运行 `scripts/model-iteration.ps1 -Action status` 检查是否已有待完成迭代。
5. 没有待完成迭代时，运行 `-Action start -ModelVersion <version>`。

详细产物要求见 [references/artifact-guide.md](references/artifact-guide.md)。

## 状态机

| 状态 | Agent职责 | 是否可生成新版 |
|---|---|---|
| `evidence_collecting` | 收集对话、题目、行动、外部结果 | 否 |
| `existing_models_ready` | 完整列出旧模型及证据等级 | 否 |
| `candidates_ready` | 从人物蒸馏库提出少数高杠杆候选 | 否 |
| `awaiting_user_review` | 展示来源、价值、反作用和取舍 | 否 |
| `model_stack_approved` | 保存用户批准原话和模型ID | 是，可生成草案 |
| `skill_generated` | 生成新模型快照、分析更新和对话Skill | 否，先校验 |
| `validated_ready_for_activation` | Skill、来源、旧版本和状态检查通过 | 是，可激活 |
| `active` | 更新当前版本入口，保留旧版本 | 已完成 |

任何阶段缺口都必须停止在相应状态，不得用文字声称“已经完成”。

## 自动化命令

在项目根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File skills/model-iteration-manager/scripts/model-iteration.ps1 -Action start -ModelVersion 3.0
powershell -ExecutionPolicy Bypass -File skills/model-iteration-manager/scripts/model-iteration.ps1 -Action status -ModelVersion 3.0
```

用户明确批准后，保存其原话：

```powershell
powershell -ExecutionPolicy Bypass -File skills/model-iteration-manager/scripts/model-iteration.ps1 `
  -Action record-review -ModelVersion 3.0 `
  -ApprovedModelId model-a,model-b `
  -ApprovalEvidence "用户原话"
```

生成Skill后：

```powershell
powershell -ExecutionPolicy Bypass -File skills/model-iteration-manager/scripts/model-iteration.ps1 `
  -Action mark-generated -ModelVersion 3.0 `
  -DialogueVersion 0.3.0 `
  -SkillPath user-space/skills/inner-capacity-dialogue-v0.3.0/SKILL.md

powershell -ExecutionPolicy Bypass -File skills/model-iteration-manager/scripts/model-iteration.ps1 `
  -Action validate -ModelVersion 3.0
```

若原位重构当前对话Skill，`mark-generated`还必须传入：

```powershell
-PreGenerationSnapshotPath user-space/model-snapshots/dialogue-v0.3.0-pre-review/SKILL.md
```

只有验证通过并且用户授权切换后才能激活：

```powershell
powershell -ExecutionPolicy Bypass -File skills/model-iteration-manager/scripts/model-iteration.ps1 `
  -Action activate -ModelVersion 3.0 -ConfirmActivation
```

## 模型提取规则

- 从真实事件中提取“如何定义问题、选信息、定主次、控风险、行动和退出”。
- 区分 `已验证`、`正在形成`、`待验证`。
- 每个模型至少绑定一个证据；没有证据只算候选解释。
- 与上一版逐项对照：保留、增强、降权、移除建议。
- 未经用户明确同意，禁止删除旧模型。

## 蒸馏库扩展规则

- 先判断用户当前阶段的关键认知瓶颈，再搜索人物库。
- 选择能改变整个判断链的少数模型，不按每个问题一一配名人。
- 必须读取人物Skill的核心模型、证据、局限和诚实边界。
- 每个候选必须写入真实本地 `source_path`，校验脚本会检查。
- 说明为什么现在选它，以及为什么其他名人模型暂不进入核心。
- 人物语气、名言和身份不算思维模型。

## 用户评审门槛

自动化不能替用户批准。

只有用户明确表达同意、拒绝、修改或暂缓时，才能运行 `record-review`。必须保存用户原话；不能把沉默、继续聊天或Agent推荐当成批准。

批准只代表试用。只有后续行为证据出现，才能把扩展模型升级为“用户已有模型”。

## 生成规则

生成新版时必须同时处理：

- 版本化用户模型快照。
- 活的分析 / 校准 Skill。
- 新的对话 / 执行 Skill。
- `state.json` 和恢复摘要。
- 旧版本与生成前草案备份。

若新Skill路径与迭代启动时的当前Skill路径相同，`mark-generated`会强制要求生成前快照，验证阶段也会检查快照存在。

新对话Skill必须明确：用户已有模型、批准试用模型、人物来源、调用顺序、适用场景和禁用边界。

## 禁止事项

- 不绕过 `awaiting_user_review`。
- 不在候选阶段修改当前生效的对话Skill。
- 不用新模型覆盖旧模型。
- 不因模型名字高级就加入。
- 不把个人证据写入公开协议或模板。
- 不删除旧版本；需要替换草案时先留快照。
- 不在验证失败时更新当前版本入口。

## 完成证明

交付时说明：

1. 当前迭代状态和各门槛。
2. 用户保留、批准、拒绝和暂缓了哪些模型。
3. 新旧版本路径和备份路径。
4. 运行了哪些校验。
5. 哪些内容仍需真实行为验证。
