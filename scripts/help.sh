#!/bin/sh

set -ue
umask 0022
export LC_ALL=C

set -- $ARGS

if [ "$#" -eq 0 ]; then
  grep -v '```' /tmp/documents/help.md
elif [ "_$1" = "_-h" ]; then
  grep -v '```' /tmp/documents/help.md
else
  echo "Unrecognized option: $1" && exit 1
fi
