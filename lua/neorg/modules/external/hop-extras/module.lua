local neorg = require('neorg.core')

local utils = require('neorg.modules.external.hop-extras.utils')

local namespace = 'external.hop-extras'

local module = neorg.modules.create(namespace)

local defaultAliases = {
  gh = 'https://github.com/{}',
  npm = 'https://www.npmjs.com/package/{}',
  crates = 'https://crates.io/crates/{}',
  pub = 'https://pub.dev/packages/{}',
  caniuse = 'https://caniuse.com/#search={}',
  bundlephobia = 'https://bundlephobia.com/result?p={}',
  reddit = 'http://www.reddit.com/r/{}/',
}

module.config.public = {
  aliases = {},
  bind_enter_key = true,
}

module.setup = function()
  return {
    success = true,
    requires = {
      'core.integrations.treesitter',
      'core.ui',
      'core.dirman.utils',
      'core.links',
      'core.esupports.hop',
    },
  }
end

module.load = function()
  vim.keymap.set('', '<plug>(neorg.external.hop-extras.hop-link)', function() module.public.hop_link() end)
  vim.keymap.set('', '<plug>(neorg.external.hop-extras.hop-link.vsplit)', function() module.public.hop_link('vsplit') end)

  -- Bind <cr> to hop links
  if module.config.public.bind_enter_key then
    vim.keymap.set('n', '<CR>', '<plug>(neorg.external.hop-extras.hop-link)')
    vim.keymap.set('n', '<M-CR>', '<plug>(neorg.external.hop-extras.hop-link.vsplit)')
  end
end

module.public = {
  hop_link = function(split)
    local hop_module = module.required['core.esupports.hop']
    local link_node_at_cursor = hop_module.extract_link_node()
    local parsed_link = hop_module.parse_link(link_node_at_cursor)
    module.public.follow_link(link_node_at_cursor, split, parsed_link)
  end,

  follow_link = function(node, split, link)
    if vim.g.__neorg_hop_extras_debug then
      print(vim.inspect(link))
    end

    if not link then
      module.required['core.esupports.hop'].follow_link(node, split, link)
      return
    end

    if link.link_location_text then
      -- Command links
      if link.link_location_text:match('^%+.+') then
        local cmd = link.link_location_text:gsub('^%+', '')
        vim.cmd(cmd)
        return
      end

      -- Aliases
      if link.link_location_text:match('^&%w+%s.+') then
        local link_location = link.link_location_text:gsub('^&', '')
        local alias_key, value_tbl = utils.cons(utils.split_string(link_location, ' '))
        local value = table.concat(value_tbl, ' ')

        local aliases = vim.tbl_extend('force', defaultAliases, module.config.public.aliases)

        if aliases[alias_key] then
          link.link_location_text = aliases[alias_key]:gsub('{}', value)
          module.required['core.esupports.hop'].follow_link(node, split, link)
        end

        return
      end

      -- Prompt for links
      if link.link_location_text:match('^!.+') then
        link.link_location_text = link.link_location_text:gsub('^!%s*', '')

        -- TODO: Support internal link type {! :somefile:}
        if vim.fn.confirm('Open link ' .. link.link_location_text .. '?') == 1 then
          module.public.follow_link(node, split, link) -- rec
        end
        return
      end
    end

    module.required['core.esupports.hop'].follow_link(node, split, link)
  end,
}

return module
