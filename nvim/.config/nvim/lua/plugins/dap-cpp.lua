return {
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			local adapter = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}
			dap.adapters.codelldb = adapter
			dap.adapters.lldb = adapter
			-- C/C++ launch configs come from LazyVim's clangd extra ("Launch file")
			-- as a manual fallback; the normal path is :CMakeDebug below.
		end,
	},
	{
		-- Loaded by LazyVim's cmake extra whenever cwd contains a CMakeLists.txt
		"Civitasv/cmake-tools.nvim",
		opts = {
			-- build/Debug, build/Release, ... (one dir per variant)
			cmake_build_directory = "build/${variant:buildType}",
			cmake_dap_configuration = {
				name = "cpp",
				type = "codelldb",
				request = "launch",
				stopOnEntry = false,
				runInTerminal = true,
				console = "integratedTerminal",
			},
		},
		keys = {
			-- configure (if needed) + build + launch the selected target under codelldb
			{ "<leader>dd", "<cmd>CMakeDebug<cr>", desc = "CMake: Build & Debug" },
			{ "<leader>dT", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "CMake: Select Launch Target" },
			{
				"<leader>dv",
				function()
					-- presets project: picking a build preset also sets its configure preset
					if require("cmake-tools.presets").exists(vim.uv.cwd()) then
						vim.cmd("CMakeSelectBuildPreset")
					else
						vim.cmd("CMakeSelectBuildType")
					end
				end,
				desc = "CMake: Select Build Type / Preset",
			},
			{ "<leader>dA", ":CMakeLaunchArgs ", desc = "CMake: Set Launch Args" },
		},
	},
}
