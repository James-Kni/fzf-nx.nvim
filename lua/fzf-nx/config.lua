local config = {}

---@class TermContext
---@field target string | nil NX target the command was built for
---@field projects string[] Projects picked for this run
---@field cwd string Directory the command should run in

---@class Config
---@field nx_cmd string Command to use for executing actions
---@field list_projects_cmd function Generates a command string to list projects based on the provided target.
---Open an external terminal instead of using the internal term.
---String uses '{}' as placeholder (e.g. 'kitty -e {}'),
---function receives cmd and returns the full command string.
---@field external_term_cmd string | nil | fun(cmd: string): string
---Launch cmd yourself. For multiplexers whose API needs more than one call,
---or when the target and project names are wanted for a window label.
---Return false to fall back to external_term_cmd, then the internal term.
---@field term_handler nil | fun(cmd: string, ctx: TermContext): boolean | nil
---@field preferred_picker 'fzf-lua' | 'snacks' Select preferred picker
config = {
  nx_cmd            = "nx",
  ---@param target string
  ---@return string
  list_projects_cmd = function(target)
    return "nx show projects --with-target " .. target
  end,
  external_term_cmd = nil,
  term_handler      = nil,
  preferred_picker = "fzf-lua"
}

return config
