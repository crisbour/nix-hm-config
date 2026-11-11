require("aerial").setup({
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "[", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "]", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
-- Toggle tree of symbols from tree-sitter
vim.keymap.set("n", "<A-s>", "<cmd>AerialToggle!<CR>")
--vim.keymap.set("n", "<A-z>", "<cmd>AerialNavToggle<CR>")
