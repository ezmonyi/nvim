return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"jayp0521/mason-null-ls.nvim",
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		require("mason-null-ls").setup({
			ensure_installed = {
				"stylua", -- lua formatter
				"ruff", -- Python linter and formatter
			},
			automatic_installation = true,
		})
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters
		null_ls.setup({
			sources = {
				formatting.stylua,
				require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
				require("none-ls.formatting.ruff_format"),
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "format buffer" })
	end,
}
