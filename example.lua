
function add_rtp(path)
  vim.o.runtimepath =
    vim.o.runtimepath .. ',' .. vim.fn.expand('$HOME/.local/share/nvim/site/pack/packer/start/' .. path)
end

print(vim.fn.getcwd())

vim.o.runtimepath = vim.o.runtimepath .. ',' .. vim.fn.getcwd()
add_rtp('plenary.nvim')
add_rtp('nvim-treesitter')
add_rtp('neorg')

---

function neorg_keybindings(keybinds)
  keybinds.map_event_to_mode("norg", {
    n = {
      { "<CR>", "external.hop-extras.hop-link", opts = { desc = "Follow link" } },
    }
  }, { silent = true, noremap = true })
end

require('neorg').setup {
  load = {
    ['core.defaults'] = {},
    ['external.hop-extras'] = {},
    ['core.keybinds'] = {
      config = {
        hook = neorg_keybindings,
      }
    },
  },
}

vim.cmd [[ e ./example.norg ]]
vim.cmd [[ set filetype=norg ]]

-- (Neorg keybind norg external.hop-extras.hop-link)
