FROM ruby:3.4.7

RUN gem update --system 3.7.2 && gem install bundler -v 2.7.2

WORKDIR /usr/src/api

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

RUN chmod +x ./bin/rails

CMD ["./bin/rails server --host 0.0.0.0"]
