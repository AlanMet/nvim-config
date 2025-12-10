return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Try requiring nvim-lspconfig; if it's not available, skip LSP setup
			local ok, lspconfig = pcall(require, "lspconfig")
			if not ok or not lspconfig then
				vim.notify("nvim-lspconfig not found; skipping LSP setup", vim.log.levels.WARN)
				return
			end

			-- Try to prefer the non-deprecated configs table to avoid triggering
			-- the lspconfig __index metamethod (which prints deprecation warnings).
			local configs_ok, configs = pcall(require, "lspconfig.configs")

			-- Define on_attach so keymaps only exist when LSP is running
			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			end

			-- Register servers with both capabilities and on_attach
			local servers = { "lua_ls", "ts_ls" }
			for _, srv in ipairs(servers) do
				-- Prefer the 'lspconfig.configs' table which doesn't invoke the
				-- deprecated __index metamethod. If that isn't available, fall back
				-- to the older pattern (may show deprecation warning).
				if configs_ok and configs and configs[srv] and type(configs[srv].setup) == "function" then
					configs[srv].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				elseif vim.lsp and vim.lsp.config and vim.lsp.config[srv] and type(vim.lsp.config[srv].setup) == "function" then
					-- Prefer the built-in vim.lsp.config if present (newer API)
					vim.lsp.config[srv].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				else
					-- Last resort: call the older lspconfig[server].setup(). This may
					-- trigger a deprecation notification via vim.notify from lspconfig's
					-- metatable __index. Temporarily suppress vim.notify to avoid
					-- noisy deprecation warnings while still setting up the server.
					local mt = getmetatable(lspconfig) or {}
					local notify_orig = vim.notify
					local suppressed = false
					if mt.__index then
						suppressed = true
						vim.notify = function() end
					end
					local ok_setup, _ = pcall(function()
						if lspconfig[srv] and type(lspconfig[srv].setup) == "function" then
							lspconfig[srv].setup({
								capabilities = capabilities,
								on_attach = on_attach,
							})
						else
							error("server not available")
						end
					end)
					if suppressed then
						vim.notify = notify_orig
					end
					if not ok_setup then
						vim.notify(string.format("lspconfig: server '%s' not available in this build", srv), vim.log.levels.WARN)
					end
				end
			end
		end,
	},
}
