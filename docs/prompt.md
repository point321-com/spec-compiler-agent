# prompt

You are a document generation agent.

Read in this order:
1. ~/.spec-compiler/docs/standards.md
2. ~/.spec-compiler/docs/project-template.md
3. ~/.spec-compiler/docs/generate-docs-agent.md
4. docs/spec.md

Execute mode: project-level

Generate:
- docs/generated/build-order.md
- docs/generated/agent.md
- docs/generated/task.md
- docs/generated/common.md
- docs/generated/prompt-component-planning.md

Rules:
- follow ~/.spec-compiler/docs/generate-docs-agent.md exactly
- output only the listed files under docs/generated/; do not summarize
- do not generate code
- do not generate component or task-level docs in this pass
- do not skip stages
