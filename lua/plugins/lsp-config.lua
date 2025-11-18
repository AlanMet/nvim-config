-- lua/plugins/lsp-config.lua
--
-- This file configures all your Language Servers
-- and their installer (Mason).

return {
  -- This is the Mason plugin, which installs LSPs and tools
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ensure_installed = {
          -- For none-ls (linters/formatters)
          "stylua",
          "prettier",
          "black",
          "isort",
          "eslint_d",
          -- For Telescope
          "fd",
        }
      })
    end,
  },

  -- This plugin connects Mason to lspconfig
  { "williamboman/mason-lspconfig.nvim" },

  -- This is the main LSP configuration plugin
  {
    "neovim/nvim-lspconfig",
    -- It depends on the two plugins above
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    
    -- This is the main config function
    config = function()
      -- 1. Get capabilities (for nvim-cmp)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 2. Define our "on_attach" function (for keymaps)
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      -- 3. Tell Mason-LSPConfig which servers to install
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "clangd",
          "pyright",
          "dartls",
          "cssls",
          "html"
        },
      })
      
      -- 4. Get the lspconfig plugin
      local lspconfig = require("lspconfig")

      -- 5. Define the list of servers to set up
      local servers = {
        "lua_ls",
        "ts_ls",
        "clangd",
        "pyright",
        "dartls",
        "cssls",
        "html"
      }

      -- 6. Loop over the servers and set them up
      for _, server_name in ipairs(servers) do
        lspconfig[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    end,
  },
}