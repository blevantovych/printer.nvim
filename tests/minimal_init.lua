local root_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
local deps_dir = root_dir .. "/.tests/deps"

vim.opt.runtimepath:prepend(root_dir)
vim.opt.runtimepath:append(deps_dir .. "/plenary.nvim")
vim.opt.runtimepath:append(deps_dir .. "/nvim-treesitter")

vim.cmd("runtime plugin/plenary.vim")
vim.cmd("runtime plugin/nvim-treesitter.lua")
vim.cmd("filetype on")
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
