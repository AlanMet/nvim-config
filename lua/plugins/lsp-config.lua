-- lua/plugins/lsp-config.lua
--
-- This file configures all your Language Servers
-- and their installer (Mason).
-- (This is the FINAL, correct "up-to-date" version)

return {
  -- This is the Mason plugin, which installs LSPs and tools
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ensure_installed = {
          -- For none-ls
          "stylua", "prettier", "black", "isort", "eslint_d",
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
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    
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

      -- 3. Define the list of servers to install
      local servers = {
        "lua_ls",
        "ts_ls",
        "clangd",
        "pyright",
        "dartls",
        "cssls",
        "html"
      }

      -- 4. THIS IS THE NEW, CORRECT SETUP BLOCK --
      -- This is one single call to mason-lspconfig
      require("mason-lspconfig").setup({
        -- This list tells Mason which LSPs to install
        ensure_installed = servers,
        
        -- This 'handlers' table replaces the old 'for' loop
        handlers = {
          -- This is the "default setup" function.
          -- It will be called for every server in the 'ensure_installed' list.
          function(server_name)
            require("lspconfig")[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
        }
      })
    end,
  },
}