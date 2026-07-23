# dotfiles

Личные конфиги. Структура репозитория повторяет структуру `$HOME` — путь
файла в репо совпадает с путём относительно домашней директории
(`.vimrc` → `~/.vimrc`, `.config/nvim` → `~/.config/nvim` и т.д.).

## Установка на новой машине

```sh
git clone git@github.com:r2bln/dotfiles.git ~/sources/dotfiles
cd ~/sources/dotfiles
make install
```

`make install` делает по порядку:

| Таргет     | Что делает |
|------------|------------|
| `packages` | ставит пакеты через `pacman` (см. список ниже) |
| `link`     | симлинкает файлы из репо в `$HOME`, существующий файл/симлинк с другим содержимым бэкапится в `<файл>.bak` |
| `editor`   | добавляет `export EDITOR=nvim` / `VISUAL=nvim` в `~/.bashrc`, если их там ещё нет |
| `plugins`  | ставит плагины Neovim (`nvim --headless "+Lazy! sync" +qa`) |

Таргеты идемпотентны, `make install` можно перезапускать безопасно.
Пакеты (`packages`): `git tmux btop neovim base-devel tree-sitter-cli
ripgrep fd unzip nodejs npm curl`. `base-devel`/`tree-sitter-cli` нужны,
чтобы компилировались парсеры treesitter и `telescope-fzf-native`;
`ripgrep`/`fd` — для telescope; `nodejs`/`npm` — часть LSP-серверов
(ts_ls, bashls, jsonls, yamlls) ставится через них.

## .gitconfig

Трекается целиком (`user.email`, `user.name`, `core.editor = nvim`,
`init.defaultBranch = main`). Меняется прямо в репо, а не через
`git config --global`.

## Neovim

`.config/nvim`, менеджер плагинов — [lazy.nvim](https://github.com/folke/lazy.nvim)
(ставится и обновляется сам при первом запуске).

```
.config/nvim/
├── init.lua                 -- require config.options / config.lazy / config.keymaps
└── lua/
    ├── config/
    │   ├── options.lua      -- vim.opt: табы=4, ignorecase, number, nowrap...
    │   ├── lazy.lua          -- bootstrap lazy.nvim, require("lazy").setup("plugins")
    │   └── keymaps.lua      -- глобальные маппинги
    └── plugins/              -- один файл = один lazy-спек (или группа), подхватывается автоматически
        ├── colorscheme.lua   -- gruvbox (по умолчанию) + badwolf
        ├── treesitter.lua    -- подсветка/indent/folds
        ├── lsp.lua           -- mason + mason-lspconfig + nvim-lspconfig
        ├── cmp.lua           -- nvim-cmp + LuaSnip
        ├── telescope.lua     -- fuzzy finder
        ├── tree.lua          -- nvim-tree (файловое дерево)
        ├── git.lua           -- gitsigns + vim-fugitive
        ├── ui.lua            -- lualine, indent-blankline, which-key
        ├── editor.lua        -- autopairs, Comment.nvim
        └── claudecode.lua    -- интеграция с Claude Code CLI
```

Новый плагин = новый (или дополненный) файл в `lua/plugins/`, возвращающий
lazy-спек (`return { "author/repo", opts = {...} }`). Перезапустить nvim
или `:Lazy sync` — поставится само.

### Языки с LSP из коробки (mason ensure_installed)

`lua_ls, pyright, ts_ls, bashls, clangd, rust_analyzer, gopls, jsonls,
yamlls, marksman`. Добавить сервер — дописать в список внутри
`lua/plugins/lsp.lua`.

### Клавиши

Общие (config/keymaps.lua):

| Клавиша      | Действие |
|--------------|----------|
| `<Tab>`      | переключить файловое дерево (nvim-tree) |
| `<C-p>`      | найти файл (telescope) |
| `<leader>fg` | grep по проекту (telescope) |
| `<leader>fb` | список буферов (telescope) |
| `<C-k>`      | символы документа (LSP, через telescope) |
| `<F12>`      | `:make` |
| `gd` / `gr`  | перейти к определению / ссылкам (LSP, после LspAttach) |
| `K`          | hover (LSP) |
| `<leader>rn` | rename (LSP) |
| `<leader>ca` | code action (LSP) |
| `<leader>e`  | диагностика по строке |
| `[d` / `]d`  | пред./след. диагностика |
| `<leader>w`  | сохранить |
| `<leader>q`  | закрыть |

`<leader>` — пробел. Полный список открывается через **which-key**
сам по себе — набери `<leader>` и подожди, покажет подсказку.

Claude Code (`lua/plugins/claudecode.lua`), требует установленный `claude`
в `$PATH`:

| Клавиша      | Действие |
|--------------|----------|
| `<leader>ac` | открыть/закрыть Claude |
| `<leader>af` | фокус на Claude |
| `<leader>ab` | добавить текущий буфer в контекст |
| `<leader>as` | (в visual mode) отправить выделение в Claude |
| `<leader>aa` / `<leader>ad` | принять / отклонить предложенный diff |

## Обновление плагинов

```
nvim
:Lazy sync
```

или `make plugins`.
