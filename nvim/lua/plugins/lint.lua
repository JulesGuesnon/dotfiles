local should_eslint_start = require("utils.file_exists").file_exists("./.eslintrc.json")

return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = should_eslint_start and {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    } or {},
  },
}
