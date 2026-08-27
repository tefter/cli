FROM elixir:1.9-slim as builder

# The base images are Debian buster, which has moved to archive.debian.org.
RUN sed -i 's|deb.debian.org|archive.debian.org|g; s|security.debian.org|archive.debian.org|g; /buster-updates/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false -qq update
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

RUN sed -i 's|deb.debian.org|archive.debian.org|g; s|security.debian.org|archive.debian.org|g; /buster-updates/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false -qq update
RUN apt-get -qq install locales libssl1.1 libtinfo5 xdg-utils

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/tefter_cli .

# The TUI draws UTF-8 (borders, the block cursor); without this the VM runs
# in latin1 and warns on boot. C.UTF-8 ships with the base image — no
# locale-gen needed.
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# start_iex, not start: plain `start` boots the BEAM with -noshell, and on
# current systems termbox then opens the alternate screen and never draws —
# a black, dead TUI. Quit with Ctrl+Q.
CMD ["./bin/tefter_cli", "start_iex"]
