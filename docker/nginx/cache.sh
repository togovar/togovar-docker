#!/usr/bin/env bash

set -euo pipefail

case $1 in
purge)
  rm -rv /var/cache/nginx/sparqlist/*
  ;;
*)
  echo "Unknown command: $1" >&2
  exit 1
  ;;
esac
