#!/bin/bash

if [[ $1 == "unicorn" ]]; then
  bundle install
  yarn install

  yarn build

  cp -rv /app/dist/* /var/www/

  mkdir -p /app/tmp/pids && rm -f /app/tmp/pids/*
  mkdir -p /app/tmp/sockets && rm -f /app/tmp/sockets/*

  echo
  echo "start unicorn..."
fi

exec "$@"
