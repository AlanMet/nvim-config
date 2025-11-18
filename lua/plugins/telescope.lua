-- lua/plugins/telescope.lua
--
-- This is the final, working config.
-- It uses the BUILT-IN find_files picker, which filters as you type,
-- but we override its command to ONLY find folders.
--
return {
  {
    "nvim-telescope/telescope.nvim",
    -- We are on the latest version (no tag)
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")
      local state = require("telescope.actions.state") -- Get the 'state' module

      -- Standard Telescope setup
      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          file_browser = {
            theme = "dropdown",
            cwd_to_path = true,
            hijack_netrw = true,
          },
        },
      })

      -- Load extensions
      telescope.load_extension("ui-select")
      telescope.load_extension("file_browser")

      -- Standard Keymaps
      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
      vim.keymap.set("n", "<leader>?", builtin.keymaps, {})

      --
      -- CUSTOM "OPEN FOLDER" COMMAND
      --
      vim.keymap.set("n", "<leader>op", function()
        -- We are using the built-in 'find_files' picker
        builtin.find_files({
          prompt_title = "Open Folder",
          
          -- We override its default find_command with our smart 'fd' command
          find_command = {
            "fd",
            "--type", "d",         -- Find directories
            "--no-hidden",         -- Ignore hidden
            "--max-depth", "5",    -- Don't go too deep
            
            -- Exclude all common junk folders
            "-E", ".git",
            "-E", "node_modules",
            "-E", "venv",
            "-E", ".venv",
            "-E", "__pycache__",
            "-E", "site-packages",
            "-E", "target",
            
            ".",                   -- Search in...
            vim.fn.expand("~")     -- ...your home directory
          },
          
          -- Start the picker in your home directory
          cwd = vim.fn.expand("~"),
          
          attach_mappings = function(prompt_bufnr, map)
            
            -- This is the <Enter> key.
            -- We replace the default "open file" action.
            actions.select_default:replace(function()
              local selection = state.get_selected_entry()
              actions.close(prompt_bufnr)
              -- "Open Folder" (cd into the selected directory)
              vim.cmd.cd(selection.value)
            end)

            return true
          end,
        })
      end, { desc = "Open Project (any folder)" })
    end,
  },
}