# dotfiles

Personal configuration for this machine. Tracked with a bare git repository whose
work tree is `$HOME`, so files stay where they belong and **nothing is tracked
unless it is added by name**.

## Using it

`dots` is the whole interface — plain git, pointed at this repo:

```sh
dots status                 # what changed in tracked files
dots add ~/.config/thing    # start tracking something
dots commit -m "..."        # signed and scanned automatically
dots push                   # scanned again before it leaves the machine
```

## On a fresh machine

```sh
git clone --bare https://github.com/gafgpt-cmd/dotfiles.git ~/.local/share/dotfiles.git
git --git-dir=$HOME/.local/share/dotfiles.git --work-tree=$HOME config status.showUntrackedFiles no
git --git-dir=$HOME/.local/share/dotfiles.git --work-tree=$HOME checkout main
dictation-setup
```

`dictation-setup` is idempotent: it checks dependencies, restores the keyboard
shortcuts, installs the autostart entry, and starts the tray indicator. Run
`dictation-setup --check` to see what is missing without changing anything.

## Dictation

Speech-to-text through [hyprwhspr](https://github.com/goodroot/hyprwhspr), wrapped
so it can be driven from the keyboard and the system tray.

| Key | Action |
| --- | --- |
| `Super`+`D` | Start/stop dictating (loads the engine if needed) |
| `Ctrl`+`Super`+`D` | Switch engine: Parakeet ↔ Whisper |
| `Shift`+`Super`+`D` | Load/unload the engine to free memory |
| `Super`+`T` | TV mode on/off |

The tray icon shows state at a glance: dim crossed-out microphone means the engine
is unloaded, white means ready, **red means recording**, blue means TV mode. Left
click dictates; right click opens the full menu.

**TV mode** parks hyprwhspr's spoken start phrases. Without it, a television saying
"start dictation" begins recording and types what it hears into the focused window.
The phrases are saved to `~/.local/share/dictation-indicator/wake-words.json` and
restored when TV mode is switched off.

**Engines** — Parakeet (`onnx-asr`) is English-only and loads in about three seconds;
faster-whisper is multilingual. Both run on CPU here. Switching rewrites
`transcription_backend` in the hyprwhspr config and restarts the engine, keeping a
backup of the previous configuration.

`dictation-ctl --help` documents every command.

### Requirements

hyprwhspr, `python3-gi` with GTK 3, `xclip`, `notify-send`, systemd user services,
and an XFCE session for the keyboard shortcuts and system tray.

## Git hardening

Commits are signed with an OpenPGP key, and gitleaks runs at two gates from
`~/.config/git/hooks`: `pre-commit` scans the staged content, `pre-push` scans every
commit in the range being pushed. The pre-push gate matters most — it re-checks
history written earlier or by other tools before anything reaches a remote.

Only the public half of the signing key lives here. The private key, its passphrase,
and its revocation certificate belong in a password manager, never in this repo.
