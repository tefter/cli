FROM elixir:1.9-slim as builder

RUN apt-get -qq update
RUN apt-get -qq install git build-essential python

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info

ENV MIX_ENV prod

ADD . .
RUN mix deps.get
RUN mix release --quiet --overwrite

FROM debian:buster-slim

RUN apt-get -qq update
RUN apt-get -qq install locales libssl1.1 libtinfo5 xdg-utils

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/tefter_cli .

CMD ["./bin/tefter_cli", "start"]
