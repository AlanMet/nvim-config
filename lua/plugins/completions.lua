return {
  {
    "hrsh7th/cmp-nvim-lsp",
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

      -- Try to lazily load VSCode-style snippets for LuaSnip if available
      pcall(function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end)

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- Prefer LuaSnip if present, otherwise fall back to vsnip if available
            local ok_ls, luasnip = pcall(require, "luasnip")
            if ok_ls and luasnip and luasnip.lsp_expand then
              luasnip.lsp_expand(args.body)
              return
            end

            if vim.fn.exists('*vsnip#anonymous') == 1 then
              vim.fn["vsnip#anonymous"](args.body)
            end
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          -- { name = "nvim_lsp" },
          { name = "luasnip" }, -- For luasnip users.
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
