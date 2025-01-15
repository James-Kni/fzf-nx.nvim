local cache = {}

local cache_file = vim.fn.stdpath("cache") .. "/fzf-nx_cached_projects.json"
local cached_projects = {}

function cache.load()
	if vim.fn.filereadable(cache_file) == 1 then
		local content = table.concat(vim.fn.readfile(cache_file), "\n")
		local ok, data = pcall(vim.json.decode, content)
		if not ok then
			vim.notify("Failed to load NX project cache: invalid JSON", vim.log.levels.WARN)
		else
			cached_projects = data or {}
		end
	end
end

function cache.save()
	local ok, content = pcall(vim.json.encode, cached_projects, { indent = true })
	if not ok then
		vim.notify("Failed to save NX project cache: encoding error", vim.log.levels.WARN)
	else
		vim.fn.writefile({ content }, cache_file)
	end
end

function cache.clear()
	cached_projects = {}
	cache.save()
end

function cache.get(target)
	return cached_projects[target]
end

function cache.set(target, projects)
	cached_projects[target] = projects
	cache.save()
end

return cache
