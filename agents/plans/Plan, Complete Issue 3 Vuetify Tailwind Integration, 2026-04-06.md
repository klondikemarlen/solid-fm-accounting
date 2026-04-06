# Plan: Complete Issue 3 Vuetify Tailwind Integration

## Problem Statement

Issue #3 asks for Tailwind-style utility support in the `web/` app using the Vuetify 4 guidance,
especially the CSS layer ordering pattern. During implementation review, the better fit turned out to
be Vuetify's UnoCSS `presetWind4` guidance rather than a direct `tailwindcss` package install. The
front-end started with Vuetify installed, but no UnoCSS or Tailwind-style utility setup, no shared
stylesheet entrypoint for layered CSS imports, and no documentation for how Vuetify styles and
utility classes should coexist.

## Current State Analysis

**Current Implementation:**
- `web/` uses Vue 3 + Vite + Vuetify.
- `web/src/plugins/vuetify-plugin.ts` imports `modern-normalize` and `vuetify/styles` directly.
- There is no utility-CSS dependency or Vite integration in `web/package.json` or
  `web/vite.config.js`.
- There is no central app stylesheet in `web/src/` that can establish CSS cascade layer order.

**Constraints Identified During Review:**
- The repo currently uses Vuetify 3, not Vuetify 4.
- The issue itself already acknowledges ambiguity between "prepare for Vuetify 4 + Tailwind" and
  "upgrade fully to Vuetify 4 as part of this work."
- The more doc-faithful shape is a dedicated `src/styles/layers.css` file imported at the top of the
  Vuetify plugin before `vuetify/styles`, with UnoCSS emitted to named CSS cascade layers.

## Key Findings

1. The lowest-risk way to complete the issue is to implement UnoCSS `presetWind4` using the Vuetify
   CSS layer ordering pattern now, while leaving a full Vuetify major-version upgrade to separate
   work.
2. The core implementation requirement is not a component rewrite, but a stylesheet and build-pipeline
   change that gives Tailwind utilities predictable precedence over Vuetify where intended.
3. A tiny proof-of-integration example is enough to validate the setup and make the intended usage
   pattern concrete for future front-end work.
4. The correct setup shape is: UnoCSS plugin + `uno.config.ts` + a dedicated `layers.css` file
   imported from the Vuetify plugin before `vuetify/styles`, with UnoCSS emitted to named CSS
   cascade layers and consumed through `uno.css`.
5. The remaining work is now documentation and issue closeout, not core build setup.

## Recommended Solution(s)

### Option 1: Add UnoCSS `presetWind4` To The Existing Vuetify App Using Layered CSS (Recommended)

**Rationale:** This resolves the practical CSS integration problem raised in issue #3 without
coupling it to a broad and potentially disruptive Vuetify major upgrade.

**Implementation:**
- Add UnoCSS and `@unocss/preset-wind4` dependencies to `web/package.json`.
- Register the UnoCSS Vite plugin in `web/vite.config.js`.
- Create `web/uno.config.ts` with `presetWind4()` and CSS layer output configured for Vuetify-aware
  layer ordering.
- Create `web/src/styles/layers.css` that establishes cascade layer order using the Vuetify docs'
  naming pattern.
- Import `layers.css` at the top of `web/src/plugins/vuetify-plugin.ts`, before `vuetify/styles`.
- Import `uno.css` from the Vuetify plugin so UnoCSS output participates in the declared layers.
- Remove redundant normalization imports if UnoCSS preflights supersede them cleanly.
- Add one small proof-of-integration UI example using both Vuetify components and utility classes.
- Update `web/README.md` to document the intended styling rules of engagement.
- Close issue #3 with a summary that explains the repo now follows the Vuetify-recommended
  `presetWind4` route for Tailwind-style utilities.

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

Implement UnoCSS `presetWind4` in the existing app using the Vuetify CSS layer ordering model,
document that strategy, and close issue #3 with a note that the Tailwind-style integration pattern
is now in place while a full Vuetify major upgrade can remain separate if desired.

## Files To Review

1. `web/package.json` - Add UnoCSS dependencies and remove redundant style deps.
2. `web/vite.config.js` - Register the UnoCSS Vite plugin.
3. `web/uno.config.ts` - Define `presetWind4()` and CSS layer mapping.
4. `web/src/styles/layers.css` - Declare the layer order from the Vuetify docs.
5. `web/src/plugins/vuetify-plugin.ts` - Import `layers.css`, `vuetify/styles`, and `uno.css` in the correct order.
6. `web/src/pages/StatusPage.vue` - Proof-of-integration example.
7. `web/README.md` - Document how utility classes and Vuetify should be used together.
8. `https://github.com/klondikemarlen/solid-fm-accounting/issues/3` - Close with implementation summary after verification.

## Related Issues

- https://github.com/klondikemarlen/solid-fm-accounting/issues/3
