local command = {}

local fzf_nx = require("fzf-nx")
local utils = require("fzf-nx.utils")

local function has_value(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

function command.command_handler(args)
  if not utils.is_nx_monorepo() then
    return nil
  end

  if args[1] == "reset" then
    utils.nx_reset()
  elseif args[1] == "serve" then
    if args[2] ~= nil then
      utils.nx_term("serve " .. args[2])
    else
      fzf_nx.nx_run('serve')
    end
  else
    utils.nx_term(table.concat(args, " "))
  end
end

function command.command_complete(line)
  if not utils.is_nx_monorepo(true) then
    return nil
  end

  local args = vim.split(line, "%s+")
  local arg_pos = #args - 2

  if arg_pos == 0 then
    local options = {
      "serve",
      "lint",
      "test",
      "reset",
    }

    return vim.tbl_filter(function(v)
      return vim.startswith(v, args[2])
    end, options)
  end

  if arg_pos == 1 then
    local options = {}

    if has_value({ "serve", "test", "lint" }, args[2]) then
      options = vim.fn.systemlist(fzf_nx.config.list_projects_cmd(args[2]))
    end

    return vim.tbl_filter(function(v)
      return vim.startswith(v, args[3])
    end, options)
  end
end

return command
