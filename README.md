# fzf-nx.nvim

Plugin for using NX within Neovim using fzf-lua.


## Installation

Install with lazy:

```lua
{
  "James-Kni/fzf-nx.nvim",
  dependencies = { "ibhagwan/fzf-lua" },
  opts = {},
  -- Example keymaps
  keys = {
    {
      "<leader>ns",
      function()
        require("fzf-nx").nx_run("serve")
      end,
      desc = "Serve project",
    },
    {
      "<leader>nl",
      function()
        require("fzf-nx").nx_run("lint")
      end,
      desc = "Lint project",
    },
    {
      "<leader>nR",
      function()
        require("fzf-nx.utils").nx_reset()
      end,
      desc = "Reset NX",
    }
  }
}
```

## Default config 
```lua
{
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
    
