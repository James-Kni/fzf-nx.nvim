local config = {}

---@class Config
---@field keymaps boolean Use builtin keymaps
---@field nx_cmd string Command to use for executing actions
---@field list_projects_cmd function Generates a command string to list projects based on the provided target.
---@field open_on_serve boolean Open browser when serving project
---@field override_term function | nil Open an external terminal instead of using the internal term. E.g. 'kitty -e'
config = {
  keymaps           = true,
  nx_cmd            = "nx",
  open_on_serve     = false,
  ---@param target string
  ---@return string
  list_projects_cmd = function(target)
    return "nx show projects --with-target " .. target
  end,
  external_term_cmd = nil
}

return config
