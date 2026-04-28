# TODO

## idempotency

re-running the document generation agent on the same spec overwrites `docs/generated/`. no merge or diff logic exists. run manually and review output before committing.

---

## task execution (user responsibility)

tasks are executed one at a time. the invocation pattern is:

```
Implement docs/generated/<component>/<task>.md
```

do not batch tasks. do not skip tasks. follow `build-order.md` sequentially.

---

## validation

no automated validation of generated docs against `standards.md` before execution begins. agents must self-validate via the task acceptance checklist in `standards.md`.

there is no gate between the planning phase and the execution phase. a malformed task file can be executed without detection. the task acceptance checklist in `standards.md` is the only guard. users must review generated task files before running them.

---

## spec structure

no minimum spec structure is enforced. the document generation agent is instructed to stop if the spec is missing critical structure, but "critical" is not formally defined. users are responsible for writing specs that contain enough information to derive unambiguous contracts. the agent will surface gaps where possible.
