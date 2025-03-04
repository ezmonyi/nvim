return {
  "rcarriga/nvim-dap-ui",
  version = "*",
  dependencies = {
    "mfussenegger/nvim-dap",
    "theHamsta/nvim-dap-virtual-text",
    "nvimtools/hydra.nvim",
    "nvim-lualine/lualine.nvim",
  },
  config = function()
    require("nvim-dap-virtual-text").setup({ virt_text_pos = "eol" })
    --
    --Setup status line for Hydra
    local hydra_statusline = require("hydra.statusline")

    require("lualine").setup({
      options = {
        refresh = {
          statusline = 250,
        }
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              if hydra_statusline.is_active() == true and vim.fn.mode() == "n" then
                return hydra_statusline.get_name()
              end
              return str
            end,

            color = function(tb)
              if hydra_statusline.is_active() == true and vim.fn.mode() == "n" then
                return { bg = hydra_statusline.get_color() }
              end
              return tb
            end,
          }
        }
      }
    })

  end,
}
