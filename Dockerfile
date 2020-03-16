FROM ruby:2.7.0-alpine3.11

WORKDIR /proj-cont

COPY init_proj/create-rc-files.sh .

RUN set -ox pipefail \
  && ./create-rc-files.sh \
  && apk update \
  && apk add --no-cache \
    bash vim yarn tzdata build-base \
    postgresql-client postgresql-dev \
  && gem install bundler -N \
  && rm -rf /var/cache/apk/*s

COPY . .

CMD ["init_proj/start-rails-server.sh"]

