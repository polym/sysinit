let mapleader=";"

filetype on
filetype plugin on

vnoremap <Leader>y "+y
nmap <Leader>p "+p

set incsearch
set ignorecase
set nocompatible
set wildmenu

set fileencodings=utf-8,gb2312,gbk,gb18030
set termencoding=utf-8
set encoding=utf-8

"load vundle
source /root/.vimrc.vundle

"let g:go_def_mode = 'godef'
let g:go_def_reuse_buffer = 1
au FileType go nmap <Leader>d <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

set gcr=a:block-blinkon0
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=m
set guioptions-=T

set laststatus=2
set number 
set hlsearch
"set cursorline

syntax enable
syntax on

filetype indent on
set expandtab
set ts=4
set sw=4

syntax enable
set background=dark
colorscheme solarized

" maps
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width = 60

map <Leader>t :split<CR>

map <Leader>f :NERDTreeToggle<CR>
map <Leader>q :NERDTreeFocus<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
let g:NERDTreeDirArrowExpandable = '📁'
let g:NERDTreeDirArrowCollapsible = '📂'

map <Leader>y :Oscyank<CR>

map <Leader>b :GoBuild<CR>
map <Leader>TT :GoTestFunc<CR>
map <Leader>TG :GoTest<CR>

map <Leader>mb :!make build<CR>

map <Leader>F :FZF<CR>

map <Leader>GS :Gina status --opener=vnew<CR>
map <Leader>GM :Gina commit<CR>

map <Leader>r :GoReferrers<CR>
map <Leader>i :GoImplements<CR>

let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
"let g:go_info_mode = "gopls"
let g:go_def_mode = "gopls"
"let g:go_fmt_command = "goimports"
let g:go_test_timeout = '10m'
let g:go_fillstruct_mode = 'gopls'

let g:SignatureMap = {
        \ 'Leader'             :  "m",
        \ 'PlaceNextMark'      :  "m,",
        \ 'ToggleMarkAtLine'   :  "m.",
        \ 'PurgeMarksAtLine'   :  "m-",
        \ 'DeleteMark'         :  "dm",
        \ 'PurgeMarks'         :  "mda",
        \ 'PurgeMarkers'       :  "m<BS>",
        \ 'GotoNextLineAlpha'  :  "']",
        \ 'GotoPrevLineAlpha'  :  "'[",
        \ 'GotoNextSpotAlpha'  :  "`]",
        \ 'GotoPrevSpotAlpha'  :  "`[",
        \ 'GotoNextLineByPos'  :  "]'",
        \ 'GotoPrevLineByPos'  :  "['",
        \ 'GotoNextSpotByPos'  :  "mn",
        \ 'GotoPrevSpotByPos'  :  "mp",
        \ 'GotoNextMarker'     :  "[+",
        \ 'GotoPrevMarker'     :  "[-",
        \ 'GotoNextMarkerAny'  :  "]=",
        \ 'GotoPrevMarkerAny'  :  "[=",
        \ 'ListLocalMarks'     :  "ms",
        \ 'ListLocalMarkers'   :  "m?"
        \ }
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'gitcommit' : 1,
      \}
let g:ycm_log_level = 'debug'
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0

" call glaive#Install()
" Glaive codefmt clang_format_style="{IndentWidth: 4, ColumnLimit: 120, AllowShortIfStatementsOnASingleLine: false}"
" augroup autoformat_settings
"   autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
" augroup END

augroup Racer
    autocmd!
    autocmd FileType rust nmap <buffer> gd         <Plug>(rust-def)
    autocmd FileType rust nmap <buffer> gs         <Plug>(rust-def-split)
    autocmd FileType rust nmap <buffer> gx         <Plug>(rust-def-vertical)
    autocmd FileType rust nmap <buffer> gt         <Plug>(rust-def-tab)
    autocmd FileType rust nmap <buffer> <leader>gd <Plug>(rust-doc)
    autocmd FileType rust nmap <buffer> <leader>gD <Plug>(rust-doc-tab)
augroup END
