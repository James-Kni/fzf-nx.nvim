local utils = {}

--- Check if cwd is in an NX monorepo
--- @param silent boolean? Don't show notification
---@return boolean
function utils.is_nx_monorepo(silent)
	local current_dir = vim.fn.getcwd()
	local found_nx_json = false

	repeat
		if vim.fn.findfile("nx.json", current_dir) ~= "" then
			found_nx_json = true
			break
		end

		local parent_dir = vim.fn.fnamemodify(current_dir, ":h")

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
function utils.nx_term(args)
	local config = require("fzf-nx").config

	local cmd = string.format("%s %s", config.nx_cmd, args)

	if vim.g.nx_env ~= nil then
		cmd = string.format("%s %s", vim.g.nx_env, cmd)
	end

	if config.external_term_cmd == nil then
		vim.cmd(string.format("term %s", cmd))
	else
		if type(config.external_term_cmd) == "function" then
			cmd = config.external_term_cmd(cmd)
		else
			cmd = config.external_term_cmd:gsub("{}", cmd)
		end
		vim.fn.system(cmd .. " &")
	end
end

---Run NX reset command
---@param clear_cache boolean Clear plugin cache (only snacks picker makes use of this)
utils.nx_reset = function(clear_cache)
	local config = require("fzf-nx").config

	vim.fn.jobstart(string.format("%s reset", config.nx_cmd), {
		on_exit = function()
			if clear_cache then
				require("fzf-nx.cache").clear()
			end

			vim.notify("Reset complete!")
		end,
	})
end

return utils
