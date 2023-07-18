# neorg-hop-extras
Neorg module for some additional types of links

## Install

#### For [packer](https://github.com/wbthomason/packer.nvim) users -
```lua
  use {
    'nvim-neorg/neorg',
    -- ...
    requires = {
      -- ...
      {'phenax/neorg-hop-extras'},
    }
  }
```


#### Config
```lua
require('neorg').setup {
  load = {
    -- ...
    ['external.hop-extras'] = {}
    ['core.keybinds'] = {
      config = {
        hook = neorg_keybindings,
      }
    },
  },
}

function neorg_keybindings(keybinds)
  keybinds.map_event_to_mode("norg", {
    n = {
      { "<CR>", "external.hop-extras.hop-link", opts = { desc = "Follow link" } },
    }
  }, { silent = true, noremap = true })
end
```

