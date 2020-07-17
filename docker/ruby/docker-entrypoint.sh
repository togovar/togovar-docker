#!/bin/bash

if [[ $1 == "unicorn" ]]; then
  bundle install
  yarn install
  rails webpacker:compile

  cp -rv /app/public/* /var/www/

  echo
  echo "start unicorn..."
fi

exec "$@"
