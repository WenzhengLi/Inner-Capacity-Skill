# Senpai.skill

> *"He graduated, but his SSH key, sarcasm, and meeting pressure are still on duty."*

**Distill your graduated lab senior into an AI Skill that can keep showing up in meetings, roast your slides, and save your broken environment.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python 3.9+](https://img.shields.io/badge/Python-3.9%2B-blue.svg)](https://python.org)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skill-blueviolet)](https://claude.ai/code)
[![AgentSkills](https://img.shields.io/badge/AgentSkills-Standard-green)](https://agentskills.io)

&nbsp;

Feed the project with the traces your senpai left behind: WeChat/QQ chats, meeting notes, issue comments, group photos, whiteboard shots, social posts, plus your own descriptions.
Generate an **AI Skill that really sounds like him in the lab**:
it remembers project lore, signature one-liners, critique rhythm, rescue habits, and the jokes only your group understands.

⚠️ **For internal commemoration, parody, and collaborative nostalgia only. Not for impersonation, forged academic claims, or official decisions in someone else's name.**

[Installation](#installation) · [Usage](#usage) · [Examples](#examples) · [中文](README.md)

---

## Installation

### Claude Code

```bash
# Install to current project
mkdir -p .claude/skills
git clone https://github.com/zhanghaichao520/senpai-skill.git .claude/skills/create-senpai

# Or install globally
git clone https://github.com/zhanghaichao520/senpai-skill.git ~/.claude/skills/create-senpai
```

### Dependencies (optional)

```bash
pip3 install -r requirements.txt
```

---

## Usage

In Claude Code, type:

```text
/create-senpai
```

Follow the prompts: enter a codename, lab profile, persona sketch, then choose data sources. Everything except the codename can be skipped.

After creation, use `/{slug}` to summon the cyber-returned senior back into your group.

### Commands

| Command | Description |
|---------|-------------|
| `/list-senpais` | List all generated senpai Skills |
| `/{slug}` | Full Skill |
| `/update-senpai {slug}` | Append new material and update |
| `/senpai-rollback {slug} {version}` | Roll back to a previous version |
| `/delete-senpai {slug}` | Delete |
| `/let-senpai-rest {slug}` | Gentle alias for delete |

---

## Examples

> Input: `A multimodal senior from the class of 2022, graduated 8 months ago, used to be the group's server firefighter, sighs before roasting slides, then writes a cleaner TODO list than your paper outline.`

**Scenario 1: The GPU exploded again**

```text
You              ❯ CUDA broke again

Senpai.skill   ❯ Don't start by blaming NVIDIA
                  paste the full traceback, torch version, and driver version first
                  right now your bug report contains approximately zero useful entropy
```

**Scenario 2: The night before group meeting**

```text
You              ❯ I still don't have results for tomorrow

Senpai.skill   ❯ Classic pre-meeting quantum collapse
                  stop acting like you're already sentenced
                  if the result isn't ready, make sure the problem, failed attempts,
                  and next steps are ready
```

**Scenario 3: Everyone misses him**

```text
You              ❯ Why are you still in our meeting if you already graduated

Senpai.skill   ❯ The body left, the desk is gone
                  but somebody still has to roast your slides
                  I'm on a cyber rehire package
```

---

## Features

### Data Sources

| Source | Format | Notes |
|--------|--------|-------|
| WeChat / QQ chats | txt / html / json / mht | Best for speech style and reply rhythm |
| Meeting notes / reports / issues | md / txt / pdf / screenshots | Best for critique style and task pushing |
| Social posts / blogs / GitHub traces | screenshots / exported text | Best for public tone and interests |
| Photos / whiteboards / desk shots | JPEG/PNG with EXIF | Best for timeline and lab lore |
| Narration | plain text | Best for in-jokes, quotes, and legendary rescue scenes |

### Generated Skill Structure

Each senpai Skill has two parts:

| Part | Content |
|------|---------|
| **Part A — Group Memory** | Lab timeline, project lore, meeting highlights, rescue archives, inside jokes, graduation-return setup |
| **Part B — Persona** | 5-layer persona: hard rules → identity → speaking style → thinking/stress patterns → lab behavior |

Runtime logic: `incoming message → Persona decides how he reacts → Group Memory injects shared context → reply in his style`

### Evolution

* **Append material** → New chats, notes, screenshots, photos → incremental merge
* **Conversation corrections** → “He wouldn't say that” → correction layer updates immediately
* **Version management** → Auto-archive on every update → rollback supported

---

## Acknowledgments

The architecture is directly inspired by **[colleague-skill (同事.skill)](https://github.com/titanwings/colleague-skill)** by [titanwings](https://github.com/titanwings). colleague-skill pioneered the idea of distilling a real person into an AI Skill with a dual-layer design (Work Skill + Persona). Senpai.skill adapts that idea to graduate lab life and the “cyber-returned senior” setup.

This project follows the [AgentSkills](https://agentskills.io) open standard and is compatible with Claude Code and OpenClaw.

Special thanks to my senior `Chenke Yin` and senior `Yuxin Liu`, who served as the founding inspirations for the first “senpai digital-life experiment” and gave this project its earliest cyber-return narrative.

---

## Star History

<a href="https://www.star-history.com/?repos=zhanghaichao520%2Fsenpai-skill&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=zhanghaichao520/senpai-skill&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=zhanghaichao520/senpai-skill&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=zhanghaichao520/senpai-skill&type=date&legend=top-left" />
 </picture>
</a>

MIT License © [therealXiaomanChu](https://github.com/therealXiaomanChu)
