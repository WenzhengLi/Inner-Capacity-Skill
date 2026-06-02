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

- `【开始】` triggers the daily growth check-in.
- `【讲故事】` triggers one story-based thinking-model training session.
- `【继续】` is no longer a story trigger; interpret it only in the current conversational context.
- Story mode must start with the actual story name as the top title, not the generic word `故事`.
- Story mode rotates writing approaches in this order: 莫言式 -> 契诃夫式 -> 莫泊桑式 -> 欧亨利式 -> repeat.
- Story mode should read the latest non-empty `写法流派` in `STORY_TRAINING_LOG.md` and choose the next one. If none exists, start with 莫言式.
- Each story log row records: time, story name, writing approach, concept, example count, and acceptance score. Existing older story rows can leave writing approach blank.
