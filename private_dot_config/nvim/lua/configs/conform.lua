local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    typescript = { "oxfmt", "biome" },
    javascript = { "oxfmt", "biome" },
    typescriptreact = { "oxfmt", "biome" },
    javascriptreact = { "oxfmt", "biome" },
    json = { "oxfmt", "biome" },
    jsonc = { "oxfmt", "biome" },
    go = { "golines", "goimports-reviser", "gofumpt" },
    yaml = { "yamlfmt" },
    sql = { "sqruff" },
    python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    ["c++"] = { "clang-format" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },

  formatters = {
    ["clang-format"] = {
      args = { "-style={BasedOnStyle: LLVM}" },
    },
    ["golines"] = {
      args = { "--max-len=100" },
    },
  },
}

return options
