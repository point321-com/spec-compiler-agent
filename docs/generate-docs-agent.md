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
- generate build order
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

---

### 4. artifact and format enforcement

all generated task documents must conform exactly to the task file format defined in `project-template.md`.

all task content must satisfy the artifact and dependency rules defined in `standards.md`.

---

### 5. contract centralization

- extract all shared contracts into common.md
- do not duplicate contracts across components
- all components must reference common.md

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
