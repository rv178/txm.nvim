if vim.g.loaded_txm then
	return
end
vim.g.loaded_txm = 1

vim.keymap.set('v', '<Plug>(TxmPreview)', function()
	require('txm').preview()
end)
