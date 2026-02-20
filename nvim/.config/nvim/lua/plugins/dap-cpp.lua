return {
	"mfussenegger/nvim-dap",
	opts = function()
		local dap = require("dap")
		local adapter = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.exepath("codelldb"),
				args = { "--port", "${port}" },
			},
		}
		dap.adapters.codelldb = adapter
		dap.adapters.lldb = adapter  -- cmake-tools.nvim uses this name
		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "codelldb",
				request = "launch",
				program = function()
					local exe = vim.fn.input("Executable: ", vim.fn.getcwd() .. "/build-debug/", "file")
					if exe == "" then return nil end
					local makeprg = vim.o.makeprg
					vim.notify("Building: " .. makeprg, vim.log.levels.INFO)
					local out = vim.fn.system(makeprg)
					if vim.v.shell_error ~= 0 then
						vim.notify("Build failed:\n" .. out, vim.log.levels.ERROR)
						return nil
					end
					return exe
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}
	end,
}
