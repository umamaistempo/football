#!/bin/sh
# wait-for-postgres.sh
# Taken from https://docs.docker.com/compose/startup-order/

set -e

cmd="$@"

until PGPASSWORD=$FOOTBALL_DATABASE_PASSWORD psql -h "$FOOTBALL_DATABASE_HOSTNAME" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd
