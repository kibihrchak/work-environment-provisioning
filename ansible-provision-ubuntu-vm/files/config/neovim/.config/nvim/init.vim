
call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-surround'
Plug 'honza/vim-snippets'
Plug 'garbas/vim-snipmate'
Plug 'marcweber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'

call plug#end()


let mapleader = ","

map <Leader>w <Esc>:w<Enter>
map <Leader>e <Esc>:e<Enter>

" shortcut for entering window commands
nnoremap <Leader>b <C-W>
" fold toggle
nnoremap <Space> za
" fold others
nnoremap <Leader>zo zMzO
" turn off search highlight
nnoremap <Leader>nh :noh<CR>

vnoremap <Leader>y "+y
vnoremap <Leader>p "+p
vnoremap <Leader>d "+d
nnoremap <Leader>y "+y
nnoremap <Leader>p "+p
nnoremap <Leader>d "+d
nnoremap U <C-r>
nnoremap <Leader>v <C-v>

" Search and replace abbreviations
nmap <Leader>r :%s/
vmap <Leader>r <Esc>:%s/<c-r>=GetVisual()<cr>/


set ruler                           " shows ruler for the cursor
set number                          " show line numbers
set mouse=a                         " set mouse support in all modes

if exists('g:vscode')
    " VSCode extension

    nnoremap <Leader>R <Cmd>call VSCodeNotify("workbench.action.openRecent")<CR>
else
    " ordinary neovim
endif
