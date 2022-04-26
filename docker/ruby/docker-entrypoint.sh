#!/bin/bash

if [[ $1 == "start" ]]; then
  bundle install
  npm install

  echo "build frontend" >&2
  npm run build:prod
  cp -rv /opt/togovar/app/dist/* /var/www/

  if [[ -d /opt/togovar/app/stanza ]]; then
    echo
    echo "build stanza" >&2

    cd /opt/togovar/app/stanza
    npm install
    npx togostanza build --output-path /var/www/stanza
    cd -
  fi

  mkdir -p /opt/togovar/app/tmp/pids && rm -f /opt/togovar/app/tmp/pids/*
  mkdir -p /opt/togovar/app/tmp/sockets && rm -f /opt/togovar/app/tmp/sockets/*

  echo
  echo "start unicorn..."

  bundle exec unicorn -c config/unicorn.rb
else
  exec "$@"
fi
