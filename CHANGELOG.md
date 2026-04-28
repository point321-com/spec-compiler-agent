# CHANGELOG

## spec-guidelines overhaul — 2026-04-28

rewrote `docs/spec-guidelines.md` and added `docs/prompt-spec.md` to introduce a structured spec-generation phase before the existing planning phase.

---

### changes

---

#### fix 1 — repeated section name text

**problem:** every required section had the section heading followed immediately by a redundant plain-text repetition of the name (e.g., `### 3. components` then `components` on the next line). formatting artifact — added no value.

**resolution:** removed the redundant text from all 10 required sections.

**file:** `docs/spec-guidelines.md`

---

#### fix 2 — audience clarified to AI agent

**problem:** the purpose statement claimed the document was designed for both "humans writing specs" and "agents expanding high-level ideas." these are different use cases and the doc was optimized for neither.

**resolution:** reframed the document explicitly for an AI agent. the human provides `docs/input-spec.md`; the agent produces `docs/spec.md`. human authorship guidance removed.

**file:** `docs/spec-guidelines.md`

---

#### fix 3 — input guide added

**problem:** no definition of what the agent receives as input. the agent had no basis for knowing what constitutes a processable spec vs. something too thin to work with.

**resolution:** added an `## input` section defining `docs/input-spec.md` as the input source. includes rules for how to treat loose, inconsistent human input: read fully before acting, extract stated requirements, do not invent behavior, treat implementation hints as constraints not decisions.

**file:** `docs/spec-guidelines.md`

---

#### fix 4 — output contract added

**problem:** the document said "expand into full spec.md" but never stated the output path, structure requirements, or constraints. agents had no explicit contract to satisfy.

**resolution:** added an `## output contract` section. explicitly states: write `docs/spec.md`, structured using the 10 required sections, no code, no implementation detail beyond interface-level contracts, no unresolved placeholders.

**file:** `docs/spec-guidelines.md`

---

#### fix 5 — gap-handling protocol added

**problem:** no protocol defined for missing or ambiguous input. agents had no guidance on when to assume, when to mark a gap, or when to stop entirely.

**resolution:** added `## gap-handling protocol` with three tiers:
- resolvable gaps: mark with `[ASSUMED: ...]` and continue
- unresolvable gaps: mark with `[GAP: ...]` and continue
- blocking gaps: stop, do not write `docs/spec.md`, produce `docs/spec-blocked.md` instead

**file:** `docs/spec-guidelines.md`

---

#### fix 6 — self-validation checklist repositioned as agent execution gate

**problem:** the validation checklist was a passive post-review tool. it was not wired into the agent's execution flow.

**resolution:** renamed to `## self-validation checklist`, added explicit instruction to run it before writing `docs/spec.md`. all checks must pass. if any fail, apply gap-handling protocol before proceeding.

**file:** `docs/spec-guidelines.md`

---

#### fix 7 — invocation pattern added via prompt-spec.md

**problem:** no invocation entry point existed for the spec-generation phase. there was no `prompt-spec.md` equivalent of `prompt.md`.

**resolution:** created `docs/prompt-spec.md`. invocation pattern: `Implement docs/prompt-spec.md`. follows the same structure as `docs/prompt.md`. reads spec-guidelines and input-spec, generates docs/spec.md, applies gap-handling, falls back to spec-blocked.md if input is insufficient.

**files:** `docs/prompt-spec.md` (new)

---

#### fix 8 — derivation guides added to required sections

**problem:** required sections told the agent what to produce but not how to derive it from a vague human input. agents with no context could not fill sections correctly.

**resolution:** added a `**Derivation guide:**` block to each of the 10 required sections. guides are intentionally loose — they provide heuristics for interpretation, not rigid rules, since human input is inconsistent by nature.

**file:** `docs/spec-guidelines.md`

---

#### fix 9 — execution steps added

**problem:** no explicit ordered execution protocol for the agent. the agent had to infer its own workflow.

**resolution:** added `## execution steps` with a 7-step numbered sequence: read guidelines → read input → identify components/flows/constraints → apply gap-handling → populate sections → self-validate → write spec.md.

**file:** `docs/spec-guidelines.md`

---

#### fix 10 — implementation-level config rule removed

**problem:** the configuration section included "flags must not change code paths (use no-op pattern)." this is an implementation decision, not a spec-level concern. it does not belong in a document that defines architecture-level contracts.

**resolution:** removed the rule from `docs/spec-guidelines.md`. if this constraint is needed, it belongs in `docs/standards.md`.

**file:** `docs/spec-guidelines.md`

---

## output discipline — 2026-04-28

**problem:** document generation agents sometimes respond with narrative summaries or high-level plans instead of writing the requested files under `docs/generated/`, which breaks the compiler contract and wastes context.

**resolution:** added an explicit rule to `prompt.md` and to both generated prompt templates in `project-template.md`: output only the listed files under `docs/generated/`; do not summarize. added matching policy as rule 9 (`output discipline`) in `generate-docs-agent.md` (failure conditions renumbered to 10).

**files:** `prompt.md`, `project-template.md`, `generate-docs-agent.md`

---

## review pass — 2026-04-28

reviewed all core system files (`README.md`, `standards.md`, `project-template.md`, `generate-docs-agent.md`, `prompt.md`, `TODO.md`) for consistency, correctness, and agent-safety issues.

---

### issues identified and resolved

---

#### issue 3 — `task.md` content underspecified in `generate-docs-agent.md`

**problem:** mode: project-level in `generate-docs-agent.md` listed `task.md` as an output but provided no guidance on its content. an agent reading only the agent doc could not correctly populate `task.md`.

**resolution:** added a note to mode: project-level in `generate-docs-agent.md` stating that content formats for all generated documents are defined in `project-template.md` and must be followed exactly.

**file:** `generate-docs-agent.md`

---

#### issue 4 — no declared precedence between `next task` and `build-order.md`

**problem:** task files include a `## next task` field. `build-order.md` defines the global execution sequence. if the two conflicted, there was no stated tiebreaker. an agent could follow the wrong source.

**resolution:** added `build-order.md` as item 4 in the document authority section of `generate-docs-agent.md`, explicitly declaring it authoritative over `next task` fields. conflicts must be resolved by fixing the task file.

**file:** `generate-docs-agent.md`

---

#### issue 5 — implementation guidance embedded inside task file template

**problem:** the functional tests section of the task file format template in `project-template.md` contained `(omit section only if no runnable boundary exists yet)` as part of the example line. this is guidance, not a test case placeholder. agents copying the template verbatim would include the parenthetical in generated task files.

**resolution:** removed the parenthetical from the template body. the rule governing omission is already stated in the `rules` section below the template.

**file:** `project-template.md`

---

#### issue 6 — progressive generation escape hatch

**problem:** rule 6 in `generate-docs-agent.md` said "never generate everything at once unless explicitly instructed." the escape hatch allowed an agent prompted to "do everything" to collapse all three passes into one, defeating the progressive generation model entirely.

**resolution:** removed "unless explicitly instructed." the rule now reads "never generate everything at once." no exceptions.

**file:** `generate-docs-agent.md`

---

#### issue 7 — `common.md` "no duplication from spec" was ambiguous

**problem:** the `common.md` rules in `project-template.md` included "no duplication from spec." since `common.md` is derived from the spec, an agent could interpret this as "include nothing from the spec," producing an empty or near-empty `common.md`.

**resolution:** replaced with "do not copy spec requirements prose; extract only implementation-relevant contracts."

**file:** `project-template.md`

---

#### issue 9 — no validation gate between planning and execution (undocumented)

**problem:** no automated validation exists between the planning phase and the execution phase. a malformed generated task file could be executed without detection. this was an acknowledged limitation but only partially documented.

**resolution:** expanded the `## validation` section in `TODO.md` to explicitly state the risk and that users must review generated task files before execution.

additionally documented the spec structure limitation (no minimum spec structure enforced, no formal definition of "critical structure") in `TODO.md`.

**file:** `TODO.md`

---

### issues reviewed and accepted as-is

| # | reason |
|---|--------|
| 1 | `ROOT` path — sandbox context; ROOT will be set to relative project root at usage time |
| 2 | `prompt.md` location assumption — same as #1; by design |
| 8 | idempotency warning buried — already documented in `TODO.md`; acceptable |
| 10 | spec has no required structure — cannot compensate for all spec use cases; documented in `TODO.md` |
| 11 | `generate-docs-agent.md` input paths — same `docs/` prefix assumption as #2; consistent by design, not an issue |

---
