# AI Agents & Workflows

This directory contains AI workflows, templates, and planning documents for Solid FM Accounting.

## Important

Directory READMEs under `agents/` are primarily discovery documents.

Agents should use these READMEs to discover relevant workflow, template, or plan files, then read
the underlying files directly. The individual files are the source of truth for task-specific
instructions.

## Directory Structure

```text
agents/
├── README.md
├── templates/
│   ├── README.md
│   └── *.md
├── workflows/
│   ├── README.md
│   └── *.md
└── plans/
    ├── README.md
    └── *.md
```

## Workflows

Workflows are AI-readable documents that guide coding assistants through complex, multi-step tasks.
They typically include step-by-step instructions, implementation checklists, examples, and testing
guidance.

Use [workflows/README.md](./workflows/README.md) to discover the right workflow, then read the
actual workflow file before acting.

## Plans

Plans are implementation documents that outline the steps to implement a feature, fix, or larger
refactor. They are useful for efforts that need problem framing, staged rollout notes, multiple
options, or open questions captured in one place.

Use [plans/README.md](./plans/README.md) for naming and structure guidance before creating a new
plan.

## Templates

Templates are reusable starting points for recurring documentation or code-shape tasks.

Use [templates/README.md](./templates/README.md) to discover the available templates, then read the
actual template file before using it.

## Best Practices

1. Keep `agents/workflows/*.md` as the source of truth for workflow behavior.
2. Treat directory READMEs as indexes, not full task instructions.
3. Use descriptive names for workflows and plans.
4. Update `agents/workflows/README.md` when adding a workflow.
5. Create new dated plan files instead of overwriting older implementation plans.
6. Update `agents/templates/README.md` when adding a reusable template.
