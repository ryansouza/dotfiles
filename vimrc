set nocompatible
set autoindent
"set nosmartindent
"set tabstop=4
"set shiftwidth=4
"set softtabstop=4
set showmatch
set ruler
set incsearch
set number
set hlsearch

" Syntax
syntax enable
augroup filetypedetect
	au! BufNewFile,BufRead *.erb setf eruby
	au! BufNewFile,BufRead *.ocl setf opencl
augroup END

"Tabs"
set expandtab
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=2
set tabstop=4
"let g:ctab_disable_tab_maps = 1

" Set displaying weird chars
set nolist listchars=tab:\|_,trail:·,precedes:<,extends:>

colorscheme macvim-sco

let mapleader = '\'

"Use Tab and Shift-Tab to in/undent lines"
vmap <Tab> >gv
vmap <S-Tab> <gv
imap <Tab> <C-t>
imap <S-Tab> <C-d>
nmap <Tab> a<Tab><Esc>
nmap <S-Tab> a<S-Tab><Esc>

"Map meta+arrow_keys"
imap <Home> <C-o>^
nmap <Home> ^
imap <D-S-left> <C-o>0
nmap <D-S-left> 0
imap <D-S-right> <C-o>$
nmap <D-S-right> $
imap <C-up> <C-o><C-u>
nmap <C-up> <C-u>
imap <D-up> <C-o>5<up>
nmap <D-up> 5<up>
imap <C-down> <C-o><C-d>
nmap <C-down> <C-d>
imap <D-down> <C-o>5<down>
nmap <D-down> 5<down>
let macvim_skip_cmd_opt_movement = 1
"let macvim_hig_shift_movement = 1
so ~/.vim/after/cmd_opt_movement.vim

"Start with indent guides showing"
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_space_guides = 1
let g:indent_guides_start_level = 1

" Don't wrap
set nowrap

"Highlight characters occuring after col 78"
""match OverLength /\%80v.\+/
set colorcolumn=79


"Bracket functionality"
inoremap {<CR> {<CR>}<Esc>O<Tab>
"inoremap { {}<Left>
"inoremap {<BS> <nop>
"inoremap ( ()<Left>
"inoremap (<BS> <nop>
"inoremap [ []<Left>
"inoremap [<BS> <nop>
"inoremap <expr> ) ClosePair(')')
"inoremap <expr> ] ClosePair(']')
"inoremap <expr> } CloseBracket()
"inoremap <expr> " QuoteDelim('"')


function! ClosePair(char)
 if getline('.')[col('.') - 1] == a:char
 return "\<Right>"
 else
 return a:char
 endif
endf

"Buggy when the brackets are not indented"
function! CloseBracket()
 if getline('.')[col('.') - 1] == "}"
 
   return "\<Right>"
 elseif match(getline(line('.') + 1), '\s*}') < 0
   return "\}"
 else
   return "\<c-o>]}\<RIGHT>"
 endif
endf

function! QuoteDelim(char)
 let line = getline('.')
 let col = col('.')
 if line[col - 2] == "\\"
 "Inserting a quoted quotation mark into the string
 return a:char
 elseif line[col - 1] == a:char
 "Escaping out of the string
 return "\<Right>"
 else
 "Starting a string
 return a:char.a:char."\<Esc>i"
 endif
endf
"Brackets done"


"Setup git-vim status line"
set laststatus=2
set statusline=%{fugitive#statusline()}

call pathogen#runtime_append_all_bundles()

let g:indent_guides_auto_colors = 0
""autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#dddddd ctermbg=3
""autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#eeeeee ctermbg=4

"Add commit command"
so ~/.vim/plugin/cmdalias.vim
""call CmdAlias('commit', 'Gcommit')
call CmdAlias('commit', 'Gstatus')
call CmdAlias('status', 'Gstatus')
call CmdAlias('diff', 'Gdiff')

au! BufWritePost .vimrc source ~/.vimrc 
