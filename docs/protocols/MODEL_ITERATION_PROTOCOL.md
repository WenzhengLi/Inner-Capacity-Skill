# 思维模型版本迭代协议

用途：把对话、动态题目、真实行动、人物蒸馏库扩展、用户共同评审和版本化对话Skill连接成可恢复、可校验的自动状态机。

## 触发词

- 迭代下一版
- 再迭代一版
- 再出一轮题并生成新版
- 重构模型
- 重构对话Skill
- 生成3.0 / 下一版对话
- 沉淀这次迭代逻辑

触发后读取 `skills/model-iteration-manager/SKILL.md`，并优先运行其状态脚本。

## 状态机

```text
evidence_collecting
→ existing_models_ready
→ awaiting_user_review
→ model_stack_approved
→ skill_generated
→ validated_ready_for_activation
→ active
```

失败状态：`validation_failed`。缺失任一门槛时停在当前阶段，不得宣称新版完成。

## 每轮私人工作区

路径：`user-space/model-iterations/v{model_version}/`

固定产物：

- `iteration.json`
- `EVIDENCE.md`
- `EXISTING_MODELS.md`
- `EXPANSION_CANDIDATES.md`
- `candidates.json`
- `MODEL_REVIEW.md`
- `GENERATION_PLAN.md`
- `VALIDATION.md`

私人证据、审批原话和模型判断只进入该目录，不进入公开协议。

## 自动流程

### 1. 启动

运行：

```powershell
powershell -ExecutionPolicy Bypass -File skills/model-iteration-manager/scripts/model-iteration.ps1 -Action start -ModelVersion <version>
```

脚本自动创建私人工作区、保存上一版入口并更新 `state.json.iteration_status`。已存在同版本目录时拒绝覆盖。

### 2. 证据与已有模型

Agent填写证据索引和已有模型清单，必须：

- 每个模型绑定真实证据。
- 标记已验证、正在形成或待验证。
- 对照上一版标记保留、增强、降权或建议移除。
- 未经用户同意，禁止移除旧模型。

### 3. 人物蒸馏库扩展

读取人物索引和相关人物Skill，根据当前阶段寻找少数高杠杆模型。不能按每个问题机械匹配一个人物。

每个候选必须写入：模型ID、人物、模型、本地来源路径、补足盲区、使用场景、禁用边界和候选状态。

### 4. 同步到评审态

运行 `-Action sync`。只有证据、已有模型、候选说明和候选JSON齐全时，状态才进入 `awaiting_user_review`。

### 5. 人工批准门槛

Agent向用户展示候选及不选择其他模型的理由。用户明确批准后运行 `record-review`，保存：

- 批准、拒绝、暂缓的候选ID。
- 用户批准原话。
- 审批时间。

自动化不得推断用户批准，也不得用沉默替代批准。

### 6. 生成、校验、激活

只有 `model_stack_approved` 才能生成新版。生成后运行 `mark-generated`，再运行 `validate`。

若在当前Skill路径上原位重构，`mark-generated`必须传入 `-PreGenerationSnapshotPath`；没有评审前快照时拒绝登记生成。

校验至少检查：

- 私人产物无待填写项。
- 人物来源路径存在。
- 用户批准原话存在。
- 新Skill frontmatter只含 `name` 和 `description`。
- 上一版对话Skill仍存在。
- 原位重构时，生成前快照存在。
- 状态入口尚未提前切换。

验证通过且用户授权切换后，运行 `activate -ConfirmActivation`。激活前不得修改当前生效入口。

## 自动与人工边界

可自动：建目录、保存入口、推进机器状态、验证文件、检查来源、激活已批准且已验证的版本。

必须人工：解释模型、讨论取舍、批准模型组合、授权最终切换。

需要真实行为：把“批准试用模型”升级为“用户已有模型”。

## 完成标准

- 迭代状态为 `active`。
- 当前版本入口与Skill文件一致。
- 上一版和生成前草案可回溯。
- 人物模型来源有效。
- 用户批准原话已保存。
- 校验记录全部通过。
- 恢复摘要已更新。
