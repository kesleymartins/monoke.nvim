local M = {}

local buffers_win = require('monoke.buffers.window')
local keymaps = require('monoke.keymaps')
local autocmds = require('monoke.autocmds')

M.open = function()
  buffers_win.setup()
  keymaps.setup()
  autocmds.setup()
end

M.close = function()
  keymaps.clear()
  autocmds.clear()
  buffers_win.close()
end

M.toggle = function()
  if buffers_win.is_open() then
    M.close()
  else
    M.open()
  end
end

return M
