local M = {}

local api = vim.api
local opts = { noremap = true }

M.setup = function()
  api.nvim_set_keymap('n', '<CR>', ":lua require('monoke.buffers.actions').open_buffer()<CR>", opts)
  api.nvim_set_keymap('n', 'd', ":lua require('monoke.buffers.actions').close_buffer()<CR>", opts)
end

M.clear = function()
  api.nvim_del_keymap('n', '<CR>')
  api.nvim_del_keymap('n', 'd')
end

return M
