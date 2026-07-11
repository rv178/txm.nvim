if vim.g.loaded_txm then
	return
end
vim.g.loaded_txm = 1

vim.keymap.set('v', '<Plug>(TxmPreview)', function()
	require('txm').preview()
end)

vim.api.nvim_create_user_command('TxmRender', function() require('txm').render() end, {})
vim.api.nvim_create_user_command('TxmClear', function() require('txm').clear(true) end, {})
vim.api.nvim_create_user_command('TxmToggle', function() require('txm').toggle() end, {})
