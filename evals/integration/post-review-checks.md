# Post-review integration checks — 2026-10-10

These checks verify the workflow contract after the final interface review. They are static dispatch checks, not claims that a language-model output was generated.

## Check A — AW-01 disabled, AW-02 enabled

**Setup:** The user invokes `只使用逻辑断裂模块` (or otherwise disables AW-01 while leaving AW-02 enabled).

**Expected:** The controller creates the minimal `content.intent_spec` from the request. AW-02 reads that shared field and must not read `AW-01.user_position` or any other module-private output.

**Result:** Pass. AW-02 declares only shared-contract inputs, and its Plan rule explicitly names the fallback controller behavior.

## Check B — unified rewrite followed by AW-03 validation

**Setup:** A unified rewrite changes a sentence that may add a defensive phrase or distort a required qualification while AW-03 remains enabled.

**Expected:** AW-03 participates in `validate`, checks only rewrite-introduced defensive leakage or qualification distortion, and does not create a second evidence-gap packet.

**Result:** Pass. AW-03 declares `validate`; its Validate rule constrains the pass; the entrypoint runs every enabled validator after rewrite.

## Check C — AW-03 disabled

**Setup:** The user invokes `跳过防御性写作检查`.

**Expected:** AW-03 is not run and no evidence-gap review packet is produced.

**Result:** Pass. The entrypoint makes the workflow conditional on enabled modules and explicitly suppresses AW-03's packet when it is disabled.
