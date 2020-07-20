#!/bin/bash

if [[ $1 == "unicorn" ]]; then
  bundle install
  yarn install
  rails webpacker:compile

  cp -rv /app/public/* /var/www/

  [[ -d /app/tmp/pids ]] && rm -f /app/tmp/pids/*
  [[ -d /app/tmp/sockets ]] && rm -f /app/tmp/sockets/*

  echo
  echo "start unicorn..."
fi

exec "$@"
