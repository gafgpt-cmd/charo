# charo

Dictation for XFCE. A tray app and one command that make
[hyprwhspr](https://github.com/goodroot/hyprwhspr) usable from the desktop —
click or press a key to dictate, switch engines, and stop it listening to the room.

hyprwhspr ships integrations for Waybar, Noctalia, and GNOME, and writes its state
to files "for tray script" — but no tray script exists for XFCE. Charo is that
missing piece.

## Install

```sh
git clone https://github.com/gafgpt-cmd/charo.git
cd charo
./install.sh
```

The installer links `charo`, `charo-indicator`, and `charo-setup` into
`~/.local/bin`, installs the tray icons, restores the keyboard shortcuts, adds the
autostart entry, and starts the tray. It's safe to re-run, and
`charo-setup --check` reports what's missing without changing anything.

## Use

| Key | Action |
| --- | --- |
| `Super`+`D` | Start/stop dictating (loads the engine if needed) |
| `Ctrl`+`Super`+`D` | Switch engine: Parakeet ↔ Whisper |
| `Shift`+`Super`+`D` | Load/unload the engine to free memory |
| `Super`+`T` | TV mode on/off |

The tray icon shows state at a glance: a dim crossed-out microphone means the engine
is unloaded, white means ready, **red means recording**, blue means TV mode. Left
click dictates; right click opens the full menu. Every action also raises a desktop
notification, so the keys are never silent.

Everything is available from the command line too — `charo --help` lists it.

## TV mode

hyprwhspr can sit idle listening for a spoken start phrase. That's convenient until
a television says it, at which point dictation begins and types what the presenter
is saying into whatever window has focus.

TV mode parks those phrases. They're saved to
`~/.local/share/charo/wake-words.json` and restored when you switch it off, so
nothing is lost. With TV mode on, dictation starts only from the key or the tray.

## Engines

Two local engines, switchable from the tray or `charo engine switch`:

- **Parakeet** (`onnx-asr`) — English only, loads in about three seconds
- **faster-whisper** — multilingual, slower to load

Switching rewrites `transcription_backend` in the hyprwhspr config, keeping a backup
of the previous file, and restarts the engine if it's running.

## Requirements

hyprwhspr, `python3-gi` with GTK 3, `xclip`, `notify-send`, systemd user services,
and an XFCE session for the shortcuts and system tray. Both engines run on CPU;
no GPU is needed.

## contrib/git-hooks

Not part of charo — two git hooks kept here because they're useful. `pre-commit`
scans staged content with gitleaks; `pre-push` scans every commit in the range being
pushed. Point `core.hooksPath` at the directory to use them.
