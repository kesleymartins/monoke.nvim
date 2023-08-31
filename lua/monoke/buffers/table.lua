local buffers_config = require('monoke.buffers.config')

local api = vim.api
local fn = vim.fn

local header = {}
local buffers = {}

local build_table_line = function(content)
  local result = " "

  for idx, text in ipairs(content) do
    result = string.format("%s%s", result, text)

    if idx ~= #content then
      result = string.format("%s │ ", result)
    end
  end

  return result
end

local build_divisor = function(char, positions)
  local result = ""
  local remaining_rows = buffers_config.get_options().width

  for _, pos in ipairs(positions) do
    result = string.format("%s%s%s", result, string.rep('─', pos), char)
    remaining_rows = remaining_rows - (pos + 1)
  end

  result = string.format("%s%s", result, string.rep("─", remaining_rows))

  return result
end

local update_buffer_list = function()
  buffers = {}

  for _, buf_id in ipairs(api.nvim_list_bufs()) do
    local buf_name = api.nvim_buf_get_name(buf_id)
    local buf_type = api.nvim_buf_get_option(buf_id, 'buftype')
    local buf_loaded = api.nvim_buf_is_loaded(buf_id)

    if buf_name ~= "" and buf_type == "" and buf_loaded then
      local item = { string.format("%3d", buf_id), fn.fnamemodify(buf_name ,':t') }
      table.insert(buffers, build_table_line(item))
    end
  end
end

local update_header = function()
  header = {}

  local content = { string.format("%3s", "ID"), "File Name"}
  table.insert(header, build_table_line(content))

  local divisor_char = "┼"

  if #buffers == 0 then
    table.insert(header, '  Any buffer to manage.')
    divisor_char = "┴"
  end

  table.insert(header, 2, build_divisor(divisor_char, { 5 }))
end

local M = {}

M.build = function()
  update_buffer_list()
  update_header()
end

M.get_all_data = function()
  local buffers_table = {}

  for _, value in ipairs(header) do
    table.insert(buffers_table, value)
  end

  for _, value in ipairs(buffers) do
    table.insert(buffers_table, value)
  end

  return buffers_table
end

return M
