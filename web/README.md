# Web

This directory contains the Vue 3 + TypeScript + Vuetify front-end for Solid FM Accounting.

## Development

The normal way to run the web app in development is from the repo root through `./bin/dev`.

```bash
./bin/dev up web
```

Useful commands:

- Start the full app stack: `./bin/dev up`
- Run web tests: `./bin/dev test web`
- Run web commands in the container: `./bin/dev web <command>`

## Current Starter Surface

The current front-end is intentionally small and provides a starter shell around authentication and a
few example pages:

- dashboard
- profile
- notifications
- status
- sign-in / unauthorized / not-found flows

These pages are enough to exercise layout, routing, authenticated API access, and basic user-facing
navigation without introducing a large feature surface yet.

## Code Standards

- Prefer established components and composables plus the smallest clear implementation; do not add
  speculative abstractions, compatibility layers, or dependencies.

- Use TypeScript for new code. Prefer `type` to `interface`; do not use `any`, `@ts-ignore`,
  `@ts-expect-error`, or non-null assertions. Model absent values explicitly and narrow them with
  guards.
- Name variables and functions for their domain behavior. Avoid abbreviations and unexplained magic
  values; use named constants when a value carries business meaning.
- Keep routeable components in `src/pages/`, name them `*Page.vue`, and follow the URL-shaped
  directory and route-name convention in [`src/pages/README.md`](src/pages/README.md).
- Keep HTTP calls and API-shape mapping in `src/api/`; use composables in `src/use/` for reusable
  reactive state and page components for composition.
- Use Vuetify components, props, and slots for accessible controls and component appearance. Use
  UnoCSS utilities only for layout, spacing, sizing, and small presentation changes; do not override
  Vuetify internals with utility classes.
- Keep imports grouped as Node built-ins, external packages, then `@/` imports, with blank lines
  between groups. Let the existing ESLint and Prettier configuration format source.
- Test user-visible behavior and API error states. Run focused checks through `./bin/dev test web`,
  `./bin/dev web npm run check-types`, or `./bin/dev web npm run build` as appropriate.
