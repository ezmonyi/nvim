return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function ()
     end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "%.git/", "%.o$" },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "telescope find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "telescope live_grep" })
      require("telescope").load_extension("ui-select")
    end
  }
}
