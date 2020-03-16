FROM ruby:2.7.0-alpine3.11

WORKDIR /proj-cont

COPY init_proj/create-rc-files.sh ./

RUN set -ox pipefail \
  && apk update \
  && apk add --no-cache \
    bash git vim yarn tzdata build-base \
    postgresql-client postgresql-dev \
  && ./create-rc-files.sh \
  && gem install bundler -N \
  && rm -rf /var/cache/apk/*s

COPY . .

CMD ["init_proj/start-rails-server.sh"]

