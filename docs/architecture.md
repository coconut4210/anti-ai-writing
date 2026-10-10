# Anti-AI-Writing 1.0 Architecture

## Runtime Structure

`SKILL.md` is the entrypoint. It routes eligible claim-driven writing requests through the shared contract and enabled modules. Runtime rules live in `references/`; `evals/` is development-only and is not loaded for ordinary writing.

```text
PREPARE → PLAN → COMPOSE → AUDIT → REWRITE → VALIDATE → RESOLVE
```

AW-01 protects the user's core position. AW-02 controls logical validity and argumentative progression. AW-03 removes unnecessary defensive writing and presents actionable evidence gaps after a complete draft.

## Extension Rules

Future modules must declare their stages, reads, writes, invariants, and revalidation triggers in the module interface. They produce diagnostics and local patch proposals; only the shared rewrite stage changes the draft. A future module requires its own evaluation material and at least one integration regression case before it is registered in `SKILL.md`.

## Versioning

- `1.0.x`: rule fixes and test additions without public-interface changes.
- `1.x`: backward-compatible optional modules or diagnostic fields.
- `2.0`: changes to shared fields, stage meanings, or module integration.

## Release Standard

Before release, validate Skill format, reference paths, module tests, integration cases, trigger boundaries, module-disable behavior, and internal-label leakage. Publish passed checks, known limits, and uncovered areas separately.
