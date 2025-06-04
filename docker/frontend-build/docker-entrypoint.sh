#!/usr/bin/env bash

set -euo pipefail

FRONTEND_CACHE=/var/www/.frontend.sha1
STANZA_CACHE=/var/www/.stanza.sha1

function build_frontend {
  cd /work/frontend

  if [[ -e $FRONTEND_CACHE && $(cat $FRONTEND_CACHE) = $(git rev-parse HEAD) ]]; then
    echo "Skip building frontend - git revision has not changed"
    return
  fi

  echo
  echo "===================="
  echo "Building frontend..."
  echo "===================="

  rm -rf /tmp/dist

  npm ci
  npm run build -- --output-path /tmp/dist

  cp -rv /tmp/dist/* /var/www/

  git rev-parse HEAD > $FRONTEND_CACHE
}

function build_stanza {
  cd /work/stanza

  if [[ -e $STANZA_CACHE && $(cat $STANZA_CACHE) = $(git rev-parse HEAD) ]]; then
    echo "Skip building stanza - git revision has not changed"
    return
  fi

  echo
  echo "=================="
  echo "Building stanza..."
  echo "=================="

  rm -rf /tmp/stanza

  npm ci
  npx togostanza build --output-path /tmp/stanza

  if [[ -n ${TOGOVAR_STANZA_REWRITE_URL:-} ]]; then
    echo "Rewrite URL: $TOGOVAR_STANZA_REWRITE_URL" >&2
    find /tmp/stanza \( -name '*.html' -or -name '*.js' -or -name '*.json' \) -exec sed -i "s|$TOGOVAR_STANZA_REWRITE_URL|g" {} \;
  fi

  cp -rv /tmp/stanza /var/www/

  git rev-parse HEAD > $STANZA_CACHE
}

case $1 in
build)
  build_frontend
  build_stanza
  exit 0
  ;;
*)
  exec "$@"
  ;;
esac
