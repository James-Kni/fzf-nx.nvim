local config = {}

---@class Config
---@field nx_cmd string Command to use for executing actions
---@field list_projects_cmd function Generates a command string to list projects based on the provided target.
---@field open_on_serve boolean Open browser when serving project
---Open an external terminal instead of using the internal term.
---String uses '{}' as placeholder (e.g. 'kitty -e {}'),
---function receives cmd and returns the full command string.
---@field external_term_cmd string | nil | fun(cmd: string): string
---@field preferred_picker 'fzf-lua' | 'snacks' Select preferred picker
config = {
  nx_cmd            = "nx",
  open_on_serve     = false,
  ---@param target string
  ---@return string
  list_projects_cmd = function(target)
    return "nx show projects --with-target " .. target
  end,
  external_term_cmd = nil,
  preferred_picker = "fzf-lua"
}

return config
