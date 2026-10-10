# Module Interface

Every runtime module begins with a declaration in this form:

```yaml
module_id: AW-XX
name: short-module-name
version: 1.0
default_enabled: true
stages: [prepare, audit, validate]
reads: [intent_spec, draft]
writes: [diagnostics, patch_proposals, validation_results]
invariants: [preserve_user_position, do_not_invent_evidence]
revalidate_after: [any_semantic_patch]
```

## Required Behavior

- Read and write only fields declared in the shared contract.
- Produce diagnostics and local patch proposals; do not repeatedly rewrite the whole draft.
- Keep internal labels out of the ordinary output.
- Do not broaden tool or research authorization.
- Do not trade one protected invariant for a local improvement.
- Report an unresolved conflict rather than marking an unrun validation as passed.

## Integration

The entrypoint runs enabled modules by stage. It merges overlapping proposals once in `rewrite`, then reruns every module named by `requires_revalidation`.

A module that performs a semantic deletion or rewrite must trigger AW-01 and AW-02 validation when those modules are enabled.

## Registering a Future Module

Before adding a module to `SKILL.md`, it must:

1. Declare its interface and stage dependencies.
2. Include module-specific evaluation material under `evals/`.
3. Include at least one integration regression case.
4. State its user-visible output boundary.
5. Pass package and reference-path validation.
