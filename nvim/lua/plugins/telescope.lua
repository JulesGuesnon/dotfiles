return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "%.git/" },
        vimgrep_arguments = {
          "rg",
          "--hidden",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      },
    },
    keys = {
      {
        "<leader><Space>",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
          })
        end,
        desc = "Find Files (cwd)",
      },
    },
  },
}
