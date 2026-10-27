#!/usr/bin/env bash
# Hook sh/{exports,aliases,helpers}.sh into ~/.zshrc.

set -euo pipefail

# shellcheck source=sh/setup/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

main() {
    info "🐚 Configuring ~/.zshrc..."

    local block
    block="export DOTFILES_DIR=\"$DOTFILES_DIR\"
for f in exports aliases helpers; do
    [ -f \"\$DOTFILES_DIR/sh/\$f.sh\" ] && source \"\$DOTFILES_DIR/sh/\$f.sh\"
done
unset f"

    add_block "$HOME/.zshrc" "dotfiles" "$block"
}

main "$@"
