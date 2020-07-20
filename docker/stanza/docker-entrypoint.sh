#!/usr/bin/env bash

ts build

if [[ -d /stanza/dist/stanza && -n "$STANZA_REPLACE" ]]; then
  find /stanza/dist/stanza -type f -name "metadata.json" -exec sed -i -e "s${STANZA_REPLACE}" {} \;
  find /stanza/dist/stanza -type f -name "help.html" -exec sed -i -e "s${STANZA_REPLACE}" {} \;
fi

[[ -d /stanza/dist ]] && cd /stanza/dist || echo "/stanza/dist not found" >&2

exec "$@"
