vim.api.nvim_create_user_command("Nx", function(opts)
  require("fzf-nx.command").command_handler(opts.fargs)
end, {
  desc = "NX command",
  nargs = "*",
  complete = function(_, line)
    return require("fzf-nx.command").command_complete(line)
  end
})
