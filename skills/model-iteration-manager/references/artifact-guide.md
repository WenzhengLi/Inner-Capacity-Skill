# 模型迭代产物指南

## 目录

每轮保存在 `user-space/model-iterations/v{model_version}/`：

| 文件 | 用途 |
|---|---|
| `iteration.json` | 机器可读状态、版本、审批和验证结果 |
| `EVIDENCE.md` | 对话、题目、行动和外部结果索引 |
| `EXISTING_MODELS.md` | 用户已有模型、证据等级和版本差异 |
| `EXPANSION_CANDIDATES.md` | 人物模型候选的可读分析 |
| `candidates.json` | 候选ID、来源路径和审批状态 |
| `MODEL_REVIEW.md` | 用户批准原话及批准、拒绝、暂缓结果 |
| `GENERATION_PLAN.md` | 新版文件、保留项、变化和风险 |
| `VALIDATION.md` | Skill、来源、旧版本与入口校验结果 |

## 证据标准

- `已验证`：真实事件加外部结果，或多个跨场景样本。
- `正在形成`：有行为动作，但稳定性不足。
- `待验证`：观点、计划或单次表达。

## 候选JSON

```json
{
  "candidates": [
    {
      "id": "munger-opinion-qualification",
      "person": "芒格",
      "model": "意见资格制",
      "source_path": "references/external/standalone-skills/munger-skill/SKILL.md",
      "gap": "按地位而非资格给意见定权重",
      "use_case": "选择专家与处理冲突意见",
      "guardrail": "资格制不等于只听权威",
      "status": "candidate"
    }
  ]
}
```

`source_path`必须存在。`status`只能由共同评审变成 `approved`、`rejected` 或 `deferred`。

## 生成计划最低内容

- 新模型版本与对话Skill版本。
- 原有模型保留清单。
- 增强、降权和经用户批准的移除项。
- 批准试用的人物模型与来源。
- 新Skill路径、旧Skill路径和备份路径。
- 若原位重构当前Skill，提供生成前快照路径；该路径是自动校验硬门槛。
- 验证命令和激活条件。
