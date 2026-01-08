-- tools.lua: Single source of truth for all language tooling
--
-- This file is consumed by:
--   - mason.lua (installs servers + tools)
--   - lsp.lua (configures LSP servers)
--   - conform.lua (formatting)
--   - lint.lua (linting)
--
-- HOW TO ADD A NEW LANGUAGE:
-- ==========================
-- 1. Add the LSP server name to `servers` (find names at :Mason or
--    https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers)
--
-- 2. Add formatters to `formatters` table with filetype as key
--    (find names at :ConformInfo or https://github.com/stevearc/conform.nvim#formatters)
--
-- 3. Add linters to `linters` table with filetype as key
--    (find names at https://github.com/mfussenegger/nvim-lint#available-linters)
--
-- 4. Add the Mason package names to `ensure_installed`
--    (these are the names shown in :Mason, may differ from formatter/linter names)
--
-- 5. If the LSP needs custom config, add it to `server_configs` in lsp.lua
--
-- EXAMPLE - Adding Ruby:
-- ----------------------
--   servers: add "ruby_lsp"
--   formatters: ruby = { "rubocop" }
--   linters: ruby = { "rubocop" }
--   ensure_installed: add "rubocop"

return {
  -- LSP servers (mason-lspconfig names)
  -- Find available servers: :Mason or :h mason-lspconfig-server-map
  servers = {
    "bashls",      -- bash/shell
    "dockerls",    -- dockerfile
    "gopls",       -- go
    "jsonls",      -- json
    "lua_ls",      -- lua
    "marksman",    -- markdown
    "pyright",     -- python
    "sqlls",       -- sql
    "taplo",       -- toml
    "ts_ls",       -- typescript/javascript
    "yamlls",      -- yaml
  },

  -- Formatters by filetype (conform.nvim names)
  -- Multiple formatters run in sequence; use { "a", "b", stop_after_first = true } to stop after first success
  -- Find available formatters: :ConformInfo
  formatters = {
    bash = { "shfmt" },
    go = { "gofumpt", "goimports" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    json = { "prettierd" },
    lua = { "stylua" },
    markdown = { "prettierd" },
    python = { "ruff_format", "ruff_organize_imports" },
    sh = { "shfmt" },
    sql = { "sql_formatter" },
    toml = { "taplo" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    yaml = { "prettierd" },
  },

  -- Linters by filetype (nvim-lint names)
  -- Find available linters: https://github.com/mfussenegger/nvim-lint#available-linters
  linters = {
    dockerfile = { "hadolint" },
    go = { "golangcilint" },
    lua = { "selene" },
    markdown = { "markdownlint" },
    python = { "ruff" },
    sh = { "shellcheck" },
    sql = { "sqlfluff" },
    yaml = { "yamllint" },
  },

  -- Extra tools to install via mason-tool-installer
  -- These are Mason package names (may differ from linter/formatter names above)
  -- Find package names: :Mason
  ensure_installed = {
    -- debuggers
    "debugpy",       -- python
    "delve",         -- go

    -- formatters
    "gofumpt",
    "goimports",
    "prettierd",
    "shfmt",
    "sql-formatter",
    "stylua",

    -- linters
    "golangci-lint", -- note: mason name differs from nvim-lint name (golangcilint)
    "hadolint",
    "markdownlint",
    "ruff",          -- python linter + formatter
    "selene",
    "shellcheck",
    "sqlfluff",
    "yamllint",
  },
}
