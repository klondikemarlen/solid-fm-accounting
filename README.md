# Solid FM Accounting

A simple, end-to-end bookkeeping solution: record transactions, generate accurate reports, file directly to the CRA, and seamlessly hand off to your accountant for approval — all in one place.

## General Stack

### API (Back-end)

- [Ruby](https://www.ruby-lang.org/en) + [Rails](https://rubyonrails.org/)

### Front-End

- [Vue 3](https://vuejs.org/guide/introduction.html) + [Vuetify](https://vuetifyjs.com/en/getting-started/installation/#installation)

- [Typescript](https://www.typescriptlang.org/docs/handbook/typescript-from-scratch.html)

- [Axios](https://github.com/axios/axios)

### Database

- [PostgreSQL](https://www.postgresql.org/docs/current/app-psql.html)

- [Docker Compose](https://docs.docker.com/compose/compose-file/)

### Mail Server

- Mail Dev - [MailDev](https://github.com/maildev/maildev?tab=readme-ov-file#docker-run)
- [MailDev Docker Image](https://hub.docker.com/r/maildev/maildev)

---

## Development

1. In the `api` folder.

2. Create a `.env.development` file with the following content:

   ```bash
   TODO
   ```

   See `docker-compose.development.yml` -> `x-default-environment` for optional values that you can customize as needed.

3. [Set up the `dev`](#set-up-dev-command) command, or use `docker compose -f docker-compose.development.yml` instead of `dev` in all instructions.

4. Boot the api, web, and db services via `dev up --watch` or `dev watch` or `docker compose -f docker-compose.development.yml up --watch`. This will run the boot pipeline and create the database, run migrations, and run seeds.

5. Stop the api, web, and db services via `ctrl+c` or `dev down` or if you want to wipe the database `dev down -v`.

6. Install local dependencies by installing `asdf` and node via `asdf` and then running `npm install` at the top level of the project.

7. To get the local per-service node_modules, so your code editor gets linting and types, do `cd api && bundle install` and `cd web && npm install`.

### API Service (a.k.a back-end)

1. Boot only the api service using:

   ```bash
   dev up api

   # or

   docker compose -f docker-compose.development.yml up --watch api

   # or

   cd api
   npm run start
   ```

2. Access the api by logging in to the front-end, then going to http://localhost:3000

### Web Service (a.k.a. front-end)

1. Boot only the web service using:

   ```bash
   dev up web

   # or

   docker compose -f docker-compose.development.yml up --watch web

   # or

   cd web
   npm run start
   ```

2. Log in to the front-end service at http://localhost:8080

### DB Service (a.k.a database service)

1. Boot only the db service using:

   ```bash
   dev up db

   # or

   docker compose -f docker-compose.development.yml up --watch db
   ```

   > Migrations run automatically, as do seeds.
   > NOTE: production and development have different seeds.

2. You can access the `psql` command line via

   ```bash
   dev psql

   # or

   docker compose -f docker-compose.development.yml exec db sh -c '
      PGPASSWORD="$DB_PASSWORD" psql \
         --host "$DB_HOST" \
         --username "$DB_USERNAME" \
         --dbname "$DB_DATABASE"
   '
   ```

### Mail Service (a.k.a mail server)

1. Access the web interface at http://localhost:1080

### Troubleshooting

If you are getting a bunch of "Login required" errors in the console, make sure that you have disabled any kind of enhanced tracking protection.

Auth0 use third-party cookies for authentication, and they get blocked by all major browsers
by default.

## Testing

1. Run the api test suite via `dev test_api`.

See [api/tests/README.md](./api/tests/README.md) for more detailed info.

## Migrations - Database Management

This project now uses Rails Active Record migrations. Naming conventions should continue to follow snake_case for database tables and columns.

1. To generate a new migration run:

   ```bash
   dev rails generate migration CreateUsersTable
   ```

   Replace `CreateUsersTable` with a descriptive migration class name. Generated files will appear under `api/db/migrate/`.

   > If you are using Linux, always run generators through the `dev rails` wrapper to avoid file permission issues inside Docker containers.

2. To apply all pending migrations run:

   ```bash
   dev rails db:migrate
   ```

3. To rollback the most recent migration run:

   ```bash
   dev rails db:rollback
   ```

4. To rollback all migrations and reapply them run:

   ```bash
   dev rails db:migrate:reset
   ```

### Seeding

Seeding relies on Rails `db/seeds` files located under `api/db/`. Place shared data in `api/db/seeds.rb`, and environment-specific logic in files such as `api/db/seeds/development.rb` and `api/db/seeds/production.rb`.

1. To execute the default seed script run:

   ```bash
   dev rails db:seed
   ```

2. To truncate tables and reseed from scratch run:

   ```bash
   dev rails db:seed:replant
   ```

3. To run seeds for a specific environment set `RAILS_ENV` explicitly:

   ```bash
   RAILS_ENV=production dev rails db:seed
   ```

Seeds remain environment-scoped, enabling minimal defaults in production and richer fixtures in development. Rails seeds do not track execution history, so keep every seed operation idempotent to ensure it is safe to rerun at any time.

### References

- [Active Record Migrations](https://guides.rubyonrails.org/active_record_migrations.html)

### Extras

If you want to take over a directory or file in Linux you can use `dev ownit <path-to-directory-or-file>`.

If you are on Windows or Mac, and you want that to work, you should implement it in the `bin/dev` file. You might never actually need to take ownership of anything, so this might not be relevant to you.

## Set up `dev` command

The `dev` command vastly simplifies development using docker compose. It only requires `ruby`; however, `direnv` and `asdf` will make it easier to use.

It's simply a wrapper around docker compose with the ability to quickly add custom helpers.

All commands are just strings joined together, so it's easy to add new commmands. `dev` prints out each command that it runs, so that you can run the command manually to debug it, or just so you learn some docker compose syntax as you go.

1. (optional) Install `asdf` as seen in https://asdf-vm.com/guide/getting-started.html.

   e.g. for Linux

   ```bash
   apt install curl git

   git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0

   echo '
   # asdf
   . "$HOME/.asdf/asdf.sh"
   . "$HOME/.asdf/completions/asdf.bash"
   ' >> ~/.bashrc
   ```

2. Install `ruby` via `asdf` as seen here https://github.com/asdf-vm/asdf-ruby, or using whatever custom Ruby install method works for your platform.

   e.g. for Linux

   ```bash
   asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git

   # install version from .tool-versions file
   asdf install ruby

   asdf reshim ruby
   ```

   You will now be able to run the `./bin/dev` command.

3. (optional) Install [direnv](https://direnv.net/) and create an `.envrc` with

   ```bash
    #!/usr/bin/env bash

    PATH_add bin
   ```

   and then run `direnv allow`.

   You will now be able to do `dev xxx` instead ov `./bin/dev xxx`.

# Deploying

## Production Environment (remote)

TODO

## Test Production Build Locally

Files:

- [Dockerfile](./Dockerfile)
- [docker-compose.yml](./docker-compose.yml)
- Non-commited `.env` file

1. Create a `.env` file in top level directory with the appropriate values.

   ```bash
   TODO
   ```

2. (optional) If testing build arguments do

   ```bash
   dc build --build-arg RELEASE_TAG=2024.01.8.1 --build-arg GIT_COMMIT_HASH=532bd759c301ddc3352a1cee41ceac8061bfa3f7
   ```

   or

   ```bash
   dc build \
      --build-arg RELEASE_TAG=$(date +%Y.%m.%d) \
      --build-arg GIT_COMMIT_HASH=$(git rev-parse HEAD)
   ```

   and then in the next step drop the `--build` flag.

3. Build and boot the production image via

   ```bash
   docker compose up --build
   ```

4. Go to http://localhost:3000/ and log in.

5. Navigate around the app and do some stuff and see if it works.

## Testing GitHub Publish Locally

- https://nektosact.com/installation/gh.html
- https://github.com/cli/cli/blob/trunk/docs/install_linux.md

1. Install GitHub CLI, via:
   ```sh
   sudo apt install gh
   ```
   See https://github.com/cli/cli/blob/trunk/docs/install_linux.md
   NOTE: `snap` version of `gh` has permission limits, and will not work correctly, so use the `apt` version instead.
2. Install GitHub publish library via:
   ```sh
   gh extension install https://github.com/nektos/gh-act
   ```
   See https://nektosact.com/installation/gh.html
3. Generate secrets file via:
   ```sh
   ./bin/build-github-act-secrets-file.sh
   ```
4. Run publish action via:
   ```sh
   gh act push \
      -P ubuntu-latest=-self-hosted \
      --job build \
      --env PUSH_ENABLED=false \
      --secret-file .secrets
   ```
   Wait a long time, this will be very slow and not show much progress.
5. Check that the secrets built correctly:
   ```bash
   docker run --rm -it \
     --entrypoint /bin/sh \
     some.repo/solid-fm-accounting:<LATEST_TAG>
   ```
