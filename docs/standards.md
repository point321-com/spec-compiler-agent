# engineering standards

## purpose

This document defines non-negotiable engineering rules for all projects using this template. These rules are reusable across any spec and must be enforced by all agents.

---

## core principles

- every unit of work must produce a real, testable artifact
- no implicit behavior — everything must be explicit and observable
- interfaces first, implementation second
- strict separation of concerns across libs and services
- no hidden coupling between components
- all behavior must be validated with tests

---

## repository structure

code is always written to:

```
ROOT/libs/<lib-name>/
ROOT/services/<service-name>/
```

documentation is always written to:

```
docs/generated/...
```


no code is written under `docs/`

---

## artifact rule (hard requirement)

every task must produce a concrete artifact.

an artifact is one of:

- function
- class
- protocol / interface
- module
- service endpoint
- adapter
- cli command

### artifact requirements

every artifact must:

- have a clear public interface
- contain all logic for the task inside it
- not depend on future tasks
- be directly importable or callable
- be testable in isolation

### invalid tasks

a task is invalid if it only:

- creates folders
- creates empty files
- adds TODOs
- adds placeholders without logic
- defers implementation to future tasks

---

## dependency enforcement (hard requirement)

every task must explicitly declare dependencies.

### required sections in every task

**reads**
- list of required documents
- list of required previous tasks

**writes**
- exact files created or modified

no implicit dependencies are allowed.

### cross-component import rule

a component may only import from another lib if that dependency is explicitly declared in `build-order.md` for that component. importing from a lib not listed as a dependency in `build-order.md` is forbidden.

since agents are invoked from the project root, the import path to a declared dependency lib is:

```
libs/<lib-name>/src/
```

this path must be used consistently in implementation notes, task files, and any generated configuration (e.g., `pyproject.toml` path dependencies). a component with no declared lib dependencies must not import from any lib under `libs/`.

---

## testing rules

### unit tests (mandatory)

- every artifact must have unit tests
- no external dependencies
- all I/O must be mocked
- must validate:
  - interface
  - behavior
  - edge cases

### functional tests (early requirement)

- must be implemented as soon as a runnable boundary exists
- should validate real interaction between components
- should not be delayed until "later phases"

---

## interface and contract rules

- all interfaces must be explicit and typed
- no dynamic or loosely defined structures
- inputs and outputs must be validated
- contracts must not change silently

---

## implementation rules

- no business logic in glue code
- no logic in tests
- no global state unless explicitly required
- no direct external client usage outside abstraction layers
- no hardcoded secrets or environment values

---

## task acceptance checklist

before executing any task, the agent must verify:

- [ ] all files listed in `reads` exist and have been read
- [ ] the task defines a concrete artifact (not a scaffold, stub, or TODO)
- [ ] `writes` lists full paths from the project root (e.g., `<component>/src/module.py`, `<component>/tests/unit/test_module.py`)
- [ ] unit tests are defined in the task
- [ ] `definition of done` criteria are all achievable

if any check fails, stop and produce a `<task-name>-blocked.md` (see below).

---

## task lifecycle

### completed — `<task-name>-done.md`

every completed task must produce a done file.

**done file must include:**

- summary of implementation
- files created or modified
- tests added
- assumptions or deviations
- instructions for next task

---

### blocked — `<task-name>-blocked.md`

if a task cannot be completed, the agent must stop and produce a blocked file. do not attempt partial implementation.

**blocked file must include:**

- which acceptance check failed
- what is missing or unclear
- what must be resolved before the task can proceed
- no code or partial artifacts

execution halts. the user resolves the block, then re-runs the task.

---

### refactor — `<task-name>-refactor-<nn>.md`

when changes or fixes are needed to a completed task, the user manually creates a refactor file (e.g. `01-auth-refactor-00.md`).

**refactor file must include:**

- reference to the original task
- description of what must change and why
- exact files to modify
- tests to update or add

on completion, the agent appends a `## changelog` section to the existing `<task-name>-done.md` with:

- refactor file name
- summary of changes made
- files modified
- date

---

## prompt execution rule

the only valid way to run an agent is:

```
Implement ~/.spec-compiler/docs/prompt.md
```


no manual instructions.

---

## failure conditions

agents must refuse to proceed if:

- required dependencies are missing
- task does not define an artifact
- contracts are unclear
- standards are violated

---

## enforcement priority

1. security and correctness
2. contract integrity
3. testability
4. performance
5. convenience

