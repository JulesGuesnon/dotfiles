return {
  "coffebar/neovim-project",
  opts = {
    projects = { -- define project roots
      "~/Dev/*",
      "~/Dev/weft/libs/arene/*",
      "~/Dev/weft/apps/arene/*",
      "~/Dev/weft/apps/weft/*",
      "~/Dev/weft/libs/weft/*",
      "~/.config/nvim",
    },
    picker = {
      type = "telescope", -- or "fzf-lua"
    },
  },
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "Shatur/neovim-session-manager" },
  },
  keys = {
    { "<leader>p", "<cmd>NeovimProjectDiscover<CR>", desc = "Open projects" },
  },
  cmd = { "NeovimProjectDiscover", "NeovimProjectHistory", "NeovimProjectLoadRecent" },
}
