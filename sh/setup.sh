#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR=$(realpath $(dirname $0)/../../)

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
    printf "💥 \033[1;31m%s\033[0m\n" "$1"
}

warning() {
    printf "⚠️ \033[1;33m%s\033[0m\n" "$1"
}

debug "dotfile root path: $DOTFILES_DIR"

symlink() {
    local target="$1"
    local link="$2"

    if [ ! -e "$link" ]; then
        ln -sv "$target" "$link"
        success "Added symlink $link to $target"
    elif [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
        debug "Symlink already exists: $link"
    else
        warning "$link exists but is not a symlink to $target"
    fi
}

setup_links_to_config_files() {
    info "⚙️ Setting up config links..."
    local config_dir="$HOME/.config"
    mkdir -pv "$config_dir"

    # Main config links
    symlink "$DOTFILES_DIR/nvim" "$config_dir/nvim"
    symlink "$DOTFILES_DIR/aichat" "$config_dir/aichat"
    symlink "$DOTFILES_DIR/alacritty" "$config_dir/alacritty"

    # Home directory links
    symlink "$DOTFILES_DIR/.golangci.yml" "$HOME_DIR/.golangci.yml"
    symlink "$DOTFILES_DIR/.tmux.conf" "$HOME_DIR/.tmux.conf"
}

main() {
 setup_links_to_config_files 
}

main "$@"
