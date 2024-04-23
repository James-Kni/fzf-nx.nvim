local M = {}

local utils = require("fzf-nx.utils")
local config = require("fzf-nx.config")

--- @type Config
M.config = config

--- Run target with fzf for selecting project
---@param target string NX target E.g. serve, lint
---@param opts any? fzf options
M.nx_run = function(target, opts)
  local fzf = require("fzf-lua")

  if utils.is_nx_monorepo() then
    opts = opts or {}

    local options = {
      prompt = string.format("NX %s>", target),
      fzf_opts = { ['--multi'] = true },
      actions = {
        ['default'] = function(selected)
          local cmd = ""
          if #selected > 1 then
            cmd = string.format("run-many --target=%s --projects=%s --parallel", target, table.concat(selected, ","))
          else
            cmd = string.format("%s %s", target, selected[1])
          end

          if M.config.open_on_serve and target == "serve" then
            cmd = cmd .. " --open"
          end

          utils.nx_term(cmd)
        end,
      }
    }

    opts = vim.tbl_deep_extend("force", options, opts or {})
    fzf.fzf_exec(M.config.list_projects_cmd(target), opts)
  end
end

--- Setup builtin keymaps
local function setup_keymaps()
  vim.keymap.set(
    'n', '<leader>ns',
    function()
      M.nx_run('serve')
    end,
    { desc = 'Serve project' }
  )

  vim.keymap.set(
    'n', '<leader>nt',
    function()
      M.nx_run('test')
    end,
    { desc = 'Test project' }
  )

  vim.keymap.set(
    'n', '<leader>nl',
    function()
      M.nx_run('lint')
    end,
    { desc = 'Lint project' }
  )

  vim.keymap.set(
    'n', '<leader>nR',
    utils.nx_reset,
    { desc = 'Reset' }
  )
end

--- Setup fzf-nx plugin
---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})

  if M.config.keymaps == true then
    setup_keymaps()
  end
end

return M
