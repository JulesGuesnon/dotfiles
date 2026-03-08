-- Tooling utility module for smart formatter/linter selection
-- Detects project config files and returns appropriate tools

local M = {}

-- Helper function to check if file exists in current working directory
function M.file_exists(path)
  local full_path = vim.fn.getcwd() .. "/" .. path
  return vim.fn.filereadable(full_path) == 1
end

-- Detect which config files exist in the project
function M.detect_config_files()
  return {
    oxlint = M.file_exists(".oxlintrc.json") or M.file_exists(".oxlintrc.js"),
    oxfmt = M.file_exists(".oxfmtrc.json") or M.file_exists(".oxfmtrc.jsonc"),
    biome = M.file_exists("biome.json") or M.file_exists("biome.jsonc"),
    eslint = M.file_exists(".eslintrc.json")
      or M.file_exists(".eslintrc.js")
      or M.file_exists(".eslintrc.cjs")
      or M.file_exists(".eslintrc.yaml")
      or M.file_exists(".eslintrc.yml")
      or M.file_exists("eslint.config.js"),
    prettier = M.file_exists(".prettierrc")
      or M.file_exists(".prettierrc.json")
      or M.file_exists(".prettierrc.yml")
      or M.file_exists(".prettierrc.yaml")
      or M.file_exists(".prettierrc.js")
      or M.file_exists("prettier.config.js"),
  }
end

-- Get the appropriate formatter based on priority:
-- 1. oxfmt (if .oxfmtrc.json exists)
-- 2. biome (if biome.json exists)
-- 3. prettier (if .prettierrc exists)
-- 4. oxfmt (default fallback)
function M.get_formatter()
  local configs = M.detect_config_files()

  if configs.oxfmt then
    return "oxfmt"
  elseif configs.biome then
    return "biome"
  elseif configs.prettier then
    return "prettier"
  else
    -- Default to oxfmt
    return "oxfmt"
  end
end

-- Get the appropriate linter based on priority:
-- 1. oxlint (if .oxlintrc.json exists - handled by LSP)
-- 2. biome (if biome.json exists - handled by LSP)
-- 3. eslint_d (if .eslintrc.json exists)
-- 4. nil (default - oxlint LSP won't start without config)
function M.get_linter()
  local configs = M.detect_config_files()

  -- Note: oxlint and biome are handled by their LSP servers
  -- This is only for nvim-lint integration
  if configs.eslint and not configs.oxlint and not configs.biome then
    return "eslint_d"
  end

  return nil
end

-- Check if oxlint LSP should be used
-- Oxlint LSP requires .oxlintrc.json to be present
function M.should_use_oxlint_lsp()
  return M.detect_config_files().oxlint
end

-- Check if biome LSP should be used
function M.should_use_biome_lsp()
  return M.detect_config_files().biome
end

-- Get formatter for specific filetype
-- Returns formatter name or nil
function M.get_formatter_for_filetype(filetype)
  local formatter = M.get_formatter()

  -- Oxfmt supports many languages
  local oxfmt_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
    "json5",
    "yaml",
    "toml",
    "html",
    "vue",
    "css",
    "scss",
    "less",
    "markdown",
    "mdx",
    "graphql",
    "handlebars",
  }

  -- Check if formatter supports this filetype
  if formatter == "oxfmt" then
    for _, ft in ipairs(oxfmt_filetypes) do
      if ft == filetype then
        return formatter
      end
    end
  end

  -- Biome and Prettier support similar filetypes
  if formatter == "biome" or formatter == "prettier" then
    return formatter
  end

  return nil
end

return M
