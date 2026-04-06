# Solid FM Accounting

Solid FM Accounting is a full-stack bookkeeping application. The API is Ruby on Rails, the web app
is Vue 3 + TypeScript + Vuetify, and local development runs primarily through Docker Compose via
[`./bin/dev`](./bin/dev).

This file follows the spirit of <https://agents.md/> for AI agent documentation.

## Documentation Philosophy

Keep `AGENTS.md` focused on repo-wide conventions and high-level workflow guidance. Shard detailed
guidance throughout the codebase so it lives near the code it governs. When guidance becomes
specific to an architectural area, move it into a nearby `README.md` or `agents/` document and link
to it from here instead of letting top-level documentation become a dumping ground.

Useful local documentation:

- [README.md](README.md)
- [api/README.md](api/README.md)
- [bin/README.md](bin/README.md)
- [web/README.md](web/README.md)
- [web/src/api/README.md](web/src/api/README.md)
- [web/src/pages/README.md](web/src/pages/README.md)
- [agents/README.md](agents/README.md)
- [agents/plans/README.md](agents/plans/README.md)
- [agents/templates/README.md](agents/templates/README.md)
- [agents/workflows/README.md](agents/workflows/README.md)

## AI Workflows

The [`agents/workflows/`](agents/workflows/) directory contains reusable AI workflow documents for
common tasks such as:

- pull request writing and updating
- reviewer-facing testing instructions
- GitHub issue creation
- code review

When asked to create or update a pull request, agents should normally use both the pull request
management workflow and the testing instructions workflow together. When the work begins with issue
creation or issue cleanup, agents should also use the GitHub issue workflow.

## Dev Environment Tips

- Prefer `./bin/dev`, not bare `dev`, so commands work reliably from the repo root
- Start all services: `./bin/dev up`
- Start API only: `./bin/dev up api`
- Start web only: `./bin/dev up web`
- Build services: `./bin/dev build <service>`
- Stop services: `./bin/dev down`
- Remove a specific service volume when needed by passing extra Docker Compose args through
  `./bin/dev down`, for example `./bin/dev down api -v`
- Access an API shell: `./bin/dev exec api bash`
- Run Rails commands: `./bin/dev rails <command>`
- Access PostgreSQL: `./bin/dev psql`

## Formatting

- Ruby files should be formatted in-editor with Shopify Ruby LSP using `syntax_tree`
- Standalone SQL files should be formatted with Prettier using [`prettier-plugin-sql`](./package.json)
- Frontend TypeScript/Vue code should follow the local ESLint and Prettier configuration
- The shared Prettier config lives at [`.prettierrc.yaml`](./.prettierrc.yaml)

## Testing

- Prefer focused test runs over broad ones when verifying a narrow change
- Use the local wrappers where possible:
  - API: `./bin/dev test api`
  - Web: `./bin/dev test web`
- Reviewer-facing testing steps should be written with the
  [testing instructions workflow](agents/workflows/testing-instructions.md)

## Pull Requests

- Use descriptive, emoji-prefixed commit messages
- Keep one commit per logical change
- For PR descriptions, use the structure in [`.github/pull_request_template.md`](./.github/pull_request_template.md)
- When a PR changes user-visible behavior, always include precise testing steps with exact UI labels

## Planning Documents

- When asked to write a plan, create a new dated plan file in [`agents/plans/`](agents/plans/)
- Use the `Type, Title, Date.md` naming convention
- Do not overwrite `agents/plans/README.md` unless the request explicitly asks to update plan
  directory documentation
