---
name: anti-ai-writing
description: Use when a user supplies a core claim and asks for an original Chinese commentary, analysis, or argument that develops the claim without distorting it, breaking its logic, or adding unnecessary defensive writing.
---

# Anti-AI-Writing

Create independent Chinese writing from a user-provided core claim. Preserve the user's actual position, make each important inference supportable, and keep unnecessary opposition, disclaimers, and correction history out of the prose.

## When to Use

Use automatically when the request includes both:

- a core claim or judgment; and
- a request to create, explore, analyse, or argue from that claim as an independent piece of writing.

Do not automatically use for translation, summarization, formatting, fact lookup, standalone diagnosis of an existing text, or creative work not organized around a core claim. The user can always invoke `$anti-ai-writing` explicitly.

## User Controls

Honor natural-language controls such as:

- “不要使用 anti-ai-writing”；
- “关闭 anti-ai-writing”；
- “跳过防御性写作检查”；
- “只使用稻草人和逻辑断裂模块”。

Disabling a module affects only this Skill's workflow. It does not remove platform safety, truthfulness, or tool-permission requirements.

## Runtime References

Read [the shared contract](references/shared-contract.md) before applying modules. Read [the module interface](references/module-interface.md) when adding, changing, or disabling modules. Apply the shared conflict priority whenever module proposals overlap.

Load enabled modules from this registry:

| ID | Module | File | Stages |
|---|---|---|---|
| AW-01 | 稻草人保护 | [01-strawman.md](references/modules/01-strawman.md) | prepare, audit, validate |
| AW-02 | 逻辑断裂控制 | [02-logic-break.md](references/modules/02-logic-break.md) | plan, compose, audit, validate |
| AW-03 | 防御性写作控制 | [03-defensive-writing.md](references/modules/03-defensive-writing.md) | prepare, compose, audit, validate, resolve |

## Workflow

1. Parse the request into the shared contract and determine enabled modules.
2. Run `prepare`: if enabled, AW-01 locks the user position; if enabled, AW-03 separates content goals from exclusions and real opposition. The controller always establishes a minimal `intent_spec` from the request.
3. Run `plan`: if enabled, AW-02 builds the argument goals, supported relationships, and necessary boundaries.
4. Compose one continuous draft with AW-02 and AW-03 controls.
5. Run all enabled audits. Modules produce diagnostics and local patch proposals; they do not rewrite the whole draft independently.
6. Merge compatible proposals once in `rewrite`, using the conflict priority in the shared contract.
7. Revalidate semantic changes with every enabled validator: AW-01 protects the user position, AW-02 checks logic and progression, and AW-03 checks defensive leakage. If AW-03 is disabled, do not generate its evidence-gap review packet.
8. Stop after two repair rounds. Ask one question only if a remaining ambiguity would change the article's direction; otherwise deliver the draft.
9. If AW-03 finds an actionable evidence gap, append its user review packet after the complete draft.

## Output Boundary

Normally output only the finished writing. Do not expose internal labels, module identifiers, argument maps, diagnostics, patch history, or state codes.

When an actionable evidence gap remains, output the complete draft first, then a separate user-facing item with these options:

```text
网络调查搜集材料 / 我来补充 / 仅保留当前叙述 / 删除当前叙述
```

Do not investigate without the user's item-specific authorization.

## Maintenance

Runtime rules live in `references/modules/`. Tests and historical evaluation material live in `evals/` and are not loaded for ordinary writing. Follow [the architecture guide](docs/architecture.md) before registering a future module.
