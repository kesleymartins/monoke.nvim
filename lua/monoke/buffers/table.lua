local buffers_config = require('monoke.buffers.config')

local api = vim.api
local fn = vim.fn

local config = {}
config.header = {}
config.buffers = {}

config.chars = {}
config.chars.vline = "│"
config.chars.hline = "─"

local build_line = function(data)
  local result = ""
  local rem_cols = buffers_config.get_options().width

  for idx, text in ipairs(data) do
    if idx == 1 then
      result = result .. string.format(" %3s ", text)
    else
      result = result .. string.format(" %s", text)
      result = result .. string.rep(" ", rem_cols / 2 - #result)
    end

    rem_cols = rem_cols - #result

    if idx ~= #data then
      result = result .. config.chars.vline
      rem_cols = rem_cols - 1
    end
  end

  return result
end

local update_buffer_list = function()
  config.buffers = {}

  for _, id in ipairs(api.nvim_list_bufs()) do
    local path = api.nvim_buf_get_name(id)
    local type = api.nvim_buf_get_option(id, 'buftype')
    local loaded = api.nvim_buf_is_loaded(id)

    if path ~= "" and type == "" and loaded then
      local content = { id, fn.fnamemodify(path,':t'), fn.fnamemodify(path, ':p:h:t') .. '/' }
      table.insert(config.buffers, build_line(content))
    end
  end

  if #config.buffers == 0 then
    table.insert(config.buffers, string.format(" %s", "Any buffer to manage."))
  end
end

local update_header = function()
  config.header = {}

  table.insert(config.header, build_line({ "ID", "File Name", "Folder Name"}))
  table.insert(config.header, string.rep("─", buffers_config.get_options().width))
end

local M = {}

M.build = function()
  update_header()
  update_buffer_list()
end

M.get_all_data = function()
  local buffers_table = {}

  for _, value in ipairs(config.header) do
    table.insert(buffers_table, value)
  end

  for _, value in ipairs(config.buffers) do
    table.insert(buffers_table, value)
  end

  return buffers_table
end

return M
