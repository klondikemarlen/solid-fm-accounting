FROM ruby:3.4.7

RUN gem update --system 3.7.2 && gem install bundler -v 2.7.2

# TODO: add this once it is needed?
# Install build dependencies for gems with native extensions
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y \
#     build-essential \
#     git \
#     libpq-dev \
#     libyaml-dev \
#     pkg-config \
#     postgresql-client && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

WORKDIR /usr/src/api

COPY Gemfile Gemfile.lock ./

RUN bundle install

# Make bundle directory writable for all users (needed when running as non-root)
RUN chmod -R a+w /usr/local/bundle

COPY . .

RUN chmod +x ./bin/rails

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
