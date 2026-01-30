-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<leader><Space>", "<leader>fF", { desc = "Find Files (cwd)", remap = true })
map("n", "<S-g>", "<S-g>zz", { desc = "Go to bottom of the file", remap = true })
map("n", "}", "}zz", { desc = "Jump paragraph", remap = true })
map("n", "{", "{zz", { desc = "Jump paragraph", remap = true })

vim.keymap.set("n", "<leader>db", "_v$%$y$%o<Esc>o<Esc>p", { desc = "Duplicate block", noremap = true })
vim.keymap.set("n", "<TAB>", ">>")
vim.keymap.set("n", "<S-TAB>", "<<")

vim.keymap.set("n", "<leader>k", "<cmd>LazyDocker<CR>", { desc = "Toggle LazyDocker", noremap = true, silent = true })



