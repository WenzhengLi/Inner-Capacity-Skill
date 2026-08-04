# Agent Router Protocol

每次收到用户消息，必须先执行 Router Check，再执行具体任务。不得跳过。

## 第一步：读取状态

1. 读取 `user-space/SYNC_STATE.json`，超过 24 小时未同步则先执行同步（规则见 `STARTUP_SYNC_PROTOCOL.md`）。
2. 读取 `user-space/state.json`。如果不存在，路由到【初始化】。

## 第二步：判断任务类型

先确定主任务类型。若消息同时涉及健康、隐私、提交、删除、user-space 写入、公开仓库提交、重写 Skill 等安全边界，必须叠加对应禁止规则，不因主类型匹配而跳过安全检查。

### 1. 主线进度查询

**触发词**：`查看主线进度`、`查看 Skill 进度`、`检查 Skill 状态`、`检查我的模型状态`、`我现在到哪一步了`
**必须读取**：`user-space/state.json`、`analysis_skill_path` 指向的分析 / 校准 Skill（如果存在）、`conversation_skill_path` 指向的对话 / 执行 Skill（如果存在）
**禁止**：不得修改任何文件。
**输出**：50 题进度、用户模型状态、Skill 生成状态、当前阶段、下一步建议。

### 2. 初始化

**触发条件**：`state.json` 不存在，或 `stage=onboarding`，或用户说`开始`且状态未完成。
**必须读取**：`docs/protocols/ONBOARDING_PROTOCOL.md`、`templates/user-space/`
**禁止**：不得跳过初始化问题直接进入评估。
**输出**：按 ONBOARDING_PROTOCOL 执行。

### 3. 讲故事

**触发词**：`【讲故事】`、`讲故事`、指定写法名称（如`莫言式`、`欧亨利式`）
**必须读取**：`skills/story-thinking-trainer/SKILL.md`、`user-space/STORY_TRAINING_LOG.md`、`docs/protocols/STORY_TRAINING_PLAN.md`
**条件读取**：如果 `personal_skill_ready`，先读取 `analysis_skill_path` 指向的分析 / 校准 Skill，再读取 `conversation_skill_path` 指向的对话 / 执行 Skill。
**禁止**：不得一次讲多个故事。不得跳过质量检查。不得不更新日志。
**输出**：一个故事、概念解释、应用（≤3）、开放作业、更新日志。

### 4. 健康

**触发词**：`健康`、`身体`、`睡眠`、`中药反馈`、`给医生总结`、`抽烟`、`暴食`、`运动`
**必须读取**：`user-space/HEALTH_PROFILE.md`、`docs/protocols/HEALTH_AND_DESTINY_MODULES.md`
**禁止**：不得做医疗诊断。不得开药、改药、停药。不得用命理做医学判断。
**输出**：记录整理、低风险建议、给医生摘要。

### 5. 命理 / 合盘 / 奇门

**触发词**：`命理`、`算命`、`八字`、`四柱`、`大运`、`流年`、`合盘`、`姻缘`、`奇门`、`国运`、`人生方向`、`找房起局`
**必须读取**：`skills/destiny-life-strategist/SKILL.md`、`user-space/destiny/DESTINY_LIFE_PROFILE.md`、`user-space/HEALTH_PROFILE.md`、`user-space/USER_MODEL_DIAGNOSIS_DRAFT.md`
**禁止**：不做宿命判断。不替用户做医疗、法律、财务决定。
**输出**：象征层 + 现实层 + 校准层 + 行动层，附上中下策和最小动作。

### 6. 支线任务

**触发词**：`登记任务`、`任务`、`支线任务`、`查看任务`
**必须读取**：`docs/protocols/SIDE_TASK_PROTOCOL.md`、`user-space/side-tasks/INDEX.md`
**禁止**：不得未经确认直接登记。不得一次登记超过 3 个任务。
**输出**：复述任务理解、确认后登记、写清索引和验收方式。

### 7. 聊天分析

**触发条件**：用户长篇表达观点、经历、反思，不属于上述类型。
**必须读取**：`docs/protocols/CHAT_ANALYSIS_PROTOCOL.md`
**条件读取**：如果 `personal_skill_ready` 且私人 Skill 存在，必须先读取。
**禁止**：不得急着纠正。不得把聊天材料自动固化为公开功能。
**输出**：先理解、再拆结构、再给模型、再给最小动作。

### 8. 功能沉淀

**触发词**：`功能沉淀`、`沉淀模式`、`做成可迁移`
**必须读取**：`docs/protocols/FUNCTION_CONSOLIDATION_PROTOCOL.md`
**禁止**：不得把个人经历、健康记录、命理记录写入公开项目。
**输出**：判断属于公开功能、个人记录、支线任务还是聊天素材，再按规则处理。

### 9. 思维模型版本迭代

**触发词/场景**：`迭代下一版`、`再迭代一版`、`重构模型`、`重构对话 Skill`、`生成3.0`、`下一版对话`、`沉淀这次迭代逻辑`
**必须读取**：`skills/model-iteration-manager/SKILL.md`、`docs/protocols/MODEL_ITERATION_PROTOCOL.md`、`user-space/state.json`、当前用户模型、分析Skill、对话Skill、人物蒸馏库索引
**禁止**：不得根据对话归纳后直接生成；不得绕过用户共同评审；不得无授权删除旧模型；不得在校验前切换当前版本入口。
**输出**：当前迭代状态、下一门槛、私人迭代工作区，或验证后的激活结果。

### 10. 用户专属 Skill 生成或修正

**触发词/场景**：`生成我的 Skill`、`修正我的 Skill`、`重新生成用户专属 Skill`、`为什么没切到我的 Skill`、`检查我的模型状态`
**必须读取**：`docs/protocols/USER_SKILL_GENERATION_PROTOCOL.md`、`user-space/state.json`、`user-space/USER_MODEL.md` 或 `user-space/USER_MODEL_DIAGNOSIS_DRAFT.md`、分析 / 校准 Skill、当前对话 / 执行 Skill（如果存在）、`docs/inventory/PERSONA_SKILL_INDEX.md`、`docs/inventory/EXTERNAL_SKILL_MODELS.md`
**禁止**：不得把分析 / 校准 Skill 当成对话 / 执行 Skill。不得覆盖现有分析 Skill 或旧版对话 Skill；生成对话 Skill 时应新建版本化目录。
**输出**：当前状态、缺口判断、下一步任务单，或确认后的新版本生成结果。

### 11. 普通成长聊天

**触发条件**：不属于上述任何类型的一般对话。
**必须读取**：`user-space/state.json`。如果 `personal_skill_ready`，必须先读取 `analysis_skill_path` 指向的分析 / 校准 Skill，再读取 `conversation_skill_path` 指向的对话 / 执行 Skill；如果新字段缺失，则回退读取 `user_skill_path` 并提示状态字段过旧。
**禁止**：不得在未读取用户专属 Skill 的情况下直接用通用模板回答。不得修改 user-space 文件除非用户明确要求。
**输出**：基于对话 / 执行 Skill 的模型和场景路由回答，落到一个最小动作；如发现应校准分析 Skill，说明建议更新内容。

### 12. 代码 / 提交 / 仓库操作

**触发词**：`提交`、`commit`、`push`、`git`、`代码`、`仓库`、`同步`
**必须读取**：相关目标文件。
**禁止**：仓库提交不得包含 `user-space/` 目录下任何文件，除非用户明确要求并二次确认。不得修改 `.gitignore` 中关于 `user-space/` 的排除规则。
**输出**：说明提交范围，确认后再执行。

## 第三步：安全边界叠加

主类型确定后，检查消息是否同时触及以下边界，若是，叠加对应禁止规则：

- **user-space 写入**（除日志自动更新外）：必须先生成任务单。
- **公开仓库提交**：必须先说明范围和验收标准。
- **重写或修改 Skill 文件**：必须先列出变化摘要并获得用户确认。
- **删除任何文件**：必须先生成任务单。
- **迁移模板到 user-space**：必须先确认不覆盖现有个人数据。

## 第四步：任务单规则

无法判断主类型，或触及安全边界时，不得直接执行，必须先生成任务单。

### 中高风险任务

以下任务默认必须先生成任务单，不得直接执行：

1. 修改或重写 Skill 文件、协议文件。
2. 写入 `user-space/`（故事日志自动记录除外）。
3. 公开仓库提交 / push。
4. 删除、移动、重命名文件。
5. 修改模板（`templates/`）。
6. 生成或覆盖用户专属 Skill。
7. 涉及健康、命理、财务、法律、重大关系判断。

### 任务单格式

```text
任务单
- 类型：[路由分类]
- 必须读取：[文件列表]
- 将修改：[文件列表]
- 禁止事项：[对应分类的禁止规则]
- 验收标准：[完成后如何判断做对了]
- 风险：[可能的副作用]
- 是否需要用户确认：是 / 否
```

## 第五步：完成证明

每次任务执行完毕，必须输出：

1. 改了哪些文件（如果执行了文件改动）。
2. 验证了什么。
3. 没有做什么（如果跳过了某些动作，说明原因）。
4. 下一步是什么。

如果只是分析或建议，不涉及文件改动，明确说明"本次未修改任何文件"。
