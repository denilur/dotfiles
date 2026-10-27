SHELL := /bin/bash

LUA_FILES := $(shell git ls-files --cached --others --exclude-standard -- '*.lua')
SH_SCRIPTS := $(shell git ls-files --cached --others --exclude-standard -- 'sh/setup/*.sh' 'config/tmux/*.sh')
SH_FRAGMENTS := sh/exports.sh sh/aliases.sh sh/helpers.sh

TPM_DIR := $(HOME)/.config/tmux/plugins/tpm

.PHONY: install update brew link shell tmux-plugins nvim-plugins macos \
	check check-lua check-shell check-nvim format

## install: brew packages, config links, zsh hook, tmux and nvim plugins
install: brew link shell tmux-plugins nvim-plugins

## update: pull dotfiles, upgrade brew packages, tmux and nvim plugins
update:
	git -C "$(CURDIR)" pull --ff-only
	brew update
	brew bundle install --file=Brewfile
	brew upgrade
	$(MAKE) link tmux-plugins
	"$(TPM_DIR)/bin/update_plugins" all
	nvim --headless -c 'lua vim.pack.update(nil, { force = true })' -c 'TSUpdate' -c 'qa'

brew:
	brew bundle install --file=Brewfile

link:
	./sh/setup/link.sh

shell:
	./sh/setup/shell.sh

tmux-plugins:
	@[ -d "$(TPM_DIR)" ] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$(TPM_DIR)"
	"$(TPM_DIR)/bin/install_plugins"

## nvim-plugins: install plugins pinned in nvim-pack-lock.json
nvim-plugins:
	nvim --headless -c 'qa'

## macos: opt-in macOS defaults (key repeat, Finder, Dock)
macos:
	./sh/setup/macos.sh

check: check-lua check-shell check-nvim

check-lua:
	luacheck $(LUA_FILES)
	stylua --check $(LUA_FILES)

check-shell:
	shellcheck -x $(SH_SCRIPTS)
	shellcheck -s bash $(SH_FRAGMENTS)

## check-nvim: start the real config headless and fail on any startup error
check-nvim:
	nvim --headless -c 'lua if #vim.v.errmsg > 0 then print(vim.v.errmsg) vim.cmd.cquit() end' -c 'qa' 2>&1 \
		| tee /dev/stderr | (! grep -qE 'E[0-9]+:|Error')

format:
	stylua $(LUA_FILES)
