return {
	-- Use the official null-ls plugin (lazy-loaded to avoid deprecation warnings at startup)
	"jose-elias-alvarez/null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local ok, null_ls = pcall(require, "null-ls")
		if not ok or not null_ls then
			vim.notify("null-ls not found; skipping null-ls setup", vim.log.levels.WARN)
			return
		end

		local builtins = null_ls.builtins

		local sources = {
			builtins.formatting.stylua,
			builtins.formatting.prettier,
			builtins.formatting.black,
			builtins.formatting.isort,
		}

		-- Add eslint_d diagnostics if available; otherwise warn and skip it
		if builtins and builtins.diagnostics and builtins.diagnostics.eslint_d then
			table.insert(sources, builtins.diagnostics.eslint_d)
		else
			vim.schedule(function()
				vim.notify("null-ls builtin 'eslint_d' not available. Make sure you're using a null-ls version that provides it and that the 'eslint_d' executable is installed.", vim.log.levels.WARN)
			end)
		end

		null_ls.setup({
			sources = sources,
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
