#!/bin/bash

if [[ $1 == "unicorn" ]]; then
  bundle install
  yarn install

  [[ -n "$WEBPACKER_FORCE_COMPILE" ]] && rails webpacker:clobber

  rails webpacker:compile

  cp -rv /app/public/* /var/www/

  mkdir -p /app/tmp/pids && rm -f /app/tmp/pids/*
  mkdir -p /app/tmp/sockets && rm -f /app/tmp/sockets/*

  echo
  echo "start unicorn..."
fi

exec "$@"
