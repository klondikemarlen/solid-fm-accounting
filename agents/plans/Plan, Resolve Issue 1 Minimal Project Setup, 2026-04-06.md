# Plan: Resolve Issue 1 Minimal Project Setup

## Problem Statement

GitHub issue #1 asks for a minimal project setup with a Rails back-end and Vue front-end running in
Docker, based loosely on the earlier Traditional Knowledge project structure. The repo now appears
to satisfy most of that scope in practice, but the issue is not cleanly closeable because some
documentation no longer matches the actual development workflow, and the "minimal front-end"
expectation has not been explicitly revalidated against the current app shape.

## Current State Analysis

**Current Implementation:**
- The API is a Rails app under `api/`.
- The front-end is a Vue 3 + TypeScript + Vuetify app under `web/`.
- Local development runs through Docker Compose via `./bin/dev`.
- Recent setup work tightened development ergonomics around container user mapping, formatting, and
  stale Rails PID cleanup.

**Known Gaps:**
- `README.md` still contains outdated setup guidance, including placeholder `.env.development`
  instructions and command examples that conflict with current `./bin/dev` guidance.
- `README.md` appears to overstate startup behavior around automatic database bootstrapping.
- The issue wording about "strip down front-end to minimal examples" may or may not still match the
  intended scope of the current front-end.

## Key Findings

1. The core technical objective of issue #1 appears substantially complete.
2. The biggest blocker to closing the issue is documentation accuracy, not missing infrastructure.
3. The front-end may already be minimal enough for current project goals, but that should be
   explicitly evaluated rather than assumed.

## Recommended Solution(s)

### Option 1: Close The Gap With A Small Cleanup Pass (Recommended)

**Rationale:** Most of the issue has already been implemented. A focused cleanup pass is lower risk
and more appropriate than reopening large setup work that is probably no longer needed.

**Implementation:**
- Audit `README.md` against the actual `./bin/dev`, Docker Compose, and Rails startup behavior.
- Replace stale setup instructions with current, tested commands.
- Remove or rewrite outdated claims about `.env.development`, local host installs, and automatic
  boot pipeline behavior.
- Review the current front-end routes and pages to decide whether they still fit the issue's
  "minimal examples" goal.
- If the current front-end is acceptable, document that as the resolved interpretation of the issue.
- If it is not acceptable, split the remaining front-end slimming work into a follow-up issue.
- Add a short issue-resolution summary before closing the GitHub issue.

**Benefits:**
- Preserves already-completed setup work.
- Aligns onboarding docs with the real developer workflow.
- Avoids keeping the issue open purely because of wording drift.
- Creates a clearer boundary between "project setup is done" and later feature work.

### Option 2: Re-scope The Issue Into Infrastructure And Front-End Simplification

**Rationale:** If the current front-end is still considered too featureful, the original issue may
be carrying two different kinds of work.

**Implementation:**
- Close issue #1 as complete for Docker + Rails + Vue project scaffolding.
- Open a follow-up issue specifically for further front-end minimization or starter-page cleanup.

**Benefits:**
- Prevents the infrastructure issue from staying open indefinitely.
- Keeps remaining work focused and easier to estimate.

## Decision Factors

1. Whether the current front-end is considered "minimal enough" for the original issue intent.
2. Whether `README.md` can be brought in line with current behavior in one small pass.
3. Whether the team wants issue #1 to represent initial scaffolding only, or also later cleanup of
   example pages and app wiring.

## Recommended Action

Do a small issue-closure pass now:

1. Update `README.md` to reflect the current Docker-first `./bin/dev` workflow.
2. Verify and correct any claims about database bootstrap behavior.
3. Review the current front-end against the issue's "minimal examples" wording.
4. If the front-end is acceptable, close issue #1 with a summary of what shipped.
5. If not, open a narrower follow-up issue and close issue #1 as the infrastructure milestone.

## Files To Review

1. `README.md` - Main setup and onboarding instructions that currently appear stale in places.
2. `AGENTS.md` - Current repo-level guidance that already reflects the preferred dev workflow.
3. `bin/dev` - Source of truth for the Docker development helper behavior.
4. `docker-compose.development.yml` - Source of truth for service startup and local containers.
5. `api/README.md` - API-specific docs that may need to stay aligned with the top-level README.
6. `web/README.md` - Front-end docs to compare against the "minimal examples" intent.
7. `web/src/routes.ts` - Quick indicator of how broad the current front-end surface area is.
8. `web/src/pages/` - Current page inventory to evaluate whether follow-up slimming work is needed.

## Related Issues

- https://github.com/klondikemarlen/solid-fm-accounting/issues/1
