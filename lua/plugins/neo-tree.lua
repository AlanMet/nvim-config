-- lua/plugins/neo-tree.lua

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  
  -- Replace your old 'config' function with this one
  config = function()
    -- This keeps your keymaps
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})

    -- This adds the setup configuration
    require("neo-tree").setup({
      -- This makes it close when it's the last window
      close_if_last_window = true, 
      
      -- This makes the tree "follow" your open file
      follow_current_file = {
        enabled = true,
      },
      
      -- THIS IS THE FIX
      filesystem = {
        filtered_items = {
          -- This hides them by default
          visible = false, 
          -- These are the rules
          hide_dotfiles = true,
          hide_gitignored = true,
          -- This hides specific junk files
          never_show = { ".DS_Store", "thumbs.db" },
        }
      },
    })
  end,
}
