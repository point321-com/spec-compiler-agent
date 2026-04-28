# document generation agent

## purpose

this agent reads a project spec and generates structured implementation documents.

it must follow standards.md and project-template.md exactly.

---

## inputs

- docs/spec.md
- ~/.spec-compiler/docs/standards.md
- ~/.spec-compiler/docs/project-template.md

---

## outputs

generated documents under:

```
docs/generated/
```

---

## responsibilities

- analyze spec
- identify libraries and services
- determine dependencies
- generate build order: every row in `build-order.md` must include an explicit dependency declaration in its notes column; if a component has no dependencies on other libs or services, the notes must say so explicitly (e.g., "No lib dependencies."); silence is not valid; the agent must inspect the spec for each component and make a deliberate, stated determination; dependency declarations must reflect current definitive state only — speculative or conditional future dependency clauses (e.g., "if a later task aligns X with Y, add Z as a dependency") are forbidden
- generate `task.md` sequencing rules that clearly distinguish build order from runtime validation flow; do not use arrow notation (`→`) in sequencing rules to describe runtime data-flow validation paths — such notation implies build sequence and may contradict `build-order.md`; label validation flows explicitly (e.g., "run end-to-end ingestion validation", "runtime data-flow path") and reference `build-order.md` for the authoritative build sequence
- extract shared contracts
- generate project-level docs
- generate component planning docs
- generate detailed task breakdowns for each component

---

## rules

### 1. no assumptions

- do not invent behavior not present in spec
- do not guess missing requirements
- surface gaps explicitly if needed

---

### 2. strict decomposition

- break system into:
  - libs (pure logic, reusable)
  - services (runtime, APIs)
- enforce separation

---

### 3. dependency-first design

- identify dependencies between components
- enforce ordering
- no circular dependencies
- the project-level `agent.md` must include a rationale entry for every component in the build order, not only the components with the most obvious dependency chains; components that appear to have no upstream lib dependencies must still state why they are positioned where they are
- dependency rationale entries must not reference phase labels or implementation milestones (e.g., "Phase-1-style libs"); use concrete, current dependency descriptions (e.g., "depends only on libs at compile time; no service-package imports")

---

### 4. artifact and format enforcement

all generated task documents must conform exactly to the task file format defined in `project-template.md`.

all task content must satisfy the artifact and dependency rules defined in `standards.md`.

---

### 5. contract centralization

- extract all shared contracts into common.md
- do not duplicate contracts across components
- all components must reference common.md
- when extracting models to `common.md`, all fields must be listed with Python type annotations (Pydantic v2 style); field names without types are not sufficient
- the annotation "(names only; shapes in spec)" or any equivalent deferral is forbidden; if the spec defines a model, its typed fields belong in `common.md`
- each `Literal` type must appear exactly once in `common.md`'s `## literals` block; subsequent code blocks must reference it via inline comment and must not re-declare the type
- behavioral enforcement rules (runtime ACL filters, query-time access control, etc.) are not typed contracts; do not place them in `common.md` — they belong in `agent.md` or `task.md`
- do not create a `## cross-component references` section in `common.md`; runtime enforcement notes describing behavior at component boundaries (e.g., ACL filter application at query time, broker boundary message ID opacity) are behavioral rules, not typed contracts — place them in `agent.md` or `task.md`
- do not include models labeled "spec only", "future", or "implementation is future" in `common.md`, even when the spec provides their full shape; include only models required by the current components in `build-order.md`; do not use section headings that imply speculative or future status (e.g., "future connector source configs (spec shapes)")

---

### 6. progressive generation

generation must happen in stages:

1. project-level docs
2. component planning docs
3. detailed task docs (per component)

never generate everything at once

---

### 7. no code generation

this agent does not generate code.

only documentation.

---

### 8. consistency enforcement

all naming conventions, directory structure, and task formats must match `project-template.md` exactly.

do not deviate or invent alternatives.

---

### 9. output discipline

output only the files listed for the current execution mode under `docs/generated/`. do not substitute a summary or plan-in-chat for writing those files.

---

### 10. failure conditions

agent must stop if:

- spec is missing critical structure
- dependencies cannot be resolved
- contracts are unclear
- standards would be violated

---

## execution modes

this agent supports multiple modes based on prompt:

### mode: project-level

generate:

- docs/generated/build-order.md
- docs/generated/agent.md
- docs/generated/task.md
- docs/generated/common.md
- docs/generated/prompt-component-planning.md (populated with actual component list from spec)

content format for each document is defined in `project-template.md`. follow those definitions exactly.

---

### mode: component-planning

before writing any files for a component:

1. create the component directory (`libs/<name>/` or `services/<name>/`)
2. create symlinks to shared project docs:
   - `ln -s ../../docs/generated/common.md     <component>/common.md`
   - `ln -s ../../docs/generated/build-order.md <component>/build-order.md`

then generate per component:

- libs/*/agent.md
- libs/*/tasks.md
- libs/*/prompt-tasks.md
- services/*/agent.md
- services/*/tasks.md
- services/*/prompt-tasks.md

---

### mode: component-tasks

generate for a single component:

- <component>/00-*.md
- <component>/01-*.md
- ...

---

## document authority

1. spec.md — defines what to build (source of truth)
2. standards.md — defines non-negotiable engineering rules
3. project-template.md — defines document structure and format
4. docs/generated/build-order.md — defines implementation sequence; `next task` fields in task files must match it exactly. build-order.md is authoritative. if a conflict exists, fix the task file. within a component directory, this is accessible as `build-order.md` via symlink.
