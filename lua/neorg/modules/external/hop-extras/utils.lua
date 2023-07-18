local utils = {}

function utils.get_root_node(bufnr, ft)
  local parser = vim.treesitter.get_parser(bufnr, ft)
  return parser:parse()[1]:root()
end

function utils.split_string(input, sep)
  local result = {}
  local pattern = '([^' .. sep .. ']+)'
  for substring in string.gmatch(input, pattern) do
    table.insert(result, substring)
  end
  return result
end

function utils.cons(tbl)
  if #tbl == 0 then return nil, {} end

  local tl = {}
  for i, x in pairs(tbl) do
    if i > 1 then
      table.insert(tl, x)
    end
  end
  return tbl[1], tl
end


return utils

