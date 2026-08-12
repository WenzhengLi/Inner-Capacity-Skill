# 启动前同步协议

用途：任何功能指令执行前，先判断项目内核是否需要从远端更新，避免本地规则长期落后；同时保护 `user-space/` 中的个人数据和本地立意。

## 触发时机

每次收到用户指令后，先执行本协议，再进入故事、答题、聊天分析、命理、健康、支线任务或功能沉淀等具体流程。

如果当前请求本身就是同步、Git、冲突处理或仓库维护，则直接执行本协议的完整流程。

## 状态文件

同步状态保存在：

```text
user-space/SYNC_STATE.json
```

首次使用时，从模板复制：

```text
templates/user-space/SYNC_STATE.json
```

推荐字段：

```json
{
  "last_pull_at": null,
  "last_result": "never_checked",
  "last_remote": null,
  "last_branch": null,
  "last_local_head": null,
  "last_remote_head": null,
  "notes": ""
}
```

## 24 小时判断

1. 读取 `user-space/SYNC_STATE.json`。
2. 用当前时间与 `last_pull_at` 对比。
3. 如果 `last_pull_at` 为空，或距离当前时间超过 24 小时，则尝试同步。
4. 如果未超过 24 小时，只继续处理用户原始请求，不更新 `SYNC_STATE.json`。

关键原则：每次都检查时间，但不是每次都更新时间。只有真正进入“超过 24 小时后的同步流程”并得到结果时，才写入 `SYNC_STATE.json`。不要因为普通对话、普通检查或未超过 24 小时而刷新 24 小时窗口。

## 安全同步流程

先确认当前目录是否是 Git 仓库：

```powershell
git rev-parse --is-inside-work-tree
```

如果不是 Git 仓库：

- 不执行拉取。
- `last_result` 写为 `skipped_not_git_repo`。
- `last_pull_at` 写为当前时间，表示本轮超过 24 小时后的同步尝试已经完成，避免每条指令都重复报同一个非 Git 问题。
- 继续处理用户原始请求。

如果是 Git 仓库：

1. 查看本地修改：

```powershell
git status --short
```

2. 获取远端更新，但不合并：

```powershell
git fetch --all --prune
```

3. 确认上游分支。优先使用当前分支的上游：

```powershell
git rev-parse --abbrev-ref --symbolic-full-name '@{u}'
```

如果没有上游，使用项目默认远端分支，例如 `origin/main`。

4. 列出远端即将更新的文件：

```powershell
git diff --name-status HEAD..@{u}
```

5. 如果没有远端更新：

- 更新 `last_pull_at` 为当前时间。
- `last_result` 写为 `already_up_to_date`。
- 继续处理用户原始请求。

6. 如果有远端更新且工作区干净：

```powershell
git pull --ff-only
```

成功后更新 `last_pull_at`、`last_result=pulled`。

7. 如果有远端更新且工作区不干净：

- 提取本地变更文件列表。
- 提取远端更新文件列表。
- 计算二者交集。

如果没有交集，可以执行：

```powershell
git pull --ff-only
```

并保留本地未提交修改。

如果存在交集，停止拉取，进入用户决策。

## 冲突提示格式

当远端更新与本地修改存在交集，或 `git pull --ff-only` 因分叉失败时，不要自动合并，不要自动覆盖。

向用户说明：

```text
本次拉取检测到需要你决定：

远端将更新：
1. {文件路径} - {增/删/改}

本地也改过，可能与当前立意不一致：
1. {文件路径} - {本地修改摘要}

可选处理：
1. 暂不拉取，先继续本地工作。
2. 我先逐文件对比，给你一份合并建议。
3. 先把本地修改提交或备份，再拉取远端。
4. 放弃这些本地修改并拉取远端。这个会丢本地内容，只有你明确同意才做。
```

其中“本地立意不一致”不只指 Git 文本冲突，也包括：

- 远端改了公开协议，本地也改了同一协议。
- 远端改变了 Skill 行为，本地正在根据用户偏好调整同一 Skill。
- 远端更新 README / handoff 的入口规则，本地也有未提交入口规则。
- 远端模板变了，本地正在修改同名模板。

## 用户空间保护

`user-space/` 是个人空间，默认不提交、不拉取、不作为远端覆盖对象。

如果远端更新了 `templates/user-space/`，而本地已有 `user-space/`，不要自动覆盖用户个人文件。只说明模板有更新，并询问是否需要把模板变化迁移到个人空间。

## 输出要求

如果没有更新或未超过 24 小时，通常只需一句短提示或静默继续，不要打断主任务。

如果实际拉取了更新，简要说明：

- 拉取时间。
- 更新了哪些公开文件。
- 是否影响当前指令。

如果发生冲突或立意不一致，必须暂停当前任务，让用户先选择处理方式。
