local overrides = require "configs.overrides"

return {
  -- ── Disable nvim-cmp (replaced by blink.cmp) ──
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
  },

  -- ── FFF: fast fuzzy file finder ──
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    cmd = { "FFFScan", "FFFRefreshGit", "FFFHealth" },
    opts = {
      lazy_sync = false,
      layout = {
        height = 0.8,
        width = 0.8,
        prompt_position = "bottom",
        preview_position = "right",
        preview_size = 0.5,
      },
      preview = {
        enabled = true,
      },
      frecency = {
        enabled = true,
      },
    },
    keys = {
      { "fz", function() require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } }) end, desc = "FFF fuzzy grep" },
      { "fc", function() require("fff").live_grep({ query = vim.fn.expand("<cword>") }) end, desc = "FFF search word under cursor" },
    },
  },

  -- ── Core: snacks.nvim ──
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = false },
      terminal = { enabled = true },
      lazygit = { enabled = true },
      zen = { enabled = true },
    },
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>z", function() Snacks.zen() end, desc = "Zen Mode" },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Zoom" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Scratch" },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
      { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
    },
  },

  -- ── Snippets ──
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function()
      require("luasnip").config.set_config { history = true, updateevents = "TextChanged,TextChangedI" }
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- ── Autopairs ──
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
    end,
  },

  -- ── Completion: blink.cmp ──
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.lib", "saghen/blink.compat", "rafamadriz/friendly-snippets" },
    build = function()
      require("blink.cmp").build():pwait()
    end,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "enter" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = true },
        menu = {
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = { preset = "luasnip" },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },

  -- ── Formatting ──
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- ── LSP ──
  {
    "neovim/nvim-lspconfig",
    dependencies = "pmizio/typescript-tools.nvim",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- ── LSP progress notifications ──
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- ── Mason ──
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  -- ── Treesitter ──
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "html",
        "css",
        "javascript",
        "json",
        "toml",
        "markdown",
        "c",
        "bash",
        "lua",
        "tsx",
        "typescript",
        "go",
        "rust",
        "zig",
        "sql",
        "yaml",
        "dockerfile",
        "terraform",
        "regex",
        "mermaid",
        "python",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    },
    dependencies = {
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup()
        end,
      },
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    ft = {
      "astro",
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "markdown",
      "glimmer",
      "handlebars",
      "hbs",
    },
    config = function()
      require("ts_context_commentstring").setup {
        enable_autocmd = false,
      }
    end,
  },

  -- ── Comment ──
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {},
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },

  -- ── Folds ──
  {
    "kevinhwang91/nvim-ufo",
    event = "VimEnter",
    init = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldnestmax = 99
      vim.o.foldenable = true
      vim.o.foldmethod = "indent"

      vim.opt.fillchars = {
        fold = " ",
        foldopen = "▾",
        foldsep = " ",
        foldclose = "▸",
        stl = " ",
        eob = " ",
      }
    end,
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        opts = function()
          local builtin = require "statuscol.builtin"
          return {
            relculright = true,
            bt_ignore = { "nofile", "prompt", "terminal", "packer" },
            ft_ignore = {
              "NvimTree",
              "dashboard",
              "nvcheatsheet",
              "dapui_watches",
              "dap-repl",
              "dapui_console",
              "dapui_stacks",
              "dapui_breakpoints",
              "dapui_scopes",
              "help",
              "vim",
              "alpha",
              "dashboard",
              "neo-tree",
              "Trouble",
              "noice",
              "lazy",
              "toggleterm",
              "mason",
            },
            segments = {
              {
                text = { " ", " ", builtin.lnumfunc, " " },
                click = "v:lua.ScLa",
                condition = { true, builtin.not_empty },
              },
            },
          }
        end,
      },
    },
    opts = {
      close_fold_kinds_for_ft = { default = { "imports" } },
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },

  -- ── Diagnostics ──
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TodoTrouble" },
    dependencies = {
      {
        "folke/todo-comments.nvim",
        opts = {},
      },
    },
    config = function()
      dofile(vim.g.base46_cache .. "trouble")
      require("trouble").setup()
    end,
  },

  -- ── Rust ──
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
  },

  -- ── Markdown ──
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown" },
    },
    ft = { "markdown" },
  },

  -- ── Git Signs ──
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set
        map("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
        map("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Prev hunk" })
        map("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
        map("n", "<leader>hb", gs.blame_line, { buffer = bufnr, desc = "Blame line" })
        map("v", "<leader>hs", function()
          gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { buffer = bufnr, desc = "Stage hunk" })
      end,
    },
  },

  -- ── Surround ──
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {},
  },

  -- ── SQL: dadbod ──
  {
    "tpope/vim-dadbod",
    cmd = "DB",
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = "tpope/vim-dadbod",
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
    init = function()
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = vim.fn.stdpath "config" .. "/db_ui"
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    dependencies = "tpope/vim-dadbod",
  },

  -- ── File explorer: nvim-tree ──
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filesystem_watchers = { enable = false },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      view = {
        width = 35,
      },
    },
  },

  -- ── Git: neogit ──
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      kind = "tab",
    },
    keys = {
      { "<leader>gn", "<cmd>Neogit<CR>", desc = "Neogit" },
    },
  },

  -- ── Code outline ──
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    opts = {},
    keys = {
      { "<leader>ao", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
    },
    config = function(_, opts)
      require("aerial").setup(opts)
    end,
  },

  -- ── Which-key ──
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps",
      },
    },
  },

  -- ── Quick file switching ──
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon mark" },
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
    },
  },

  -- ── Project-wide find & replace ──
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      { "<leader>rs", "<cmd>RipSubstitute<CR>", desc = "Rip Substitute" },
    },
  },

  -- ── NvChad community ──
  "NvChad/nvcommunity",
  { import = "nvcommunity.git.lazygit" },
  { import = "nvcommunity.lsp.prettyhover" },
}
