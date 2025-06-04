#!/usr/bin/env bash

set -euo pipefail

case $1 in
start)
  mkdir -p /app/tmp/{pids,sockets}

  rm -rf /app/tmp/cache/*
  rm -f /app/tmp/pids/unicorn.pid

  echo "==================="
  echo "Starting unicorn..."
  echo "==================="

  bundle exec unicorn -c config/unicorn.rb
  ;;
*)
  exec "$@"
  ;;
esac
