---
name: agent-router
description: Mandatory product entry-point Skill for every user message in Inner-Capacity-Skill, including ordinary chat, `切换对话skill`, `讲故事`, assessments, health, destiny, side tasks, and development requests. Read state.json to resolve the current analysis and conversation Skill paths dynamically, route to the correct product protocol, and distinguish the product dialogue Skill from the separate `aiskill` collaboration role. Detailed rules are in docs/protocols/AGENT_ROUTER_PROTOCOL.md.
---

# Agent Router

每次收到用户消息，必须先执行此 Skill，再执行任何具体任务。不得跳过。

## 入口词义与版本防护

- `切换对话skill`、`进入对话skill`：读取 `user-space/state.json`，按当前指针依次激活分析 / 校准 Skill 和对话 / 执行 Skill；不得解释为 `aiskill`。
- `讲故事`、`【讲故事】` 或指定故事流派：完成上述动态双 Skill 激活后，再进入 `skills/story-thinking-trainer/SKILL.md`。
- 只有明确出现 `切换aiskill`、`aiskill，开始工作` 或协作资产维护意图时，才转入 `.agents/skills/ai-collaboration-manager/SKILL.md`。
- 每次执行都重新读取状态指针。禁止缓存上次路径、扫描目录猜测最新版或在 Router 中写死私人 Skill 版本号。
- 状态路径不存在或不一致时停止并报告，不得用通用对话或通用故事模板兜底。

## 执行流程

### 1. 同步检查

读取 `user-space/SYNC_STATE.json`。如果 `last_pull_at` 距当前超过 24 小时，先执行同步（规则见 `docs/protocols/STARTUP_SYNC_PROTOCOL.md`）。

### 2. 上下文压缩检查

读取并遵循 `docs/protocols/CONTEXT_COMPACTION_PROTOCOL.md`。

- 如果软件层暴露上下文使用率，且使用率 `>= 80%`，先生成行为级压缩摘要，再执行用户任务。
- 如果软件层不暴露精确百分比，但当前对话已经跨多轮复杂任务、读取/修改大量文件、发生恢复/压缩/续接，或任务涉及双 Skill、校准分数、投资分析、故事作业、健康/命理、协议修改，也按“可能超过 80%”处理。
- 压缩或恢复后，必须重新读取 `state.json`、分析 / 校准 Skill、对话 / 执行 Skill、Router 协议和当前任务协议。

### 3. 读取状态

读取 `user-space/state.json`。如果不存在，路由到初始化（`docs/protocols/ONBOARDING_PROTOCOL.md`）。

### 4. 判断任务类型

按 `docs/protocols/AGENT_ROUTER_PROTOCOL.md` 第二步的 12 个分类匹配。先确定主任务类型。若消息同时涉及安全边界，叠加对应禁止规则。

### 5. 读取对应 Skill / 协议

根据主任务类型，读取对应 Skill 或协议文件。具体文件列表见 `docs/protocols/AGENT_ROUTER_PROTOCOL.md` 各分类。

### 6. 双 Skill 强制规则

当 `user-space/state.json` 中 `stage=personal_skill_ready` 时：

- 先读取 `analysis_skill_path` 指向的分析 / 校准 Skill。
- 再读取 `conversation_skill_path` 指向的对话 / 执行 Skill。
- 如果新字段缺失，才回退读取 `user_skill_path`，并提示状态字段过旧。
- 普通成长聊天、聊天分析和讲故事：必须按上述顺序读取双 Skill，再回答或进入故事协议。
- 当用户只说 `讲故事`、`【讲故事】` 或指定故事流派，且当前会话没有足够历史沟通记录可判断用户状态时，先按上述顺序切换内化 Skill，再读取故事训练协议；不得直接按通用故事模板开讲。
- 健康、命理、支线任务等功能在 `AGENT_ROUTER_PROTOCOL.md` 中有条件读取的，按注明执行。
- 不得把 analysis Skill 当成 executable dialogue Skill。
- 不得用通用模板替代 conversation Skill。
- 私人 Skill 更新后继续以 `state.json` 当前指针为准；Router 和专项 Skill 不因版本号变化而改路径。

### 7. 停止规则

以下情况不得直接执行，必须先生成任务单或说明缺口：

- 涉及 `user-space/` 写入（故事日志自动记录除外）。
- 涉及公开仓库提交或 push。
- 涉及删除、移动、重命名文件。
- 涉及修改或重写 Skill 文件、协议文件、模板。
- 涉及生成或覆盖用户专属 Skill。
- 涉及健康、命理、财务、法律、重大关系判断。
- 状态文件（`state.json`）与实际文件不一致时。
- 无法判断消息属于哪个类型时。

## 任务单格式

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

## 完成证明

每次任务执行完毕，必须输出：

1. 改了哪些文件（如果执行了文件改动）。
2. 验证了什么。
3. 没有做什么（如果跳过了某些动作，说明原因）。
4. 下一步是什么。

如果只是分析或建议，不涉及文件改动，明确说明"本次未修改任何文件"。
