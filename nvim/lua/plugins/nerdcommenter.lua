-- for nerdcommenter
vim.g.NERDCreateDefaultMappings = 0

return {
	"preservim/nerdcommenter",
	config = function()
		vim.keymap.set({ "n", "v" }, "<C-/>", ':call nerdcommenter#Comment(0,"toggle")<CR>', { silent = true })
		vim.g.NERDSpaceDelims = 1
		vim.g.NERDDefaultAlign = "left"
	end,
}
