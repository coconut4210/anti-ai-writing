# Anti-AI-Writing Skill 1.0 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将当前 01—03 规则、共享流程和评测资料整理为可安装、可扩展、可发布到 GitHub 的 Anti-AI-Writing 1.0 Skill。

**Architecture:** 仓库根目录为 Skill 根目录。`SKILL.md` 作为轻量入口，按需加载共享契约、模块接口和三个运行模块；模块只产出诊断与局部修复建议，由主控统一重写。评测材料保留在 `evals/`，不作为正常创作的运行上下文。

**Tech Stack:** Markdown、YAML、PowerShell、Git、Codex Skill Creator validator。

**Spec:** `docs/superpowers/specs/2026-10-10-anti-ai-writing-v1-design.md`

## Global Constraints

- Skill 名称固定为 `anti-ai-writing`，默认允许隐式触发并支持显式 `$anti-ai-writing` 调用。
- 1.0 仅注册 AW-01、AW-02、AW-03；04—10 不创建空白运行模块。
- 运行规则、评测资料和维护文档分离；普通创作不加载 `evals/`。
- 模块不得直接重写全文或覆盖其他模块状态；统一重写后必须复验语义修改。
- 普通输出只交付成稿；存在可行动证据缺口时才附加中文待确认项。
- 不擅自创建许可证文本；发布前由用户选择许可证。
- 不改变已有 `problem-details/` 与 `evals/` 的历史资料，除非迁移后已验证引用和内容完整。

## Review Focus

- 自动触发边界：核心论点创作应触发，翻译、摘要、事实核实和非观点型创作不应自动触发。
- 用户关闭模块：关闭 AW-03 时不应输出待确认清单，但仍保留平台级安全与事实边界。
- 模块冲突：AW-03 删除防御内容后，AW-01 与 AW-02 必须复验立场和逻辑。
- 证据缺口：不能将预期机制写成已经发生的效果，也不能把免责声明作为待确认项的替代。
- 输出泄漏：正文不得出现模块 ID、内部状态码、诊断标签或修改历史。

---

### Task 1: 建立 Skill 根目录入口和元数据

**Files:**
- Create: `SKILL.md`
- Create: `agents/openai.yaml`
- Create: `README.md`
- Create: `docs/architecture.md`

**Interfaces:**
- Consumes: 已批准架构规格中的触发、目录与版本规则。
- Produces: 可被 Codex 发现的 Skill 入口、用户可读的 GitHub 说明和维护者架构说明。

- [ ] **Step 1: 创建 Skill Creator 格式检查的失败目标清单**

在实施记录中列出 `SKILL.md` 必须具备的 `name`、`description`、模块引用和无脚手架占位符要求。

- [ ] **Step 2: 运行 Skill Creator validator，确认当前根目录不是有效 Skill**

Run: `python C:\Users\admin\.codex\skills\.system\skill-creator\scripts\quick_validate.py .`

Expected: FAIL，原因是根目录尚无 `SKILL.md`。

- [ ] **Step 3: 创建简洁的 `SKILL.md` 与 `agents/openai.yaml`**

`SKILL.md` 的 frontmatter 使用 `name: anti-ai-writing`；description 仅描述“用户提供核心论点并要求独立创作、探讨或论证”这一触发场景。正文声明混合触发、用户模块开关、阶段顺序、注册表、输出边界，并链接运行时必需引用。

`agents/openai.yaml` 保持隐式调用开启，使用与 Skill 一致的显示名、短描述和默认提示。

- [ ] **Step 4: 创建 `README.md` 与 `docs/architecture.md`**

README 面向 GitHub 用户，包含用途、适用与不适用场景、安装方式、显式调用方式、模块开关、当前限制和许可证待选状态。架构文档从已批准规格中提炼目录职责、共享流程、扩展步骤和版本策略。

- [ ] **Step 5: 运行包格式验证**

Run: `python C:\Users\admin\.codex\skills\.system\skill-creator\scripts\quick_validate.py .`

Expected: PASS，且无未完成脚手架警告。

- [ ] **Step 6: Commit**

```bash
git add SKILL.md agents/openai.yaml README.md docs/architecture.md
git commit -m "feat: add anti-ai-writing skill entrypoint"
```

### Task 2: 建立共享契约与模块接入接口

**Files:**
- Create: `references/shared-contract.md`
- Create: `references/module-interface.md`
- Modify: `SKILL.md`

**Interfaces:**
- Consumes: `SKILL.md` 的阶段流程和架构规格第 6—9 节。
- Produces: 供 AW-01—03 与未来模块共同使用的状态字段、诊断格式、补丁格式、冲突优先级与接入要求。

- [ ] **Step 1: 写出共享字段的失败检查清单**

要求文档明确 `request`、`runtime`、`content` 三个顶层域，以及 `intent_spec`、`argument_plan`、`diagnostics`、`patch_proposals`、`uncertainty_items`、`validation_results` 的语义与终稿可见性。

- [ ] **Step 2: 创建 `references/shared-contract.md`**

以 YAML 结构展示共享状态；定义 `diagnostic`、`patch_proposal`、`uncertainty_item` 的最小字段；明确内部字段不得进入终稿。

- [ ] **Step 3: 创建 `references/module-interface.md`**

规定模块 header、`stages`、`reads`、`writes`、`invariants`、`revalidate_after`；规定模块只诊断、主控统一重写；写入新增模块的独立测试与集成回归要求。

- [ ] **Step 4: 在 `SKILL.md` 链接共享引用**

在入口流程中说明所有启用模块前先读取共享契约；需要新增模块时读取模块接口。

- [ ] **Step 5: 验证接口完整性**

Run: `rg -n "intent_spec|argument_plan|patch_proposals|uncertainty_items|revalidate_after|统一重写" references SKILL.md`

Expected: 每个共享字段和接口要求均至少出现一次，且 `SKILL.md` 指向两个引用文件。

- [ ] **Step 6: Commit**

```bash
git add references/shared-contract.md references/module-interface.md SKILL.md
git commit -m "feat: define shared module contract"
```

### Task 3: 提炼 AW-01 稻草人保护模块

**Files:**
- Create: `references/modules/01-strawman.md`
- Modify: `SKILL.md`
- Preserve: `problem-details/01-稻草人.txt`
- Preserve: `evals/strawman/`

**Interfaces:**
- Consumes: `intent_spec.core_thesis`、任务约束和当前草稿。
- Produces: `strawman` diagnostics、局部 patch proposals、立场验证结果。

- [ ] **Step 1: 定义 AW-01 的验收检查**

从现有评测中选取“保留主体、范围、程度、条件和比较维度；不输出内部双向推演；不凭空引入反方段落”三项不变量。

- [ ] **Step 2: 创建 `references/modules/01-strawman.md`**

提炼原文件中的论点保护、构思期内部双向推演、分歧定位、最小追问、终稿输出边界和成稿校验；删除测试历史和重复说明。写入 AW-01 header：`prepare`、`audit`、`validate`。

- [ ] **Step 3: 在注册表中登记 AW-01**

明确默认启用、无模块依赖、在所有语义补丁后复验。

- [ ] **Step 4: 验证模块与既有评测的对应关系**

Run: `rg -n "主体|范围|程度|条件|比较维度|双向推演|只输出成稿" references/modules/01-strawman.md; rg --files evals/strawman`

Expected: 模块包含三项不变量，既有稻草人评测仍存在。

- [ ] **Step 5: Commit**

```bash
git add references/modules/01-strawman.md SKILL.md
git commit -m "feat: add strawman protection module"
```

### Task 4: 提炼 AW-02 逻辑断裂控制模块

**Files:**
- Create: `references/modules/02-logic-break.md`
- Modify: `SKILL.md`
- Preserve: `problem-details/02-逻辑断裂.txt`
- Preserve: `evals/logic-break/`

**Interfaces:**
- Consumes: `intent_spec`、AW-01 的论点定义、`argument_plan` 与当前草稿。
- Produces: 关系有效性与论证推进 diagnostics、局部 patch proposals、逻辑验证结果。

- [ ] **Step 1: 定义 AW-02 的验收检查**

要求模块区分关系断裂与推进断裂；只允许依据足够的关键连接；缺少依据时限定、重连、保留待核实或删除；不得把用户核心论点擅自替换。

- [ ] **Step 2: 创建 `references/modules/02-logic-break.md`**

提炼 Claim Gate、Progression Gate、用户立场保护、统一修复后复验、最小追问与已知边界；将完整测试矩阵、单次测试结果和历史状态留在 `evals/` 或维护文档。写入 AW-02 header：`plan`、`compose`、`audit`、`validate`，依赖 AW-01 的论点定义。

- [ ] **Step 3: 在注册表中登记 AW-02**

明确 AW-02 不把不充分依据补造成事实，且任何 AW-03 语义删除后需要重新复验。

- [ ] **Step 4: 验证模块与既有评测的对应关系**

Run: `rg -n "Claim Gate|Progression Gate|user_position|QUALIFY|RELINK|不编造" references/modules/02-logic-break.md; rg --files evals/logic-break`

Expected: 模块包含关系与推进双重控制，既有逻辑断裂评测仍存在。

- [ ] **Step 5: Commit**

```bash
git add references/modules/02-logic-break.md SKILL.md
git commit -m "feat: add logic break module"
```

### Task 5: 提炼 AW-03 防御性写作模块

**Files:**
- Create: `references/modules/03-defensive-writing.md`
- Modify: `SKILL.md`
- Preserve: `problem-details/03-防御性写作.txt`
- Preserve: `evals/defensive-writing/`

**Interfaces:**
- Consumes: `intent_spec`、当前草稿、`source_policy`、证据边界和修订后的逻辑验证结果。
- Produces: 防御性写作 diagnostics、局部 patch proposals、`uncertainty_items`、用户决策状态。

- [ ] **Step 1: 定义 AW-03 的验收检查**

要求区分排除项和反驳义务；删除无关防御链但保留必要反驳；区分功能事实、预期机制与实际效果；对可行动证据缺口展示中文四选项。

- [ ] **Step 2: 创建 `references/modules/03-defensive-writing.md`**

提炼意图与约束分流、Defensive Necessity Gate、统一修复、语义复验、Audit 4、逐项授权和中文选项。保留“效果断言 + 证据免责声明”必须产生待确认项的 V2 规则。写入 AW-03 header：`prepare`、`compose`、`audit`、`resolve`。

- [ ] **Step 3: 在注册表中登记 AW-03**

明确 AW-03 的修复会触发 AW-01/AW-02 复验；明确没有可行动证据缺口时直接交付成稿。

- [ ] **Step 4: 验证模块与既有评测的对应关系**

Run: `rg -n "exclusion_constraints|required_oppositions|function_fact|expected_mechanism_or_design_value|observed_effect|网络调查搜集材料" references/modules/03-defensive-writing.md; rg --files evals/defensive-writing`

Expected: 模块包含防御链和 Audit 4 的核心约束，既有防御性写作评测仍存在。

- [ ] **Step 5: Commit**

```bash
git add references/modules/03-defensive-writing.md SKILL.md
git commit -m "feat: add defensive writing module"
```

### Task 6: 完成入口编排、用户控制与 GitHub 文档

**Files:**
- Modify: `SKILL.md`
- Modify: `README.md`
- Modify: `docs/architecture.md`

**Interfaces:**
- Consumes: 三个模块 header、共享契约、模块接口。
- Produces: 完整的混合触发、模块注册表、冲突优先级、输出契约与扩展指南。

- [ ] **Step 1: 定义入口集成验收检查**

要求入口同时包含自动触发条件、默认不触发条件、显式调用、整 Skill 关闭、单模块关闭、三个模块注册表、两轮修复上限和中文待确认项边界。

- [ ] **Step 2: 完成 `SKILL.md` 的运行编排**

以简短路由形式声明何时读取每个模块；将 01—03 按 PREPARE、PLAN、COMPOSE、AUDIT、REWRITE、VALIDATE、RESOLVE 调度；加入冲突优先级和不显示内部标签的终稿契约。

- [ ] **Step 3: 完成面向 GitHub 的 README 与架构文档**

README 说明用户如何安装、何时自动触发、如何明确启用或关闭模块、1.0 的范围与限制。架构文档说明未来模块如何声明接口、注册和验证。

- [ ] **Step 4: 验证入口与模块引用**

Run: `rg -n "AW-01|AW-02|AW-03|关闭|PREPARE|RESOLVE|网络调查搜集材料" SKILL.md README.md docs/architecture.md; rg -o "references/[A-Za-z0-9_./-]+\.md" SKILL.md`

Expected: 三个模块、混合触发与输出契约均存在；所有引用路径对应实际文件。

- [ ] **Step 5: Commit**

```bash
git add SKILL.md README.md docs/architecture.md
git commit -m "feat: wire anti-ai-writing v1 workflow"
```

### Task 7: 添加集成评测索引并完成发布前验证

**Files:**
- Create: `evals/integration/README.md`
- Create: `evals/integration/cases.md`
- Modify: `README.md`

**Interfaces:**
- Consumes: 三个模块、现有模块级评测和规格第 11 节发布门槛。
- Produces: 不加载到运行上下文的集成回归清单，以及可复现的发布前验证命令。

- [ ] **Step 1: 定义集成评测清单**

覆盖 AW-03 删除内容后逻辑仍成立、AW-02 限定不改变立场、AW-01 不诱发证据编造、待确认项仅在证据缺口出现、内部标签不泄漏，以及五种触发/关闭情形。

- [ ] **Step 2: 创建 `evals/integration/cases.md` 与 `README.md`**

每个案例写明输入类型、启用模块、期望结果和人工检查点；链接现有模块级评测而不复制原始输出。

- [ ] **Step 3: 运行格式与引用验证**

Run: `python C:\Users\admin\.codex\skills\.system\skill-creator\scripts\quick_validate.py .`

Expected: PASS。

Run: `rg -n "[T]ODO|[T]BD|[F]IXME" SKILL.md agents references README.md docs evals/integration`

Expected: 无匹配。

- [ ] **Step 4: 进行人工集成检查**

使用现有“国乒正在被饭圈化荼毒”输出，核对：正文没有内部标签；AW-01 未把论点改弱；AW-02 未补造事实；AW-03 在经验性影响缺少材料时产生中文待确认项。

- [ ] **Step 5: Commit**

```bash
git add evals/integration README.md
git commit -m "test: add v1 integration evaluation guide"
```

### Task 8: 配置远程、提交与推送 1.0

**Files:**
- Modify: Git configuration and remote metadata only.

**Interfaces:**
- Consumes: 通过验证的 1.0 工作树与 GitHub 仓库 `https://github.com/coconut4210/anti-ai-writing`。
- Produces: GitHub 上的可安装 1.0 仓库。

- [ ] **Step 1: 验证 Git 作者身份和远程地址**

Run: `git config --get user.name; git config --get user.email; git remote -v`

Expected: 有可用的仓库级作者身份，`origin` 指向用户提供的 GitHub 仓库。

- [ ] **Step 2: 配置或更新 `origin`**

Run: `git remote add origin https://github.com/coconut4210/anti-ai-writing.git`，或在已有 `origin` 时使用 `git remote set-url origin ...`。

- [ ] **Step 3: 提交所有经验证的 1.0 文件**

Run: `git status --short; git add -- SKILL.md agents references evals docs README.md problem-details problems.txt; git commit -m "feat: release anti-ai-writing skill v1.0"`

Expected: 只包含经检查的 Skill、文档、评测与现有规则资料。

- [ ] **Step 4: 推送默认分支**

Run: `git push -u origin master`

Expected: 推送成功并返回远程分支跟踪信息。

- [ ] **Step 5: 验证远程状态**

Run: `git status --short; git log -1 --oneline; git ls-remote --heads origin master`

Expected: 工作树无未提交的 1.0 文件，本地最新提交与远程 `master` 相符。

## Self-Review

- Spec coverage: 目录、混合触发、共享契约、模块接口、三个模块、统一重写、冲突处理、输出契约、测试门槛、版本策略和 GitHub 发布分别由 Task 1—8 覆盖。
- Step scan: 每项创建、提炼、验证和提交任务都有明确文件与可检查结果。
- Type consistency: AW-01、AW-02、AW-03 与 `intent_spec`、`argument_plan`、`diagnostics`、`patch_proposals`、`uncertainty_items` 命名与规格一致。
- Review focus: 五项风险分别在 Task 1、Task 5、Task 6 和 Task 7 的验收与集成检查中覆盖。
- Proportion: 计划记录文件职责、接口和验证命令，不复制模块正文。
