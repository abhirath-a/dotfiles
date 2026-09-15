require("abhi.opts")
require("abhi.keymaps")
require("abhi.autocmds")

require("kanso").setup({ transparent = true })

vim.cmd.colorscheme("kanso-zen")

vim.lsp.enable({
  "lua_ls",
  "gopls",
  "nil_ls",
  "ty",
  "tsgo",
  "rust_analyzer",
  "astro",
  "biome",
  "elixirls",
  "tinymist",
  "svelte",
  "tailwindcss",
  "ruff",
  "jdtls",
  "clangd"
})

