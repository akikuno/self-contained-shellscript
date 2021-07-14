#!/bin/sh

set -ue
umask 0022
export LC_ALL=C

set -- $ARGS

[ "$#" -eq 0 ] && grep -v '```' /tmp/documents/help.md && exit 0

[ "_$1" = "_-h" ] && grep -v '```' /tmp/documents/help.md && exit 0

echo "Unrecognized option: $1" && exit 1
