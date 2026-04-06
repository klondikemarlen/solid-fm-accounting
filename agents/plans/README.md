# Plans

This directory contains implementation planning documents for the Solid FM Accounting project.

## Available Plans

See this directory for available plans. Plans are created as needed for complex implementation work
and follow the naming convention: `Type, Title, Date.md`.

## Using Plans

Plans are created when implementation requires analysis, staged rollout thinking, multiple options,
or cross-cutting decisions.

Example:

```text
Create a plan for improving transaction import validation and save it to agents/plans/
```

See parent [agents/README.md](../README.md) for general AI workflow documentation.

Do not overwrite this README when creating a new plan unless the request is specifically about
updating plan-directory documentation.

## Plan Structure

All plans should generally follow this shape:

```markdown
# Plan: [Descriptive Title]

## Problem Statement
[Clear description of the problem or opportunity]

## Current State Analysis
**Current Implementation:**
- [Current state bullets]

## Key Findings
1. [Finding 1]
2. [Finding 2]

## Recommended Solution(s)

### Option 1: [Option Name] (Recommended)
**Rationale:** [Why this is preferred]
**Implementation:**
- [Steps]
**Benefits:**
- [Benefits]

## Decision Factors
1. [Factor 1]
2. [Factor 2]

## Recommended Action
[Specific recommendation with next steps]

## Files To Review
1. `path/to/file1` - [What to check]

## Related Issues
- [Issue links]
```

## File Naming Convention

**Format:** `Type, Title, Date.md`

Examples:

- `Plan, Uncommitted Work Review And Commit Grouping, 2026-04-06.md`
- `Infrastructure, API Development Container User Mapping, 2026-04-06.md`

Rules:

- Use commas to separate the three components
- Use ISO dates (`YYYY-MM-DD`)
- Prefer descriptive titles over abbreviations
- Use `Plan` when the work does not fit a narrower category
- Prefer creating a new dated file over reusing an older plan unless it is truly the same plan
