require("fzf-lua").setup({ fzf_colors = { bg = "-1" } })

require("fzf-lua").register_ui_select()

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua grep<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<CR>")
vim.keymap.set("n", "<leader>gw", "<cmd>FzfLua git_worktrees<CR>")
