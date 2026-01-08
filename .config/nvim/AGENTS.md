# AGENTS.md - Neovim Configuration

Guidance for AI coding agents working on this Neovim configuration.

## Repository Structure

```
.config/nvim/
├── init.lua                 # Entry point - loads core modules and lazy.nvim
├── lua/
│   ├── plugins/             # Plugin specs (one file per plugin)
│   ├── snippets/            # LuaSnip snippets by filetype
│   ├── tools.lua            # LSP/formatter/linter definitions (central config)
│   ├── keymaps.lua          # Global keymaps
│   ├── options.lua          # Vim options
│   ├── statuscolumn.lua     # Custom statuscolumn
│   └── util.lua             # Utility functions
├── after/ftplugin/          # Filetype-specific settings
├── after/plugin/            # Autocommands
├── configs/                 # Tool configs (stylua.toml, etc.)
└── colors/                  # Custom colorschemes
```

## Build/Lint/Test Commands

```bash
# Lint with selene
selene lua/

# Format with stylua
stylua --config-path configs/stylua.toml lua/

# Check for startup errors
nvim --headless -c 'qa!'
```

**Testing in Neovim:**
- `<leader>tc` - Run test under cursor
- `<leader>tf` - Run all tests in file
- `<leader>X` - Source current Lua file
- `:lua R("module")` - Reload a module

## Code Style Guidelines

### Formatting (stylua)
- **Indent**: 2 spaces
- **Line width**: 120 chars
- **Quotes**: Double quotes

### Naming Conventions
- `snake_case` for functions and variables
- `PascalCase` for augroup names
- Descriptive names over abbreviations

### Module Pattern
```lua
local function helper() end
local function public_func() end

return { public_func = public_func }
```

### Safe Requires
```lua
local ok, module = pcall(require, "module")
if not ok then
  vim.notify("Module not found", vim.log.levels.WARN)
  return
end
```

### Error Handling
```lua
local success, result = pcall(vim.cmd.Ex)
if not success then
  vim.notify("Error: " .. tostring(result), vim.log.levels.ERROR)
end
```

### Plugin Specs
```lua
-- https://github.com/author/plugin-name
return {
  "author/plugin-name",
  event = { "BufReadPre", "BufNewFile" },
  keys = { { "<leader>x", function() end, desc = "Description" } },
  config = function()
    require("plugin").setup({})
  end,
}
```

### Keymaps
```lua
vim.keymap.set("n", "<leader>x", func, { desc = "[X] Description" })
```

## Adding New Languages

Edit `lua/tools.lua`:
1. `servers` - LSP server name
2. `formatters` - `filetype = { "formatter" }`
3. `linters` - `filetype = { "linter" }`
4. `ensure_installed` - Mason package name

Custom LSP config: add to `server_configs` in `lua/plugins/lsp.lua`

## Key Files

| File | Purpose |
|------|---------|
| `lua/tools.lua` | Central LSP/formatter/linter config |
| `lua/plugins/lsp.lua` | LSP setup and keymaps |
| `lua/plugins/conform.lua` | Formatting |
| `lua/plugins/lint.lua` | Linting |
| `lua/keymaps.lua` | Global keybindings |

## Common Patterns

**Filetype exclusions:**
```lua
local exclude = { "help", "lazy", "TelescopePrompt" }
if vim.tbl_contains(exclude, vim.bo.filetype) then return end
```

**User input:**
```lua
vim.ui.input({ prompt = "Value:" }, function(input)
  if input then --[[ use input ]] end
end)
```

**Autocommands:**
```lua
vim.api.nvim_create_augroup("group_name", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = "group_name",
  callback = function() end,
})
```

## Do Not

- Add emojis to code or comments
- Create documentation files unless asked
- Modify lazy-lock.json (managed by lazy.nvim)
- Use `vim.cmd` when Lua API exists
- Define keymaps without `desc` (breaks which-key)
- Commit changes without user request
