
set showbreak=↩\

" Custom keybindings ----------------------------------------------------------
" Make j and k behave nicer when the line wraps
noremap j gj
noremap k gk

syntax on
filetype plugin indent on

" Tabs
set expandtab
set shiftwidth=2
set tabstop=4

set number                                              " Show the current line number
set scrolloff=5                                         " Always have 5 lines above/below the current line

set foldmethod=indent
set foldnestmax=5
set foldlevelstart=99
set foldcolumn=0

set list
set listchars=tab:>-


"set splitbelow

" Max code size highlighted limiters
"let &colorcolumn="80,".join(range(120,999),",")
"highlight ColorColumn ctermbg=black guibg=black

let mapleader=' '

" TODO: Configure vim.diagnostic
"vim.diagnostic.config({
"  virtual_text = true,
"  signs = true,
"  underline = true,
"  update_in_insert = false,
"  severity_sort = false,
"})
