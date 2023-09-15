local M = {}

local api = vim.api

local ui = require('monoke.ui')

M.setup = function()
  local opts = { nargs=0 }

  api.nvim_create_user_command('MNKToggle', ui.toggle, opts)
  api.nvim_create_user_command('MNKOpen', ui.open, opts)
  api.nvim_create_user_command('MNKClose', ui.close, opts)
end

return M
