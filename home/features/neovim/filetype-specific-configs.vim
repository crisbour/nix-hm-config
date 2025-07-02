" FILETYPE SPECIFIC CONFIGURATIONS
" =============================================================================
"set modeline " allow stuff like vim: set spelllang=en_us at the top of files

" Automatically break lines at 80 characters on TeX/LaTeX, Markdown, and text
" files
" Enable spell check on TeX/LaTeX, Markdown, and text files
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst,*.qmd setlocal tw=80
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst,*.qmd setlocal linebreak breakindent
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst,*.qmd setlocal spell spelllang=en_gb
autocmd BufNewFile,BufRead *.tex,*.md,*.txt,*.rst,*.qmd match Over100Length /\%81v.\+/

" Set specific indentation for Julia and Python
autocmd FileType julia setlocal shiftwidth=4 tabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4
