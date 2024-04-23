# fzf-nx.nvim

Plugin for using NX within Neovim using fzf-lua.


## Installation

Install with lazy:

```lua
{
  "James-Kni/fzf-nx.nvim",
  dependencies = { "ibhagwan/fzf-lua" },
  opts = {},
}
```

## Default config 
```lua
{
  -- Use builtin keymaps
  keymaps           = true,
  -- Command used for running NX commands
  nx_cmd            = "nx",
  -- Open browser on project serve
  open_on_serve     = false,
  -- Command used to getting a list of NX projects
  list_projects_cmd = function(target)
    return "nx show projects --with-target " .. target
  end,
  -- Run using an external terminal. E.g. "kitty -e"
  -- When not set, the internal terminal will be used
  external_term_cmd = nil
}
```
    
