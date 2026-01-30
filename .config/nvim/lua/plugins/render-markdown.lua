-- https://github.com/MeanderingProgrammer/render-markdown.nvim

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  opts = {
    -- Render in normal and command modes
    render_modes = { "n", "c" },
    -- Anti-conceal: show raw markdown on cursor line
    anti_conceal = {
      enabled = true,
      above = 0,
      below = 0,
    },
    heading = {
      enabled = true,
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      enabled = true,
      sign = true,
      style = "full",
      width = "full",
      left_pad = 2,
      right_pad = 2,
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰱒 " },
    },
    quote = {
      enabled = true,
      icon = "▋",
    },
    pipe_table = {
      enabled = true,
      style = "full",
    },
    link = {
      enabled = true,
      hyperlink = "󰌹 ",
      image = "󰥶 ",
    },
  },
}
