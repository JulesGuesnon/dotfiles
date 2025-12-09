return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = true,
    opts = {},
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
-- return {
--   {
--     "folke/tokyonight.nvim",
--     lazy = true,
--     opts = {
--       style = "night",
--       on_colors = function(colors)
--         colors.bg = "#0e1116"
--         colors.bg_dark = "#050608"
--         colors.bg_sidebar = "#050608"
--       end,
--       on_highlights = function(hl, _c)
--         local purple = "#9990e0"
--         hl["@type.builtin"] = {
--           fg = purple,
--         }
--         hl["@type"] = {
--           fg = purple,
--         }
--         hl.IlluminatedWordRead = {
--           fg = purple,
--         }
--         hl.IlluminatedWordText = {
--           fg = purple,
--         }
--         hl.IlluminatedWordWrite = {
--           fg = purple,
--         }
--         hl["@lsp.type.struct"] = {
--           link = "@type",
--         }
--         hl["@lsp.type.typeAlias"] = {
--           link = "@type",
--         }
--       end,
--     },
--   },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "tokyonight",
--     },
--   },
-- }

-- return {
--   {
--     "folke/tokyonight.nvim",
--     lazy = true,
--     opts = {
--       style = "day",
--     },
--   },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "tokyonight",
--     },
--   },
-- }
