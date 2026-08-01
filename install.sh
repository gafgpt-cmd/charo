#!/bin/sh
# Install charo for the current user: links the commands onto PATH, installs
# the tray icons, then runs charo-setup to wire up the desktop.
#
# Links rather than copies, so `git pull` in this checkout updates the
# installed commands immediately.
set -eu

source_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
bindir="$HOME/.local/bin"
share="$HOME/.local/share/charo"
icons="$share/icons"

mkdir -p "$bindir" "$icons"

for file in charo charo-indicator charo-setup; do
    ln -sf "$source_dir/bin/$file" "$bindir/$file"
    printf 'linked %s -> %s\n' "$bindir/$file" "$source_dir/bin/$file"
done

for icon in "$source_dir"/share/icons/*.svg; do
    cp -f "$icon" "$icons/"
done
cp -f "$source_dir/share/dictation-defaults.json" "$share/"
printf 'installed tray icons and dictation defaults into %s\n\n' "$share"

case ":$PATH:" in
    *":$bindir:"*) ;;
    *) printf 'NOTE: %s is not on your PATH - add it to use charo by name.\n\n' "$bindir" ;;
esac

exec "$bindir/charo-setup" "$@"
