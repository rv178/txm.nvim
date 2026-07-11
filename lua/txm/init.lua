local M = {}

local function open_popup(text)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)

	local width = math.min(vim.fn.max(vim.tbl_map(vim.fn.strdisplaywidth, text)), math.floor(vim.o.columns * 0.8))
	local height = math.min(#text, math.floor(vim.o.lines * 0.8))

	local win = vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = (vim.o.lines - height) / 2,
		col = (vim.o.columns - width) / 2,
		border = 'solid',
		title = 'Txm',
		title_pos = 'center',
		style = 'minimal',
	})

	vim.bo[buf].modifiable = false
	vim.wo[win].winhighlight = 'NormalFloat:NormalFloat,FloatTitle:NormalFloat'
	vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = buf })
end

function M.preview()
	vim.cmd('noautocmd normal! "zy')
	local text = vim.fn.getreg('z')
	vim.fn.setreg('z', '')

	open_popup(vim.fn.systemlist({ 'txm', text }))
end

return M
