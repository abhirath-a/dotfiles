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
  "biome",
  "elixirls",
  "tinymist",
  "svelte",
  "tailwindcss",
  "ruff",
  "jdtls",
  "clangd",
  "oxfmt"
})

vim.lsp.config("astro", {
  init_options = {
    typescript = {
      tsdk = require('nix-info').settings.tssdk,
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})

vim.lsp.enable("astro")
