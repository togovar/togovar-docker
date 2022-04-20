#!/bin/bash

if [[ $1 == "start" ]]; then
  bundle install
  npm install

  echo "build frontend" >&2
  npm run build:prod
  cp -rv /app/dist/* /var/www/

  if [[ -d stanza ]]; then
    echo
    echo "build stanza" >&2

    cd stanza
    npm install
    npm run build --output-path /var/www/stanza
    cd -
  fi

  mkdir -p /app/tmp/pids && rm -f /app/tmp/pids/*
  mkdir -p /app/tmp/sockets && rm -f /app/tmp/sockets/*

  echo
  echo "start unicorn..."

  bundle exec unicorn -c config/unicorn.rb
else
  exec "$@"
fi
