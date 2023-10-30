#!/bin/bash

mkdir -p /opt/togovar/app/tmp/{pids,sockets}

if [[ $1 == "start" ]]; then
  rm -fv /opt/togovar/app/tmp/pids/unicorn.pid

  bundle install

  echo >&2
  echo "start unicorn..." >&2

  bundle exec unicorn -c config/unicorn.rb
elif [[ $1 == "build" ]]; then
  # workaround for https://github.com/npm/cli/issues/624
  orig=$(stat -c '%u' /opt/togovar/app)
  chown root /opt/togovar/app
  npm install --legacy-peer-deps
  chown "$orig" /opt/togovar/app

  if [[ -d /opt/togovar/app/stanza ]]; then
    cd /opt/togovar/app/stanza || exit
    npm install --legacy-peer-deps

    echo >&2
    echo "build stanza" >&2
    npx togostanza build --output-path /tmp/stanza
    cp -rv /tmp/stanza /var/www/

    cd - || exit
  fi

  echo >&2
  echo "build frontend" >&2
  npm run build
  cp -rv /opt/togovar/app/dist/* /var/www/
else
  exec "$@"
fi
