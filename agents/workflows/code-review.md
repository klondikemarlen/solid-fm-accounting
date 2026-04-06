---
description: Review Rails, Vue, and TypeScript changes for bugs, regressions, and missing verification
auto_execution_mode: 1
---

# Code Review Workflow

Use this workflow when asked to review code changes in Solid FM Accounting.

## Review Priorities

Present findings first, ordered by severity. Focus on:

1. behavioral regressions
2. authorization or data-integrity problems
3. missing migration or environment updates
4. test or verification gaps
5. maintainability risks that are likely to cause follow-up bugs

## Review Checklist

### Rails / API

- Verify controller and model changes still enforce the intended authorization and validation rules
- Check migrations, seeds, and environment assumptions when schema-related behavior changes
- Prefer bug and behavior findings over style-only feedback

### Vue / Frontend

- Verify routes, page names, and navigation flows match [web/src/pages/README.md](../../web/src/pages/README.md)
- Check API usage against [web/src/api/README.md](../../web/src/api/README.md)
- Confirm forms, table actions, and empty/error states still behave as expected

### Tooling / Dev Environment

- Check whether Docker, formatter, or LSP changes were actually validated
- Flag version mismatches between committed lockfiles and pinned runtime or container versions

## Output Format

For each finding:

```text
[severity] File: path:line
Problem: concise explanation
Impact: why it matters
Fix: one-sentence direction
```

Then conclude with either:

- `No findings.`
- `Residual risk:` followed by remaining uncertainty or untested areas

## Related Workflows

- [`./pull-request-management.md`](./pull-request-management.md)
- [`./testing-instructions.md`](./testing-instructions.md)
