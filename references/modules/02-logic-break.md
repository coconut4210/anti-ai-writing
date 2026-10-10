# AW-02：逻辑断裂控制

```yaml
module_id: AW-02
name: logic-break-guard
version: 1.0
default_enabled: true
stages: [plan, compose, audit, validate]
reads: [content.intent_spec, content.argument_plan, content.draft_versions]
writes: [content.argument_plan, content.diagnostics, content.patch_proposals, content.validation_results]
invariants: [preserve_user_position, do_not_invent_evidence, separate_validity_from_progression]
revalidate_after: [any_semantic_patch, AW-03.semantic_patch]
```

## Purpose

Control two independent risks:

- **关系断裂 / logical validity**: a causal, inferential, explanatory, evidential, or interpretive connection lacks a non-circular warrant.
- **推进断裂 / argumentative progression**: a paragraph is related to the subject but adds no evidence, mechanism, inference, boundary, or necessary synthesis.

Do not treat sentence length, connective words, literary interpretation with clear subjective ownership, or necessary background as automatic defects.

## Plan

Read the user's position from `content.intent_spec`. The controller creates a minimal `intent_spec` from the request even when AW-01 is disabled; AW-02 must not depend on another module's private output.

Keep the user's `user_position` as the writing target. Separate it from model-added support, interpretation, hypothesis, and external-looking facts.

For each important relation, name its type and support state: `supported`, `plausible_but_unverified`, `unsupported`, or `contradicted`. A relationship requires a warrant: allowed material, reliable common knowledge, or a clearly owned interpretation. Similar wording, topical association, chronology, or a connective word is not a warrant.

Set a small number of argument goals. Each new paragraph must contribute evidence, mechanism, inference, boundary, synthesis, or necessary context serving a later goal.

## Compose: Claim Gate and Progression Gate

Before a key relation is written, run the **Claim Gate**:

- `WRITE` only when the warrant supports the intended strength.
- `QUALIFY` when support is limited.
- `RELINK` when claims belong together but the proposed inference does not.
- `HOLD` when an important fact needs verification.
- `DROP` when no support exists and the claim is not needed.

Never allow a `plausible_but_unverified` intermediate conclusion to become a later established fact. Do not use `ADD_WARRANT` to invent mechanism, evidence, data, or sources.

Then run the **Progression Gate**: identify which unfinished goal the content serves and what it newly contributes. Keep necessary context only when it supports a later goal; redirect or merge related but nonadvancing material.

## Audit and Repair

Audit relation fit, warrant presence, support sufficiency, conditions, cascade risk, paragraph contribution, redundancy, and unresolved questions separately.

Repair locally:

- qualify or reduce the connection;
- relink as a comparison, coexistence, or owned interpretation;
- remove repeated or nonadvancing material;
- flag a fact that requires verification.

Do not silently replace the user's thesis. If material is insufficient, qualify model-added support or present the thesis as the author's judgment; do not fabricate support.

After any AW-03 semantic change, recheck logical validity and argumentative progression before final delivery.
