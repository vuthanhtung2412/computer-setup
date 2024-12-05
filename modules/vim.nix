{
  config,
  pkgs,
  ...
}:
{
  programs = {
    vim = {
      enable = true;
      extraConfig = ''
        " Enable system clipboard integration
        set clipboard=unnamedplus

        " Character deletion won't send to clipboard
        nnoremap x "_x
        vnoremap x "_x
        nnoremap X "_X
        vnoremap X "_X

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

        " Map jj to Escape in insert mode
        inoremap jj <Esc>

        " vim diff is not readable in wezterm
        " link : https://stackoverflow.com/questions/2019281/load-different-colorscheme-when-using-vimdiff
        if &diff
          " colorscheme evening
          highlight DiffAdd    cterm=bold ctermfg=15 ctermbg=60 gui=none guifg=White guibg=#313244
          highlight DiffDelete cterm=bold ctermfg=15 ctermbg=89 gui=none guifg=White guibg=#C74F81
          highlight DiffChange cterm=bold ctermfg=15 ctermbg=60 gui=none guifg=White guibg=#313244
          highlight DiffText   cterm=bold ctermfg=15 ctermbg=89 gui=none guifg=White guibg=#C74F81
        endif
      '';
    };
  };
}
