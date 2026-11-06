-- Run / debug the Catch2 TEST_CASE (and enclosing SECTIONs) under the cursor
-- via cmake-tools, which builds the test target first.

-- Escape Catch2 test-spec metacharacters in a test/section name.
local function escape(name)
	return (name:gsub("([\\,%[%]%*])", "\\%1"))
end

-- true if (row, col) [1-based row, 0-based col] is inside a string or comment
local function in_string_or_comment(row, col)
	local ok, caps = pcall(vim.treesitter.get_captures_at_pos, 0, row - 1, col)
	if not ok then
		return false
	end
	for _, c in ipairs(caps) do
		if c.capture:match("^string") or c.capture:match("^comment") then
			return true
		end
	end
	return false
end

-- Line number of the '}' closing the first '{' at/after (row, col), or nil.
local function block_end(row, col)
	local view = vim.fn.winsaveview()
	vim.api.nvim_win_set_cursor(0, { row, col })
	local open = vim.fn.searchpos("{", "cW")
	local close = nil
	if open[1] ~= 0 then
		local skip = function()
			local p = vim.api.nvim_win_get_cursor(0)
			return in_string_or_comment(p[1], p[2]) and 1 or 0
		end
		close = vim.fn.searchpairpos("{", "", "}", "nW", skip)[1]
	end
	vim.fn.winrestview(view)
	return (close and close ~= 0) and close or nil
end

-- Returns { test_name, section1, section2, ... } or nil.
local function nearest_test()
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, cur, false)

	local test_row, test_name
	for row = cur, 1, -1 do
		local l = lines[row]
		local name = l:match('^%s*TEST_CASE%s*%(%s*"(.-)"')
			or l:match('^%s*TEST_CASE_METHOD%s*%(.-,%s*"(.-)"')
		local scenario = l:match('^%s*SCENARIO%s*%(%s*"(.-)"')
		if scenario then
			name = "Scenario: " .. scenario
		end
		if name then
			test_row, test_name = row, name
			break
		end
	end
	if not test_row then
		return nil
	end

	local spec = { test_name }
	for row = test_row + 1, cur do
		local l = lines[row]
		local s, sname = l:match('^%s*()SECTION%s*%(%s*"(.-)"')
		if s then
			local e = block_end(row, s - 1)
			if e and e >= cur then
				table.insert(spec, sname)
			end
		end
	end
	return spec
end

local function catch_args()
	local spec = nearest_test()
	if not spec then
		vim.notify("No TEST_CASE found above cursor", vim.log.levels.WARN)
		return nil
	end
	local args = { escape(spec[1]) }
	for i = 2, #spec do
		vim.list_extend(args, { "-c", spec[i] })
	end
	vim.notify("Catch2: " .. table.concat(spec, " / "))
	return args
end

local TARGET = "toyctre_tests"

return {
	"Civitasv/cmake-tools.nvim",
	keys = {
		{
			"<leader>tr",
			function()
				local args = catch_args()
				if args then
					require("cmake-tools").run({ target = TARGET, args = args })
				end
			end,
			desc = "Run Nearest Catch2 Test",
		},
		{
			"<leader>td",
			function()
				local args = catch_args()
				if args then
					require("cmake-tools").debug({ target = TARGET, args = args })
				end
			end,
			desc = "Debug Nearest Catch2 Test",
		},
	},
}
