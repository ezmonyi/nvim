return {
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.event:on("confirm_done", function(event)
        local entry = event.entry
        if not entry or not entry.source or entry.source.name ~= "nvim_lsp" then
          return
        end

        local item = entry:get_completion_item() or {}
        local inserted = (item.textEdit and item.textEdit.newText) or item.insertText or item.word or item.label or ""
        if not inserted:find("\\/", 1, true) and not inserted:match("/$") then
          return
        end

        vim.schedule(function()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_get_current_line()
          local before = line:sub(1, col)
          if before:sub(-2) ~= "\\/" then
            return
          end

          vim.api.nvim_set_current_line(before:sub(1, -3) .. "/" .. line:sub(col + 1))
          vim.api.nvim_win_set_cursor(0, { row, col - 1 })
        end)
      end)

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
	  ["<C-n>"] = cmp.mapping.select_next_item(),
	  ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
