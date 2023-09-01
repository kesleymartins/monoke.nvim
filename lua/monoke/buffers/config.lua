local api = vim.api

local options = {}
options.title = " Monoke Buffer Manager "
options.title_pos = "center"
options.relative = "editor"
options.style = "minimal"
options.border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}
options.width = 60
options.height = 7
options.row = (api.nvim_get_option('lines') - options.height) / 2
options.col = (api.nvim_get_option('columns') - options.width) / 2

local M = {}

M.get_options = function()
 return options
end

M.update_options = function(config)
  options.width = config.width
  options.height = config.height

  options.col = (api.nvim_get_option('columns') - options.width) / 2
  options.row = (api.nvim_get_option('lines') - options.height) / 2
end

return M
