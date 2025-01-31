local M = {}

local utils = require("fzf-nx.utils")
local config = require("fzf-nx.config")
local cache = require("fzf-nx.cache")

--- @type Config
M.config = config

--- Run target with picker for selection
---@param target string NX target E.g. serve, lint
M.nx_run = function(target)
	if not utils.is_nx_monorepo() then
		return
	end

	local ok_fzf, fzf = pcall(require, "fzf-lua")
	local ok_snacks, snacks = pcall(require, "snacks")

	local use_fzf = ok_fzf and (M.config.preferred_picker == "fzf-lua" or not ok_snacks)
	local use_snacks = ok_snacks and (M.config.preferred_picker == "snacks" or not ok_fzf)

	if use_fzf then
		fzf.fzf_exec(M.config.list_projects_cmd(target), {
			prompt = string.format("NX %s>", target),
			fzf_opts = { ["--multi"] = true },
			actions = {
				["default"] = function(selected)
					local cmd = ""
					if #selected > 1 then
						cmd = string.format(
							"run-many --target=%s --projects=%s --parallel",
							target,
							table.concat(selected, ",")
						)
					else
						cmd = string.format("%s %s", target, selected[1])
					end

					if M.config.open_on_serve and target == "serve" then
						cmd = cmd .. " --open"
					end

					utils.nx_term(cmd)
				end,
			},
		})
	elseif use_snacks then
		snacks.picker("nx", {
			prompt = string.format("%s>", target),
			layout = {
				preset = "vscode",
			},
			format = "text",
			preview = "none",
			finder = function(opts, ctx)
				-- Show the picker right away, nx takes decades to run
				ctx.picker:show()

				local projects = cache.get(target)
				if #projects > 0 then
					return projects
				else
					-- Oh Lord have mercy...
					opts.on_change = function(picker)
						local picker_items = picker:items()

						if #picker_items > 0 then
							cache.set(
								target,
								vim.tbl_map(function(item)
									return { text = item.text }
								end, picker_items)
							)

							-- Remove handler when done
							opts.on_change = nil
						end
					end

					return require("snacks.picker.source.proc").proc({
						opts,
						-- TODO: Bit weird, should probably do this properly
						{
							cmd = "sh",
							args = { "-c", M.config.list_projects_cmd(target) },
						},
					}, ctx)
				end
			end,
			confirm = function(picker)
				picker:close()
				local selected = picker:selected({ fallback = true })

				local cmd = ""
				if #selected > 1 then
					local selected_items = {}
					for _, item in ipairs(selected) do
						table.insert(selected_items, item.text)
					end
					cmd = string.format(
						"run-many --target=%s --projects=%s --parallel",
						target,
						table.concat(selected_items, ",")
					)
				else
					cmd = string.format("%s %s", target, selected[1].text)
				end

				if M.config.open_on_serve and target == "serve" then
					cmd = cmd .. " --open"
				end

				utils.nx_term(cmd)
			end,
		})
	else
		vim.notify("No supported picker available")
	end
end

--- Setup fzf-nx plugin
---@param args Config?
M.setup = function(args)
	M.config = vim.tbl_deep_extend("force", M.config, args or {})
	cache.load()
end

return M
