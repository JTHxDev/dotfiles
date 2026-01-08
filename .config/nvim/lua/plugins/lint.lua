-- lint.lua: Asynchronous linting
--
-- https://github.com/mfussenegger/nvim-lint
--
-- USAGE:
-- ======
-- Linting runs automatically on:
--   - BufEnter (when opening a file)
--   - BufWritePost (after saving)
--   - InsertLeave (after leaving insert mode)
--
-- Diagnostics appear via vim.diagnostic (same as LSP diagnostics)
--
-- HOW TO ADD LINTERS:
-- ===================
-- 1. Add the linter to `tools.lua` in the `linters` table
--    Use nvim-lint names: https://github.com/mfussenegger/nvim-lint#available-linters
-- 2. Add the Mason package name to `tools.lua` in `ensure_installed`
--    Note: Mason names may differ (e.g., "golangci-lint" vs "golangcilint")
-- 3. Restart nvim and run :Lazy sync
--
-- HOW TO CUSTOMIZE A LINTER:
-- ==========================
-- Add configuration after lint.linters_by_ft:
--
--   lint.linters.mypy.args = {
--     "--ignore-missing-imports",
--     "--show-column-numbers",
--   }

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local tools = require("tools")

    -- Linters by filetype (defined in tools.lua)
    lint.linters_by_ft = tools.linters

    -- Run linters automatically
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
