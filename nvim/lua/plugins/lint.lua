local tooling = require("utils.tooling")

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
      parser = require("lint.parser").from_pattern("^(.-):(%d+):(%d+):%s*(.+)$", { "file", "lnum", "col", "message" }),
    }

    -- Apply opts
    for k, v in pairs(opts.linters_by_ft or {}) do
      lint.linters_by_ft[k] = v
    end
  end,
  opts = function()
    local linter = tooling.get_linter()

    local linters_by_ft = {
      -- Kotlin - always lint
      kotlin = { "ktlint", "detekt" },
    }

    -- Only add JS/TS linting if eslint is the selected linter
    -- (oxlint and biome are handled by their LSP servers)
    if linter == "eslint_d" then
      linters_by_ft.javascript = { "eslint_d" }
      linters_by_ft.typescript = { "eslint_d" }
      linters_by_ft.javascriptreact = { "eslint_d" }
      linters_by_ft.typescriptreact = { "eslint_d" }
    end

    return {
      linters_by_ft = linters_by_ft,
    }
  end,
}
