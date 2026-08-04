# Agent Handoff

## Project

This folder contains the early design materials for `Inner Capacity Skill`.

The goal is to build a reusable growth-oriented persona/thinking-model Skill. It should assess the user through structured questions, infer the user's current thinking patterns and growth stage, then hold conversations that help the user expand and reconstruct their mental models.

## Read Order

0. `docs/protocols/STARTUP_SYNC_PROTOCOL.md`
   - Before any user instruction, check `user-space/SYNC_STATE.json`.
   - Compare current time with `last_pull_at`; if it is older than 24 hours, fetch and pull safely.
   - Do not update the sync timestamp on every check; update it only after the over-24-hour sync flow produces a result.
   - If remote updates touch files that also have local changes or local intent conflicts, stop and ask the user to choose before merging.

0.5. `skills/agent-router/SKILL.md` 和 `docs/protocols/AGENT_ROUTER_PROTOCOL.md`
   - 每次用户消息到达后，先按 Router Skill 判断任务类型，再读取对应 Skill 和协议文件。
   - Router 是所有指令的强制入口，不得跳过。
   - 中高风险任务（修改 Skill/协议、写入 user-space、公开提交、删除文件、生成用户专属 Skill、健康/命理/财务/法律/重大关系判断）必须先生成任务单。

1. `docs/core/GOAL.md`
   - Understand the core intention.
   - The current worldview is "reconstructable shou-yang-sheng-yin", not a fixed doctrine.
   - Treat the yin/yang model as an initial working hypothesis that must be revised against user answers.

2. `docs/assessment/ASSESSMENT_QUESTIONS.md`
   - Contains the first 50 assessment questions.
   - These questions are the initial data collection layer for evaluating the user's thinking model, internal capacity, desires, fears, decision patterns, and growth stage.

3. `docs/core/DISTILLATION_METHOD.md`
   - Explains how Nuwa Skill-style distillation works.
   - Adapts that approach from distilling public personas to distilling the user themselves.

4. `docs/protocols/USER_SKILL_GENERATION_PROTOCOL.md`
   - Defines the closed loop from 50 answered questions to user model evaluation, analysis/calibration Skill, and versioned dialogue Skill.
   - If the analysis Skill exists but no conversation Skill exists, generate a new versioned dialogue Skill without overwriting the analysis Skill.

4.5. `docs/protocols/MODEL_ITERATION_PROTOCOL.md` and `skills/model-iteration-manager/SKILL.md`
   - Manage every post-baseline model version through a state machine: evidence, existing models, distilled-persona candidates, explicit user review, generation, validation, and activation.
   - Never generate a new dialogue version directly from summarized conversations.
   - Preserve previous models and versions; save the user's approval words and validate all local model-source paths.

5. `docs/protocols/CHAT_ANALYSIS_PROTOCOL.md`, `docs/protocols/SIDE_TASK_PROTOCOL.md`, `docs/protocols/FUNCTION_CONSOLIDATION_PROTOCOL.md`
   - Explain how to handle long reflective chat, optional side tasks, and reusable feature consolidation.

## Core Idea

The Skill should not merely role-play a wise mentor.

It should:

- Ask high-quality questions.
- Extract patterns from the user's real answers.
- Diagnose the user's current growth stage.
- Identify which "yang" dimensions need training.
- Detect where the user may be chasing "yin" beyond current capacity.
- Recommend external thinking models to expand the user's frame.
- Keep the core worldview open to reconstruction.

## Initial Working Model

The current model distinguishes:

- `Yang`: internal capacity, such as cognition, judgment, body, emotional stability, self-control, long-term thinking, relationship capacity, risk awareness, and value ordering.
- `Yin`: external resources and outcomes, such as money, status, reputation, power, opportunities, relationships, affection, recognition, and influence.

Important: this model is not final. It should be tested against the user's answers and updated when reality disagrees with it.

## Reference GitHub Repositories

Main inspiration:

- Awesome Persona Skills: https://github.com/tmstack/awesome-persona-skills
- Nuwa Skill: https://github.com/alchaincyf/nuwa-skill
- Nuwa Skill `SKILL.md`: https://github.com/alchaincyf/nuwa-skill/blob/main/SKILL.md
- Nuwa extraction framework: https://github.com/alchaincyf/nuwa-skill/blob/main/references/extraction-framework.md

Related self-distillation direction:

- Yourself Skill: https://github.com/notdog1998/yourself-skill

## Next Build Steps

1. Let the user answer the 50 assessment questions, either all at once or in batches.
2. Create a scoring and interpretation framework for the answers.
3. Define 8-10 measurable "yang" dimensions.
4. Define growth-stage detection rules.
5. Define thinking-model recommendation rules.
6. Create the actual `SKILL.md` only after the assessment and distillation approach are clearer.

## Important Constraints

- Do not treat "yang insufficient" as the explanation for everything.
- Consider environment, structure, information gaps, resource constraints, timing, and relationship systems.
- Do not copy the user's current patterns blindly; distinguish current self, higher self, and reconstructable growth system.
- Do not turn the Skill into fortune-telling, motivational slogans, or a fixed ideology.
- Preserve user agency. The Skill can diagnose, question, and train, but should not make major life decisions for the user.

## Current Interaction Rules

- Before any instruction, follow `docs/protocols/STARTUP_SYNC_PROTOCOL.md`: compare current time with `user-space/SYNC_STATE.json.last_pull_at`; check every time, but update the timestamp only after the over-24-hour sync flow finishes; if remote updates conflict with local files or local intent, list updates, list conflict files, and ask the user to choose.
- For main conversation, first check `user-space/state.json`. If `stage=personal_skill_ready`, read `analysis_skill_path` as the analysis/calibration Skill, then read `conversation_skill_path` as the executable dialogue Skill before applying specialized protocols. If these newer fields are missing, fall back to `user_skill_path` and note that the state schema is old.
- If the user-specific Skill cannot be used, follow `docs/protocols/USER_SKILL_GENERATION_PROTOCOL.md`: incomplete questions mean continue the 50-question assessment; completed questions without evaluation mean generate the user model; evaluation with only an analysis/calibration Skill means generate a new versioned dialogue Skill, without overwriting the analysis Skill.
- `查看主线进度`, `查看 Skill 进度`, `检查 Skill 状态`, `检查我的模型状态`, and `我现在到哪一步了` are progress-query commands. Read `user-space/state.json`, verify the private Skill file if needed, then report assessment, evaluation, model recommendation, private Skill generation, current stage, and next step.
- `【开始】` is an intelligent entrypoint. If `user-space/state.json` does not exist, follow `docs/protocols/ONBOARDING_PROTOCOL.md`: introduce “2026 款傻妞”, ask the initialization questions, then begin the 50-question distillation. If onboarding/evaluation/personal Skill generation is complete, it can enter daily growth check-in.
- The 50-question assessment is dynamic, not a fixed questionnaire. Follow `docs/protocols/ASSESSMENT_PROTOCOL.md`: generate each user's questions from their profile and recent answers, 3 at a time, grouped by direction and interleaved across directions.
- Users may replace questions, but the full assessment still requires 50 answered questions. A 15-question lightweight mode is allowed only for rough initial modeling.
- Default assistant name is “2026款傻妞”; users may rename it via `assistant_name`.
- Long reflective user outputs should enter chat analysis mode. Follow `docs/protocols/CHAT_ANALYSIS_PROTOCOL.md`: understand first, then analyze what is right, what may be simplified, how to extend it, what model it suggests, and what small action is acceptable.
- If chat produces concrete actions, use `docs/protocols/SIDE_TASK_PROTOCOL.md` and ask whether to register them as side tasks in `user-space/side-tasks/INDEX.md`. Pending tasks live in `user-space/side-tasks/NOT_STARTED.md`; started or completed tasks each need their own file under `user-space/side-tasks/tasks/`.
- If the user says “功能沉淀” or asks to make the project more portable, follow `docs/protocols/FUNCTION_CONSOLIDATION_PROTOCOL.md`. Only reusable, portable capabilities belong in public project files; personal thoughts and records belong in `user-space/`.
- If the user asks to iterate, rebuild, or generate the next model/dialogue version, use `skills/model-iteration-manager/SKILL.md`. Run its status script first, stop at the explicit user-review gate, and activate only after validation and user authorization.
- `【讲故事】` triggers one story-based thinking-model training session.
- `【继续】` is no longer a story trigger; interpret it only in the current conversational context.
- Story mode must start with bold Markdown `**{故事名}·{流派}**` as the top title, not the generic word `故事`.
- Story mode should place `立意：...` and `时间：...` after the story body, before `点破概念：...`, so the opening reads naturally.
- Story mode has been extracted into `skills/story-thinking-trainer/SKILL.md`; use that file as the main contract when optimizing or running stories.
- Story theme selection is now two-layered: first choose the life training direction, then choose the concrete model. Life directions include work execution, technical growth, body base, money/desire, relationship communication, emotional self-control, light entrepreneurship, risk boundary, self-knowledge, and long-termism.
- Story mode should read `docs/protocols/STORY_TRAINING_PLAN.md` when no personal plan exists. Use the weekly plan and daily module as the default agenda, but let the user's newest real context override it. Related model groups can guide selection, but each story should teach one primary concept.
- Story mode rotates writing approaches in this order: 莫言式 -> 契诃夫式 -> 莫泊桑式 -> 欧亨利式 -> repeat.
- Story mode should read the latest non-empty `写法流派` in `user-space/STORY_TRAINING_LOG.md`; if missing, create it from `templates/user-space/STORY_TRAINING_LOG.md`.
- If the user names a writing approach, use that approach instead of rotation for that run.
- Each approach must be implemented through narrative mechanism, not by merely labeling the story. Use the Quality Gate in `story-thinking-trainer`.
- Story application should be gentler by default: one direct personal reminder, plus two generalized/external examples. Avoid repeatedly giving the user four or five personal correction points after every story.
- Each story log row records: time, story name, writing approach, concept, example count, and acceptance score. Existing older story rows can leave writing approach blank.
