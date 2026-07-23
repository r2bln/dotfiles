DOTFILES_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

PACMAN_PACKAGES := git tmux btop neovim base-devel tree-sitter-cli ripgrep fd unzip nodejs npm curl

LINKS := .vimrc:.vimrc .config/nvim:.config/nvim .gitconfig:.gitconfig

.PHONY: install packages link editor plugins

install: packages link editor plugins

packages:
	sudo pacman -S --needed --noconfirm $(PACMAN_PACKAGES)

link:
	@for pair in $(LINKS); do \
		src="$(DOTFILES_DIR)/$${pair%%:*}"; \
		dst="$(HOME)/$${pair##*:}"; \
		mkdir -p "$$(dirname "$$dst")"; \
		if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
			echo "ok     $$dst"; \
		else \
			if [ -e "$$dst" ] || [ -L "$$dst" ]; then \
				echo "backup $$dst -> $$dst.bak"; \
				mv "$$dst" "$$dst.bak"; \
			fi; \
			ln -sfn "$$src" "$$dst"; \
			echo "link   $$dst -> $$src"; \
		fi; \
	done

editor:
	grep -qxF 'export EDITOR=nvim' "$(HOME)/.bashrc" || echo 'export EDITOR=nvim' >> "$(HOME)/.bashrc"
	grep -qxF 'export VISUAL=nvim' "$(HOME)/.bashrc" || echo 'export VISUAL=nvim' >> "$(HOME)/.bashrc"

plugins:
	nvim --headless "+Lazy! sync" +qa
