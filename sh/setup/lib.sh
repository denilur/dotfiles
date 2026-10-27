#!/usr/bin/env bash
# Shared helpers for setup scripts. Source, don't execute.
# shellcheck disable=SC2034  # variables are used by the scripts that source this file

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"
XDG_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

debug() {
    printf "\033[1;37m%s\033[0m\n" "$1"
}

info() {
    printf "\n\033[1;34m%s\033[0m\n" "$1"
}

success() {
    printf "✅ \033[1;32m%s\033[0m\n" "$1"
}

error() {
    printf "💥 \033[1;31m%s\033[0m\n" "$1" >&2
}

warning() {
    printf "⚠️ \033[1;33m%s\033[0m\n" "$1"
}

is_mac() {
    [ "$(uname -s)" = "Darwin" ]
}

# symlink TARGET LINK
# Creates LINK -> TARGET. An existing file/dir/foreign symlink at LINK is moved
# to $BACKUP_DIR first, so nothing is lost.
symlink() {
    local target="$1"
    local link="$2"

    if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
        debug "ok: $link"
        return 0
    fi

    mkdir -p "$(dirname "$link")"

    if [ -e "$link" ] || [ -L "$link" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$link" "$BACKUP_DIR/"
        warning "moved old $link to $BACKUP_DIR/"
    fi

    ln -s "$target" "$link"
    success "$link -> $target"
}

# add_block FILE NAME CONTENT
# Idempotently writes CONTENT between "# >>> NAME >>>" / "# <<< NAME <<<" markers.
add_block() {
    local file="$1"
    local name="$2"
    local content="$3"
    local begin="# >>> $name >>>"
    local end="# <<< $name <<<"
    local tmp

    touch "$file"
    tmp="$(mktemp)"
    awk -v b="$begin" -v e="$end" '
        $0 == b { skip = 1; next }
        $0 == e { skip = 0; next }
        !skip { print }
    ' "$file" >"$tmp"
    printf "%s\n%s\n%s\n" "$begin" "$content" "$end" >>"$tmp"

    if cmp -s "$tmp" "$file"; then
        rm -f "$tmp"
        debug "ok: block '$name' in $file"
    else
        cat "$tmp" >"$file"
        rm -f "$tmp"
        success "updated block '$name' in $file"
    fi
}
