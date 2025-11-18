-- lua/plugins/autopairs.lua

return {
  "windwp/nvim-autopairs",
  -- This will load the plugin when you enter insert mode
  event = "InsertEnter",
  -- This setup is "smart" and will check for nvim-cmp
  config = function()
    require("nvim-autopairs").setup({})
  end,
}