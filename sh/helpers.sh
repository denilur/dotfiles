# Sourced from ~/.zshrc (see `make shell`). Keep safe for interactive startup.

# tms: pick a tmux session with fzf; type a new name to create one.
tms() {
    local sessions selected session
    sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
    if [ -z "$sessions" ]; then
        printf "Enter new session name: "
        read -r session
        tmux new-session -s "${session:-default}"
        return
    fi

    selected=$(printf "%s\n" "$sessions" | fzf --prompt="Session (or enter new): " --print-query --height=10)
    session=$(printf "%s\n" "$selected" | grep -v "^$" | tail -1)
    [ -n "$session" ] || return 0

    if [ -n "${TMUX:-}" ]; then
        tmux has-session -t "=$session" 2>/dev/null || tmux new-session -d -s "$session"
        tmux switch-client -t "=$session"
    elif tmux has-session -t "=$session" 2>/dev/null; then
        tmux attach -t "=$session"
    else
        tmux new-session -s "$session"
    fi
}

# with-retry runs a command until it succeeds: up to RETRY_MAX_ATTEMPTS tries
# (default 20) with RETRY_DELAY_SEC seconds (default 1) between them.
#
#   with-retry curl -fsS https://example.com
#   RETRY_DELAY_SEC=2 RETRY_MAX_ATTEMPTS=5 with-retry make test
with-retry() {
    if [ "$#" -eq 0 ]; then
        printf "with-retry: no command given\n" >&2
        return 2
    fi

    local delay="${RETRY_DELAY_SEC:-1}"
    local max_attempts="${RETRY_MAX_ATTEMPTS:-20}"
    local attempt=1
    local rc=0

    while [ "$attempt" -le "$max_attempts" ]; do
        rc=0
        "$@" || rc=$?
        [ "$rc" -eq 0 ] && return 0

        if [ "$attempt" -lt "$max_attempts" ]; then
            printf "with-retry: attempt %d/%d failed (exit %d); retrying in %ss\n" \
                "$attempt" "$max_attempts" "$rc" "$delay" >&2
            sleep "$delay"
        fi
        attempt=$((attempt + 1))
    done

    printf "with-retry: gave up after %d attempts (last exit %d)\n" "$max_attempts" "$rc" >&2
    return "$rc"
}

# pass-fzf: pick an entry from password-store with fzf and copy it.
pass-fzf() {
    local store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
    local selected

    if ! command -v pass >/dev/null 2>&1 || [ ! -d "$store" ]; then
        printf "pass-fzf: pass or %s is missing\n" "$store" >&2
        return 1
    fi

    selected=$(
        cd "$store" && find . -type f -name "*.gpg" | sed 's#^\./##; s#\.gpg$##' | sort | fzf --prompt="pass> "
    ) || return 0
    [ -n "$selected" ] && pass -c "$selected"
}
