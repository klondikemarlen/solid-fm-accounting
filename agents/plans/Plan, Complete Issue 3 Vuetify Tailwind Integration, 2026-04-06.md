# Plan: Complete Issue 3 Vuetify Tailwind Integration

## Problem Statement

Issue #3 asks for Tailwind CSS integration in the `web/` app using the Vuetify 4 Tailwind guidance,
especially the CSS layer ordering pattern. The current front-end has Vuetify installed, but no
Tailwind setup, no shared stylesheet entrypoint for layered CSS imports, and no documentation for
how Vuetify styles and utility classes should coexist.

## Current State Analysis

**Current Implementation:**
- `web/` uses Vue 3 + Vite + Vuetify.
- `web/src/plugins/vuetify-plugin.ts` imports `modern-normalize` and `vuetify/styles` directly.
- There is no Tailwind dependency or Vite integration in `web/package.json` or `web/vite.config.js`.
- There is no central app stylesheet in `web/src/` that can establish CSS cascade layer order.

**Constraint Identified During Review:**
- The repo currently uses Vuetify 3, not Vuetify 4.
- The issue itself already acknowledges ambiguity between "prepare for Vuetify 4 + Tailwind" and
  "upgrade fully to Vuetify 4 as part of this work."

## Key Findings

1. The lowest-risk way to complete the issue is to implement Tailwind using the Vuetify CSS layer
   ordering pattern now, while leaving a full Vuetify major-version upgrade to separate work.
2. The core implementation requirement is not a component rewrite, but a stylesheet and build-pipeline
   change that gives Tailwind utilities predictable precedence over Vuetify where intended.
3. A tiny proof-of-integration example is enough to validate the setup and make the intended usage
   pattern concrete for future front-end work.

## Recommended Solution(s)

### Option 1: Add Tailwind v4 To The Existing Vuetify App Using Layered CSS (Recommended)

**Rationale:** This resolves the practical CSS integration problem raised in issue #3 without
coupling it to a broad and potentially disruptive Vuetify major upgrade.

**Implementation:**
- Add Tailwind v4 dependencies to `web/package.json`.
- Register the Tailwind Vite plugin in `web/vite.config.js`.
- Create a shared stylesheet in `web/src/styles/` that establishes cascade layer order and imports
  both Tailwind and Vuetify styles.
- Move Vuetify style importing out of the plugin file and into the layered stylesheet.
- Remove redundant normalization imports if Tailwind preflight supersedes them cleanly.
- Add one small proof-of-integration UI example using both Vuetify components and Tailwind utility
  classes.
- Update `web/README.md` to document the intended styling rules of engagement.

**Benefits:**
- Delivers the Tailwind integration requested by the issue.
- Keeps the change bounded and easier to review.
- Documents a clear styling strategy for future work.

### Option 2: Combine Tailwind Integration With A Full Vuetify 4 Upgrade

**Rationale:** This aligns literally with the issue title, but it is a substantially broader change.

**Implementation:**
- Upgrade Vuetify and any related tooling to the relevant Vuetify 4-compatible versions.
- Then add Tailwind integration on top.

**Benefits:**
- Collapses two potentially related migrations into one issue.

**Risks:**
- Much larger regression surface.
- Harder to review and verify.
- More likely to block the Tailwind goal behind unrelated framework migration work.

## Decision Factors

1. The repo currently runs on Vuetify 3 and already has working pages/components.
2. The user asked specifically for the Vuetify 4 CSS-layer guidance, not necessarily a forced
   framework-major upgrade in the same patch.
3. Issue #3 already leaves room to clarify whether the work is "prepare for" versus "fully upgrade."

## Recommended Action

Implement Tailwind v4 in the existing app using the Vuetify CSS layer ordering model, document that
strategy, and close issue #3 with a note that the integration pattern is now in place while a full
Vuetify major upgrade can remain separate if desired.

## Files To Review

1. `web/package.json` - Add Tailwind dependencies.
2. `web/vite.config.js` - Register the Tailwind Vite plugin.
3. `web/src/main.ts` - Import the shared app stylesheet.
4. `web/src/plugins/vuetify-plugin.ts` - Remove direct style imports if they move to the new CSS entrypoint.
5. `web/src/pages/StatusPage.vue` - Good candidate for a small proof-of-integration example.
6. `web/README.md` - Document how Tailwind and Vuetify should be used together.
7. `https://github.com/klondikemarlen/solid-fm-accounting/issues/3` - Close with implementation summary after verification.

## Related Issues

- https://github.com/klondikemarlen/solid-fm-accounting/issues/3
