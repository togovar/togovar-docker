#!/bin/bash

if [[ $1 == "start" ]]; then
  bundle install
  npm install

  npm run build

  cp -rv /app/dist/* /var/www/

  mkdir -p /app/tmp/pids && rm -f /app/tmp/pids/*
  mkdir -p /app/tmp/sockets && rm -f /app/tmp/sockets/*

  echo
  echo "start unicorn..."

  bundle exec unicorn -c config/unicorn.rb
else
  exec "$@"
fi
