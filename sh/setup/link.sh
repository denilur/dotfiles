#!/usr/bin/env bash
# Symlink configs from config/ into $HOME.

set -euo pipefail

# shellcheck source=sh/setup/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

main() {
    info "⚙️ Linking configs..."

    symlink "$CONFIG_DIR/nvim" "$XDG_CONFIG/nvim"
    symlink "$CONFIG_DIR/ghostty" "$XDG_CONFIG/ghostty"
    symlink "$CONFIG_DIR/yazi" "$XDG_CONFIG/yazi"
    symlink "$CONFIG_DIR/lazygit/config.yml" "$XDG_CONFIG/lazygit/config.yml"
    symlink "$CONFIG_DIR/worktrunk/config.toml" "$XDG_CONFIG/worktrunk/config.toml"

    # tmux >= 3.1 reads ~/.config/tmux/tmux.conf only when ~/.tmux.conf is absent.
    symlink "$CONFIG_DIR/tmux/tmux.conf" "$XDG_CONFIG/tmux/tmux.conf"
    symlink "$CONFIG_DIR/tmux/theme-dark.conf" "$XDG_CONFIG/tmux/theme-dark.conf"
    symlink "$CONFIG_DIR/tmux/theme-light.conf" "$XDG_CONFIG/tmux/theme-light.conf"
    symlink "$CONFIG_DIR/tmux/theme-watch.sh" "$XDG_CONFIG/tmux/theme-watch.sh"
    local legacy
    for legacy in .tmux.conf .tmux-theme-dark.conf .tmux-theme-light.conf .tmux-theme-watch.sh; do
        if [ -L "$HOME/$legacy" ]; then
            rm "$HOME/$legacy"
            warning "removed legacy link ~/$legacy"
        fi
    done

    # Git: shared settings live in ~/.config/git/config; ~/.gitconfig stays
    # local (user, tokens) and takes precedence.
    symlink "$CONFIG_DIR/git/config" "$XDG_CONFIG/git/config"
    symlink "$CONFIG_DIR/git/ignore" "$XDG_CONFIG/git/ignore"

    # golangci-lint falls back to a config in $HOME.
    symlink "$CONFIG_DIR/golangci.yml" "$HOME/.golangci.yml"

    # Dangling link left from the removed alacritty config.
    if [ -L "$XDG_CONFIG/alacritty" ] && [ ! -e "$XDG_CONFIG/alacritty" ]; then
        rm "$XDG_CONFIG/alacritty"
        warning "removed dangling $XDG_CONFIG/alacritty"
    fi
}

main "$@"
