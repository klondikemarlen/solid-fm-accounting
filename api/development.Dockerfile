FROM ruby:3.4.9

# Accept UID/GID as build args to match host user
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN gem update --system 4.0.9 && gem install bundler -v 4.0.8

WORKDIR /usr/src/api

# Install gems as root (per article recommendation)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Create app user with matching UID/GID and home directory
RUN groupadd --gid ${GROUP_ID} appuser && \
    useradd --uid ${USER_ID} --gid ${GROUP_ID} --create-home --shell /bin/bash appuser

# Give ownership of app and bundle directories to appuser
RUN chown -R appuser:appuser /usr/src/api /usr/local/bundle

COPY . .
RUN chmod +x ./bin/rails

# Switch to non-root user
USER appuser

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
