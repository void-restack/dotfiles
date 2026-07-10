require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Override NvChad's telescope mappings with fff + snacks.picker
map("n", "<leader>ff", function() require("fff").find_files() end, { desc = "Find files (fff)" })
map("n", "<leader>fw", function() require("fff").live_grep() end, { desc = "Live grep (fff)" })
map("n", "<leader>fo", function() require("fff").find_files() end, { desc = "Recent files (fff)" })
map("n", "<leader>fa", function() Snacks.picker.files { hidden = true, ignored = true } end, { desc = "Find all files" })
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- LSP mappings
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP Implementation" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map("n", "<leader>gf", function() vim.lsp.buf.format { async = true } end, { desc = "Format buffer" })
map("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })