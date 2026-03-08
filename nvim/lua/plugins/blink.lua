return {
  {
    "saghen/blink.cmp",
    version = "v1.*",
    enabled = true,
    opts = {
      -- Force Lua implementation to avoid async loading issues
      -- The Rust implementation is faster but requires downloading binaries
      -- Lua works immediately without download
      fuzzy = {
        implementation = "lua",
      },
    },
  },
}
