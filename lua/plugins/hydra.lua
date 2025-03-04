return {
	"nvimtools/hydra.nvim",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"nvim-lualine/lualine.nvim",
	},
	config = function()
		local Hydra = require("hydra")

		DapHydra = Hydra({
			name = "DEBUG",
			config = {
				color = "pink",
				desc = "Debug mode",
				invoke_on_body = true,
				hint = {
					float_opts = {
						border = "rounded",
					},
					hide_on_load = true,
					show_name = false,
				},
			},

			mode = "n",
			body = "<Leader>d",
			heads = {
				{
					"U",
					function()
						require("dapui").toggle()
					end,
				},
				{
					".",
					function()
						require("dap").toggle_breakpoint()
					end,
				},
				{
					">",
					function()
						if vim.bo.filetype ~= "dap-float" then
							require("dap").continue()
						end
					end,
				},
				{
					"H",
					function()
						if vim.bo.filetype ~= "dap-float" then
							require("dap").step_back()
						end
					end,
				},
				{
					"K",
					function()
						if vim.bo.filetype ~= "dap-float" then
							require("dap").step_out()
						end
					end,
				},
				{
					"L",
					function()
						if vim.bo.filetype ~= "dap-float" then
							print(vim.bo.filetype)
							require("dap").step_over()
						end
					end,
				},
				{
					"J",
					function()
						if vim.bo.filetype ~= "dap-float" then
							require("dap").step_into()
						end
					end,
				},
				{
					"X",
					function()
						require("dap").terminate()
					end,
				},
				{
					"*",
					function()
						require("dap").run_to_cursor()
					end,
				},
				{ "<Leader>d", nil, { exit = true, nowait = true } },
			},
		})
	end,
}
