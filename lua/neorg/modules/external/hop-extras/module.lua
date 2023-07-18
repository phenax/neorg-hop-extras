require('neorg.modules.base')

local utils = require('neorg.modules.external.hop-extras.utils')

local namespace = 'external.hop-extras'
local EVENT_HOP_LINK = 'hop-link'

local module = neorg.modules.create(namespace)

module.config.public = {}

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
    print(vim.inspect(link))

    function follow()
      if link.link_type == "url" then
        -- Command links
        if link.link_location_text:match("^%+.+") then
          local cmd = link.link_location_text:gsub("^%+", "")
          vim.cmd(cmd)
          return true
        end

        -- Search
        if link.link_location_text:match("^&%w+%s.+") then
          vim.print("Shorthand :: " .. link.link_location_text)
          return true
        end

        -- Prompt for external links
        if link.link_location_text:match("^!.+") then
          link.link_location_text = link.link_location_text:gsub("^!%s*", "")

          if vim.fn.confirm("Follow link " .. link.link_location_text .. "?") then
            module.public.follow_link(node, split, link) -- rec
          end
          return true
        end
      end

      return false
    end

    local link_followed = follow()
    if not link_followed then
      module.required['core.esupports.hop'].follow_link(node, split, link)
    end
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
