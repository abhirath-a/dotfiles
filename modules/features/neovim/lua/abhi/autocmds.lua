vim.api.nvim_create_autocmd("FileType", {
  callback = function() pcall(vim.treesitter.start) end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = event.buf })
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { buffer = event.buf })
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.hl_op() end,
})
