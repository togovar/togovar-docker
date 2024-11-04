#!/bin/bash

set -e

mkdir -p /opt/togovar/app/tmp/{pids,sockets}

if [[ $1 == "start" ]]; then
  rm -rfv /opt/togovar/app/tmp/cache/*
  rm -fv /opt/togovar/app/tmp/pids/unicorn.pid

  echo >&2
  echo "start unicorn..." >&2

  bundle exec unicorn -c config/unicorn.rb
elif [[ $1 == "build" ]]; then
  if [[ -d /opt/togovar/app/stanza ]]; then
    cd /opt/togovar/app/stanza

    npm install

    echo >&2
    echo "build stanza" >&2
    npx togostanza build --output-path /tmp/stanza
    cp -rv /tmp/stanza /var/www/

    cd -
  fi

  echo >&2
  echo "build frontend" >&2
  npm run build
  cp -rv /opt/togovar/app/dist/* /var/www/
else
  exec "$@"
fi
