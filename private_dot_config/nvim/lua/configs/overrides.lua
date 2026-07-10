local M = {}

M.mason = {
  ensure_installed = {
    -- LSP servers
    "lua-language-server",
    "html-lsp",
    "css-lsp",
    "eslint-lsp",
    "json-lsp",
    "gopls",
    "pyright",
    "ruff",
    "tailwindcss-language-server",
    "emmet-language-server",
    "clangd",
    "zls",
    "oxlint",
    -- Formatters
    "stylua",
    "prettierd",
    "biome",
    "golines",
    "goimports-reviser",
    "gofumpt",
    "clang-format",
    "yamlfmt",
    "sqruff",
  },
}

return M
