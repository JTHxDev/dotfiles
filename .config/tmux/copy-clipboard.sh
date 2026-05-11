#!/usr/bin/env bash
# Pipe stdin to the system clipboard, picking the right tool for the host.
# Invoked by tmux copy-mode bindings. OSC 52 (set-clipboard on) handles the
# remote->local forwarding case (e.g. mosh from macOS into this Ubuntu box),
# so this script only needs to set the *local* clipboard when one exists.

if command -v pbcopy >/dev/null 2>&1; then
  exec pbcopy
elif [ -n "$WAYLAND_DISPLAY" ] && command -v wl-copy >/dev/null 2>&1; then
  exec wl-copy
elif [ -n "$DISPLAY" ] && command -v xclip >/dev/null 2>&1; then
  exec xclip -selection clipboard -in
elif [ -n "$DISPLAY" ] && command -v xsel >/dev/null 2>&1; then
  exec xsel --clipboard --input
else
  cat >/dev/null
fi
