" frequently used action : c/r/y/d
" UPPERCASE ACTION : till the end of the line
" C/D already works fine
noremap Y y$

" jj to escape insert mode
inoremap jj <Esc>

" send to clipboard
set clipboard=unnamed

" x send to register only in visual mode
nnoremap x "_x
nnoremap X "_X

" y always send to register
" d/c/r/D/C shouldn't send to clipboard/register
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
nnoremap r "_r

" k/j : up/down visually instead of logically
nmap j gj
vmap j gj
nmap k gk
vmap k gk

" tab equal to 2 spaces
set tabstop=2

" action + i/a + '/"/`/{/[/< : on the surrounded block
" Already works !

" action + i/a + p : on the current paragraph
" Already works !

" action + i/a + s : on the current sentence (surrounded by dots)
" Already works !

" action + i/a + g : on the whole file 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: This is not working (perhaps it is not working with Code Mirror vim) "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nmap dig GVggd
" nmap dag GVggd
" nmap yig :%y<CR>
" nmap yag :%y<CR>
" nmap cig GVggc
" nmap cag GVggc
" nmap vig G$vgg
" nmap Vig GVgg

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

" To be continued : 
" Extend with obscommand, cmcommand, jscommand and jsfile
" leap.nvim like
