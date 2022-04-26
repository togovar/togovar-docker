#!/bin/bash

if [[ $1 == "start" ]]; then
  bundle install
  npm install

  if [[ -d /opt/togovar/app/stanza ]]; then
    cd /opt/togovar/app/stanza
    npm install

    echo >&2
    echo "build stanza" >&2
    npx togostanza build --output-path /var/www/stanza
    cd -
  fi

  echo >&2
  echo "build frontend" >&2
  npm run build:prod
  cp -rv /opt/togovar/app/dist/* /var/www/

  mkdir -p /opt/togovar/app/tmp/pids && rm -f /opt/togovar/app/tmp/pids/*
  mkdir -p /opt/togovar/app/tmp/sockets && rm -f /opt/togovar/app/tmp/sockets/*

  echo >&2
  echo "start unicorn..." >&2

  bundle exec unicorn -c config/unicorn.rb
else
  exec "$@"
fi
