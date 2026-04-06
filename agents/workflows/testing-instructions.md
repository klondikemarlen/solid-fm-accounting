---
description: Generate comprehensive testing instructions for pull requests
auto_execution_mode: 1
---

# Testing Instructions Workflow

This workflow guides you through creating comprehensive, accurate testing instructions for a pull
request.

## Intent

**WHY this workflow exists:** Pull requests need clear, actionable testing instructions that
reviewers can follow to validate changes. Without proper testing instructions, PR validation
becomes inconsistent and error-prone.

**WHAT this workflow produces:**

- comprehensive testing instructions with exact UI element names
- sequential test cases covering happy paths, edge cases, and error conditions
- navigation paths and verification steps for each test scenario

**Decision Rules:**

- **Always verify UI element names:** Never guess button names, tab names, or labels. Search the
  Vue code
- **Use exact formatting:** Follow the established bold formatting and sequential numbering pattern
- **Cover the real user flow:** Include creation, editing, saving, return paths, refresh behavior,
  or direct URL entry when relevant
- **Start with the standard setup:** Begin every section with the standard app boot and login steps

## Process

### Step 1: Understand the Change

Read the PR description and diff to understand:

- what feature or bug is being addressed
- what specific functionality changed
- what edge cases need testing
- any concerns or reviewer questions already raised

### Step 2: Verify Real UI Labels

Never guess UI labels. Search the Vue code.

```bash
rg -n "v-btn|label=|title=" web/src -g "*.vue"
rg -n "v-tab|tabs" web/src -g "*.vue"
rg -n "router|to=" web/src -g "*.vue" -g "*.ts"
```

Use [web/src/pages/README.md](../../web/src/pages/README.md) and
[web/src/api/README.md](../../web/src/api/README.md) when the route or API shape matters.

### Step 3: Structure Test Cases

Break testing into logical scenarios:

- **Test Case 1:** Main happy path
- **Test Case 2:** Important variations or edits
- **Test Case 3:** Error handling or blocked states

### Step 4: Use the Standard Format

```markdown
# Testing Instructions

1. Run the relevant test suite via `./bin/dev test api` or `./bin/dev test web`
2. Boot the app via `./bin/dev up`
3. Log in to the app at http://localhost:8080

## Test Case 1: [Descriptive scenario name]

4. From the main app Dashboard, [first action]
5. Click **[Exact Button Name]**
6. Fill in [form details]
7. Verify [expected outcome]
```

### Step 5: Formatting Rules

1. Bold all UI elements: `**Save**`, `**Transactions**`, `**Back**`
2. Continue numbering across all test cases
3. Use navigation arrows for menu flows: `**Dashboard** → **Transactions**`
4. Use explicit verification language: `Verify that...`
5. Use backticks for exact URLs, field values, IDs, and error messages

## Related Workflows

- [`./pull-request-management.md`](./pull-request-management.md)
- [`./github-issue-creation.md`](./github-issue-creation.md)
