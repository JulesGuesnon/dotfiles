local should_eslint_start = require("utils.file_exists").file_exists("./.eslintrc.json")

local lint = require("lint")

lint.linters.detekt = {
  cmd = "detekt", -- or full path if not in PATH
  stdin = false,
  append_fname = false,
  args = {
    "--input",
    function()
      return vim.fn.expand("%:p")
    end,
  },
  stream = "stdout",
  ignore_exitcode = true,
  parser = require("lint.parser").from_pattern(
    -- adjust pattern to match detekt output
    "^(.-):(%d+):(%d+):%s*(.+)$",
    { "file", "lnum", "col", "message" }
  ),
}

return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = should_eslint_start and {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    } or {
      kotlin = { "ktlint", "detekt" },
    },
  },
}
