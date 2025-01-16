" Set language for the spell checker
setlocal spell spelllang=en_gb

set showbreak=↩\

" Custom keybindings ----------------------------------------------------------
" Make j and k behave nicer when the line wraps
noremap j gj
noremap k gk

" WARN: Not sure why, but "syntax on" breaks quarto-nvim/otter-nvim
"syntax on
filetype plugin indent on

" Tabs
set expandtab
set shiftwidth=2
set tabstop=2
"autocmd BufEnter *.hpp,*.cpp,.h,.c : setlocal shiftwidth=4 tabstop=4 expandtab

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

" Tree-sitter based folding. (Technically not a module because it's per windows and not per buffer.)
" -> This will respect your foldminlines and foldnestmax settings.
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable                     " Disable folding at startup.

" TODO: Configure vim.diagnostic
"vim.diagnostic.config({
"  virtual_text = true,
"  signs = true,
"  underline = true,
"  update_in_insert = false,
"  severity_sort = false,
"})
