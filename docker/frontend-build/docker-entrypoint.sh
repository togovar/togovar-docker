#!/usr/bin/env bash

set -euo pipefail

function build_frontend {
  cd /work/frontend

  echo
  echo "===================="
  echo "Building frontend..."
  echo "===================="

  rm -rf /tmp/dist

  npm ci
  npm run build -- --output-path /tmp/dist

  cp -rv /tmp/dist/* /var/www/
}

function build_stanza {
  cd /work/stanza

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
