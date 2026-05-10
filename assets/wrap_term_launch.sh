#!/usr/bin/env sh

cat ~/.local/state/hyprlandsh/sequences.txt 2>/dev/null

exec "$@"
