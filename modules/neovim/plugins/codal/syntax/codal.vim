" Vim syntax file
" Language:    Codal
" Filenames:   *.codal
" Maintainer:  Zdenek Prikryl <prikryl@codasip.com>
" Last Change: 2017 Mar 31
" Remark:      Included by the CodAL syntax.

" quit when a syntax file was already loaded
if exists("b:current_syntax")
	finish
endif

syn case match

" codal keywords
syn keyword codalKeyword address_space
syn keyword codalKeyword alias
syn keyword codalKeyword arch
syn keyword codalKeyword as
syn keyword codalKeyword assembler
syn keyword codalKeyword attribute
syn keyword codalKeyword binary
syn keyword codalKeyword bit
syn keyword codalKeyword bitsizeof
syn keyword codalKeyword break
syn keyword codalKeyword bus
syn keyword codalKeyword cache
syn keyword codalKeyword case
syn keyword codalKeyword clog2
syn keyword codalKeyword component
syn keyword codalKeyword connect
syn keyword codalKeyword continue
syn keyword codalKeyword decoder
syn keyword codalKeyword decoders
syn keyword codalKeyword default
syn keyword codalKeyword do
syn keyword codalKeyword element
syn keyword codalKeyword else
syn keyword codalKeyword emulation
syn keyword codalKeyword enum
syn keyword codalKeyword event
syn keyword codalKeyword extern
syn keyword codalKeyword for
syn keyword codalKeyword if
syn keyword codalKeyword inline
syn keyword codalKeyword interface
syn keyword codalKeyword label
syn keyword codalKeyword mapping
syn keyword codalKeyword memory
syn keyword codalKeyword module
syn keyword codalKeyword open
syn keyword codalKeyword pattern
syn keyword codalKeyword pc
syn keyword codalKeyword peephole
syn keyword codalKeyword pipeline
syn keyword codalKeyword port
syn keyword codalKeyword register
syn keyword codalKeyword register_file
syn keyword codalKeyword return
syn keyword codalKeyword schedule_class
syn keyword codalKeyword semantics
syn keyword codalKeyword set
syn keyword codalKeyword settings
syn keyword codalKeyword signal
syn keyword codalKeyword start
syn keyword codalKeyword STRINGIZE
syn keyword codalKeyword switch
syn keyword codalKeyword symbol
syn keyword codalKeyword timing
syn keyword codalKeyword type
syn keyword codalKeyword typedef
syn keyword codalKeyword typename
syn keyword codalKeyword use
syn keyword codalKeyword void
syn keyword codalKeyword while

" Attributes
syn keyword codalAttribute allow_in_delay_slot
syn keyword codalAttribute arbiter
syn keyword codalAttribute base
syn keyword codalAttribute write_enable
syn keyword codalAttribute unaligned
syn keyword codalAttribute size
syn keyword codalAttribute roots
syn keyword codalAttribute rplpolicy
syn keyword codalAttribute reset
syn keyword codalAttribute peepholes
syn keyword codalAttribute overlap
syn keyword codalAttribute non_cacheable
syn keyword codalAttribute numways
syn keyword codalAttribute mask
syn keyword codalAttribute latencies
syn keyword codalAttribute latency
syn keyword codalAttribute linesize
syn keyword codalAttribute bundling
syn keyword codalAttribute compiler
syn keyword codalAttribute simulator
syn keyword codalAttribute custom_schedule
syn keyword codalAttribute dataports
syn keyword codalAttribute debugger
syn keyword codalAttribute delay_slot
syn keyword codalAttribute dff
syn keyword codalAttribute direction
syn keyword codalAttribute emulations
syn keyword codalAttribute encoding
syn keyword codalAttribute endianness
syn keyword codalAttribute decoding
syn keyword codalAttribute flag
syn keyword codalAttribute bits
syn keyword codalAttribute instructions
syn keyword codalAttribute interfaces
syn keyword codalAttribute llvm_class

" Types
syn match codalInt /\<int\d*\>/
syn match codalUint /\<uint\d*\>/
syn keyword codalType const
syn keyword codalType float
syn keyword codalType double
syn keyword codalType bool
syn keyword codalType unsigned
syn keyword codalType signed
syn keyword codalType char
syn keyword codalType short
syn keyword codalType long
syn keyword codalType true
syn keyword codalType false

" Include
syn match codalInclude "^\s*\zs\(%:\|#\)\s*include\>"

" Preprocessor
syn region codalPreProc start="^\s*\zs\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$"
syn region codalDefine  start="^\s*\zs\(%:\|#\)\s*\(define\|undef\|if\|ifdef\|ifndef\|endif\)\>" skip="\\$" end="$"

" Builtins
syn match codalBuiltin /\<codasip_\w\+\>/ 

" Errors
syn match codalParErr     ")"
syn match codalBrackErr   "]"
syn match codalBraceErr   "}"

" Enclosing delimiters
syn region codalEncl transparent matchgroup=codalParEncl start="(" matchgroup=codalParEncl end=")" contains=ALLBUT,codalParErr
syn region codalEncl transparent matchgroup=codalBrackEncl start="\[" matchgroup=codalBrackEncl end="\]" contains=ALLBUT,codalBrackErr
syn region codalEncl transparent matchgroup=codalBraceEncl start="{" matchgroup=codalBraceEncl end="}" contains=ALLBUT,codalBraceErr

" Comments
syn region codalComment start="//" skip="\\$" end="$" keepend contains=codalComment,codalTodo
syn region codalComment start="/\*" end="\*/" contains=codalComment,codalTodo

" Todo
syn keyword codalTodo TODO FIXME todo fixme Todo Fixme


" Strings
syn region codalString start=+"+ skip=+\\\\\|\\"+ end=+"+

" Special chars
syn match codalKeyChar  "="
syn match codalKeyChar  ";"
syn match codalKeyChar  "?"
syn match codalKeyChar  ":"

" Synchronization
syn sync minlines=50
syn sync maxlines=500

" Define the default highlighting.
" Only when an item doesn't have highlighting yet


hi def link codalParErr Error
hi def link codalBraceErr Error
hi def link codalBrackErr Error

hi def link codalComment Comment

hi def link codalTodo Todo

hi def link codalKeyword Keyword
hi def link codalAttribute Keyword

hi def link codalType Type
hi def link codalInt Type
hi def link codalUint Type

hi def link codalString String

hi def link codalBuiltin Identifier

hi def link codalInclude Include

hi def link codalPreProc PreProc
hi def link codalDefine Macro

let b:current_syntax = "codal"

