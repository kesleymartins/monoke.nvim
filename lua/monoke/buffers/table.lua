local buffers_config = require('monoke.buffers.config')

local api = vim.api
local fn = vim.fn

local chars = {}
chars.vline = "│"
chars.hline = "─"
chars.cross = "┼"
chars.ucross = "┴"

local data = {}
data.header = {"ID", "File Name", "Folder Name"}
data.buffers = {}
data.columns = {}
data.width = 0
data.table = {}

local update_buffers = function()
  data.buffers = {}

  for _, id in ipairs(api.nvim_list_bufs()) do
    local path = api.nvim_buf_get_name(id)
    local type = api.nvim_buf_get_option(id, 'buftype')
    local loaded = api.nvim_buf_is_loaded(id)

    if path ~= "" and type == "" and loaded then
      local buffer = {
        tostring(id),
        fn.fnamemodify(path,':t'),
        fn.fnamemodify(path, ':p:h:t')
      }

      table.insert(data.buffers, buffer)
    end
  end
end

local update_columns = function()
  data.columns = {}

  for _, text in ipairs(data.header) do
    table.insert(data.columns, #text + 2)
  end

  for _, buffer in ipairs(data.buffers) do
    for jdx, text in ipairs(buffer) do
      local col_size = #text + 2

      if data.columns[jdx] < col_size then
        data.columns[jdx] = col_size
      end
    end
  end
end

local update_width = function()
  data.width = 0

  for _, col in ipairs(data.columns) do
    data.width = data.width + col
  end

  data.width = data.width + (#data.columns - 1)
end

local build_divisor_row = function()
  local row = ""
  local div_cros = chars.cross

  if #data.buffers == 0 then
    div_cros = chars.ucross
  end

  for idx, col in ipairs(data.columns) do
    row = row .. string.rep(chars.hline, col)

    if idx ~= #data.columns then
      row = row .. div_cros
    end
  end

  table.insert(data.table, row)
end

local build_message_row = function(message)
  local margin = string.rep(' ', (data.width - #message) / 2)
  local row = string.format("%s%s%s", margin, message, margin)
  table.insert(data.table, row)
end

local build_data_row = function(line)
  local row = ""

  for idx, text in ipairs(line) do
    local rem_space = data.columns[idx] - #text - 2
    row = row .. string.format(" %s%s ", text, string.rep(' ', rem_space))

    if idx ~= #line then
      row = row .. chars.vline
    end
  end

  table.insert(data.table, row)
end

local build_table = function()
  data.table = {}

  build_data_row(data.header)
  build_divisor_row()

  if #data.buffers == 0 then
    build_message_row('Any buffer to manage.')
  else
    for _, line in ipairs(data.buffers) do
      build_data_row(line)
    end
  end
end

local M = {}

M.build = function()
  update_buffers()

  update_columns()
  update_width()

  build_table()

  buffers_config.update_options({ width = data.width, height = #data.table })
end

M.get_content = function()
  return data.table
end

return M
