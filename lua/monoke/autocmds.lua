local api = vim.api

local buffers_win = require('monoke.buffers.window')
local group

local M = {}

M.setup = function()
  group = api.nvim_create_augroup("monoke", {})

  api.nvim_create_autocmd('CursorMoved', {
    group = group,
    callback = buffers_win.fix_cursor_position
  })
end

M.clear = function()
  api.nvim_del_augroup_by_id(group)
end

return M
