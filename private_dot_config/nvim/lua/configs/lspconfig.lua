require("nvchad.configs.lspconfig").defaults()

-- Override NvChad's on_init to NOT disable semantic tokens (blink.cmp needs them)
-- and inject blink.cmp capabilities into all LSP clients
vim.lsp.config("*", {
  on_init = function(client, _)
    -- intentionally empty: do NOT disable semantic tokens like NvChad does
  end,
  capabilities = require("blink.cmp").get_lsp_capabilities({}, true),
})

-- Disable LSP file watching to prevent EMFILE on macOS
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    if client.capabilities and client.capabilities.workspace then
      client.capabilities.workspace.didChangeWatchedFiles = client.capabilities.workspace.didChangeWatchedFiles or {}
      client.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
    end
  end,
  desc = "Disable LSP file watching",
})

-- Basic LSP servers (using defaults)
vim.lsp.enable "html"
vim.lsp.enable "css"
vim.lsp.enable "emmet_language_server"
-- Configure clangd (C/C++ LSP)
vim.lsp.config("clangd", {
  -- Disable clangd's formatting (we use conform.nvim with clang-format)
  -- This prevents conflicts between clangd formatting and conform.nvim
  init_options = {
    clangdFileStatus = true,
  },
})

vim.lsp.enable "clangd"

-- Configure pyright (Python type checker)
vim.lsp.config("pyright", {
  settings = {
    pyright = {
      -- Disable pyright's formatting (we use ruff via conform.nvim)
      disableOrganizeImports = false,
    },
    python = {
      analysis = {
        typeCheckingMode = "basic", -- "off", "basic", "strict"
        autoImportCompletions = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.enable "pyright"

-- Configure ruff (Python linter/formatter)
vim.lsp.config("ruff", {
  -- Ruff handles linting, formatting is done via conform.nvim
  init_options = {
    settings = {
      -- Ruff will use pyproject.toml or ruff.toml if present
    },
  },
})

vim.lsp.enable "ruff"

-- Configure oxlint (JavaScript/TypeScript linter from Oxide Project)
vim.lsp.config("oxlint", {
  cmd = { "oxlint", "--lsp" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { ".git" },
})

vim.lsp.enable "oxlint"

-- Configure jsonls (JSON language server)
vim.lsp.config("jsonls", {
  settings = {
    json = {
      -- Use schemastore if available (install b0o/schemastore.nvim for JSON schema support)
      schemas = (function()
        local ok, schemastore = pcall(require, "schemastore")
        return ok and schemastore.json.schemas() or {}
      end)(),
      validate = { enable = true },
    },
  },
})

vim.lsp.enable "jsonls"

-- Configure zls (Zig language server)
vim.lsp.config("zls", {
  filetypes = { "zig", "zon" },
})

vim.lsp.enable "zls"

-- Configure gopls (Go language server)
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        fieldalignment = true,
        nilness = true,
        shadow = true,
      },
    },
  },
})

vim.lsp.enable "gopls"

-- Configure tailwindcss (Tailwind CSS IntelliSense)
vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          -- Support for class-variance-authority (cva)
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          -- Support for clsx
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          -- Support for tailwind-variants (tv)
          { "tv\\((([^()]*|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
        },
      },
    },
  },
})

vim.lsp.enable "tailwindcss"

-- Configure typescript-tools (TypeScript/JavaScript)
require("typescript-tools").setup {
  tsserver_path = nil,
}
