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

## Styling

The web app now uses Vuetify plus UnoCSS `presetWind4` for Tailwind-style utility classes.

- The UnoCSS setup lives in `web/uno.config.ts`.
- CSS cascade layer order is declared in `web/src/styles/layers.css`.
- `web/src/plugins/vuetify-plugin.ts` loads `layers.css` before `vuetify/styles`, then imports
  `uno.css`.

Preferred usage:

- Use Vuetify components for app structure, accessible widgets, and component-level styling.
- Use UnoCSS utility classes for layout, spacing, sizing, and lightweight one-off presentation.
- Avoid fighting component internals with utility classes when a Vuetify prop or slot is the better
  fit.

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
