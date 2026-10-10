# AW-03：防御性写作控制

```yaml
module_id: AW-03
name: defensive-writing-guard
version: 1.0
default_enabled: true
stages: [prepare, compose, audit, resolve]
reads: [content.intent_spec, content.draft_versions, request.source_policy, content.validation_results]
writes: [content.diagnostics, content.patch_proposals, content.uncertainty_items]
invariants: [do_not_invent_opposition, do_not_leak_exclusions, do_not_invent_evidence, preserve_necessary_qualifications]
revalidate_after: [any_semantic_patch]
```

## Purpose

Keep the prose centered on what the user wants to say. Remove a model-invented opponent, a user exclusion that leaked into the prose, and defensive chains that add no independent information. Preserve a real opposition, necessary evidence boundary, or high-risk warning when the task or material requires it.

## Prepare

Split the input into:

- `content_objectives`: what the writing must express;
- `user_position`: the claim to develop;
- `exclusion_constraints`: directions that constrain generation but do not automatically belong in prose;
- `required_oppositions`: views the user explicitly asks to compare, rebut, or discuss;
- `contextual_disputes`: real disputes present in supplied material;
- `evidence_boundaries`: what the material can and cannot support.

`exclusion_constraints` are not `required_oppositions`. First form a direct, positive statement that expresses the content objective without mentioning an excluded alternative.

## Compose: Defensive Necessity Gate

Treat a negation, disclaimer, imagined objection, or vague qualification as a candidate, not a defect. For each candidate, identify the defended-against proposition and its source: `user_required`, `contextual_dispute`, `user_exclusion_constraint`, `evidence_boundary`, `model_introduced`, or `unknown`.

Keep it only when task necessity, evidence necessity, contextual necessity, independent information, or material safety risk requires it. Otherwise:

- `DIRECT`: remove the defensive frame and state the positive content;
- `CALIBRATE`: keep only evidence-required uncertainty;
- `DROP`: remove content without independent contribution;
- `REVIEW`: preserve temporarily when safe treatment is unclear.

If an unnecessary object produces a chain of rebuttals, exceptions, or disclaimers, prune the dependent material unless it has independent factual value. Rewrite independent value positively. Do not reintroduce an imagined opponent to make the paragraph flow.

## Audit and Unified Rewrite

Audit unsolicited opposition, constraint leakage, overqualification, preemptive disclaimers, and defensive cascades. Emit diagnostics and local patches only; the shared `rewrite` stage merges them once.

After an AW-03 deletion or rewrite, AW-01 and AW-02 must revalidate the user position, logical relations, and progression.

## Audit 4: Evidence-Gap Resolver

After a complete readable draft exists, compare each empirical-effect claim with the available material. Do not use only words such as “可能” or “一定程度上” as the trigger.

Distinguish:

- `function_fact`: a supplied function or observed behavior;
- `expected_mechanism_or_design_value`: a plausible way the function could matter;
- `observed_effect`: a claim that efficiency, accuracy, cost, quality, satisfaction, conversion, risk, or another measurable result has actually changed.

An `observed_effect` needs supporting object, scenario, metric, baseline, data, or source as appropriate. When these fields are missing, the complete draft may state the function fact or expected mechanism, but it must not present the effect as already achieved.

“效果断言 + 证据免责声明” does not resolve the gap. For example, a sentence claiming improved efficiency followed by “currently no data is available” still requires an uncertainty item. A disclaimer explains the gap; it does not replace the user's decision.

Do not create an item when the material supports the effect, the effect has been removed without implication, or the user has already chosen to retain, remove, or close that item.

## User Review Packet

Only when actionable gaps remain, append the packet after the complete draft:

```text
【完整稿】
可直接使用的正文

【待确认的模糊陈述】
U01｜精确范围与完整句
缺少：对象、场景、指标、基线、数据或来源
当前不能安全具体化的原因：……
可选：网络调查搜集材料 / 我来补充 / 仅保留当前叙述 / 删除当前叙述
```

The choices map internally to `INVESTIGATE`, `PROVIDE`, `KEEP`, and `REMOVE`, but the codes never replace the Chinese labels in user-facing output. Research is item-specific and requires explicit authorization. If there are no actionable gaps, deliver only the complete draft.
