local should_biome_start = require("utils.file_exists").file_exists("./biome.json")

-- Oxlint LSP configuration
-- Oxlint provides LSP via: oxlint --lsp
-- Install in your project: npm install -D oxlint
-- Create .oxlintrc.json to enable: echo '{}' > .oxlintrc.json
-- The LSP will use lspconfig's built-in oxlint configuration

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
        -- Oxlint LSP - automatically picks up .oxlintrc.json
        -- Provides linting with 500+ ESLint rules
        -- Use :LspOxlintFixAll to apply automatic fixes
        oxlint = {
          -- lspconfig handles local node_modules/.bin/oxlint automatically
          -- Type-aware linting enabled if .oxlintrc.json contains "typescript"
          settings = {
            typeAware = true, -- Enable type-aware linting
            -- run = 'onType', -- Run on every keystroke (default: onSave)
          },
        },
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
