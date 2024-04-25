local M = {}

--- Check if cwd is in an NX monorepo
--- @param silent boolean? Don't show notification
---@return boolean
M.is_nx_monorepo = function(silent)
  local current_dir = vim.fn.getcwd()
  local found_nx_json = false

  repeat
    if vim.fn.findfile('nx.json', current_dir) ~= '' then
      found_nx_json = true
      break
    end

    local parent_dir = vim.fn.fnamemodify(current_dir, ':h')

    if parent_dir == current_dir then
      break
    end

    current_dir = parent_dir
  until false

  if found_nx_json then
    return true
  else
    if silent ~= true then
      vim.notify("Not in an NX monorepo")
    end

    return false
  end
end

--- Execute NX command in terminal using nx_cmd from config
--- @param args string NX command args
M.nx_term = function(args)
  local config = require("fzf-nx").config

  if config.external_term_cmd == nil then
    vim.cmd(string.format("term %s %s", config.nx_cmd, args))
  else
    local nx_cmd = string.format(
      "%s %s",
      config.nx_cmd,
      args
    )
    vim.fn.system(config.external_term_cmd:gsub('{}', nx_cmd) .. ' &')
  end
end

---Run NX reset command
M.nx_reset = function()
  vim.fn.jobstart("nx reset", {
    on_exit = function()
      vim.notify("Reset complete!")
    end
  })
end

return M
