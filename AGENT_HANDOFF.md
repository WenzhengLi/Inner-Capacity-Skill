# Agent Handoff

## Project

This folder contains the early design materials for `Inner Capacity Skill`.

The goal is to build a reusable growth-oriented persona/thinking-model Skill. It should assess the user through structured questions, infer the user's current thinking patterns and growth stage, then hold conversations that help the user expand and reconstruct their mental models.

## Read Order

1. `GOAL.md`
   - Understand the core intention.
   - The current worldview is "reconstructable shou-yang-sheng-yin", not a fixed doctrine.
   - Treat the yin/yang model as an initial working hypothesis that must be revised against user answers.

2. `ASSESSMENT_QUESTIONS.md`
   - Contains the first 50 assessment questions.
   - These questions are the initial data collection layer for evaluating the user's thinking model, internal capacity, desires, fears, decision patterns, and growth stage.

3. `DISTILLATION_METHOD.md`
   - Explains how Nuwa Skill-style distillation works.
   - Adapts that approach from distilling public personas to distilling the user themselves.

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

- `【开始】` is an intelligent entrypoint. If `user-space/state.json` does not exist, follow `ONBOARDING_PROTOCOL.md`: introduce “2026 款傻妞”, ask the initialization questions, then begin the 50-question distillation. If onboarding/evaluation is complete, it can enter daily growth check-in.
- The 50-question assessment is dynamic, not a fixed questionnaire. Follow `ASSESSMENT_PROTOCOL.md`: generate each user's questions from their profile and recent answers, 3 at a time, grouped by direction and interleaved across directions.
- Users may replace questions, but the full assessment still requires 50 answered questions. A 15-question lightweight mode is allowed only for rough initial modeling.
- Default assistant name is “2026款傻妞”; users may rename it via `assistant_name`.
- New cultural model modules live in `CULTURAL_MODEL_MODULES.md`: 读史处世, 地域财富, 格物养身. Use them for history/personage analysis, regional wealth flow, cooperation/credit models, and body-as-observation training. Keep medical claims bounded as observation, not diagnosis.
- `【讲故事】` triggers one story-based thinking-model training session.
- `【继续】` is no longer a story trigger; interpret it only in the current conversational context.
- Story mode must start with the actual story name as the top title, not the generic word `故事`.
- Story mode has been extracted into `skills/story-thinking-trainer/SKILL.md`; use that file as the main contract when optimizing or running stories.
- Story theme selection is now two-layered: first choose the life training direction, then choose the concrete model. Life directions include work execution, technical growth, body base, money/desire, relationship communication, emotional self-control, light entrepreneurship, risk boundary, self-knowledge, and long-termism.
- Story mode should read `STORY_TRAINING_PLAN.md` when available. Use the weekly plan and daily module as the default agenda, but let the user's newest real context override it. Related model groups can guide selection, but each story should teach one primary concept.
- Story mode rotates writing approaches in this order: 莫言式 -> 契诃夫式 -> 莫泊桑式 -> 欧亨利式 -> repeat.
- Story mode should read the latest non-empty `写法流派` in `STORY_TRAINING_LOG.md` and choose the next one. If none exists, start with 莫言式.
- If the user names a writing approach, use that approach instead of rotation for that run.
- Each approach must be implemented through narrative mechanism, not by merely labeling the story. Use the Quality Gate in `story-thinking-trainer`.
- Story application should be gentler by default: one direct personal reminder, plus two generalized/external examples. Avoid repeatedly giving the user four or five personal correction points after every story.
- Each story log row records: time, story name, writing approach, concept, example count, and acceptance score. Existing older story rows can leave writing approach blank.
