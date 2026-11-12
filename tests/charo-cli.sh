#!/bin/sh
set -eu

root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
fixtures="$root/tests/fixtures/bin"
tmp="${TMPDIR:-/tmp}/charo-cli-test-$$"
mkdir "$tmp"
log="$tmp/calls.log"
: >"$log"

run_charo() {
    HOME="$tmp/home" \
    XDG_RUNTIME_DIR="$tmp/runtime" \
    PATH="$fixtures:/usr/bin:/bin" \
    CHARO_HYPRWHSPR_BIN="$fixtures/hyprwhspr" \
    CHARO_TEST_LOG="$log" \
    CHARO_TEST_BACKEND="${CHARO_TEST_BACKEND:-onnx-asr}" \
    CHARO_TEST_TV="${CHARO_TEST_TV:-off}" \
    CHARO_TEST_SERVICE_ACTIVE="${CHARO_TEST_SERVICE_ACTIVE:-0}" \
        "$root/bin/charo" "$@"
}

actual=$(run_charo keys)
expected='Super+Space    dictate (press again to stop)
Ctrl+Super+D   switch engine
Shift+Super+D  load or unload the engine
Super+Escape   TV mode on/off'
[ "$actual" = "$expected" ] || {
    printf 'unexpected shortcut display:\n%s\n' "$actual" >&2
    exit 1
}

[ "$(run_charo engine id)" = "onnx-asr" ]
run_charo engine whisper >/dev/null
grep -qx 'backend switch faster-whisper' "$log"

CHARO_TEST_TV=on
export CHARO_TEST_TV
[ "$(run_charo tv status)" = "on" ]
run_charo tv off >/dev/null
grep -qx 'tv off' "$log"

CHARO_TEST_SERVICE_ACTIVE=1
export CHARO_TEST_SERVICE_ACTIVE
[ "$(run_charo state)" = "idle" ]
grep -qx 'systemctl --user --quiet is-active hyprwhspr.service' "$log"

CHARO_HYPRWHSPR_SERVICE=custom-hyprwhspr.service \
    CHARO_TEST_SERVICE_ACTIVE=0 run_charo state >/dev/null
grep -qx 'systemctl --user --quiet is-active custom-hyprwhspr.service' "$log"

printf 'Charo CLI stock-contract tests passed\n'
