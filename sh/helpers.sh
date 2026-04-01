#!/usr/bin/env bash

tms() {
	selected_session=$(tmux list-sessions -F "#{session_name}" | fzf --prompt="Select tmux session: ")
	if [ -n "$selected_session" ]; then
		tmux attach -t "$selected_session" || tmux switch-client -t "$selected_session"
	fi
}
