return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Your custom logo
    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    } 

    dashboard.section.header.opts.hl = "Include"

    -- The menu buttons
    dashboard.section.buttons.val = {
      dashboard.button("f", "🔎 Find file", ":Telescope find_files <CR>"),
      dashboard.button("n", "📄  New file", ":enew <CR>"),
      dashboard.button("r", "🕘  Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("t", ">_  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", "⚙️  Config", ":e $MYVIMRC <CR>"),
      dashboard.button("l", "💤  Lazy", ":Lazy <CR>"),
      dashboard.button("q", "🚪  Quit", ":qa <CR>"),
    }

    -- The footer
    local function footer()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      return "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
    end

    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = "Type"

    -- Send the config to alpha
    alpha.setup(dashboard.opts)

  end,
}
