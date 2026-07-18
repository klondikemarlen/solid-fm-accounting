# API

This directory contains the Rails API for Solid FM Accounting.

## Development

The normal way to run the API in development is from the repo root through `./bin/dev`.

```bash
./bin/dev up api
```

Useful commands:

- Start an API shell: `./bin/dev exec api bash`
- Run Rails commands: `./bin/dev rails <command>`
- Run API tests: `./bin/dev test api`

## Database

This app uses Rails migrations and Rails seeds.

- Create and apply migrations: `./bin/dev rails db:migrate`
- Roll back the latest migration: `./bin/dev rails db:rollback`
- Run seeds: `./bin/dev rails db:seed`

## Notes

- Local development uses the Docker Compose setup in the repo root.
- The API service is intended to be accessed together with the web app running at
  `http://localhost:8080`.

## Code Standards

- Prefer the existing Rails pattern and the smallest clear implementation; do not add speculative
  abstractions, compatibility layers, or dependencies.

- Follow Rails conventions: resources use RESTful routes, controllers inherit from `Api::BaseController`,
  and authentication remains the default.
- Scope every user-owned record from `current_user`; never load it globally and check ownership later.
- Keep database names `snake_case` and API JSON names `camelCase`. Serialize the API contract
  explicitly instead of leaking database column names.
- Put request parsing and HTTP responses in controllers; keep validations, associations, and domain
  invariants in models or narrowly named service objects when the workflow spans multiple models.
- Use `decimal` columns and `BigDecimal` for money. Never use floating point for amounts.
- Migrations must state nullability, foreign keys, indexes, and database constraints needed to protect
  the invariant. Make seed data idempotent.
- Test externally observable API behavior: authorization boundaries, validation failures, success
  responses, and persistence. Run focused API tests through `./bin/dev test api`.
