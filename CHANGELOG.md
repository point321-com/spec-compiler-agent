# CHANGELOG

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
