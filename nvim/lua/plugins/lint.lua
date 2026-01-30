return {
  "mfussenegger/nvim-lint",
  config = function(_, opts)
    local lint = require("lint")

    -- Define custom detekt linter
    lint.linters.detekt = {
      cmd = "detekt",
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
        "^(.-):(%d+):(%d+):%s*(.+)$",
        { "file", "lnum", "col", "message" }
      ),
    }

    -- Apply opts
    for k, v in pairs(opts.linters_by_ft or {}) do
      lint.linters_by_ft[k] = v
    end
  end,
  opts = function()
    local should_eslint_start = require("utils.file_exists").file_exists("./.eslintrc.json")
    return {
      linters_by_ft = should_eslint_start and {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      } or {
        kotlin = { "ktlint", "detekt" },
      },
    }
  end,
}
