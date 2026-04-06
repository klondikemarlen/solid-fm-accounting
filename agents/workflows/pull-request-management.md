---
description: Create and edit well-structured pull requests following Solid FM Accounting conventions
auto_execution_mode: 1
---

# Pull Request Management Workflow

## Intent

**WHY this workflow exists:** Pull requests communicate intent to reviewers and future maintainers.
A well-structured PR explains the problem, the solution approach, and how to verify correctness.
This reduces review friction and creates useful documentation.

**WHAT this workflow produces:** A draft PR with:

- a clear title
- a concise `# Context` section that explains why the change is needed
- a purpose-focused `# Implementation` section
- a `# Testing Instructions` section generated or refreshed using the testing workflow

**Decision Rules:**

- **Use the local PR template:** Follow [`.github/pull_request_template.md`](../../.github/pull_request_template.md)
- **Issue linkage wording:** Use `Fixes <issue-url>` only when the PR should close the linked issue.
  Use `Part of <issue-url>` when the PR is one slice of larger work
- **Context section:** Explain why the change is needed, not just what changed
- **Implementation section:** Focus on purpose and intent, not file-by-file summaries
- **Screenshots:** If frontend files changed, write `TODO` and let a human add screenshots later.
  Only use `N/A - backend changes only` when there are truly no UI changes
- **Draft mode:** Create PRs as drafts first
- **Testing instructions are paired:** Use `testing-instructions.md` alongside this workflow

## Quick Reference

```bash
cat <<'EOF' | gh api repos/{owner}/{repo}/pulls -X POST \
  -F title="Title here" \
  -F head="branch-name" \
  -F base="main" \
  -F draft=true \
  -F body=@-
Fixes <issue-url>

Relates to:

- <related-pr-or-issue-url>

# Context

<problem explanation>

# Implementation

1. <change purpose>

# Screenshots

TODO

# Testing Instructions

<paste output from agents/workflows/testing-instructions.md>
EOF
```

## Process

### 1. Gather Context

Before creating or updating a PR:

```bash
git status
git log main..HEAD --oneline
git diff main...HEAD
git branch -vv
```

### 2. Determine the Title

Use one of these patterns:

| Pattern | When to Use | Example |
| --- | --- | --- |
| `Issue-<number>: Description` | Linked to a GitHub issue | `Issue-98: Switch Test Suite From Jest to Vitest` |
| `Fix: Description` | Bug fix without issue number | `Fix: Auth0 Audience Request for API Login` |
| `Action Verb + Noun` | Feature or refactor | `Add API Development Container User Mapping` |

Guidelines:

- Use title case
- Be specific but concise
- Only use ticket/issue prefixes when they refer to a real external tracker entity

### 3. Fill in the PR Template

Follow this structure:

```markdown
Fixes <issue-url>

Relates to:

- <related-pr-or-issue-url>

# Context

<why this change is needed>

# Implementation

1. <purpose-focused summary>
2. <purpose-focused summary>

# Screenshots

TODO

# Testing Instructions

<testing instructions output>
```

### 4. Section Guidance

#### Context

- Explain the problem or motivation first
- Include user reports or bug reports as blockquotes when helpful
- For bugs, include steps to reproduce when they clarify the problem

#### Implementation

- Use a numbered list
- Focus on purpose, not filenames
- Keep it concise

Good example:

```markdown
1. Move Ruby formatting to Ruby LSP and Syntax Tree.
2. Limit Prettier configuration to standalone SQL files.
3. Update developer documentation to match the new tooling split.
```

Bad example:

```markdown
1. Edit .vscode/settings.json
2. Edit .prettierrc.yaml
3. Edit README.md
```

#### Screenshots

Before writing this section, check whether the diff includes frontend files:

```bash
git diff main...HEAD --name-only | rg '^web/src/(components|pages)/'
```

- If frontend files changed, write `TODO`
- If no frontend files changed, write `N/A - backend changes only`

## Related Workflows

- [`./testing-instructions.md`](./testing-instructions.md)
- [`./github-issue-creation.md`](./github-issue-creation.md)
- [`./code-review.md`](./code-review.md)
