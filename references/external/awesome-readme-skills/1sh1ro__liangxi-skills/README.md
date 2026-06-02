<div align="center">

# 凉兮-skills

> 把公开可见的推文、交易复盘和表达习惯，整理成一个能直接调用的交易型 Skill。

[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-blueviolet)](https://claude.ai/code)
[![Codex](https://img.shields.io/badge/Codex-Compatible-green)](https://github.com/openai)
[![Language](https://img.shields.io/badge/Language-中文-red)](#)

<br>

这是一个围绕交易员 **凉兮** 风格整理的 Skill 仓库。<br>
目标不是做“语气模仿”，而是把公开材料里能稳定提炼出来的：<br>
**交易框架、结构偏好、风险习惯、表达方式** 做成一个可复用的 Skill。

[安装](#安装) · [用法](#用法) · [包含内容](#包含内容) · [来源说明](#来源说明)

</div>

---

## 项目说明

当前仓库收录的是一个交易型 Skill：

- `liangxi-trader`

它适合这些场景：

- 按“凉兮”风格看 BTC / ETH / 黄金 / 白银结构
- 把普通市场观点改写成更直接、更像盘手的中文表达
- 按他的思路输出交易计划，而不是只给方向判断
- 从公开帖子里提炼“什么时候做，什么时候等，什么时候承认看错”

这个 Skill 的重点不是人格扮演，而是以下四层：

1. 交易画像
2. 结构打法
3. 风险模型
4. 话术风格

---

## 安装

### Codex

把仓库克隆到 `~/.codex/skills/` 下：

```bash
git clone https://github.com/1sh1ro/liangxi-skills.git ~/.codex/skills/liangxi-skills
```

或者只取其中的 Skill 目录：

```bash
mkdir -p ~/.codex/skills
cp -R liangxi-trader ~/.codex/skills/
```

### Claude Code

如果你在 Claude Code 里使用，可放到项目根目录或全局技能目录：

```bash
mkdir -p .claude/skills
git clone https://github.com/1sh1ro/liangxi-skills.git .claude/skills/liangxi-skills
```

---

## 用法

直接把它当成一个交易风格 Skill 调用即可，例如：

```text
按凉兮风格看一下 BTC 这段结构
```

```text
把我这段做多观点改成凉兮会发的那种推文
```

```text
按凉兮的方法，给我出一个黄金交易计划
```

```text
如果是凉兮来做这段 ETH，他会等什么确认，哪里不会追
```

建议输出场景：

- 盘面分析
- 交易计划
- 风险提示
- 推文改写
- 观点压缩

---

## 包含内容

当前 `liangxi-trader` Skill 主要由这些文件组成：

### 1. Skill 入口

- `liangxi-trader/SKILL.md`

定义触发场景、核心规则、输出格式和使用方式。

### 2. 交易画像

- `liangxi-trader/references/trading-profile.md`

总结其公开材料里稳定出现的：

- 市场关注范围
- 结构偏好
- 指标使用方式
- 执行风格
- 典型判断逻辑

### 3. 结构打法库

- `liangxi-trader/references/setup-playbook.md`

包括：

- 假突破反手
- 真突破延续
- 区间吸筹 / 派发
- 双孕线 / 压缩突破
- 先走第一段再考虑反手
- 宏观事件 + 图形共振
- 巨鲸 / 消息速度差跟单

### 4. 风险模型

- `liangxi-trader/references/risk-model.md`

包括：

- 大币 / 小币的仓位差异
- 杠杆使用习惯
- 什么情况下不做
- 什么算确认
- 什么算失效

### 5. 公开交易记录提炼

- `liangxi-trader/references/public-trade-history.md`

只保留公开可见、自述可追溯的交易/复盘材料，不把不可验证内容当作事实。

### 6. 风格表达

- `liangxi-trader/references/style-guide.md`

用于约束输出语气，避免写成“研究报告腔”或“AI 空话”。

### 7. 来源摘要

- `liangxi-trader/references/source-posts.md`

记录这个 Skill 主要依据了哪些公开索引材料。

---

## 来源说明

这个 Skill 主要基于公开可访问的网页索引内容整理，不包含私有聊天记录或交易后台数据。

当前使用的主要公开来源包括：

- `r.jina.ai` 对 X 公开页面的镜像抓取
- `x-sou.com` 的公开索引页
- 少量第三方公开转述页，仅作低置信补充

重要说明：

- 当前仓库把 `@WallStreet0Name` 作为“凉兮 persona”的最佳努力公开来源
- 这是一种基于公开材料的归纳，不是身份认证
- 部分交易记录属于公开自述或复盘内容，不等同于交易所对账单

所以这个 Skill 更适合：

- 学习交易框架
- 复用表达方式
- 提炼结构打法

不适合：

- 当作身份认证材料
- 当作收益证明材料
- 当作真实持仓证明材料

---

## 设计原则

这个仓库的目标不是做一个“像他说话”的玩具，而是做一个更实用的交易 Skill。

所以保留内容遵循三条原则：

1. 能稳定复用
2. 能支撑交易决策表达
3. 能被公开来源解释

删掉的内容也很明确：

- 原始抓取脚本
- 临时缓存数据
- 对最终使用没有帮助的过程性文件

---

## 后续可扩展方向

如果后面继续扩展，这个仓库还可以补：

- BTC / ETH / 黄金三套固定分析模板
- 更细的推文语料分层
- 不同市场状态下的“凉兮式表达模板”
- 更多公开来源交叉验证

---

## 目录结构

```text
liangxi-skills/
└── liangxi-trader/
    ├── SKILL.md
    └── references/
        ├── trading-profile.md
        ├── setup-playbook.md
        ├── risk-model.md
        ├── public-trade-history.md
        ├── source-posts.md
        └── style-guide.md
```

---

## 免责声明

本仓库仅用于：

- 公开资料整理
- 风格与交易方法提炼
- AI Skill 构建

不构成：

- 投资建议
- 身份证明
- 收益保证

