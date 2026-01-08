-- lsp.lua: LSP server configuration using Neovim 0.11+ native API
--
-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/j-hui/fidget.nvim
--
-- HOW IT WORKS:
-- =============
-- 1. mason.lua installs servers listed in tools.lua
-- 2. This file configures each server using vim.lsp.config (native API)
-- 3. Servers use default config unless listed in `server_configs`
--
-- HOW TO ADD CUSTOM LSP CONFIG:
-- =============================
-- Add a new entry to `server_configs` table below with the server name as key.
--
-- EXAMPLE - Adding custom gopls config:
-- -------------------------------------
--   server_configs = {
--     gopls = {
--       settings = {
--         gopls = {
--           analyses = { unusedparams = true },
--           staticcheck = true,
--         },
--       },
--     },
--   }

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local tools = require("tools")

    -- Diagnostic configuration
    vim.diagnostic.config({
      update_in_insert = false,
      signs = false,
      severity_sort = true,
      virtual_text = { spacing = 1 },
    })

    ---------------------------------------------------------------------------
    -- LSP Keymaps (applied via LspAttach autocommand)
    ---------------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local bufnr = ev.buf
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("<leader>D", vim.diagnostic.open_float, "[D]iagnostics")
        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        map("g]", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        map("g}", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
      end,
    })

    -- Capabilities for autocompletion (shared by all servers)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    ---------------------------------------------------------------------------
    -- Fidget: LSP progress indicator
    ---------------------------------------------------------------------------
    require("fidget").setup({
      progress = {
        display = {
          render_limit = 16,
          done_ttl = 3,
          done_icon = "✔",
          progress_icon = { "dots" },
        },
      },
    })

    ---------------------------------------------------------------------------
    -- Server-specific configurations (merged with defaults)
    -- Add custom settings here for any server that needs non-default config
    ---------------------------------------------------------------------------
    local server_configs = {
      -- Lua: configured for Neovim development
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      },

      -- Python: pyright with sensible defaults
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      },
    }

    ---------------------------------------------------------------------------
    -- Setup all servers from tools.lua using vim.lsp.config (Neovim 0.11+)
    ---------------------------------------------------------------------------
    for _, server_name in ipairs(tools.servers) do
      local config = {
        capabilities = capabilities,
      }
      -- Merge server-specific config if it exists
      if server_configs[server_name] then
        config = vim.tbl_deep_extend("force", config, server_configs[server_name])
      end
      vim.lsp.config(server_name, config)
    end

    -- Enable all configured servers
    vim.lsp.enable(tools.servers)
  end,
}
