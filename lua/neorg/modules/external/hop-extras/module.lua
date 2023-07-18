require('neorg.modules.base')

local utils = require('neorg.modules.external.hop-extras.utils')

local namespace = 'external.hop-extras'
local EVENT_HOP_LINK = 'hop-link'

local module = neorg.modules.create(namespace)

module.config.public = {
  aliases = {
    gh = "https://github.com/{}",
    npm = "https://www.npmjs.com/package/{}",
    crates = "https://crates.io/crates/{}",
    pub = "https://pub.dev/packages/{}",
    caniuse = "https://caniuse.com/#search={}",
    bundlephobia = "https://bundlephobia.com/result?p={}",
    reddit = "http://www.reddit.com/r/{}/",
  },
}

module.setup = function()
  return {
    success = true,
    requires = {
      'core.keybinds',
      'core.esupports.hop',
    },
  }
end

module.load = function()
  module.required['core.keybinds'].register_keybind(namespace, EVENT_HOP_LINK)
end

module.private = { }

module.public = {
  follow_link = function(node, split, link)
    -- print(vim.inspect(link))

    if link.link_type == "url" then
      -- Command links
      if link.link_location_text:match("^%+.+") then
        local cmd = link.link_location_text:gsub("^%+", "")
        vim.cmd(cmd)
        return
      end

      -- Aliases
      if link.link_location_text:match("^&%w+%s.+") then
        local alias_key, value = utils.cons(utils.split_string(link.link_location_text:gsub("^&", ""), " "))
        value = table.concat(value, " ")

        local alias = module.config.public.aliases[alias_key]
        if alias then
          link.link_location_text = alias:gsub("{}", value)
          module.required['core.esupports.hop'].follow_link(node, split, link)
        end

        return
      end

      -- Prompt for links
      if link.link_location_text:match("^!.+") then
        link.link_location_text = link.link_location_text:gsub("^!%s*", "")

        -- TODO: Support internal link type {! :somefile:}
        if vim.fn.confirm("Follow link " .. link.link_location_text .. "?") then
          module.public.follow_link(node, split, link) -- rec
        end
        return
      end
    end

    module.required['core.esupports.hop'].follow_link(node, split, link)
  end,

  -- TODO: Custom treesitter nodes
  -- parse_link = function(node, buf)
  -- end,
}

module.on_event = function(event)
  local event_name = event.split_type[2]
  local bufnr = event.buffer

  if event_name == namespace .. '.' .. EVENT_HOP_LINK then
    local split = event.content[1]
    local node = module.required['core.esupports.hop'].extract_link_node()

    if node then
      local link = module.required['core.esupports.hop'].parse_link(node, bufnr)
      module.public.follow_link(node, split, link)
    end
  end
end

module.events.subscribed = {
  ['core.keybinds'] = {
    [namespace .. '.' .. EVENT_HOP_LINK] = true,
  },
}

return module
