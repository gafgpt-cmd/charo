#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
actual=$(HOME=/nonexistent PATH="$root/tests/fixtures/bin:/usr/bin:/bin" \
    "$root/bin/charo" keys)
expected='Super+Space    dictate (press again to stop)
Ctrl+Super+D   switch engine
Shift+Super+D  load or unload the engine
Super+Escape   TV mode on/off'

if [ "$actual" != "$expected" ]; then
    printf 'unexpected shortcut display:\n%s\n' "$actual" >&2
    exit 1
fi

printf '%s\n' "$actual"
