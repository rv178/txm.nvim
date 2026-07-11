local M = {}

local function peek(text, i)
	return text:sub(i, i)
end

local function escaped(text, pos)
	local n = 0
	local j = pos - 1

	while j >= 1 and peek(text, j) == '\\' do
		n = n + 1
		j = j - 1
	end

	return n % 2 == 1
end

local function next_dollar(text, from)
	local i = from
	while true do
		local p = text:find('%$', i)
		if not p then return nil end

		if not escaped(text, p) then return p end
		i = p + 1
	end
end

function M.find_latex(text)
	local regions = {}
	local i = 1

	while true do
		local open = next_dollar(text, i)
		if not open then break end

		local double = peek(text, open + 1) == '$'
		local delim = double and 2 or 1

		local start = open + delim

		local close = next_dollar(text, start)
		if not close then break end

		regions[#regions + 1] = {
			content = text:sub(start, close - 1),
			e = close + delim - 1,
		}

		i = close + delim
	end
	return regions
end

return M
