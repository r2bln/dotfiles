local map = vim.keymap.set

map("n", "<Tab>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Grep in project" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<C-k>", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })

map("n", "<F12>", "<cmd>make<CR>", { desc = "Make" })

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

map("v", "<C-y>", '"+y', { desc = "Yank selection to system clipboard" })

-- Ctrl-hjkl window navigation (works from normal mode and from inside terminals like Claude Code)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Window left" })
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Window down" })
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Window up" })
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Window right" })
