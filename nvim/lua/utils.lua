function vimCmd(cmd)
	local handler = function()
		vim.cmd(cmd)
	end

	return handler
end
