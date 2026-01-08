vim.g.mapleader = " "

-- https://nanotipsforvim.prose.sh/using-pcall-to-make-your-config-more-stable
local function safeRequire(module)
  local success, loadedModule = pcall(require, module)
  if success then
    return loadedModule
  else
    vim.notify("Error loading module: " .. module .. "\n" .. loadedModule, vim.log.levels.ERROR)
  end
end
-- Built-ins
safeRequire("netrw")
safeRequire("options")

-- Custom
safeRequire("statuscolumn")
safeRequire("keymaps")
vim.env.PATH = vim.env.PATH .. ':/opt/homebrew/bin'
vim.env.TMPDIR = "/tmp"

-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "plugins",
    change_detection = { notify = true }
})

if vim.loader then vim.loader.enable() end
