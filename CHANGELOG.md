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

---

## generated output review — 2026-04-28

applied fixes from `REFACTOR.md` (principal AI/ML engineer review pass) to source templates. scope: issues identified in `docs/generated/build-order.md`, `common.md`, and `agent.md`. no changes to `task.md` or `prompt-component-planning.md` (passed review).

---

### changes

---

#### fix 1 — `build-order.md` silent dependency rows

**problem:** rows in `build-order.md` with no upstream dependencies carried no notes entry. silence was ambiguous — it did not confirm "no dependencies," it simply omitted the information.

**resolution:**
- `project-template.md` (`## build-order.md` → `### requirements`): added rule requiring every row to carry an explicit dependency declaration; "no lib dependencies" is a valid and required declaration when true.
- `generate-docs-agent.md` (`## responsibilities`): expanded the `generate build order` bullet to state that every row must have an explicit notes entry; silence is not valid; the agent must inspect the spec and make a deliberate, stated determination.

**files:** `project-template.md`, `generate-docs-agent.md`

---

#### fix 2a — `common.md` authoring instruction prose leaked into contract file

**problem:** `common.md` contained a line that was an authoring instruction ("Component-specific task docs must not restate full spec prose…"), not an implementation contract.

**resolution:** `project-template.md` (`## common.md` → `### rules`): added rule prohibiting authoring instructions, agent directives, and meta-commentary from `common.md`.

**file:** `project-template.md`

---

#### fix 2b — `common.md` restated `standards.md` structure rules

**problem:** `common.md` contained a `## repository layout` section duplicating path rules already defined in `standards.md`. governance prose is not an implementation contract.

**resolution:** `project-template.md` (`## common.md` → `### rules`): added rule prohibiting restatement of repository structure, naming conventions, or engineering rules from `standards.md`; reference by name instead.

**file:** `project-template.md`

---

#### fix 2c — `common.md` model contracts deferred types to spec

**problem:** the `## core models` section carried "(names only; shapes in spec)" and listed field names without Python type annotations. `standards.md` requires all interfaces to be explicit and typed. a contract that defers to the spec is not a contract.

**resolution:**
- `project-template.md` (`## common.md` → `### includes`): replaced `- shared models` with `- shared models: full typed field listings (Pydantic v2 annotations); not names-only references to the spec`.
- `generate-docs-agent.md` (`### 5. contract centralization`): added two bullets: typed fields required when extracting models; "(names only; shapes in spec)" and equivalent deferrals are forbidden.

**files:** `project-template.md`, `generate-docs-agent.md`

---

#### fix 3 — `agent.md` dependency rationale incomplete

**problem:** the `## dependency rationale` section in `agent.md` covered only the main service-to-lib chains. several libs (`libs/auth`, `libs/observability`, `libs/pii`, `libs/reranker`) had no rationale entry.

**resolution:**
- `project-template.md` (`## agent.md (project-level)` → `### includes`): replaced the `dependency ordering rationale` bullet to require an explicit rationale entry for every library and service in the build order, not just primary chains.
- `generate-docs-agent.md` (`### 3. dependency-first design`): added bullet requiring a rationale entry for every component; components with no obvious upstream dependencies must still state why they are positioned where they are.

**files:** `project-template.md`, `generate-docs-agent.md`

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

## REFACTOR.md implementation — 2026-04-28

Applied all four fixes from `REFACTOR.md` (principal AI/ML engineer review of `docs/generated/` output). Fixes applied to source template files only. No files under `docs/generated/` were modified; regeneration is a separate pass.

---

### REFACTOR-01 — build-order.md preamble: no spec prose

**File:** `~/.spec-compiler/docs/project-template.md`
**Section:** `## build-order.md` → `### requirements`
**Change:** Added rule — preamble must contain only the global sequence ordering statement; scope constraints, phase validation notes, and other spec prose are forbidden.

---

### REFACTOR-02 — build-order.md dependency notes: no speculative clauses

**Files:**
- `~/.spec-compiler/docs/project-template.md` — `## build-order.md` → `### requirements` (+1 rule)
- `~/.spec-compiler/docs/generate-docs-agent.md` — `## responsibilities` build-order bullet (clause appended)

**Change:** Dependency declarations must reflect current definitive state only; speculative or conditional future dependency clauses are forbidden.

---

### REFACTOR-03 — common.md: no duplicate Literal re-declarations

**Files:**
- `~/.spec-compiler/docs/project-template.md` — `## common.md` → `### rules` (+1 rule)
- `~/.spec-compiler/docs/generate-docs-agent.md` — `### 5. contract centralization` (+1 bullet)

**Change:** Each `Literal` type must be declared exactly once in the `## literals` block; subsequent code blocks must reference it via inline comment and must not re-declare the type.

---

### REFACTOR-04 — common.md: no behavioral enforcement prose

**Files:**
- `~/.spec-compiler/docs/project-template.md` — `## common.md` → `### rules` (+1 rule)
- `~/.spec-compiler/docs/generate-docs-agent.md` — `### 5. contract centralization` (+1 bullet)

**Change:** Behavioral enforcement rules (e.g., runtime ACL filters, query-time access control) are not typed contracts; they belong in `agent.md` or `task.md`, not `common.md`.

---

## REFACTOR.md generated-output review — 2026-04-28 (second pass)

Applied fixes from `~/.spec-compiler/REFACTOR.md` (generated 2026-04-28, project: rag-platform, branch: phase00-documentation). The four violations were identified in `docs/generated/` output. The generated files were patched in the `restatucture` commit; this pass encodes corresponding rules in the source templates to prevent recurrence on regeneration.

No files under `docs/generated/` were modified in this pass.

---

### Issue 1 — common.md: no `## cross-component references` section

**Files:**
- `~/.spec-compiler/docs/generate-docs-agent.md` — rule 5 (contract centralization), line 89
- `~/.spec-compiler/docs/project-template.md` — `## common.md` → `### rules`, line 108

**Rule violated:** Behavioral enforcement prose in `common.md` (`project-template.md` + `generate-docs-agent.md` rule 5).

**Change:** Added explicit prohibition on creating a `## cross-component references` section in `common.md`. Runtime enforcement notes describing behavior at component boundaries (ACL filter application at query time, broker boundary message ID opacity) are behavioral rules, not typed contracts — they belong in `agent.md` or `task.md`.

---

### Issue 2 — common.md: no speculative / future-labeled models

**Files:**
- `~/.spec-compiler/docs/generate-docs-agent.md` — rule 5 (contract centralization), line 90
- `~/.spec-compiler/docs/project-template.md` — `## common.md` → `### rules`, line 109

**Rule violated:** No speculative or future-state content; `common.md` must be minimal and precise.

**Change:** Added rule: models labeled "spec only", "future", or "implementation is future" must be excluded from `common.md` even when the spec provides their full shape. Only models required by current `build-order.md` components are permitted. Section headings must not imply speculative or future status (e.g., "future connector source configs (spec shapes)").

**Spec note:** `SharepointSourceConfig` and `GDriveSourceConfig` are explicitly labeled "spec only — implementation is future" in `docs/spec.md`; they must not appear in `common.md`.

---

### Issue 3 — agent.md: no phase labels in dependency rationale

**File:** `~/.spec-compiler/docs/generate-docs-agent.md` — rule 3 (dependency-first design), line 68

**Rule violated:** Dependency declarations must reflect current definitive state only; no speculative or conditional future dependency clauses.

**Change:** Added rule: dependency rationale entries in `agent.md` must not reference phase labels or implementation milestones (e.g., "Phase-1-style libs"). Use concrete, current dependency descriptions (e.g., "depends only on libs at compile time; no service-package imports").

---

### Issue 4 — task.md: build order vs. runtime validation flow

**Files:**
- `~/.spec-compiler/docs/generate-docs-agent.md` — responsibilities block, line 35
- `~/.spec-compiler/docs/project-template.md` — `## task.md (project-level)` → new `### rules` subsection, line 139

**Rule violated:** Task file must not contradict `build-order.md`; no ambiguous sequencing.

**Change:** Added rule: `task.md` sequencing rules must clearly distinguish build order from runtime validation flow. Arrow notation (`→`) in sequencing rules implies build sequence — forbidden for describing runtime data-flow validation paths. Validation flows must be labeled explicitly (e.g., "run end-to-end ingestion validation once components X, Y, Z are built per `build-order.md`").

---

## REFACTOR.md applied — 2026-04-28 (rag-platform, phase00-documentation)

**Source:** `~/.spec-compiler/REFACTOR.md` (principal AI/ML review of `docs/generated/`)
**Scope:** Surgical edits to `docs/generated/common.md` only. No other generated files touched; no regeneration performed.

### Files modified

#### `docs/generated/common.md`

| Line | Change |
|------|--------|
| 3 | Removed meta-commentary sentence from preamble. Retained only: `Shared typed contracts for \`rag-platform\`.` |
| 133 | `classification: str` → `classification: ClassificationLevel  # ClassificationLevel: see ## literals block above` in `ChunkPayload` |

### Files passing review (no changes required)

- `docs/generated/build-order.md` — PASS
- `docs/generated/agent.md` — PASS
- `docs/generated/task.md` — PASS
- `docs/generated/prompt-component-planning.md` — PASS

### Rules enforced

- `project-template.md` § common.md rules: "must not contain authoring instructions, agent directives, or meta-commentary"
- `generate-docs-agent.md` § contract centralization: all fields must use Pydantic v2 type annotations; canonical `Literal` types must not be loosened to bare `str`

---

## REFACTOR.md applied — 2026-04-28 (rag-platform, phase00-documentation) — second surgical pass

**Source:** `~/.spec-compiler/REFACTOR.md` (principal AI/ML engineer, same review pass)
**Scope:** Two remaining issues in `docs/generated/common.md` not addressed in the prior pass. No other generated files touched; no regeneration performed.

### Files modified

#### `docs/generated/common.md`

| Line | Change |
|------|--------|
| 117 | `classification: str` → `classification: ClassificationLiteral  # ClassificationLiteral: see ## literals block above; spec.md defines this as str — tightened here to canonical literal for consistency` in `ChunkPayload` |
| 230–234 | Removed entire `## rules` section (2 bullets: agent directive + meta-commentary) |

**spec.md verification (Issue 2):** `spec.md` line 445 explicitly types `ChunkPayload.classification` as `str`. Per REFACTOR.md instructions, the field was tightened to `ClassificationLiteral` with an inline comment documenting the deviation rather than silently accepting the wider type.

### Files passing review (no changes required)

- `docs/generated/build-order.md` — PASS
- `docs/generated/agent.md` — PASS
- `docs/generated/task.md` — PASS
- `docs/generated/prompt-component-planning.md` — PASS

### Rules enforced

- `project-template.md` § common.md rules: "must not contain authoring instructions, agent directives, or meta-commentary"
- `generate-docs-agent.md` § contract centralization: all fields must use Pydantic v2 annotations; each `Literal` type declared once; subsequent blocks reference via inline comment

---

## REFACTOR.md applied — 2026-04-29 (rag-platform, phase00-documentation)

**Source:** `~/.spec-compiler/REFACTOR.md` (generated 2026-04-29, principal AI/ML engineer review)
**Scope:** Source template fixes only. No files under `docs/generated/` were modified; regeneration is a separate pass.

---

### REFACTOR-01 — common.md preamble: one-liner shape made unambiguous (REGRESSION)

**Files:**
- `~/.spec-compiler/docs/project-template.md` — `## common.md` → `### rules`
- `~/.spec-compiler/docs/generate-docs-agent.md` — `### 5. contract centralization`

**Change:** Added explicit rule in both files stating the preamble must be exactly one sentence: `Shared typed contracts for \`<project-name>\`.` — no trailing sentences about excluded content, no pointers to other documents, no meta-commentary of any kind. Prior surgical pass (2026-04-28) fixed the output directly; the template did not encode the allowed shape, allowing regeneration to grow the preamble back.

---

### REFACTOR-02 — common.md Literal tightening: explicit rule with named example (SPIN)

**Files:**
- `~/.spec-compiler/docs/project-template.md` — `## common.md` → `### rules`
- `~/.spec-compiler/docs/generate-docs-agent.md` — `### 5. contract centralization`

**Change:** Added rule in both files: when a field's value set is fully covered by a canonical `Literal` alias in the `## literals` block, that alias must be used as the annotation — not `str` or any wider type — even when the spec types the field as `str`. Named `ChunkPayload.classification` as the canonical example with required inline comment format. Rule names the principle so it applies to all future fields, not only this one. Prior template wording did not address the case where the spec itself uses a wider type, leaving the generator free to follow the spec rather than tighten it.

---

### REFACTOR-03 — agent.md dependency rationale: required substitute pattern for phase labels (REGRESSION)

**Files:**
- `~/.spec-compiler/docs/generate-docs-agent.md` — `### 3. dependency-first design`
- `~/.spec-compiler/docs/project-template.md` — `## agent.md (project-level)` → `### includes`

**Change:** Extended the existing phase-label prohibition in both files with a required substitute pattern: when describing scope or current build scope, state the concrete reason using `build-order.md` component names (e.g., "only `FilesystemSourceConfig` is in scope per current `build-order.md`") — not a phase label. Also added explicit language to the `project-template.md` dependency ordering rationale bullet: "rationale must not use phase labels, milestone names, or release-stage language; describe only current concrete dependency facts." The prior rule prohibited phase labels but offered no substitute, leaving the generator to reach for phase language when expressing scope constraints.

---

## REFACTOR.md applied — 2026-04-30 (rag-platform, phase00-documentation) — second pass

**Source:** `~/.spec-compiler/REFACTOR.md` (generated 2026-04-30, principal AI/ML engineer review)
**Scope:** Source template fixes only. No files under `docs/generated/` were modified; regeneration is a separate pass.

---

### REFACTOR-01 — task.md: prohibit milestone language in scope descriptions (NEW)

**Files:**
- `~/.spec-compiler/docs/project-template.md` — `## task.md (project-level)` → `### rules` (+1 rule)
- `~/.spec-compiler/docs/generate-docs-agent.md` — `### 3. dependency-first design` (+1 bullet)

**Problem:** `docs/generated/task.md` line 33 used "Day 1" and "later work" as scope markers. The REFACTOR-03 rule (2026-04-29) required scope descriptions to use concrete `build-order.md` component names without phase or milestone language, but that rule was only added to the dependency rationale guidance for `agent.md` — it was never extended to `task.md`.

**Change:** Added rule to `project-template.md` `## task.md (project-level)` → `### rules`: scope descriptions must use `build-order.md` component names; phase labels, milestone names, release-stage language, and time-relative markers ("Day 1", "later work", "first pass") are forbidden substitutes. Added matching bullet to `generate-docs-agent.md` `### 3. dependency-first design` extending the scope-description rule to all project-level generated documents including `task.md`.

---

### REFACTOR-02 — agent.md: extend phase-label prohibition to purpose section (NEW)

**Files:**
- `~/.spec-compiler/docs/generate-docs-agent.md` — `### 3. dependency-first design` (+1 bullet)
- `~/.spec-compiler/docs/project-template.md` — `## agent.md (project-level)` → `### includes` (+1 bullet)

**Problem:** `docs/generated/agent.md` line 5 (purpose section) used "validated first" — a sequencing/phase marker. The existing rule in `generate-docs-agent.md` rule 3 targeted dependency rationale entries only; it did not explicitly cover the `## purpose` section.

**Change:** Added bullet to `generate-docs-agent.md` `### 3. dependency-first design` explicitly applying the scope-description rule to every section of `agent.md` including `## purpose`, and prohibiting phase-adjacent sequencing language ("validated first", "initial phase", "first pass") in any section. Added matching note to `project-template.md` `## agent.md (project-level)` → `### includes` stating the `## purpose` section must not use phase labels, milestone names, or sequencing markers.

---

## REFACTOR.md applied — 2026-04-30 (rag-platform, phase00-documentation)

**Source:** `~/.spec-compiler/REFACTOR.md` (generated 2026-04-30, principal AI/ML engineer review)
**Scope:** Source template fixes only. No files under `docs/generated/` were modified; regeneration is a separate pass.

---

### REFACTOR-01 — build-order.md: service-to-service runtime HTTP dependencies must be declared (NEW)

**Files:**
- `~/.spec-compiler/docs/project-template.md` — `## build-order.md` → `### requirements`
- `~/.spec-compiler/docs/generate-docs-agent.md` — `## responsibilities` build-order bullet; `### 3. dependency-first design`

**Problem:** `services/connector-filesystem` was ordered at position 10, before `services/mgmt-api` at position 12. Its dependency notes listed only library dependencies and described "mgmt-api service identity" but did not declare the actual `services/mgmt-api` runtime HTTP dependency. The spec and generated `task.md` both state that `connector-filesystem` calls `mgmt-api` over HTTP at startup and on scheduled runs to fetch `ConnectorConfig` records. The prior template rules required explicit dependency declarations for all rows and prohibited speculative clauses, but neither rule specifically addressed service-to-service runtime HTTP dependencies as ordering constraints — only lib dependencies were mentioned by example, leaving the generator free to list libs while omitting a service-to-service runtime call.

**Changes:**

`project-template.md` (`## build-order.md` → `### requirements`): Added rule — dependency notes must include service-to-service runtime dependencies; when the spec states a service calls another service over HTTP or a documented runtime protocol at startup or at runtime, the called service must either appear earlier in the build order with the dependency declared in the notes column, or the calling service's notes must explicitly state the dependency is intentionally deferred to a named later integration task; omitting a spec-documented service-to-service runtime dependency is not valid.

`generate-docs-agent.md` (`## responsibilities` build-order bullet): Appended clause — service-to-service runtime HTTP dependencies are ordering dependencies; the called service must appear before the calling service in `build-order.md` with the dependency declared in notes, or the notes must explicitly state the deferral with a named later integration point; omitting a spec-documented service-to-service dependency is not valid.

`generate-docs-agent.md` (`### 3. dependency-first design`): Added bullet — service-to-service runtime dependencies must be treated as first-class ordering constraints identical to lib-to-service dependencies; when the spec states a service calls another service over HTTP, the provider must appear before the consumer in `build-order.md` and be declared in the consumer's notes column; if implementation sequence genuinely demands building the consumer first, the consumer's notes must state the deferral explicitly with a named later integration point.

---

## REFACTOR.md applied — 2026-04-30 (rag-platform, phase00-documentation) — third pass

**Source:** `~/.spec-compiler/REFACTOR.md` (generated 2026-04-30, principal AI/ML engineer review)
**Scope:** Source template fixes only. No files under `docs/generated/` were modified; regeneration is a separate pass.

---

### REFACTOR-01 — common.md: `ConnectorRunModeFieldLiteral` declared but not referenced in any model field (NEW)

**Files:**
- `~/.spec-compiler/docs/project-template.md` — `## common.md` → `### rules` (+1 rule)
- `~/.spec-compiler/docs/generate-docs-agent.md` — `### 5. contract centralization` (+1 bullet)

**Problem:** `ConnectorRunModeFieldLiteral = Literal["cronjob", "daemon"]` appeared in the `## literals` block of `docs/generated/common.md` with no corresponding field annotation in any model and no inline comment documenting its consumer. No existing template rule required declared `Literal` types to be traceable to either a model field or a named consumer. The generator could add a `Literal` that satisfied the "declare once" rule while remaining entirely unused and undocumented.

**Change:** Added rule to both files: every `Literal` type declared in the `## literals` block must be traceable — either (a) it appears as a field annotation in the `## models` block with a referencing inline comment, or (b) the `## literals` entry itself carries an inline comment naming its consumer component. A declared `Literal` with no field reference and no documented consumer violates the minimality rule and must be removed.

---

### REFACTOR-02 — common.md: `AuditLogDestinationLiteral` declared but not referenced in any model field (NEW)

**Files:**
- `~/.spec-compiler/docs/project-template.md` — `## common.md` → `### rules` (same rule as REFACTOR-01)
- `~/.spec-compiler/docs/generate-docs-agent.md` — `### 5. contract centralization` (same bullet as REFACTOR-01)

**Problem:** `AuditLogDestinationLiteral = Literal["stdout", "file"]` appeared in the `## literals` block with no field annotation in `AuditRecordQuery` or any other model. Same root cause as Finding 1 — no rule required traceability for declared `Literal` types.

**Change:** Covered by the same rule added for REFACTOR-01. Both findings share a single template fix target; the rule was added once and covers all future undocumented `Literal` declarations.

---

## Source template fix — 2026-04-30 (project `task.md` consumption)

**Scope:** Source template fixes only. No files under `docs/generated/` were modified; regeneration is a separate pass.

### Issue — project-level `task.md` generated but not consumed

**Files:**
- `~/.spec-compiler/docs/project-template.md` — generated structure, component directory setup, `agent.md` includes, generated prompt templates, and task file format
- `~/.spec-compiler/docs/generate-docs-agent.md` — responsibilities, artifact/format enforcement, and component-planning setup

**Problem:** `docs/project-template.md` defines project-level `task.md` as the project-specific execution guide for sequencing rules, dependency handling notes, validation expectations, and task transitions. However, the generated workflow did not make that file part of the downstream context: `prompt-component-planning.md` did not read it, component directories did not symlink it, component task prompts did not read it, and generated task files did not list it in `## reads`.

**Change:** Added `task.md` as a shared component symlink, required generated `agent.md` to point planning and coding agents to `docs/generated/task.md`, added it to generated component-planning and component-task prompt read lists, added it to the generated task file `## reads` template, and added matching generator rules requiring component-planning prompts and task documents to consume project-specific execution guidance.
