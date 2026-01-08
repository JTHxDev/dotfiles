return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>o", group = "opencode" },
      },
    },
  },
  {
    "numToStr/FTerm.nvim",
    config = function()
      require("FTerm").setup({
        border = "double",
        dimensions = {
          height = 0.9,
          width = 0.9,
        },
      })
    end,
  },
  {
    "dir-project/opencode-nvim", -- I will assume this is the intended repo or we can just use a command
    enabled = false, -- Disabled because repo doesn't exist
  },
  -- Since the dedicated plugin doesn't exist, we'll implement a simple one using FTerm to launch the opencode CLI
  {
    "vim-scripts/placeholder", -- Dummy entry to satisfy lazy if needed, but we'll just add keys
    dir = vim.fn.stdpath("config"),
    name = "opencode_internal",
    keys = {
      {
        "<leader>oo",
        function()
          require("FTerm").scratch({ cmd = { "opencode" } })
        end,
        desc = "Opencode TUI",
      },
      {
        "<leader>oa",
        function()
          vim.ui.input({ prompt = "Ask Opencode: " }, function(input)
            if input and input ~= "" then
              require("FTerm").scratch({ cmd = { "opencode", "run", input } })
            end
          end)
        end,
        desc = "Opencode Ask",
      },
    },
  },
}
