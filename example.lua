local function add_rtp(path)
  vim.o.runtimepath =
      vim.o.runtimepath .. ',' .. vim.fn.expand('$HOME/.local/share/nvim/lazy/' .. path)
end

vim.o.runtimepath = vim.o.runtimepath .. ',' .. vim.fn.getcwd()
add_rtp('plenary.nvim')
add_rtp('nvim-treesitter')
add_rtp('neorg')

---

vim.g.__neorg_hop_extras_debug = true;

require('neorg').setup {
  load = {
    ['core.defaults'] = {},
    ['external.hop-extras'] = {},
  },
}

vim.cmd [[ e ./example.norg ]]
vim.cmd [[ set filetype=norg ]]

-- (Neorg keybind norg external.hop-extras.hop-link)
