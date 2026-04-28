# README

## overview

This repository defines a reusable **agent-driven project generation system**.

It converts a single `spec.md` into a fully structured, step-by-step implementation plan that coding agents can execute deterministically.

The system is designed to:
- eliminate ambiguity
- enforce consistency
- break large systems into small, testable units
- prevent agent drift

---

## how it works

There are **two phases**:

### 1. planning (documentation generation)

A document agent reads:
- `spec.md`
- `standards.md`
- `project-template.md`

It generates structured implementation docs under:

```
docs/generated/
```

These include:
- build order
- shared contracts
- per-component plans
- step-by-step task files

---

### 2. execution (code generation)

A coding agent executes tasks one at a time:

```
Implement docs/generated/.../<task>.md
```

Each task:
- produces a real artifact (function, class, module, etc.)
- includes strict dependencies (`reads`)
- writes only to:
  - `ROOT/libs/*`
  - `ROOT/services/*`
- must include tests
- produces a `<task>-done.md`

---

## core files

### `standards.md`

Defines non-negotiable engineering rules:
- every task must produce a testable artifact
- strict dependency declaration
- unit + early functional testing required
- no scaffolding-only work

---

### `project-template.md`

Defines the structure of generated documents:
- directory layout
- task format
- naming conventions
- build sequencing rules

---

### `generate-docs-agent.md`

Defines how an agent:
- reads the spec
- decomposes the system
- extracts contracts
- generates tasks in stages

This is the **brain of the system**.

---

### `prompt.md`

Entry point for agents.

The only valid invocation pattern is:

```
Implement ~/.spec-compiler/docs/prompt.md
```

This ensures:
- consistent execution
- no manual instructions
- full reproducibility

---

## key rules

### 1. artifact-driven development

Every task must produce a usable, testable artifact.

No placeholders. No empty scaffolding.

---

### 2. hard dependency enforcement

Every task explicitly declares:

```
reads
writes
```

No hidden context.

---

### 3. progressive refinement

The system avoids context overload by generating in stages:
1. project-level docs
2. component plans
3. detailed tasks
4. implementation

---

### 4. strict boundaries

- libs = reusable logic
- services = runtime systems
- no cross-boundary leakage

---

## why this exists

Coding agents fail when:
- tasks are too large
- context is too broad
- dependencies are implicit

This system fixes that by:
- forcing small, sequential work
- making dependencies explicit
- turning architecture into executable steps

---

## intended usage

1. symlink this repo: `ln -s /path/to/spec-compiler-agent ~/.spec-compiler`
2. in your project, write `docs/spec.md` (or run `Implement ~/.spec-compiler/docs/prompt-spec.md` to generate it from `docs/input-spec.md`)
3. from your project root, run:

```
Implement ~/.spec-compiler/docs/prompt.md
```

4. follow generated prompts step-by-step
5. execute tasks one at a time

---

## for agents (important)

- do not skip steps
- do not infer missing dependencies
- do not generate code during planning phases
- reject invalid tasks (no artifact, unclear contract)
- always follow `standards.md` first

---

this system is a **compiler from spec → tasks → code**.

---

## known limitations

see [TODO.md](TODO.md) for outstanding issues and planned improvements.
