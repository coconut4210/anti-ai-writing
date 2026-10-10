# Integration Evaluation

These checks verify that AW-01, AW-02, and AW-03 cooperate without changing the user's core position, fabricating support, or leaking internal workflow text. They supplement—rather than replace—the module-level evaluation folders.

Use `cases.md` as the manual regression checklist before a release. Record generated drafts and human decisions in a case-specific subdirectory when a regression is observed.

## Release Checks

1. Run the Skill Creator package validator.
2. Check every reference path in `SKILL.md`.
3. Review the module-level evaluations in `../strawman/`, `../logic-break/`, and `../defensive-writing/`.
4. Complete the integration cases and record any regression.
5. Publish passed checks, known limits, and uncovered areas separately.
