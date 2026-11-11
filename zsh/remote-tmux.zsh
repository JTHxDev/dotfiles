#!/usr/bin/env zsh
# Remote interactive logins (ssh or mosh) attach to the persistent tmux session "main".
# This makes clients without a startup command (Termius free) land in "main" too.
# Skipped when: already in tmux, coming from another tmux (TERM=tmux*/screen*, so
# no nesting), non-interactive (ssh host cmd, scripts, agents), or NO_TMUX is set.
# Escape hatch: ssh -t host 'NO_TMUX=1 exec zsh'
# If tmux fails, the plain shell continues (no "exec", so no lockout).
if [[ -o interactive && -z $TMUX && -z $NO_TMUX && $TERM != (tmux|screen)* ]] \
   && command -v tmux >/dev/null 2>&1 \
   && [[ -n $SSH_CONNECTION || "$(ps -o comm= -p $PPID 2>/dev/null)" == *mosh-server* ]]; then
  tmux new -A -s main && exit
fi
