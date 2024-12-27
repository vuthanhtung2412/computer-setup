" frequently used action : c/r/y/d
" UPPERCASE ACTION : till the end of the line
" C/D already works fine
noremap Y y$

" jj to escape insert mode
" ;; is also a good escape because of rare occurence 
" but i don't like it because it hurt my pinky
inoremap jj <Esc>

" send to clipboard
set clipboard=unnamedplus

" x send to register only in visual mode
nnoremap x "_x
nnoremap X "_X

" y always send to register
" d/c/r/D/C shouldn't send to clipboard/register
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C
nnoremap r "_r

" j/k nav by visual line not vertical line 
noremap j gj
noremap k gk
noremap J j
noremap K k

" tab equal to 2 spaces
set tabstop=2

" action + i/a + '/"/`/{/[/< : on the surrounded block
" Already works !

" action + i/a + p : on the current paragraph
" Already works !

" action + i/a + s : on the current sentence (surrounded by dots)
" Already works !

" action + i/a + g : on the whole file 
nmap dig GVggd
nmap dag GVggd
nmap yig :%y<CR>
nmap yag :%y<CR>
nmap cig GVggc
nmap cag GVggc
nmap vig G$vgg
nmap Vig GVgg

" Line numbers configuration
set number          " Show current line number
set relativenumber  " Show relative line numbers

" Some recommended additions:
" Enable syntax highlighting
syntax on

" Highlight current line
set cursorline

" Enable mouse support
set mouse=a

" Show command in bottom bar
set showcmd

" Highlight matching brackets
set showmatch

" Search as characters are entered
set incsearch

" Highlight search matches
set hlsearch

" Case insensitive search unless capital letter is used
set ignorecase
set smartcase

" vim diff is not readable in wezterm
" link : https://stackoverflow.com/questions/2019281/load-different-colorscheme-when-using-vimdiff
if &diff
  " colorscheme evening
  highlight DiffAdd    cterm=bold ctermfg=15 ctermbg=60 gui=none guifg=White guibg=#313244
  highlight DiffDelete cterm=bold ctermfg=15 ctermbg=89 gui=none guifg=White guibg=#C74F81
  highlight DiffChange cterm=bold ctermfg=15 ctermbg=60 gui=none guifg=White guibg=#313244
  highlight DiffText   cterm=bold ctermfg=15 ctermbg=89 gui=none guifg=White guibg=#C74F81
endif
