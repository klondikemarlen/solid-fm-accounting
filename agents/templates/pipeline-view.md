# Pipeline View Template

Use this template to document a real end-to-end workflow as a projection view. This template is for
documentation only.

## Suggested File Name

Use a descriptive name near the implementation, for example:

- `api/lib/pipeline_views/user_login_pipeline_view.md`
- `api/lib/pipeline_views/invoice_import_pipeline_view.md`

Optional companion metadata/spec files can live beside the view:

- `api/lib/pipeline_views/user_login_pipeline_view.yml`

## Template

````markdown
# [Flow Name] Pipeline (Projection View)

This file is a **projection view** of the end-to-end [flow name] pipeline.
It is documentation-only.

The real implementation lives in:

- `path/to/file1`
- `path/to/file2`
- `path/to/file3`

---

<!-- [BEGIN SECTION intro_and_overview] -->
## High-level narrative

1. [Describe the entry point.]
2. [Describe the next major step.]
3. [Describe the key transformation or validation.]
4. [Describe the final output or side effect.]
<!-- [END SECTION intro_and_overview] -->

---

<!-- [BEGIN SECTION key_stage_one] -->
## [Key stage one]

```ruby
# Prefer short, accurate excerpts or pseudocode grounded in the real code.
```
<!-- [END SECTION key_stage_one] -->

---

<!-- [BEGIN SECTION key_stage_two] -->
## [Key stage two]

```ruby
# Another excerpt or explanatory snippet.
```
<!-- [END SECTION key_stage_two] -->

---

<!-- [BEGIN SECTION wiring_overview] -->
## Wiring overview

Explain how the main files or framework entry points connect.
<!-- [END SECTION wiring_overview] -->
````

## Optional Companion Spec Shape

If you want a structured companion file for section metadata, use a shape like:

```yaml
version: 1

viewFile: path/to/pipeline_view.md

sections:
  - id: intro_and_overview
    kind: narrative_commentary
    source:
      mode: literal_in_view
    viewMarkers:
      begin: "<!-- [BEGIN SECTION intro_and_overview] -->"
      end: "<!-- [END SECTION intro_and_overview] -->"
    editableInView: true
```

Only create a companion spec when it adds real value. Do not imply that tooling exists unless it
actually exists in the repo.

## Guidelines

1. Keep one major flow per document.
2. Link to the real implementation files at the top.
3. Prefer small excerpts over large copied blocks.
4. Make it clear when a section is explanatory rather than literal.
5. If the document is experimental, keep it under `agents/` until the pattern stabilizes.
