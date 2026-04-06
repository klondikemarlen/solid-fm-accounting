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
