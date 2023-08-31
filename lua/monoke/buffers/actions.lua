local api = vim.api

local buffer_win = require('monoke.buffers.window')
local ui = require('monoke.ui')

local M = {}

M.open_buffer = function()
  local buf_id = buffer_win.get_selected_buffer()

  if not buf_id then
    return
  end

  ui.close()
  api.nvim_set_current_buf(buf_id)
end

M.close_buffer = function()
  local buf_id = buffer_win.get_selected_buffer()

  if not buf_id then
    return
  end

  api.nvim_buf_delete(buf_id, {})
  buffer_win.update()
end

return M
