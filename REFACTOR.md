# REFACTOR — docs/generated review findings

Generated: 2026-04-28
Project: rag-platform
Branch: phase00-documentation

---

## Issue 1 — common.md: behavioral prose in `## cross-component references`

**File:** `docs/generated/common.md` (lines 294–298)

**What is wrong:**
The `## cross-component references` section contains behavioral enforcement prose:
- "values are constrained to `ClassificationLiteral` at ingest and query time"
- "Queue and HTTP boundaries must use the models above; message IDs remain opaque strings end-to-end per `docs/spec.md`"

These are runtime enforcement rules, not typed contracts. `project-template.md` and `generate-docs-agent.md` both state explicitly: "behavioral enforcement rules (e.g., runtime ACL filter requirements, query-time access control) are not typed contracts; they belong in `agent.md` or `task.md`; do not include them in `common.md`."

**What to do:**
1. Remove the entire `## cross-component references` section from `docs/generated/common.md`.
2. Move the behavioral notes into `docs/generated/agent.md` under `## Project constraints (from spec)` or a new `## Cross-component enforcement` subsection.
3. The factual note that `ChunkPayload.classification` is typed as `str` (not `ClassificationLiteral`) is already self-evident from the model definition in `## chunk payload (qdrant)` and needs no cross-reference prose.

---

## Issue 2 — common.md: speculative section `## future connector source configs (spec shapes)`

**File:** `docs/generated/common.md` (lines 96–111)

**What is wrong:**
The section header "future connector source configs (spec shapes)" is meta-commentary about implementation phase and spec origin. The rules forbid speculative or future-state content in `common.md`. Additionally:
- `generate-docs-agent.md` rule 1 states: "do not invent behavior not present in spec"
- `project-template.md` states `common.md` "must be minimal and precise" and "only implementation-relevant contracts"
- The section label implies these models are not yet needed, making them speculative

**What to do:**
1. Inspect `docs/spec.md` to determine whether `SharepointSourceConfig` and `GDriveSourceConfig` have fully typed shapes defined there.
2. If yes (fully spec-defined): rename the section to `## sharepoint source configuration` and `## gdrive source configuration` respectively, drop "future" and "(spec shapes)" from all headings, and present them as current contracts alongside `FilesystemSourceConfig`.
3. If no (shapes not fully defined in spec): remove `SharepointSourceConfig` and `GDriveSourceConfig` entirely from `common.md`. Do not include contracts that are speculative or incomplete.

---

## Issue 3 — agent.md: "Phase-1-style libs" is spec prose / undefined phase reference

**File:** `docs/generated/agent.md` (line 63, rationale entry #9)

**What is wrong:**
The rationale for `services/embedding-api` reads: "First service: needed as HTTP upstream for ingestion's embed step; depends only on **Phase-1-style libs**."

"Phase-1-style libs" is undefined terminology — no phases are defined in the generated documents. `generate-docs-agent.md` requires dependency declarations to "reflect current definitive state only" and forbids "speculative or conditional future dependency clauses." Phase references import implicit scope constraints not grounded in the build-order.

**What to do:**
Replace "Phase-1-style libs" with the concrete current state. The correct phrasing is: "depends only on libs (no service-level imports at compile time)." The revised rationale should read:

> **services/embedding-api** — First service built; `ingestion-api` calls it over HTTP for the `/embed` step. Depends only on libs at compile time; no service-package imports.

---

## Issue 4 — task.md: Day 1 path arrow notation implies wrong build order

**File:** `docs/generated/task.md` (line 11, Sequencing rule #3)

**What is wrong:**
Rule #3 reads: "**Day 1 path:** Implement and test `connector-filesystem` → queue → `ingestion-api` with `embedding-api` available so end-to-end ingestion is proven before expanding connectors."

The arrow notation `connector-filesystem → queue → ingestion-api` reads as an implementation sequence. This directly contradicts `build-order.md`, where `libs/queue` is position #6 and `services/connector-filesystem` is position #11. An agent reading this rule could misinterpret it as: build connector-filesystem before queue.

`task.md` rule #5 itself states: "If `build-order.md` and a task file disagree on 'next task,' fix the task file to match `build-order.md`." This rule violates its own guidance.

The intent is to describe the **runtime data-flow validation path** (what to exercise end-to-end once all components are built), not the build sequence.

**What to do:**
Rewrite Sequencing rule #3 to make the distinction between build order and validation flow explicit. Suggested replacement:

> 3. **Day 1 validation path:** Once `libs/queue`, `services/embedding-api`, `services/connector-filesystem`, and `services/ingestion-api` are built in `build-order.md` sequence, run end-to-end ingestion validation: connector-filesystem publishes to queue → ingestion-api consumes and embeds via embedding-api → Qdrant upsert confirmed. This proves the ingestion pipeline before additional connector types are added.

---

## Summary table

| # | File | Rule violated | Action |
|---|------|--------------|--------|
| 1 | `docs/generated/common.md` | Behavioral enforcement prose in `common.md` | Remove `## cross-component references`; move notes to `agent.md` |
| 2 | `docs/generated/common.md` | No speculative/future contracts; must be minimal and precise | Rename sections (if spec-defined) or remove `SharepointSourceConfig` / `GDriveSourceConfig` |
| 3 | `docs/generated/agent.md` | Dependency declarations must be current definitive state only; no phase references | Replace "Phase-1-style libs" with concrete lib dependency statement |
| 4 | `docs/generated/task.md` | Task file must not contradict `build-order.md`; no ambiguous sequencing | Rewrite Day 1 path rule to distinguish build order from runtime validation flow |

---

## Files confirmed valid

- **`docs/generated/build-order.md`** — Correct lib-before-service sequence, no circular deps, explicit dependency declaration on every row, no speculative clauses, preamble is a plain sequencing statement only. PASS.
- **`docs/generated/prompt-component-planning.md`** — Correct format per `project-template.md`, all 14 component placeholder names populated with actual component paths, read order correct, all rules present. PASS.
