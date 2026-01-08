
local function test(lhs, modes, opts, rhs)
    if not opts then
        opts = {}
    end
    opts.unique = true
    vim.keymap.set(modes, lhs, rhs, opts)
end

local function keymap(modes, lhs, rhs, opts)
test(lhs, modes, opts, rhs)
end
-- open netrw
keymap("n", "<leader>pv", function()
    local success, _ = pcall(vim.cmd.Ex)
    if not success then
        vim.notify("Error: Failed to open netrw", vim.log.levels.ERROR)
    end
end)

-- -- Better than defaults
keymap("n", "J", "mzJ`z", { desc = "Join lines without moving cursor to the end" })
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll half-page without moving cursor" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll half-page without moving cursor" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected lines up" })
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected lines down" })
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- copy and paste
keymap("x", "<leader>p", [["_dP]])         -- paste and delete
keymap("x", "<leader>P", require("util").paste, { desc = "Create [P]aste in paste.sr.ht" })
keymap({ "n", "v" }, "<leader>y", [["+y]]) -- copy to system clipboard
keymap("n", "<leader>Y", [["+Y]])          -- copy line to system clipboard
keymap({ "n", "v" }, "<leader>d", [["_d]]) -- delete without yanking

-- etc
keymap("i", "<C-c>", "<Esc>")

-- Folds
keymap({ "n", "v" }, "zo", "za", { desc = "Toggle folds" })
keymap({ "n", "v" }, "zz", "zf", { desc = "Define fold" })

-- Quickfix
keymap("n", "<leader>qt", require("util").toggle_quickfix, { desc = "Toggle [q]uickfix list" })
keymap("n", "<C-k>", "<cmd>cnext<CR>zz")     -- next quickfix
keymap("n", "<C-j>", "<cmd>cprev<CR>zz")     -- previous quickfix
keymap("n", "<leader>k", "<cmd>lnext<CR>zz") -- next location list
keymap("n", "<leader>j", "<cmd>lprev<CR>zz") -- previous location list

-- Macros
keymap("n", "Q", "@j")

-- Window movement
keymap("n", "<C-M-h>", "<C-w>h", { desc = "Switch to window left" })
keymap("n", "<C-M-j>", "<C-w>j", { desc = "Switch to window below" })
keymap("n", "<C-M-k>", "<C-w>k", { desc = "Switch to window above" })
keymap("n", "<C-M-l>", "<C-w>l", { desc = "Switch to window right" })
keymap("n", "<C-M-q>", ":bd<CR>", { desc = "Close buffer" })
keymap("n", "<M-,>", "<C-w>5<", { desc = "Resize window right" })
keymap("n", "<M-.>", "<C-w>5>", { desc = "Resize window left" })
keymap("n", "<M-/>", "<C-w>+", { desc = "Resize window down" })
keymap("n", "<M-'>", "<C-w>-", { desc = "Resize window up" })

-- Project quick-access
keymap("n", "<leader><leader>", require("finders").project_files, { desc = "Search Project/Files" })
keymap("n", "<leader>ed", require("finders").dotfiles, { desc = "[E]dit [D]otfiles" })
keymap("n", "<leader>ep", require("finders").projects, { desc = "[E]dit [P]rojects" })
keymap("n", "<leader>ev", require("finders").config, { desc = "[E]dit Neo[v]im Config" })

-- Diagnostics
keymap("n", "<leader>K", vim.diagnostic.open_float, { desc = "Open Diagnostic in Float" })

vim.keymap.set("n", "<leader>ss", function()
  local word = vim.fn.expand("<cword>")
  local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
  if replacement ~= "" then
    vim.cmd(":%s/\\<" .. word .. "\\>/" .. replacement .. "/g")
  end
end, { desc = "Replace word under cursor in the entire file" })

keymap("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true })

keymap("n", "<leader>cpd", ":Copilot disable", { desc = "[C]o[P]ilot [D]isable" })
keymap("n", "<leader>cpe", ":Copilot enable", { desc = "[C]o[P]ilot [E]nable" })

