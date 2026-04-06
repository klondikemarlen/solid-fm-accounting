---
description: Create a documentation-only projection view of a real end-to-end workflow or system path
auto_execution_mode: 1
---

# Create Pipeline View Workflow

## Intent

**WHY this workflow exists:** Some flows are hard to understand because their behavior is spread
across controllers, concerns, models, integrations, front-end triggers, and framework wiring. A
pipeline view provides one readable document that projects the end-to-end path without pretending to
be executable source code.

**WHAT this workflow produces:** A documentation-only projection view that:

- explains the flow in one place
- links back to the real source files
- separates narrative sections from code-shaped excerpts
- makes architectural review, onboarding, and future refactoring easier

**Decision Rules:**

- **Documentation only:** A pipeline view is explanatory documentation, not executable code
- **Point back to reality:** Always list the real implementation files near the top
- **One flow per document:** Keep each projection focused on one end-to-end pipeline
- **Use structured sections:** Narrative and code-shaped sections should be clearly separated
- **Prefer `agents/templates/pipeline-view.md`:** Start from the shared template instead of
  improvising a format each time
- **Do not create fake tooling promises:** Unless real generator/sync tooling exists, describe the
  document as manually maintained documentation

## When To Use This

Use a pipeline view when:

- a feature spans multiple files and layers
- the team needs a readable architectural walkthrough
- a refactor or bug investigation would benefit from one end-to-end map
- onboarding or review keeps stumbling over the same cross-file flow

Do **not** use a pipeline view when:

- a short README note would be enough
- the flow is still too speculative to document accurately
- the document would duplicate one already-maintained architectural guide

## Recommended Location

Prefer storing pipeline views near the implementation they describe. Examples:

- `api/lib/pipeline_views/...`
- `web/src/.../README.md`
- `agents/plans/...` when the document is temporary design analysis rather than stable reference

If the concept is being captured for future reuse rather than immediate code-adjacent docs, keep it
as a template or workflow under `agents/`.

## Process

### 1. Identify the Real Flow

List the actual source files involved. For example:

- controller or route entry point
- authentication/authorization concerns
- service or model code
- integration client
- front-end trigger or API caller

### 2. Decide the Section Structure

A good projection view usually includes:

1. title and short purpose statement
2. pointer to the real implementation files
3. high-level narrative of the flow
4. code-shaped excerpts for important stages
5. controller or route wiring overview
6. optional integration or output summary

### 3. Use the Shared Template

Start from [`agents/templates/pipeline-view.md`](../templates/pipeline-view.md).

Replace placeholders with:

- the actual flow name
- real file paths
- real section ids
- short, accurate excerpts or pseudocode grounded in the real code

### 4. Keep It Honest

- prefer short excerpts over full file copies
- do not invent helpers or abstractions that do not exist
- if behavior is inferred, say so clearly
- if a document is incomplete, note the missing sections instead of bluffing

### 5. Review for Drift Risk

Before committing the document, ask:

- is this valuable enough to maintain?
- is the listed file set accurate?
- are the most drift-prone sections narrow and easy to update?

If the answer is no, keep the concept in `agents/templates/` instead of adding a code-adjacent doc.

## Related Files

- [`../templates/pipeline-view.md`](../templates/pipeline-view.md)
- [`../plans/README.md`](../plans/README.md)
