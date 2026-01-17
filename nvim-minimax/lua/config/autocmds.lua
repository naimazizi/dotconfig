local group = vim.api.nvim_create_augroup('nvim_minimax', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
	group = group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- CoC highlight on idle cursor (skip mini.starter)
vim.api.nvim_create_autocmd("CursorHold", {
	group = group,
	callback = function(args)
		local buf = args.buf
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end
		if vim.bo[buf].filetype == "ministarter" then
			return
		end
		if vim.fn.exists("*CocActionAsync") == 1 then
			vim.fn.CocActionAsync("highlight")
		end
	end,
	desc = "Coc: highlight symbol under cursor",
})
