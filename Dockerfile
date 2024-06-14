# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.1
FROM docker.io/library/ruby:$RUBY_VERSION-slim as base

# OS Level Dependencies
RUN --mount=type=cache,target=/var/cache/apt \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    less \
    git \
    sqlite3 \
    libsqlite3-dev \
    libvips \
    curl \
    libjemalloc2 \
    pkg-config

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

RUN gem update --system && gem install bundler

WORKDIR /app

COPY . .

RUN chmod +x /app/bin/docker-entrypoint
ENTRYPOINT ["/app/bin/docker-entrypoint"]

EXPOSE 3010

CMD ["./bin/rails", "server", "-b", "0.0.0.0"]