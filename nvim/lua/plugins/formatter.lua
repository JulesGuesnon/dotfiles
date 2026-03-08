local tooling = require("utils.tooling")

-- Get the formatter based on project config files
-- Priority: oxfmt > biome > prettier > oxfmt (default)
local formatter = tooling.get_formatter()

return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      -- JavaScript/TypeScript
      ["javascript"] = { formatter },
      ["javascriptreact"] = { formatter },
      ["typescript"] = { formatter },
      ["typescriptreact"] = { formatter },
      -- JSON
      ["json"] = { formatter },
      ["jsonc"] = { formatter },
      -- Web
      ["html"] = { formatter },
      ["css"] = { formatter },
      ["scss"] = { formatter },
      ["less"] = { formatter },

      -- Vue
      ["vue"] = { formatter },

      -- Markdown
      ["markdown"] = { formatter },
      ["markdown.mdx"] = { formatter },
      ["mdx"] = { formatter },

      -- Other web formats
      ["yaml"] = { formatter },
      ["graphql"] = { formatter },
      ["handlebars"] = { formatter },
      ["svg"] = { formatter },
      ["xml"] = { formatter },

      -- OCaml (keep existing config)
      ["ocaml"] = { "ocamlformat" },
      ["menhir"] = { "ocamlformat" },
      ["ocamlinterface"] = { "ocamlformat" },
      ["ocamllex"] = { "ocamlformat" },
      ["reason"] = { "ocamlformat" },
      ["dune"] = { "dune" },
    },
    formatters = {
      ocamlformat = {
        args = { "--name", "$FILENAME", "-" },
      },
      dune = {
        stdin = true,
        command = "dune",
        args = { "format-dune-file" },
      },
    },
  },
}
