-- mason.lua: Package manager for LSP servers, formatters, linters, debuggers
--
-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim
-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
--
-- USAGE:
-- ======
-- :Mason - Open Mason UI to see installed packages
-- :MasonInstall <pkg> - Install a package manually
-- :MasonUninstall <pkg> - Uninstall a package
--
-- HOW IT WORKS:
-- =============
-- This file installs tools; configuration happens elsewhere:
--   - LSP servers: installed here, configured in lsp.lua
--   - Formatters: installed here, configured in conform.lua (via tools.lua)
--   - Linters: installed here, configured in lint.lua (via tools.lua)
--
-- HOW TO ADD TOOLS:
-- =================
-- Edit tools.lua:
--   - LSP servers: add to `servers` table
--   - Formatters/linters/debuggers: add to `ensure_installed` table
--
-- Package names are shown in the :Mason UI

return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local tools = require("tools")

    require("mason").setup()

    -- Install LSP servers (names from mason-lspconfig)
    require("mason-lspconfig").setup({
      ensure_installed = tools.servers,
    })

    -- Install formatters, linters, debuggers (names from Mason)
    require("mason-tool-installer").setup({
      ensure_installed = tools.ensure_installed,
    })
  end,
}
