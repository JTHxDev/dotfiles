local opt = vim.opt

opt.guicursor = ""

opt.nu = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "no"
opt.isfname:append("@-@")

opt.updatetime = 50

opt.colorcolumn = "80"

-- Statuscolumn
opt.statuscolumn = [[%!v:lua.statuscolumn()]]
-- Use mise Python
vim.g.python3_host_prog = vim.fn.expand(require("common").shims_dir) .. "/python3"


opt.autoindent = true
opt.autoread = true

-- Statusbar and separators
opt.laststatus = 3 -- Global statusbar
opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
