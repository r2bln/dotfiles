DOTFILES_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
OS_ID := $(shell sh -c '. /etc/os-release 2>/dev/null; echo "$$ID $$ID_LIKE"' | tr '[:upper:]' '[:lower:]')

NVIM_MIN_VERSION := 0.12.0
NVIM_INSTALL_DIR := $(HOME)/.local/opt/nvim
NVIM_TARBALL_URL := https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

NVM_DIR := $(HOME)/.nvm
NVM_VERSION := v0.40.4
NVM_INSTALL_URL := https://raw.githubusercontent.com/nvm-sh/nvm/$(NVM_VERSION)/install.sh

ifneq (,$(findstring arch,$(OS_ID)))
	DISTRO := arch
	PKG_INSTALL := sudo pacman -S --needed --noconfirm
	PACKAGES := git tmux btop neovim base-devel ripgrep fd unzip curl
else ifneq (,$(findstring debian,$(OS_ID)))
	DISTRO := debian
	PKG_INSTALL := sudo apt-get update && sudo apt-get install -y
	PACKAGES := git tmux btop build-essential ripgrep fd-find unzip curl
else
	$(error Неизвестный дистрибутив ($(OS_ID)). Допиши PACKAGES/PKG_INSTALL в Makefile)
endif

LINKS := .vimrc:.vimrc .config/nvim:.config/nvim .gitconfig:.gitconfig

.PHONY: install packages nvim fd-shim node tools link shell-env plugins

install: packages nvim fd-shim node tools link shell-env plugins

packages:
	$(PKG_INSTALL) $(PACKAGES)

# На Arch neovim ставится пакетом (rolling, всегда свежий). На Debian
# пакет в apt обычно слишком старый для nvim-treesitter (нужен >= $(NVIM_MIN_VERSION)),
# поэтому при устаревшей/отсутствующей версии тянем официальный релиз с GitHub
# в $(NVIM_INSTALL_DIR) и линкуем бинарник в ~/.local/bin.
nvim:
ifeq ($(DISTRO),debian)
	@mkdir -p "$(HOME)/.local/bin"
	@if command -v nvim >/dev/null 2>&1 && dpkg --compare-versions "$$(nvim --version | head -1 | awk '{print $$2}' | sed 's/^v//')" ge $(NVIM_MIN_VERSION); then \
		echo "nvim $$(nvim --version | head -1) уже подходит"; \
	else \
		echo "ставлю nvim >= $(NVIM_MIN_VERSION) с GitHub releases в $(NVIM_INSTALL_DIR)"; \
		mkdir -p "$(NVIM_INSTALL_DIR)"; \
		curl -fsSL "$(NVIM_TARBALL_URL)" -o /tmp/nvim-dotfiles.tar.gz; \
		tar -xzf /tmp/nvim-dotfiles.tar.gz --strip-components=1 -C "$(NVIM_INSTALL_DIR)"; \
		rm -f /tmp/nvim-dotfiles.tar.gz; \
		ln -sfn "$(NVIM_INSTALL_DIR)/bin/nvim" "$(HOME)/.local/bin/nvim"; \
	fi
else
	@true
endif

# Debian даёт fd-find с бинарником fdfind — линкуем его как fd, чтобы telescope находил.
fd-shim:
ifeq ($(DISTRO),debian)
	@mkdir -p "$(HOME)/.local/bin"
	@if command -v fdfind >/dev/null 2>&1 && [ ! -e "$(HOME)/.local/bin/fd" ]; then \
		ln -s "$$(command -v fdfind)" "$(HOME)/.local/bin/fd"; \
	fi
else
	@true
endif

# node/npm ставим через nvm, а не пакетным менеджером: в apt/pacman версии
# либо старые, либо требуют sudo для глобальных npm-пакетов. nvm сам держит
# node в $(HOME) и добавляет свой блок инициализации в ~/.bashrc.
node:
	@if [ ! -s "$(NVM_DIR)/nvm.sh" ]; then \
		echo "ставлю nvm $(NVM_VERSION)"; \
		curl -fsSL "$(NVM_INSTALL_URL)" | bash; \
	fi
	@bash -c '. "$(NVM_DIR)/nvm.sh" && nvm install stable && nvm alias default stable'

# tree-sitter-cli нужен для компиляции парсеров nvim-treesitter; ставим через
# npm из nvm (без sudo — глобальные пакеты ставятся в $(NVM_DIR)).
tools:
	@bash -c '. "$(NVM_DIR)/nvm.sh" && nvm use stable && npm install -g tree-sitter-cli'

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

shell-env:
	grep -qxF 'export PATH="$$HOME/.local/bin:$$PATH"' "$(HOME)/.bashrc" || echo 'export PATH="$$HOME/.local/bin:$$PATH"' >> "$(HOME)/.bashrc"
	grep -qxF 'export EDITOR=nvim' "$(HOME)/.bashrc" || echo 'export EDITOR=nvim' >> "$(HOME)/.bashrc"
	grep -qxF 'export VISUAL=nvim' "$(HOME)/.bashrc" || echo 'export VISUAL=nvim' >> "$(HOME)/.bashrc"
	grep -qxF 'alias e='"'"'$$EDITOR'"'"'' "$(HOME)/.bashrc" || echo 'alias e='"'"'$$EDITOR'"'"'' >> "$(HOME)/.bashrc"
	grep -qxF 'alias sudo='"'"'sudo '"'"'' "$(HOME)/.bashrc" || echo 'alias sudo='"'"'sudo '"'"'' >> "$(HOME)/.bashrc"

plugins:
	nvim --headless "+Lazy! sync" +qa
