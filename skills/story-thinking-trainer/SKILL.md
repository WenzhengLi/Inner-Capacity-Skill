---
name: story-thinking-trainer
description: Use when the user says 【讲故事】, asks for a story-based thinking-model lesson, names a story style such as 莫言式、契诃夫式、莫泊桑式、欧亨利式, or wants story training logs and homework scoring updated.
---

# Story Thinking Trainer

This Skill teaches one thinking model through one short story, then maps it back to the user's real life and records the training.

## Trigger

Use this Skill when the user says:

- `【讲故事】`
- `讲故事`
- `讲故事，{写法流派}`
- asks to score a story homework answer
- asks to update `STORY_TRAINING_LOG.md`

Do not use `【继续】` as a story trigger unless the local context clearly means continuing the current story task.

## Core Contract

1. Tell exactly one story.
2. The top title must be the story name, not the generic word `故事`.
3. Do not reveal the concept before the story.
4. Use a concrete scene before abstraction.
5. After the story, reveal the concept, explain the metaphor, apply it to the user, give open homework, and log the row.
6. Application examples are capped at 3 total: usually 1-2 user examples plus at most 1 external example.
7. If the user says the answer is confusing, compress to one core sentence and one action.

## Style Selection

If the user names a style, use that style for this run.

Otherwise rotate by reading the latest non-empty `写法流派` in `STORY_TRAINING_LOG.md`:

`莫言式 -> 契诃夫式 -> 莫泊桑式 -> 欧亨利式 -> 莫言式`

If no previous non-empty style exists, start with `莫言式`.

Only borrow narrative techniques. Do not produce long literary imitation, signature phrasing, or parody of a specific author.

## Style Cards

### 莫言式

Mechanism:

- Start from a folk scene: village gate, shop counter, kitchen, field path, rented room, outside-order shop, factory dormitory.
- Let desire become an object: a ledger, bowl, cigarette, shoe, knife, steamed bun, medicine packet, broken phone.
- Use earthy sensory detail: smell, heat, sweat, dust, oil, hunger, bodily discomfort.
- Add mild absurdity: everyone treats a ridiculous thing as normal.
- End with a blunt folk insight, as if an elder said it while wiping a table.

Avoid:

- Decorative rural language with no function.
- Excessive gore, grotesque detail, or dialect display.
- Explaining the concept too early.

Self-check:

- If the story has no smell, object, desire, and absurd normality, it is not 莫言式 enough.

### 契诃夫式

Mechanism:

- Start with an ordinary, quiet moment.
- Keep the conflict small on the surface and large underneath.
- Use subtext: what people do not say matters more than what they say.
- Reveal the model through a small gesture, hesitation, silence, or unfinished action.
- Leave a little open aftertaste; the ending should not feel like a punchline.

Avoid:

- Big speeches.
- Moral verdicts inside the story.
- A dramatic twist that turns the story into 欧亨利式.

Self-check:

- If the story cannot survive on restraint, subtext, and one small revealing action, rewrite it.

### 莫泊桑式

Mechanism:

- Put the character under social pressure: money, status, face, relationship, class, vanity, reputation.
- Make the character believe they are choosing freely while actually being pulled by desire or shame.
- Keep causality clean: one vanity leads to one compromise, then one cost.
- Let irony expose the self-deception.
- The ending should sting, but it should feel earned by the character's own choices.

Avoid:

- Random misfortune.
- Cheap cruelty.
- Turning the story into a lecture on society.

Self-check:

- If there is no face, money, vanity, or social comparison pushing the character, it is not 莫泊桑式 enough.

### 欧亨利式

Mechanism:

- Set up a visible desire and a hidden missing condition.
- Give the reader one expectation while quietly planting another.
- Use a concrete token object: button, ticket, watch, receipt, key, coin, file, medicine box.
- The ending must reverse the meaning of earlier details, not merely surprise.
- The reversal should be warm, ironic, or bittersweet, and should illuminate the concept.

Avoid:

- Random twist.
- Twist that contradicts earlier facts.
- Ending that is clever but does not teach the model.

Self-check:

- If the last line does not make the reader reinterpret at least one earlier detail, rewrite it.

## Theme Selection

Choose a story theme in two layers unless the user specifies a concept.

Layer 1: choose the life training direction the user most needs right now. Do not pick from the model list mechanically.

- work execution: daily main line, visible delivery, deadline, handoff, review
- technical growth: .NET, IoT flow, AI usage, architecture judgment, testing
- body base: sleep, food, smoking, exercise, energy, recovery, environment
- money and desire: consumption, reward, vanity, cash flow, delayed gratification
- relationship communication: emotional translation, boundaries, repair, respect
- emotional self-control: anger, impulse, avoidance, shame, guilt, inner steadiness
- light entrepreneurship: small老板, workflow pain, low-cost validation, no all-in
- risk boundary: irreversible loss, leverage, quitting, health cost, rollback
- self-knowledge: identity, ability circle, true strengths, false labels
- long-termism: compounding, patience, stable rules, delayed return

Layer 2: choose one concrete model that can train that direction:

- stopping rule / decision closure
- acceptance criteria / visible delivery
- task slicing / smallest useful delivery
- capability circle / cognitive honesty
- bottleneck thinking
- double-loop review
- non-ergodic risk
- incentive structure
- specific knowledge
- job-to-be-done
- opportunity filtering
- process visualization before automation
- requirement specification
- health as base capacity
- relationship boundary and emotional translation

Selection rule:

1. Prefer the user's newest real context over old abstract diagnosis.
2. If the user recently answered homework, choose the next theme from their weak point in that answer.
3. If the user is discussing code/work, prefer work execution, technical growth, risk boundary, or visible delivery.
4. If the user is discussing body, spending, relationship, or mood, choose the matching life direction first, then the model.
5. Avoid repeating the same life direction more than twice in a row unless the user explicitly asks.
6. The story's point must be a life training point, not merely a clever explanation of a model.

## Output Template

```text
{故事名称}

写法流派：{莫言式 / 契诃夫式 / 莫泊桑式 / 欧亨利式}

{story body}

点破概念：{概念名}

立意方向：{工作推进 / 技术成长 / 身体底盘 / 金钱欲望 / 关系沟通 / 情绪自控 / 轻创业 / 风险边界 / 自我认知 / 长期主义}

隐喻对应：
- {故事元素} = {现实含义}

套到你身上：
1. {用户真实经历或当前问题}
2. {用户真实经历或当前问题}
3. {可选外部例子}

开放作业：
{没有固定答案的问题或小练习}
```

## Quality Gate

Before sending, check:

1. If the `写法流派` line is removed, can the writing mechanism still be recognized?
2. Did the concept remain hidden until after the story?
3. Did the story teach by structure, not by explanation pasted into the plot?
4. Are application examples capped at 3?
5. Is the life training direction clear, not just the abstract model?
6. Is the homework open-ended and scorable?

If any answer is no, rewrite before sending.

## Logging

After telling a story, update `STORY_TRAINING_LOG.md`:

`时间 | 故事名称 | 写法流派 | 概念 | 举例个数 | 验收分数`

- Use today's date.
- Use `待验收` until the user answers the homework.
- If the user answers, score 0-100 by transfer ability:
  - 90-100: transfers to a new scene and names boundaries.
  - 75-89: applies to real experience but boundary is incomplete.
  - 60-74: understands but applies shallowly.
  - 40-59: gets the story but not the model.
  - 0-39: stays at plot level.
