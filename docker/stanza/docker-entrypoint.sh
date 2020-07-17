#!/usr/bin/env bash

ts build

if [[ -n "$STANZA_REPLACE" ]]; then
  find dist/stanza -type f -name "metadata.json" -exec sed -i -e "s${STANZA_REPLACE}" {} \;
  find dist/stanza -type f -name "help.html" -exec sed -i -e "s${STANZA_REPLACE}" {} \;
fi

[[ -d dist ]] && cd dist || echo "/stanza/dist not found" >&2

exec "$@"
