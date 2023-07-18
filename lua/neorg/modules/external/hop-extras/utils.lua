local utils = {}

function utils.get_root_node(bufnr, ft)
  local parser = vim.treesitter.get_parser(bufnr, ft)
  return parser:parse()[1]:root()
end

function utils.split_string(input, sep)
  local result = {}
  local pattern = "([^" .. sep .. "]+)"
  for substring in string.gmatch(input, pattern) do
    table.insert(result, substring)
  end
  return result
end

return utils

