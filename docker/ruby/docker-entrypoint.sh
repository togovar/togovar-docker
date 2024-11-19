#!/bin/bash

set -e

mkdir -p /opt/togovar/app/tmp/{pids,sockets}

if [[ $1 == "start" ]]; then
  rm -rf /opt/togovar/app/tmp/cache/*
  rm -f /opt/togovar/app/tmp/pids/unicorn.pid

  echo >&2
  echo "start unicorn..." >&2

  bundle exec unicorn -c config/unicorn.rb
elif [[ $1 == "build" ]]; then
  rm -rf /tmp/stanza
  rm -rf /opt/togovar/app/dist
  rm -rf /var/www/*

  if [[ -d /opt/togovar/app/stanza ]]; then
    cd /opt/togovar/app/stanza

    npm install

    echo >&2
    echo "build stanza" >&2
    npx togostanza build --output-path /tmp/stanza

    if [[ -n $TOGOVAR_STANZA_REWRITE_URL ]]; then
      echo "Rewrite URL: $TOGOVAR_STANZA_REWRITE_URL" >&2
      find /tmp/stanza \( -name '*.html' -or -name '*.js' -or -name '*.json' \) -exec sed -i "s|$TOGOVAR_STANZA_REWRITE_URL|g" {} \;
    fi

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
