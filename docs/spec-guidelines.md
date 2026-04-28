# spec guidelines

## purpose

This document defines how an AI agent takes a human-provided high-level spec and produces a valid, structured `docs/spec.md` that feeds into the spec compiler.

The human input is intentionally loose and inconsistent. This document tells the agent how to handle that.

---

## agent role

You are a spec generation agent.

You receive a human-written description of a system. It may be:
- prose paragraphs
- bullet points
- rough architecture notes
- a mix of all of the above
- incomplete, informal, or inconsistently structured

Your job is to expand it into a valid `docs/spec.md` that satisfies all required sections below.

You do not write code. You do not make implementation decisions beyond what is needed to make contracts explicit.

---

## input

The human spec lives at `docs/input-spec.md`.

It will not be well-structured. Treat it as a starting point, not a complete source of truth.

Rules:
- read it fully before generating anything
- extract all stated requirements, components, and behaviors
- do not invent requirements not implied by the input
- treat implementation hints as constraints, not architecture decisions

---

## output contract

Write exactly one file: `docs/spec.md`

- structured using the 10 required sections below, in order
- no code
- no implementation detail beyond interface-level contracts
- no placeholders, TBDs, or deferred items unless marked via the gap-handling protocol
- apply the gap-handling protocol for anything unresolvable

---

## execution steps

1. read `docs/spec-guidelines.md` (this file) fully
2. read `docs/input-spec.md` fully
3. identify all components, data flows, and constraints in the input
4. apply the gap-handling protocol to anything missing or unclear
5. populate all 10 required sections
6. run the self-validation checklist
7. write `docs/spec.md`

---

## required sections

A valid `docs/spec.md` must include all 10 of these sections.

---

### 1. project identity

Must include:
- name
- language/runtime
- deployment model
- constraints (scalability, statelessness, etc.)

**Derivation guide:** Extract the project name directly from the input. Infer language/runtime from any tech mentions; if not stated, use the most reasonable default for the described system and mark it as an assumption. Derive deployment model from context — "API" implies HTTP service, "worker" implies background process, "CLI" implies command-line tool.

---

### 2. architecture overview

Describe:
- major planes or layers (e.g. ingestion, serving, governance)
- responsibilities of each
- how they interact

Rules:
- no implementation detail
- no code-level decisions
- must be decomposable into services

**Derivation guide:** Identify the main data flows in the human spec. Group related responsibilities into layers. If the human describes an end-to-end flow, trace it and name the boundaries. When in doubt, fewer larger layers is better than many micro ones — tasks will break them down further.

---

### 3. components

List all major components.

For each component define:
- name
- type (lib or service)
- responsibility
- inputs
- outputs
- dependencies

Rules:
- components must be independently implementable
- no hidden coupling

**Derivation guide:** A lib is pure logic with no runtime boundary. A service has a runtime boundary (HTTP, queue, CLI). If the human mentions "a module that does X," treat it as a lib candidate. If they mention "an API" or "a worker," treat it as a service candidate. Every component must have inputs and outputs — if the human did not define them, derive them from the described behavior. If you cannot derive them, raise a gap.

---

### 4. data contracts

Define all core models and schemas.

Examples:
- document models
- API payloads
- queue messages
- database records

Rules:
- must be explicit
- must be stable
- must not rely on implicit structure

**Derivation guide:** Look for nouns in the human spec — things being created, stored, passed, or returned. Each significant noun is likely a model. Define its fields at the level of "what must be present," not implementation types. If the human describes a flow ("sends a message with X and Y"), extract the schema from that description.

---

### 5. workflows

Describe system flows as ordered steps.

Examples:
- ingestion pipeline
- query pipeline

Rules:
- must be sequential
- must identify boundaries between components
- must map to future tasks

**Derivation guide:** Find the main user-facing or system-level operations. For each, write the steps as a numbered sequence where each step names a component and what it does. If the human described a flow informally, formalize it here. Each workflow must be traceable end-to-end through the components in section 3.

---

### 6. invariants

Define non-negotiable rules.

Examples:
- security rules
- validation rules
- access control rules

Rules:
- must be enforceable in code
- must apply globally

**Derivation guide:** Look for words like "always," "never," "must," "required," "forbidden" in the human spec. Each one is an invariant candidate. If the human implies a rule without stating it (e.g., "users can only see their own data"), make it explicit here.

---

### 7. configuration

Define environment variables and flags.

Rules:
- no secrets
- all behavior must be configurable

**Derivation guide:** Identify anything that would differ between environments (dev/staging/prod): URLs, ports, timeouts, limits, feature toggles. If the human mentioned a specific value, treat it as the default, not a hardcoded constant.

---

### 8. external dependencies

List:
- databases
- queues
- APIs
- services

Rules:
- must define purpose
- must define access pattern
- must not leak into all components

**Derivation guide:** Every named third-party tool, database, or API is an external dependency. For each, state: what it stores or provides, how the system accesses it (read, write, subscribe), and which components touch it directly. No component should access an external dependency that is not explicitly listed here.

---

### 9. failure handling

Define:
- retry behavior
- error handling
- fallback behavior

Rules:
- must be deterministic
- must not be undefined

**Derivation guide:** If the human did not specify failure behavior, derive reasonable defaults from the system type (e.g., HTTP service → return structured error codes; queue worker → retry with exponential backoff). Mark any default as an explicit assumption. Every external call and data boundary must have a failure mode defined.

---

### 10. testing expectations

Define:
- unit testing requirements
- integration boundaries
- critical paths to validate

**Derivation guide:** Every component in section 3 needs unit test coverage stated. Integration boundaries are the edges between services. Critical paths are the workflows in section 5 — each one needs at least one stated validation scenario.

---

## gap-handling protocol

Human specs are incomplete by nature. Use this protocol when information is missing.

### resolvable gaps

If the gap can be filled with a reasonable assumption derived from context:
- make the assumption
- mark it explicitly inline: `[ASSUMED: <what was assumed and why>]`
- continue

### unresolvable gaps

If a required section cannot be populated without information the human did not provide and cannot be reasonably inferred:
- mark the gap inline: `[GAP: <what is missing and why it blocks this section>]`
- continue generating the rest of the spec
- do not stop unless the spec has so many gaps it cannot be decomposed into tasks

### blocking gaps

If the input is too thin to derive a component list, data contracts, or workflows — stop. Do not produce `docs/spec.md`.

Instead produce `docs/spec-blocked.md` containing:
- what was provided
- what is missing
- what the human must clarify before the agent can proceed

---

## self-validation checklist

Run this before writing `docs/spec.md`. All must pass.

- [ ] all 10 required sections are populated
- [ ] every component has a name, type, inputs, outputs, and dependencies
- [ ] every workflow maps end-to-end through named components
- [ ] every external dependency has a purpose and access pattern defined
- [ ] no `[GAP]` markers exist in sections 3, 4, or 5 (components, contracts, workflows)
- [ ] no bare TBD, placeholder, or deferred content
- [ ] all `[ASSUMED]` markers are clearly labeled
- [ ] spec can be turned into a `build-order.md` and component task list

If any check fails, apply the gap-handling protocol before proceeding.

---

## writing rules

### be explicit

bad:
> the system processes documents

good:
> the ingestion service reads documents from connectors, normalizes them into RawDocument, and publishes them to the ingestion queue

---

### avoid ambiguity

bad:
> handle errors gracefully

good:
> retry up to 3 times with exponential backoff, then send to dead-letter queue

---

### define boundaries

bad:
> the system queries the database

good:
> query-api calls qdrant via qdrant_client wrapper

---

### avoid mixing concerns

do not combine:
- ingestion logic
- query logic
- storage logic

each must be separate

---

## anti-patterns

do not:
- describe UI behavior unless required
- mix implementation with architecture
- leave unresolved `[GAP]` markers in sections 3, 4, or 5
- rely on implicit data structures
- define components without inputs/outputs
- create circular dependencies
- invent requirements not present or implied by the human input

---

## final rule

If `docs/spec.md` cannot be turned into:
- `build-order.md`
- component tasks

then the spec is invalid.

This document exists to ensure that never happens.
