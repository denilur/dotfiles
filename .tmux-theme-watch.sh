#!/usr/bin/env bash
# Poll macOS Appearance and switch tmux's colour theme on change.
# Started once per tmux server from .tmux.conf; exits once the server dies.

set -uo pipefail

PIDFILE="${TMPDIR:-/tmp}/tmux-theme-watch.pid"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  exit 0
fi
echo $$ >"$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT

current=""
while tmux info >/dev/null 2>&1; do
  style=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
  if [ "$style" != "$current" ]; then
    current="$style"
    if [ "$style" = "Dark" ]; then
      tmux source-file "$HOME/.tmux-theme-dark.conf"
    else
      tmux source-file "$HOME/.tmux-theme-light.conf"
    fi
  fi
  sleep 3
done
