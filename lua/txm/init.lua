local M = {}
local pad = 4
local parser = require('txm.parser')

local function open_popup(text)
	-- add padding
	local pad_str = string.rep(' ', pad)
	text = vim.tbl_map(function(line) return pad_str .. line end, text)
	text = vim.list_extend(vim.list_extend({ '' }, text), { '' })

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)

	local width = math.min(vim.fn.max(vim.tbl_map(vim.fn.strdisplaywidth, text)), math.floor(vim.o.columns * 0.8))
	local height = math.min(#text, math.floor(vim.o.lines * 0.8))

	local win = vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width + pad,
		height = height,
		row = (vim.o.lines - height) / 2,
		col = (vim.o.columns - width) / 2,
		border = 'single',
		title = ' txm ',
		title_pos = 'center',
		style = 'minimal',
	})

	vim.bo[buf].modifiable = false
	vim.wo[win].winhighlight = 'NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal'
	vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = buf })
end

function M.preview()
	vim.cmd('noautocmd normal! "zy')
	local text = vim.fn.getreg('z')
	vim.fn.setreg('z', '')

	open_popup(vim.fn.systemlist({ 'txm', '--unboxed', text }))
end

local function offset_to_line(lines, offset)
	local pos = 0
	for lnum, line in ipairs(lines) do
		pos = pos + #line + 1
		if offset <= pos then return lnum - 1 end
	end

	return #lines - 1
end

local ns = vim.api.nvim_create_namespace('txm')
local group = vim.api.nvim_create_augroup('txm', { clear = true })

function M.render()
	local buf = vim.api.nvim_get_current_buf()
	M.clear()

	vim.api.nvim_clear_autocmds({ group = group, buffer = buf })
	vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
		group = group,
		buffer = buf,
		callback = function() M.render() end,
	})

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local text = table.concat(lines, '\n')

	for _, r in ipairs(parser.find_latex(text)) do
		local content = vim.trim(r.content)
		if content ~= '' then
			local out = vim.fn.systemlist({ 'txm', content })
			local virt = {}

			for _, l in ipairs(out) do
				virt[#virt + 1] = { { l, 'Comment' } }
			end

			if #virt > 0 then
				vim.api.nvim_buf_set_extmark(buf, ns, offset_to_line(lines, r.e), 0, {
					virt_lines = virt,
				})
			end
		end
	end
end

function M.clear(stop)
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	if stop then
		vim.api.nvim_clear_autocmds({ group = group, buffer = buf })
	end
end

function M.active(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	return #vim.api.nvim_get_autocmds({ group = group, buffer = buf }) > 0
end

function M.toggle()
	if M.active() then M.clear(true) else M.render() end
end

return M
