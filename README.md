# fzf-nx.nvim

Plugin for using NX within Neovim using fzf-lua or Snacks picker.


## Installation

Install with lazy:

```lua
{
  "James-Kni/fzf-nx.nvim",
  dependencies = {
    "ibhagwan/fzf-lua" -- or "folke/snacks.nvim"
  },
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
  -- Command used for getting a list of NX projects
  list_projects_cmd = function(target)
    return "nx show projects --with-target " .. target
  end,
  -- Run using an external terminal. E.g. "kitty sh -c '{}'"
  -- The '{}' will be replaced with the command to execute
  -- When not set, the internal terminal will be used.
  external_term_cmd = nil,
  -- Launch the command yourself, for terminals that need more than one call.
  -- Takes precedence over external_term_cmd.
  term_handler = nil,
  -- Manually select preferred picker 'fzf-lua' or 'snacks'
  preferred_picker = "fzf-lua"
}
```

## Options

- `vim.g.nx_env` can be used to set environment variables to use with NX commands.

### term_handler

`external_term_cmd` covers terminals you can start with one shell command. Some
multiplexers (herdr, tmux, wezterm, kitty remote control) need several calls,
because the window or pane id only comes back from the first one. Use
`term_handler` for those. It gets the full command and the picker context, and
does the launching itself. Return `false` and the plugin falls back to
`external_term_cmd`, then to the internal terminal.

```lua
---@param cmd string Full command, with nx_cmd and vim.g.nx_env already applied
---@param ctx TermContext Target, projects and cwd from the picker
term_handler = function(cmd, ctx)
  if vim.env.TMUX == nil then
    return false
  end

  vim.system({
    "tmux", "new-window",
    "-n", string.format("NX %s", ctx.target),
    "-c", ctx.cwd,
    "-d",
    string.format("%s; read", cmd),
  }):wait()
end
```
