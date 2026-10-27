#!/usr/bin/env bash
# Opt-in macOS defaults. Run via `make macos`.

set -euo pipefail

# shellcheck source=sh/setup/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

main() {
    if ! is_mac; then
        error "macOS only"
        return 1
    fi

    info "⚙️ Applying macOS defaults..."

    # Key repeat instead of the accent popup: holding hjkl repeats in vim.
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    defaults write com.apple.dock autohide -bool true

    killall Dock Finder SystemUIServer >/dev/null 2>&1 || true
    success "macOS defaults applied (key repeat needs re-login)"
}

main "$@"
