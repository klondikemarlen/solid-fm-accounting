FROM ruby:3.4.7

RUN gem update --system 3.7.2 && gem install bundler -v 2.7.2

WORKDIR /usr/src/api

COPY Gemfile Gemfile.lock ./

RUN bundle install

# Make bundle directory writable for all users (needed when running as non-root)
RUN chmod -R a+w /usr/local/bundle

COPY . .

RUN chmod +x ./bin/rails

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
