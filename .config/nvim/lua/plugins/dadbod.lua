return {
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',          -- UI for vim-dadbod
      'kristijanhusak/vim-dadbod-completion',  -- Optional: SQL completion
    },
    config = function()
      -- Optional: Set the save location for queries
      vim.g.db_ui_save_location = vim.fn.stdpath('config') .. '/db_ui'
   vim.g.dbs = {
       sqlserver = "sqlserver://" .. os.getenv("DB_USER") .. ":" .. os.getenv("DB_PASSWORD") .. "@" .. os.getenv("DB_HOST") .. "/" .. os.getenv("DB_NAME")
   }

    end,
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIFindBuffer', 'DBUIRenameBuffer', 'DB' }, -- Lazy-load on these commands
  }
}
