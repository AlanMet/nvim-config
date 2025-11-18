-- lua/plugins/completions.lua
--
-- This file group all plugins related to autocompletion
-- (nvim-cmp, snippets, lsp-bridge, and autopairs-bridge)

return {
  -- This is the "bridge" plugin that was missing (FIXES ERROR 2)
  { "hrsh7th/cmp-nvim-lsp" },

  -- This is your snippet engine
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },

  -- This is the main completion engine
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      require("luasnip.loaders.from_vscode").lazy_load()

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
        -- This 'mapping' block is now clean (FIXES ERROR 1)
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })

      -- This "wires" nvim-cmp to nvim-autopairs
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },
}