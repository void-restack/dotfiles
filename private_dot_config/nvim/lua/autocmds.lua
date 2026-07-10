require "nvchad.autocmds"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
  end,
  desc = "Enable inlay hints on LspAttach",
})