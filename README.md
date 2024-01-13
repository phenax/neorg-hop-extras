# neorg-hop-extras
Neorg plugin to extend the functionality of links


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


#### Basic config
```lua
require('neorg').setup {
  load = {
    ['external.hop-extras'] = {},
  },
}
```

#### Custom keybinding
```lua
require('neorg').setup {
  load = {
    -- ...
    ['external.hop-extras'] = {
      config = {
        bind_enter_key = false,
      }
    },
    ['core.keybinds'] = {
      config = {
        hook = function(keybinds)
          -- Use `external.hop-extras.hop-link` instead of `core.esupports.hop.hop-link`
          keybinds.remap_event('norg', 'n', '<leader>gl', 'external.hop-extras.hop-link')
        end,
      }
    },
  },
}
```


## Usage

#### Commands as links
Run an arbitrary vim command when a link is activated

```neorg
- View yesterday's journal {+Neorg journal yesterday}[Yesterday] - Opens yesterday's journal
- Log the time using timelog module {+Neorg timelog insert routine}[Log routine] (requires https://github.com/phenax/neorg-timelog)
- Run shell commands {+!ls}

* Counter example
  - count: 28
  - Increment: {+/-\s*count:/ | call feedkeys("\<C-a>\<C-o>")}
  - Decrement: {+/-\s*count:/ | call feedkeys("\<C-x>\<C-o>")}
```

#### Aliases for links
Use aliases for links

```neorg
- Github url - {&gh phenax/neorg-timelog}
- Npm package link - {&npm react}
- Rust package link - {&crates serde}
- Dart package link - {&pub serde}
- Twitter user @Neovim - {&tw Neovim} (Custom alias defined below)
```

To define the custom alias, use -
```lua
require('neorg').setup {
  load = {
    -- ...
    ['external.hop-extras'] = {
      config = {
        aliases = {
          tw = 'https://twitter.com/{}'
        },
      },
    },
  },
}
```

#### Ask for confirmation before opening link
Ask for confirmation (uses `vim.fn.confirm`) before activating a link

```neorg
  - Asks for confirmation before opening external link - {! https://example.com}
  - Confirm before opening alias - {! &npm react}
  - Confirm before running command {! +echo "Dangerous commands need confirmation"}
```

