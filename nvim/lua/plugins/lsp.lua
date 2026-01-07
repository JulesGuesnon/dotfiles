local should_biome_start = require("utils.file_exists").file_exists("./biome.json")

-- https://gitlab.com/mrossinek/dotfiles/-/blob/8f5919d685e4c26ce0ea44b93673db9985c335f9/nvim/.config/nvim/after/plugin/nvim-lspconfig.vim
-- local capabilities = vim.tbl_deep_extend(
--   "force",
--   vim.lsp.protocol.make_client_capabilities(),
--   require("plugins.blink").default_capabilities()
-- )
-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

-- require("lspconfig").tailwindcss.setup({
--   init_options = { userLanguages = { heex = "html" } },
-- })

return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      inlay_hints = { enabled = true },
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
        sourcekit = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        },
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
          cmd = { "bunx", "--bun", "typescript-language-server", "--stdio" },
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
          settings = {
            -- javascript = {
            --   inlayHints = {
            --     includeInlayEnumMemberValueHints = true,
            --     includeInlayFunctionLikeReturnTypeHints = true,
            --     includeInlayFunctionParameterTypeHints = true,
            --     includeInlayParameterNameHints = "all",
            --     includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            --     includeInlayPropertyDeclarationTypeHints = true,
            --     includeInlayVariableTypeHints = true,
            --   },
            -- },
            -- typescript = {
            --   inlayHints = {
            --     includeInlayEnumMemberValueHints = true,
            --     includeInlayFunctionLikeReturnTypeHints = true,
            --     includeInlayFunctionParameterTypeHints = true,
            --     includeInlayParameterNameHints = "all",
            --     includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            --     includeInlayPropertyDeclarationTypeHints = true,
            --     includeInlayVariableTypeHints = true,
            --   },
            -- },
          },
        },
      },
    },
  },
}
