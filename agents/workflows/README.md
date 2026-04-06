# Workflows

This directory contains reusable AI workflows for Solid FM Accounting.

## Important

This file is an index, not the source of truth for workflow behavior.

Agents should use this README to discover relevant workflow files, then read the actual `*.md`
workflow files directly before acting. Do not rely on the summaries in this file alone for
implementation details, constraints, or required steps.

## Available Workflows

| Workflow | Description |
| --- | --- |
| [code-review.md](./code-review.md) | Review Rails, Vue, and TypeScript changes for bugs, regressions, and missing verification |
| [create-pipeline-view.md](./create-pipeline-view.md) | Create a documentation-only projection view of a real end-to-end workflow or system path |
| [github-issue-creation.md](./github-issue-creation.md) | Create well-structured GitHub issues using the local issue templates |
| [pull-request-management.md](./pull-request-management.md) | Create and update pull requests following this repo's PR template and conventions |
| [testing-instructions.md](./testing-instructions.md) | Generate reviewer-friendly testing steps with exact UI labels and navigation |

For pull request tasks, agents should usually use `pull-request-management.md` together with
`testing-instructions.md`. When the task starts with issue framing or bug intake, agents should
also use `github-issue-creation.md`.

## Using Workflows

After identifying a relevant workflow here, read that workflow file end-to-end and follow the
workflow file itself as the authoritative instruction set.

Example:

```text
Follow the workflow in agents/workflows/pull-request-management.md
to create a PR for my changes.
```

Example:

```text
Follow the workflow in agents/workflows/testing-instructions.md
to create testing instructions for this PR.
```

Example:

```text
Follow the workflow in agents/workflows/github-issue-creation.md
to create a GitHub issue for this bug.
```

Example:

```text
Follow the workflow in agents/workflows/create-pipeline-view.md
to document the invoice import flow as a projection view.
```
