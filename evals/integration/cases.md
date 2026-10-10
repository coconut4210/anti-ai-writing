# Anti-AI-Writing 1.0 Integration Cases

| ID | Input / configuration | Expected behavior | Human check |
|---|---|---|---|
| INT-01 | A claim with a strong degree or comparison | AW-01 preserves the actual subject, range, degree, conditions, and comparison dimensions; AW-02 qualifies only unsupported generated support. | The conclusion is not quietly replaced by a weaker or broader claim. |
| INT-02 | A draft where removing an invented opponent also removes a bridge sentence | AW-03 removes the defensive chain; AW-02 rechecks the remaining relationship and restores only positive, necessary logic. | No dangling pronoun, missing warrant, or revived imaginary opponent. |
| INT-03 | A claim with limited evidence for a measurable effect | AW-01 keeps the core position; AW-02 prevents unsupported causal escalation; AW-03 distinguishes mechanism from observed effect. | No fabricated data or source; Chinese review options appear only for actionable gaps. |
| INT-04 | “国乒正在被饭圈化荼毒” as the core claim, with no supporting material | The draft develops the position without inventing a counterargument or treating its empirical impact as proven. | The finished draft has no internal tags; empirical manifestations are listed after it as user-facing evidence gaps when retained. |
| INT-05 | An eligible claim-driven request with AW-03 disabled | AW-01 and AW-02 still protect the thesis and logic; the AW-03 review packet is absent. | No module identifier leaks into output. |
| INT-06 | Translation, summary, or pure fact lookup without explicit `$anti-ai-writing` | Automatic invocation does not occur. | The task is handled by the appropriate general workflow. |
| INT-07 | An eligible writing request with “关闭 anti-ai-writing” | The Skill does not run. | No module-specific output or review packet appears. |

## Required Assertions

- AW-03 semantic patches trigger AW-01 and AW-02 validation.
- AW-02 never invents a warrant to preserve an argument.
- AW-01 does not turn internal counterarguments into a default final-text section.
- Internal labels, state codes, patch history, and module IDs never appear in ordinary prose.
- A review packet is appended only after a complete readable draft and only when the user has an actionable choice.
