local config = require('monoke.buffers.config')
local table = require('monoke.buffers.table')

local api = vim.api

local buf, win

local update_buffer_content = function()
  table.build()
  api.nvim_buf_set_lines(buf, 0, -1, false, table.get_all_data())
end

local setup_buffer = function()
  buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  update_buffer_content()
end

local setup_window = function()
  win = api.nvim_open_win(buf, true, config.get_options())
  api.nvim_win_set_option(win, 'winhighlight', 'Normal:MyHighlight')
end

local M = {}

M.setup = function()
  setup_buffer()
  setup_window()

  M.fix_cursor_position()
end

M.update = function()
  update_buffer_content()
end

M.close = function()
  api.nvim_win_close(win, true)
end

M.is_open = function()
  if buf == nil or win == nil then
    return false
  end

  return api.nvim_buf_is_valid(buf) and api.nvim_win_is_valid(win)
end

M.get_selected_buffer = function()
  local line_content = api.nvim_get_current_line()
  local buf_id = line_content:match("^%s*(%d+)")

  return tonumber(buf_id)
end

M.fix_cursor_position = function()
  local cursor = api.nvim_win_get_cursor(win)
  local cursor_line = cursor[1]

  if cursor_line <= 2 then
    api.nvim_win_set_cursor(win, { 3, cursor[2]})
  end
end

return M
