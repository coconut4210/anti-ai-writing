# Shared Contract

All enabled modules use this internal state. It is planning and validation data, not ordinary output.

```yaml
request:
  core_thesis: user-provided position to develop
  task_type: commentary | analysis | argument | other_claim_driven_writing
  audience: intended reader when given
  length_and_style: explicit delivery constraints
  explicit_constraints: user instructions and exclusions
  source_policy: context_only | user_authorized_research

runtime:
  enabled_modules: [AW-01, AW-02, AW-03]
  disabled_modules: []
  current_stage: prepare | plan | compose | audit | rewrite | validate | resolve
  revision_round: 0

content:
  intent_spec: user position, content objectives, exclusions, required oppositions, evidence boundaries
  argument_plan: goals, key relations, warrants, conditions, and progression criteria
  draft_versions: draft before and after each unified rewrite
  diagnostics: module-scoped findings
  patch_proposals: local changes not yet applied
  uncertainty_items: evidence gaps requiring a user decision
  validation_results: post-rewrite checks
```

## Diagnostic

Each diagnostic contains: `module_id`, `issue_type`, `span`, `reason`, `proposed_action`, `evidence_or_context`, and `severity`.

## Patch Proposal

Each proposal contains: `module_id`, `target_span`, `action`, `replacement_or_instruction`, `preserves`, and `requires_revalidation`.

Modules may propose local patches but never independently rewrite the whole draft.

## Uncertainty Item

Each actionable item contains: `item_id`, `span`, `paragraph_index`, `character_offsets`, `full_sentence`, `missing_fields`, `reason`, and `decision`.

The user-visible choices map to internal decisions as follows:

| User-facing choice | Internal decision |
|---|---|
| 网络调查搜集材料 | `INVESTIGATE` |
| 我来补充 | `PROVIDE` |
| 仅保留当前叙述 | `KEEP` |
| 删除当前叙述 | `REMOVE` |

## Conflict Priority

When proposals conflict, apply this order:

1. Preserve the user's explicit request and core position.
2. Do not invent facts, evidence, sources, or certainty.
3. Preserve the draft's actual meaning.
4. Preserve necessary logical relationships and conditions.
5. Improve defensive or stylistic quality.

If no safe merge exists, ask one question only when the conflict changes the article's direction. Otherwise keep the conservative draft or present an uncertainty item.

## Output Boundary

Internal fields, module labels, diagnostics, state codes, argument maps, and patch history never enter ordinary prose. A review packet is appended only after a complete readable draft and only when an actionable evidence gap remains.
