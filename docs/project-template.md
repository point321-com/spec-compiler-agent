# project template

## purpose

This document defines how to transform a spec into structured implementation documents.

it is reusable across all projects.

---

## generated structure

project-level docs (shared, read-only by components):

```
docs/generated/
├── build-order.md
├── agent.md
├── task.md
├── common.md
└── prompt-component-planning.md
```

component docs and source live together:

```
libs/
└── <lib-name>/
    ├── agent.md
    ├── tasks.md
    ├── prompt-tasks.md
    ├── 00-<task-name>.md
    ├── <task-name>-done.md
    ├── common.md          → symlink: ../../docs/generated/common.md
    └── build-order.md     → symlink: ../../docs/generated/build-order.md
services/
└── <service-name>/
    ├── agent.md
    ├── tasks.md
    ├── prompt-tasks.md
    ├── 00-<task-name>.md
    ├── <task-name>-done.md
    ├── common.md          → symlink: ../../docs/generated/common.md
    └── build-order.md     → symlink: ../../docs/generated/build-order.md
```

---

## component directory setup

when creating a new component directory (`libs/<name>/` or `services/<name>/`), the agent must:

1. create the directory
2. create the following symlinks before writing any component files:

```
ln -s ../../docs/generated/common.md     libs/<name>/common.md
ln -s ../../docs/generated/build-order.md libs/<name>/build-order.md
```

for services:

```
ln -s ../../docs/generated/common.md     services/<name>/common.md
ln -s ../../docs/generated/build-order.md services/<name>/build-order.md
```

this ensures the agent operating inside the component directory can read shared contracts without leaving its working scope.

---

## build-order.md

defines global implementation order.

### requirements

- libraries before services
- dependency-driven ordering only
- no parallel ambiguity
- explicit sequence
- every row must carry an explicit dependency declaration; "no lib dependencies" is a valid and required declaration when true
- preamble must contain only the global sequence ordering statement; do not include scope constraints, phase validation notes, or any spec prose beyond sequencing intent
- dependency notes must declare current definitive state only; speculative or conditional future dependency clauses are forbidden
- dependency notes must include service-to-service runtime dependencies; when the spec states that a service calls another service over HTTP or a documented runtime protocol (e.g., at startup or on a scheduled run), the called service must either appear earlier in the build order with that dependency declared in the notes column, or the calling service's notes must explicitly state the dependency is intentionally deferred to a named later integration task; omitting a spec-documented service-to-service runtime dependency is not valid

---

## common.md

defines shared contracts across the system.

### includes

- shared models: full typed field listings (Pydantic v2 annotations); not names-only references to the spec
- interfaces
- protocols
- cross-component rules

### rules

- must be minimal and precise
- do not copy spec requirements prose; extract only implementation-relevant contracts
- only implementation-relevant contracts
- must not contain authoring instructions, agent directives, or meta-commentary; those belong in `agent.md` or `task.md`
- must not restate repository structure, naming conventions, or engineering rules already defined in `standards.md`; reference `standards.md` by name if needed, do not copy its content
- each `Literal` type must be declared exactly once, in the `## literals` block; all other code blocks must reference the canonical definition with an inline comment (e.g., `# ClassificationLiteral: see ## literals block above`) and must not re-declare the type
- behavioral enforcement rules (e.g., runtime ACL filter requirements, query-time access control) are not typed contracts; they belong in `agent.md` or `task.md`; do not include them in `common.md`
- must not contain a `## cross-component references` section; runtime enforcement notes at component boundaries are behavioral rules, not typed contracts — place them in `agent.md` or `task.md`
- must not include models labeled "spec only", "future", or "implementation is future" in the spec; include only models required by the current components in `build-order.md`; section headings must not imply speculative or future status
- preamble must consist of exactly one sentence identifying the project: `Shared typed contracts for \`<project-name>\`.` — no trailing sentences about excluded content, no pointers to other documents, no meta-commentary of any kind
- any field whose value set is fully covered by a canonical `Literal` alias from the `## literals` block must use that alias as its annotation; a wider type such as `str` is not permitted even when the source spec uses it; document the tightening with an inline comment (e.g., `# ClassificationLiteral: tightened from str — see ## literals block above`)

---

## agent.md (project-level)

a project-specific distillation generated from the spec. tells subsequent agents how to operate in the context of this specific project.

### includes

- identified libraries and services with their roles
- dependency ordering rationale: **every library and service in the build order must have an explicit rationale entry** — not just the primary chains; explain why each component is positioned where it is relative to its neighbors; rationale must not use phase labels, milestone names, or release-stage language; describe only current concrete dependency facts
- the `## purpose` section must not use phase labels, milestone names, or sequencing markers to describe build scope; state scope concretely using `build-order.md` component names
- project-specific constraints or deviations from general standards
- component breakdown and boundaries

---

## task.md (project-level)

a project-specific execution guide for coding agents generated from the spec.

### includes

- sequencing rules specific to this project
- dependency handling notes
- validation expectations for this project's stack
- how to transition between tasks

### rules

- sequencing rules must clearly distinguish build order from runtime validation flows; do not use arrow notation (`→`) in sequencing rules to describe runtime data-flow or test validation paths — such notation implies build sequence and may contradict `build-order.md`; label validation flows explicitly (e.g., "run end-to-end validation once components X, Y, Z are built per `build-order.md`")
- scope descriptions in `task.md` must state the concrete reason using `build-order.md` component names (e.g., "only `FilesystemSourceConfig` is in scope per current `build-order.md`"); do not use phase labels, milestone names, release-stage language, or time-relative markers (e.g., "Day 1", "later work", "first pass") as substitutes for a concrete scope statement

---

## component agent.md

defines responsibilities for a specific lib or service.

### includes

- scope boundaries
- inputs and outputs
- dependencies
- what the component must not do

---

## component tasks.md

defines ordered tasks for the component.

### rules

- strictly sequential
- each task must produce an artifact
- each task must be independently testable
- no cross-component work

---

## generated prompt format: component-planning

the project-level agent must generate `docs/generated/prompt-component-planning.md` using this template, with the actual component list populated from the spec.

~~~markdown
# prompt

You are a document generation agent.

Read in this order:
1. ~/.spec-compiler/docs/standards.md
2. ~/.spec-compiler/docs/project-template.md
3. ~/.spec-compiler/docs/generate-docs-agent.md
4. docs/generated/build-order.md
5. docs/generated/common.md
6. docs/generated/agent.md

Execute mode: component-planning

Generate:
- libs/<lib-name>/agent.md
- libs/<lib-name>/tasks.md
- libs/<lib-name>/prompt-tasks.md
- services/<service-name>/agent.md
- services/<service-name>/tasks.md
- services/<service-name>/prompt-tasks.md

Rules:
- follow ~/.spec-compiler/docs/generate-docs-agent.md exactly
- before writing any component files, create the component directory and symlink shared docs (see project-template.md: component directory setup)
- output only the listed files under libs/ or services/; do not summarize
- do not generate code
- do not generate task-level docs in this pass
- one component per pass if context is constrained
~~~

---

## generated prompt format: component-tasks

the component-planning agent must generate one `docs/generated/<component>/prompt-tasks.md` per component using this template, with the component path and task list populated from that component's tasks.md.

~~~markdown
# prompt

You are a document generation agent.

Read in this order:
1. ~/.spec-compiler/docs/standards.md
2. ~/.spec-compiler/docs/project-template.md
3. ~/.spec-compiler/docs/generate-docs-agent.md
4. <component>/common.md
5. <component>/agent.md
6. <component>/tasks.md

Execute mode: component-tasks
Component: <component>

Generate:
- <component>/00-<task-name>.md
- <component>/01-<task-name>.md
- ...

Rules:
- follow ~/.spec-compiler/docs/generate-docs-agent.md exactly
- output only the listed files under <component>/; do not summarize
- do not generate code
- one component only
- follow tasks.md order exactly
~~~

---

## task file format

every task file must follow this exact structure. no sections may be omitted.

~~~markdown
# <task-name>

## purpose

<one paragraph: what is being built and why>

## reads

- common.md
- build-order.md
- agent.md
- <prior-task>-done.md

## writes

- ROOT/libs/<lib-name>/src/<module>.py
- ROOT/libs/<lib-name>/tests/unit/test_<module>.py

## artifact

### <ArtifactName>

**interface:**
<public interface, types, signatures>

**behavior:**
<what it does>

**boundaries:**
<what it must not do>

## implementation notes

<specific implementation guidance, patterns, constraints>

## tests

### unit tests

- <test case 1>
- <test case 2>

### functional tests

- <test case>

## definition of done

- [ ] artifact implemented and directly importable or callable
- [ ] all unit tests pass with no external dependencies
- [ ] no TODOs, placeholders, or deferred logic
- [ ] writes section matches actual files created
- [ ] <task-name>-done.md produced

## next task

`docs/generated/<component>/<next-task>.md`
~~~

### rules

- every section is mandatory
- `reads` must list every doc and prior task the agent needs — no implicit context
- `writes` must list exact file paths under `ROOT/libs/` or `ROOT/services/` only
- `artifact` must define a concrete, testable unit — not a folder, stub, or TODO
- `functional tests` section is required unless no runnable boundary exists; state the reason if omitted
- `definition of done` checkboxes must all be satisfiable before the task is considered complete

---

## done file format

every completed task must produce a done file matching this exact structure.

~~~markdown
# <task-name> done

## summary

<what was implemented>

## files

- <created or modified file path>

## tests

<what was tested>

## notes

<assumptions or deviations from the task spec>

## next steps

<instructions for the next task>
~~~

---

## naming conventions

- all files lowercase hyphenated except numbered tasks
- tasks use numeric prefixes:
  - 00-bootstrap.md
  - 01-<name>.md
- done files:
  - 00-bootstrap-done.md

---

## constraints

- no code generation during planning phases
- no skipping of task levels
- no merging of tasks
- no large tasks

---

## output expectations

the system must produce:

- deterministic structure
- minimal ambiguity
- strict contracts
- execution-ready tasks
