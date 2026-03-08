local util = require("lspconfig.util")

local should_biome_start = require("utils.file_exists").file_exists("./biome.json")

-- Oxlint LSP configuration
-- Note: oxlint LSP server binary is 'oxc_language_server' (installed with `npm install -g oxlint`)
vim.lsp.config("oxlint", {
  cmd = { "oxc_language_server" },
  root_dir = util.root_pattern(".oxlintrc.json"),
  single_file_support = false,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
  },
})

vim.lsp.enable("oxlint")

-- Configure LSP capabilities for blink.cmp
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- https://gitlab.com/mrossinek/dotfiles/-/blob/8f5919d685e4c26ce0ea44b93673db9985c335f9/nvim/.config/nvim/after/plugin/nvim-lspconfig.vim
-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

-- require("lspconfig").tailwindcss.setup({
--   init_options = { userLanguages = { heex = "html" } },
-- })

require("lspconfig").sourcekit.setup({
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }),
  cmd = { "sourcekit-lsp" },
  filetypes = { "swift" },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern("Package.swift")(fname)
      or require("lspconfig.util").root_pattern("*.xcodeproj")(fname)
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      inlay_hints = { enabled = true },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      },
      servers = {
        ocamllsp = {
          root_dir = require("lspconfig.util").root_pattern(
            "*.opam",
            "esy.json",
            ".git",
            "dune-project",
            "dune-workspace"
          ),
        },
        gopls = {
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
          settings = {
            gopls = {
              completeUnimported = true,
              analyses = {
                unusedparams = true,
              },
            },
          },
        },
        -- sourcekit = {
        --   capabilities = {
        --     workspace = {
        --       didChangeWatchedFiles = {
        --         dynamicRegistration = true,
        --       },
        --     },
        --   },
        --   cmd = { "sourcekit-lsp" },
        --   filetypes = { "swift" },
        --   root_dir = function(fname)
        --     return require("lspconfig.util").root_pattern("Package.swift")(fname)
        --       or require("lspconfig.util").root_pattern("*.xcodeproj")(fname)
        --   end,
        -- },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
            },
          },
        },
        lua_ls = {
          hints = true,
        },
        biome = {
          autostart = should_biome_start,
        },
        ts_ls = {
          -- root_dir = require("lspconfig.util").root_pattern("package.json"),
          cmd = { "bunx", "typescript-language-server", "--stdio" },
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
          settings = {},
        },
        mdx_analyzer = {

          init_options = {
            typescript = {
              enabled = true,
            },
          },
        },
      },
    },
  },
}
