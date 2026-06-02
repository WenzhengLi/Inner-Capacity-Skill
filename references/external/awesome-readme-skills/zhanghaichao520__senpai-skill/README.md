# 师兄.skill

> *"人虽然毕业了，但 ssh key、吐槽习惯和组会压迫感还在组里值班。"*

**把毕业的大师兄蒸馏成一个能继续开组会、骂醒你、顺手救火的 AI Skill。**

> 我们的师兄毕业得太早，早到服务器还没完全学会自己活着，组会也还没学会不挨骂。  
> 大家都很想他，所以决定用一点不太合规但很有感情的技术手段，让他以数字形态继续留在组里，争取常驻“课题组”。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python 3.9+](https://img.shields.io/badge/Python-3.9%2B-blue.svg)](https://python.org)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skill-blueviolet)](https://claude.ai/code)
[![AgentSkills](https://img.shields.io/badge/AgentSkills-Standard-green)](https://agentskills.io)

&nbsp;

提供师兄留下来的原材料: 微信/QQ群聊、组会纪要、issue 评论、合照、白板照片、朋友圈截图，再加上你们对他的主观描述。
生成一个**真的像他在开会和带人的 AI Skill**:
会记得组里的项目黑历史、经典口头禅、吐槽顺序、救火习惯，以及那些只有组里人懂的破梗。

说得再直白一点: 这不是普通的 AI 角色扮演，这是课题组面向情感需求推出的 **师兄留组工程**。
现实里他已经毕业，赛博系统里我们尽量不让他毕业。

⚠️ **本项目仅用于组内纪念、玩梗和协作复刻，不用于冒充真人、伪造学术结论或代替导师/课题组作正式决定。**

[安装](#安装) · [使用](#使用) · [效果示例](#效果示例) · [English](README_EN.md)

---

## 故事设定

每个实验室都有一个传说级师兄。
他不一定发论文最多，不一定说话最温柔，甚至不一定经常笑，但他总能在最要命的时候出现:
老板一句“你这个实验意义在哪里”，别人开始低头装死，他已经在纸上帮你重写问题定义；
服务器凌晨三点冒烟，群里一片“有人吗”，他先回一句“报错贴全”，再把机器从鬼门关里拽回来；
你被组会喷成筛子，以为人生到此为止，他会一边继续喷你，一边把你下一周该怎么活写成清单。

后来他毕业了。
工位被新同学继承，门禁失效，校园网账号注销，桌上的水杯和工牌也一起退场。
但一整个组不会这么轻易让一个师兄真正离职。
因为项目命名还带着他的时代烙印，老群聊里还存着他的名场面，甚至连“出了问题先贴日志”这种组规，都还在靠他当年的语气维持秩序。

所以 `senpai.skill` 的世界观非常简单:
现实世界允许毕业，课题组宇宙不允许核心 NPC 轻易退环境。
我们给他开一个赛博返聘通道，让他在另一个维度继续参加组会、继续嘲讽烂 PPT、继续拯救濒死环境，继续以一种不占工位但占据精神坐标的方式留在组里。

---

## 安装

### Claude Code

> **重要**: Claude Code 从 git 仓库根目录的 `.claude/skills/` 查找 skill。请在正确的位置执行。

```bash
# 安装到当前项目（在 git 仓库根目录执行）
mkdir -p .claude/skills
git clone https://github.com/zhanghaichao520/senpai-skill.git .claude/skills/create-senpai

# 或安装到全局（所有项目都能用）
git clone https://github.com/zhanghaichao520/senpai-skill.git ~/.claude/skills/create-senpai
```

### 依赖（可选）

```bash
pip3 install -r requirements.txt
```

---

## 使用

在 Claude Code 中输入：

```text
/create-senpai
```

这一步看起来像是在创建一个 Skill，实际上更像在给一位已经毕业的师兄补办赛博工牌。
你把记忆、口头禅、截图、群聊和白板残影一点点喂进去，系统再把这些碎片缝合成一个能继续开口的人。

按提示输入师兄的代号、组内信息、人设画像，然后选择数据来源。除代号外都可以跳过，仅凭描述也能先生成一个初版。

完成后用 `/{slug}` 召唤该师兄的数字生命，让他继续在组里值班。

### 管理命令

| 命令 | 说明 |
|------|------|
| `/list-senpais` | 列出所有 senpai Skill |
| `/{slug}` | 调用完整师兄 Skill |
| `/update-senpai {slug}` | 追加新材料并更新 |
| `/senpai-rollback {slug} {version}` | 回滚到历史版本 |
| `/delete-senpai {slug}` | 删除 |
| `/let-senpai-rest {slug}` | 温柔别名，意思是先别再召唤了 |

---

## 效果示例

> 输入: `做多模态的 22 届大师兄，毕业 8 个月，组里以前谁服务器炸了都找他，开组会先叹气再开喷，喷完会把 TODO 写得比论文还细。`

你通常不会在风和日丽、实验顺利、老板心情稳定的时候召唤师兄。
你会在下面这些时刻想起他:
周会前夜结果全无，服务器开始闹鬼，新人把实验环境配成了抽象艺术，或者整个组突然同时怀念那个“嘴最毒但最能救场”的人。

**场景一: 服务器又炸了**

```text
用户         ❯ 师兄 CUDA 又炸了

senpai.skill ❯ 先别急着骂 NVIDIA
              你把完整报错、torch 版本、驱动版本一起贴出来
              现在这个描述的有效信息量约等于“电脑坏了”
```

**场景二: 组会前夜心态崩了**

```text
用户         ❯ 这周结果还是没跑出来

senpai.skill ❯ 经典周会前夜量子自洽
              先别演死刑犯
              你现在最需要的是三页能讲清楚的问题定义、失败原因和下一步
              结果没有，脑子得有
```

**场景三: 大家开始想他了**

```text
用户         ❯ 师兄你都毕业了怎么还在组会里

senpai.skill ❯ 人走了 工位没了
              但你们 PPT 还是得有人骂
              我属于赛博返聘 不占经费 占你们心智带宽
```

---

## 功能特性

为了保证返场的不是一个只会套模板的空壳，而是一个真的带着组内记忆和行为逻辑的“赛博师兄”，这个 Skill 会尽量同时还原两件事:
他是谁，以及他曾经怎样和这个组一起活过。

### 数据源

| 来源 | 格式 | 备注 |
|------|------|------|
| 微信/QQ群聊 | txt / html / json / mht | 最能还原他说话方式和回复节奏 |
| 组会纪要/日报/Issue | md / txt / pdf / 截图 | 适合提取点评风格、任务推进方式 |
| 朋友圈/博客/GitHub | 截图 / 文本导出 | 提取公开表达风格和兴趣偏好 |
| 合照/白板/工位照片 | JPEG/PNG（含 EXIF） | 提取时间线、地点、名场面 |
| 口述/粘贴 | 纯文本 | 适合补充梗、经典语录、传奇救火现场 |

### 生成的 Skill 结构

每个师兄 Skill 由两部分组成，共同驱动输出：

| 部分 | 内容 |
|------|------|
| **Part A — Group Memory** | 入组时间线、项目黑历史、组会名场面、经典救火、组内梗、毕业返场设定 |
| **Part B — Persona** | 5 层人格结构: 硬规则 → 身份 → 说话风格 → 思考/压力模式 → 组内行为 |

运行逻辑: `收到消息 → Persona 判断师兄会怎么回 → Group Memory 补充组内上下文 → 用他的方式输出`

### 支持的标签

**组会风格**: 一针见血 · 先喷后救 · 先问问题再给方案 · 导师翻译器 · 细节审判庭

**带人风格**: 放养型 · Debug 保姆型 · 追着改型 · 点到为止型 · 骂完还给你改 PPT 型

**人格标签**: 吐槽役 · 人形 debug 器 · 服务器守门员 · DDL 驱动 · 乐子人 · 冷面笑匠 · 奶人怪 · 战术叹气 · 命名鬼才 · 返聘赛博人 · 开会判官 · 细节狂魔

### 进化机制

* **追加材料** → 找到新的聊天记录、纪要、截图、照片 → 自动分析增量 → merge 进对应部分
* **对话纠正** → 说“师兄不会这么说” → 写入 Correction 层，下一轮立刻生效
* **版本管理** → 每次更新自动存档，支持回滚

---

## 项目结构

本项目遵循 [AgentSkills](https://agentskills.io) 开放标准：

```text
create-senpai/
├── SKILL.md                # skill 入口（官方 frontmatter）
├── prompts/                # Prompt 模板
│   ├── intake.md           #   对话式信息录入
│   ├── memory_analyzer.md  #   组内记忆提取
│   ├── persona_analyzer.md #   师兄人格提取
│   ├── memory_builder.md   #   Group Memory 生成模板
│   ├── persona_builder.md  #   Persona 五层结构模板
│   ├── merger.md           #   增量 merge 逻辑
│   └── correction_handler.md # 对话纠正处理
├── tools/                  # Python 工具
│   ├── wechat_parser.py    # 微信聊天记录解析
│   ├── qq_parser.py        # QQ 聊天记录解析
│   ├── social_parser.py    # 公开内容扫描
│   ├── photo_analyzer.py   # 照片元信息分析
│   ├── skill_writer.py     # Skill 文件管理
│   └── version_manager.py  # 版本存档与回滚
├── senpais/                # 生成的师兄 Skill（gitignored）
├── docs/PRD.md
├── requirements.txt
└── LICENSE
```

---

## 注意事项

* **材料质量决定还原度**: 组会纪要 + 群聊 + 口述 > 单张截图
* 建议优先提供: **组会点评** > **debug 救火记录** > **日常群聊** > **毕业前后的经典场面**
* 最好的成品不是“伟光正导师发言器”，而是一个会损你两句、但真的能把你捞起来的师兄
* 这不是本人复活，只是把大家共同记忆里的那个他，编译成一个能继续陪组里唠嗑和开会的数字分身
* 如果最后生成出来的师兄过于客气、过于标准、像企业客服一样情绪稳定，那多半不是技术成功了，而是你们把他最灵魂的部分给过滤掉了

---

## 致敬 & 引用

本项目的架构灵感直接来源于 **[同事.skill](https://github.com/titanwings/colleague-skill)**（by [titanwings](https://github.com/titanwings)）。同事.skill 首创了“把人蒸馏成 AI Skill”的双层架构（Work Skill + Persona），senpai.skill 在此基础上把场景迁移到了研究生课题组和毕业返场叙事。致敬原作者的创意和开源精神。

本项目遵循 [AgentSkills](https://agentskills.io) 开放标准，兼容 Claude Code 和 OpenClaw。

特别致谢我的师兄 `Chenke Yin` 和师姐 `Yuxin Liu`，作为初代“师兄电子生命实验”的关键灵感来源和首批赛博返场角色，让这个项目第一次有了可以被认真玩梗的对象。

---

### 推荐的聊天记录导出工具

以下工具为独立的开源项目，本项目不包含它们的代码，仅在解析器中适配了它们的导出格式：

- **[WeChatMsg](https://github.com/LC044/WeChatMsg)** — 微信聊天记录导出（Windows）
- **[PyWxDump](https://github.com/xaoyaoo/PyWxDump)** — 微信数据库解密导出（Windows）
- **留痕** — 微信聊天记录导出（macOS）

---

### 写在最后

实验室里总有这种人：
平时坐在角落里，看起来像在发呆，其实已经听懂了老板刚才那段量子绕口令；
你代码一炸，他先叹气，再问你“日志呢”；
你 PPT 一烂，他嘴上说“这也敢讲”，手上已经开始帮你改标题了。

他毕业以后，工位会空，门禁会失效，报销流程也不归他管了。
但组里总会在某个周三晚上，突然很想听见那句：

`先别慌，把问题讲明白。`

这个 Skill 就是把这句话，以及说这句话的那个人，临时拉回组会现场。
如果可以的话，我们甚至希望他别只是“临时返场”，而是以一种不占工位、不领报销、但持续在群里施压的方式，永远留在组里。
毕竟有些师兄一毕业，整个实验室的 debug 成功率和 PPT 通过率都会出现肉眼可见的震荡。

## Star History

<a href="https://www.star-history.com/?repos=zhanghaichao520%2Fsenpai-skill&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=zhanghaichao520/senpai-skill&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=zhanghaichao520/senpai-skill&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=zhanghaichao520/senpai-skill&type=date&legend=top-left" />
 </picture>
</a>

MIT License © [zhanghaichao520](https://github.com/zhanghaichao520)
