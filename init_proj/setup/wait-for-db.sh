#!/bin/bash

set -x

# db コンテナの準備が整うまで待機する
until PGPASSWORD=$POSTGRES_PASSWORD psql -h $DB_HOST -U $POSTGRES_USER -c '\q'; do
  >&2 echo "Postgres is unavailable and sleeping now."
  sleep 5
done

>&2 echo "Postgres is up."
