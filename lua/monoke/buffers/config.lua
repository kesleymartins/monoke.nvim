local options = {}
local api = vim.api

local M = {}

M.setup_defaults = function()
  options.title = " Monoke Buffer Manager "
  options.title_pos = "center"
  options.relative = "editor"
  options.style = "minimal"
  options.border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}
  options.width = 60
  options.height = 7
  options.row = (api.nvim_get_option('lines') - options.height) / 2
  options.col = (api.nvim_get_option('columns') - options.width) / 2
end

M.get_options = function()
 return options
end

return M
