FROM ruby:2.5-alpine
RUN apk --no-cache add curl

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/

RUN apk --no-cache add build-base && \
    bundle install --without development test && \
    apk del build-base

COPY . /usr/src/app

ENV PORT 8000
HEALTHCHECK CMD curl --fail http://127.0.0.1:$PORT/v1/status || exit 1

CMD bundle exec puma -C config/puma.rb
