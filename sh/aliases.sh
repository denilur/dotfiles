# Sourced from ~/.zshrc (see `make shell`).

alias vim=nvim
alias nvimconfig='nvim "$DOTFILES_DIR/config/nvim/init.lua"'
alias dotfiles='cd "$DOTFILES_DIR"'

alias k=kubectl
alias ktx=kubectx
alias d=docker

alias ls="eza -l --no-user --no-permissions --git --icons --color-scale"
alias tree="eza --tree"
alias grep=rg
alias find=fd
