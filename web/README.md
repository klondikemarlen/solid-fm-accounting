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
