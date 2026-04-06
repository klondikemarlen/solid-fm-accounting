---
description: Create well-structured GitHub issues using the local issue templates
auto_execution_mode: 1
---

# GitHub Issue Creation Workflow

## Intent

**WHY this workflow exists:** Creating effective GitHub issues requires consistent structure, clear
problem descriptions, and actionable requirements. Poorly written issues lead to confusion, scope
creep, and implementation delays.

**WHAT this workflow produces:** Well-structured GitHub issues that include:

- clear problem descriptions or feature requests
- reproduction steps or implementation requirements
- issue labels and linked context
- screenshots or mockups when relevant

**Decision Rules:**

- **Use existing templates:** Always start from the repo's issue templates under
  [`.github/ISSUE_TEMPLATE/`](../../.github/ISSUE_TEMPLATE/)
- **Bug reports:** Use `bug_report.md`
- **Feature requests:** Use `feature_request.md`
- **Refactors or internal improvements:** Usually use the feature template unless the work is
  clearly a bug

## Reference Files

- [`.github/ISSUE_TEMPLATE/bug_report.md`](../../.github/ISSUE_TEMPLATE/bug_report.md)
- [`.github/ISSUE_TEMPLATE/feature_request.md`](../../.github/ISSUE_TEMPLATE/feature_request.md)

## Process

### 1. Choose the Template

- Bugs and regressions: `bug_report.md`
- Features, improvements, or refactors: `feature_request.md`

### 2. Fill Out the Template Thoughtfully

For bugs:

- describe the bug clearly
- include exact reproduction steps
- include expected behavior
- include screenshots or console errors when relevant

For feature requests:

- explain the problem or user need first
- describe the proposed solution
- note alternatives considered if they matter

### 3. Add Helpful Context

- Link related issues or PRs
- Include screenshots, wireframes, or docs when they help
- Distinguish clearly between confirmed facts and hypotheses

### 4. Create the Issue

Preferred: use the GitHub web UI so the built-in templates render cleanly.

CLI option:

```bash
gh issue create --repo {owner}/{repo} --title "Title here" --body-file /tmp/issue-body.md
```

## Related Workflows

- [`./pull-request-management.md`](./pull-request-management.md)
