-- sebnow telscope setup: https://github.com/sebnow/configs/blob/5eeac9291b94aecc1031ac68fe51c8e2c553914a/nix/home-manager/neovim/lua/sebnow/telescope.lua
local wk = require("which-key")
local telescope = require("telescope")
local builtin = require("telescope.builtin")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")

vim.g.maplocalleader = ';'

-- senon Layout and rg flags setup
telescope.setup {
defaults = {
  path_display = { "truncate" },
  layout_strategy = 'vertical',
  layout_config = {
    width = 0.80,
    height = 0.85,
  },
  mappings = {
    i = {
      ["<esc>"] = require("telescope.actions").close,
    },
  },
  file_sorter = sorters.get_fzy_sorter,
  file_previewer = previewers.vim_buffer_cat.new,
  grep_previewer = previewers.vim_buffer_vimgrep.new,
  qflist_previewer = previewers.vim_buffer_qflist.new,
},
-- TODO: Add https://github.com/aaronhallaert/advanced-git-search.nvim
pickers = {
  find_files = {
    layout_strategy = 'horizontal',
    layout_config = {
      preview_width = 0.4,
    },
    -- Alternative use `fd`: https://github.com/sebnow/configs/blob/5eeac9291b94aecc1031ac68fe51c8e2c553914a/nix/home-manager/neovim/lua/sebnow/telescope.lua#L24
    find_command = {
      'rg',
      '--files',
      '--hidden',
      '--glob',
      '!.git',
      '--glob',
      '!node_modules',
      '--glob',
      '!dist',
      '--glob',
      '!.direnv',
      '--glob',
      '!.venv',
    },
  },
  live_grep = {
    layout_config = { preview_height = 0.7 },
  },
  grep_string = {
    layout_config = { preview_height = 0.7 },
  },
  lsp_definitions = {
    layout_config = { preview_height = 0.75 },
  },
  lsp_implementations = {
    layout_config = { preview_height = 0.75 },
  },
  lsp_references = {
    layout_config = { preview_height = 0.75 },
  },
  lsp_dynamic_workspace_symbols = {
    layout_config = { preview_height = 0.75 },
  },
},
}

telescope.load_extension('fzy_native')

-- TODO: Not sure what this does (difference between this and live_grep?)
vim.keymap.set('n', '<localleader>fs', function()
builtin.grep_string({
  search = "",
  only_sort_text = true,
})
end, {})
vim.keymap.set('v', '<C-S>', builtin.grep_string, {})


-- File picker
vim.keymap.set("n", "<localleader>ff", builtin.find_files,  { desc = "Find files" })
vim.keymap.set("n", "<localleader>fg", builtin.live_grep,   { desc = "Search in project" })
vim.keymap.set("n", "<localleader>fb", builtin.buffers,     { desc = "Explore buffers" })
vim.keymap.set("n", "<localleader>fh", builtin.help_tags,   { desc = "Find help tags?" })

vim.keymap.set("n", "<localleader>fc", builtin.git_commits,   { desc = "Find help tags?" })
vim.keymap.set("n", "<localleader>fC", builtin.git_bcommits,   { desc = "Find help tags?" })

vim.keymap.set("n", "<localleader>fB", builtin.git_branches,          { desc = "Branches" })

--vim.keymap.set("n", "<localleader>fr" builtin.lsp_references,        { desc = "Explore references" })
vim.keymap.set("n", "<localleader>;",  builtin.command_history,       { desc = "Explore command history" })
vim.keymap.set("n", "<localleader>l",  builtin.resume,                { desc = "Resume previous list" })
vim.keymap.set("n", "<localleader>ws", builtin.lsp_workspace_symbols, { desc = "Explore workspace symbols" })
vim.keymap.set("n", "<localleader>ds", builtin.lsp_document_symbols,  { desc = "Explore document symbols" })

wk.register(mappings, opts)
