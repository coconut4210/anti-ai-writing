# AW-01：稻草人保护

```yaml
module_id: AW-01
name: strawman-guard
version: 1.0
default_enabled: true
stages: [prepare, audit, validate]
reads: [request.core_thesis, content.intent_spec, content.draft_versions]
writes: [content.intent_spec, content.diagnostics, content.patch_proposals, content.validation_results]
invariants: [preserve_user_position, preserve_scope_and_degree, do_not_invent_opposition]
revalidate_after: [any_semantic_patch]
```

## Purpose

Develop the user's actual position rather than a stronger, weaker, broader, narrower, or easier-to-refute substitute.

## Prepare

提取用户核心论点的主体、范围、程度、条件、比较维度和已说明的不确定性。Record only what the user actually supplied; do not assign hidden motives or positions.

进行内部双向推演：steelman both the best reasonable support and the best objection to the user's real claim. Use this map only to find conditions, key disagreements, and safe support paths. Do not copy it into the finished writing unless the user explicitly asks for a debate, rebuttal, or balanced analysis.

Ask one question only when an unresolved ambiguity would change the thesis, the article's direction, or the conclusion. Otherwise use a conservative interpretation and continue.

## Compose and Audit

- Keep the thesis as the article's target; do not silently replace it because it lacks complete evidence.
- Constrain model-added support, interpretation, and examples more strictly than the user position itself.
- Do not turn a qualified claim into an absolute claim and then rebut the absolute version.
- Do not introduce a new opposing view merely to look balanced.
- When a condition or another factor matters, state its function positively instead of first inventing an extreme claim to deny.

For each corrective, rebuttal, or defensive sentence, identify the proposition being answered. It may remain only when the user raised it or explicitly requested a response to it.

## Validate

After any semantic patch, verify that the user's position still has the same subject, range, degree, conditions, comparison dimensions, and uncertainty level. A patch that changes one of these must be rolled back or rewritten to act on model-added support instead.

普通输出只输出成稿。Never expose the steelman map, disagreement list, module ID, or validation notes.
