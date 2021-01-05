if exists('g:vscode')
    " VSCode extension
else
    " ordinary neovim
    set columns=85
    set lines=60
    set guifont=Consolas:h10
    colorscheme desert

    set guioptions-=T " toolbars
    set guioptions-=l " left-hand scrollbar
    set guioptions-=L " left-hand scrollbar when there is vert. split win.
    set guioptions-=r " right-hand scrollbar
    set guioptions-=R " right-hand scrollbar when there is hor. split win.
    set guioptions-=m " menu bar
    set guioptions-=b " bottom scrollbar
    set guioptions-=e " tab line

    nnoremap <Leader>c1 :set columns=85<CR>
    nnoremap <Leader>c2 :set columns=170<CR>
endif
