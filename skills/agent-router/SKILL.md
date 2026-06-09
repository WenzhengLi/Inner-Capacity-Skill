---
name: agent-router
description: Mandatory entry-point Skill for every user message. Before any task execution, read this Skill to route the message to the correct Skill or protocol. Checks user-space/SYNC_STATE.json and user-space/state.json, determines task type, enforces personal Skill priority, and gates all medium/high-risk actions behind a task ticket. Detailed rules are in docs/protocols/AGENT_ROUTER_PROTOCOL.md.
---

# Agent Router

每次收到用户消息，必须先执行此 Skill，再执行任何具体任务。不得跳过。

## 执行流程

### 1. 同步检查

读取 `user-space/SYNC_STATE.json`。如果 `last_pull_at` 距当前超过 24 小时，先执行同步（规则见 `docs/protocols/STARTUP_SYNC_PROTOCOL.md`）。

### 2. 读取状态

读取 `user-space/state.json`。如果不存在，路由到初始化（`docs/protocols/ONBOARDING_PROTOCOL.md`）。

### 3. 判断任务类型

按 `docs/protocols/AGENT_ROUTER_PROTOCOL.md` 第二步的 11 个分类匹配。先确定主任务类型。若消息同时涉及安全边界，叠加对应禁止规则。

### 4. 读取对应 Skill / 协议

根据主任务类型，读取对应 Skill 或协议文件。具体文件列表见 `docs/protocols/AGENT_ROUTER_PROTOCOL.md` 各分类。

### 5. 双 Skill 强制规则

当 `user-space/state.json` 中 `stage=personal_skill_ready` 时：

- 先读取 `analysis_skill_path` 指向的分析 / 校准 Skill。
- 再读取 `conversation_skill_path` 指向的对话 / 执行 Skill。
- 如果新字段缺失，才回退读取 `user_skill_path`，并提示状态字段过旧。
- 普通成长聊天和聊天分析：必须按上述顺序读取双 Skill，再回答。
- 讲故事、健康、命理、支线任务等功能在 `AGENT_ROUTER_PROTOCOL.md` 中有条件读取的，按注明执行。
- 不得把 analysis Skill 当成 executable dialogue Skill。
- 不得用通用模板替代 conversation Skill。

### 6. 停止规则

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
