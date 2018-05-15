FROM elixir:1.6-alpine

ENV PORT 4000

COPY . .

WORKDIR /
RUN set -xe \
  && apk add --no-cache postgresql-client \
  && mix local.rebar --force \
  && mix local.hex --force \
  && mix deps.get \
  && mix compile
