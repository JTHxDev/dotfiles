-- conform.lua: Code formatting
--
-- https://github.com/stevearc/conform.nvim
--
-- USAGE:
-- ======
-- - <leader>F : Format current buffer (works in normal and visual mode)
-- - :ConformInfo : Show formatter status for current buffer
--
-- HOW TO ADD FORMATTERS:
-- ======================
-- 1. Add the formatter to `tools.lua` in the `formatters` table
-- 2. Add the Mason package name to `tools.lua` in `ensure_installed`
-- 3. Restart nvim and run :Lazy sync
--
-- HOW TO CUSTOMIZE A FORMATTER:
-- =============================
-- Add an entry to the `formatters` table in setup() below.
-- See stylua example for passing custom args.
--
-- EXAMPLE - Add black for Python with custom line length:
-- -------------------------------------------------------
--   formatters = {
--     black = {
--       prepend_args = { "--line-length", "100" },
--     },
--   }
--
-- FORMAT ON SAVE:
-- ===============
-- To enable format-on-save, add this to setup():
--   format_on_save = {
--     timeout_ms = 500,
--     lsp_format = "fallback",
--   }

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>F",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "[F]ormat buffer",
    },
  },
  config = function()
    local conform = require("conform")
    local tools = require("tools")

    conform.setup({
      -- Formatters by filetype (defined in tools.lua)
      formatters_by_ft = tools.formatters,

      -- Use LSP formatting as fallback if no formatter configured
      default_format_opts = {
        lsp_format = "fallback",
      },

      -- Formatter-specific configuration
      formatters = {
        stylua = {
          prepend_args = {
            "--config-path",
            vim.fn.expand("~/.config/nvim/configs/stylua.toml"),
          },
        },
      },
    })

    -- Commands to enable/disable formatting (useful if you enable format_on_save later)
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
      vim.notify("Autoformat disabled")
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      vim.notify("Autoformat enabled")
    end, { desc = "Re-enable autoformat-on-save" })
  end,
}
