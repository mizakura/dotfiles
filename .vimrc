"--------------------------------------------------------
" コマンドスニペット
" :col :cnew // quickfixを新旧に移動する
" :chi // quickfixのリストを表示
" :vim {pattern} `git ls-files` // git で管理されてる範囲内でgrep
" <Space> E // defxウィンドウをトグる
"
let mapleader = "\<Space>"
nnoremap <Space> <Nop>
"--------------------------------------------------------
" dein.vim関係
" http://d.hatena.ne.jp/raiden325/20160716/1468641998 参考

" プラグインがインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落とす
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh'
    execute '!sh ./installer.sh ' . s:dein_dir 
    execute '!rm ./installer.sh'
  endif
  execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " ~/.vim/dein.toml,deinlazy.tomlを用意する
  let g:rc_dir    = expand('~/.vim')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

filetype plugin on
filetype plugin indent on
" :call dein#update() でプラグインのアップデート

"-----------------------------------------------------------

set showcmd
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END
syntax enable
set expandtab
set tabstop<
set softtabstop=2
set shiftwidth=2
set hlsearch
set autoindent
set laststatus=2
set t_Co=256
set shortmess+=I
set ignorecase
set smartcase
set wrapscan
set showmatch
set wildmenu
set formatoptions+=mM
set hidden

"-----------------------------------------------------------

" http://cimadai.hateblo.jp/entry/20080325/1206459666
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif
" 改行コードの自動認識
set fileformats=unix,mac,dos
set encoding=utf-8
set fileencodings=utf-8,euc-jp

"-----------------------------------------------------------

" Makefileでタブスペースをタブ文字にする
let _curfile=expand("%:r")
if _curfile == 'Makefile'
  set noexpandtab
endif

"-----------------------------------------------------------

augroup cpp-path
  autocmd!
  autocmd FileType cpp setlocal path=.,/usr/include,/usr/local/include,/usr/include/c++/
augroup END

"-----------------------------------------------------------

"" markdown 
"  autocmd BufRead,BufNewFile *.mkd  set filetype=markdown
"  autocmd BufRead,BufNewFile *.md  set filetype=markdown
"  " Need: kannokanno/previm
"  nnoremap <silent> <C-p> :PrevimOpen<CR> " Ctrl-pでプレビュー
"  " 自動で折りたたまないようにする
"  let g:vim_markdown_folding_disabled=1
"  let g:vim_markdown_math = 1
"  let g:previm_open_cmd = 'luakit -n'
"  let g:previm_enable_realtime = 1
"" 

"-----------------------------------------------------------
"http://yt-siden-memo.tumblr.com/post/118939556075
"インクルードガードUUID生成
" C/C++ insert UUID based include guard

function! s:insert_include_guard()
  let s:uuid=system('uuidgen')
  let s:uuid=strpart(s:uuid, 0, strlen(s:uuid)-1)
  let s:uuid=substitute(s:uuid, '[a-f]', '\u\0', 'g')
  let s:uuid=substitute(s:uuid, '\-', '_', 'g')
  let s:uuid='UUID_'.s:uuid
  call append(0, '#ifndef '.s:uuid)
  call append(1, '#define '.s:uuid)
  call append('$', '#endif //'.s:uuid)
endfunction
command! -nargs=0 InsertIncludeGuard call s:insert_include_guard()

"-----------------------------------------------------------------
"http://adragoona.hatenablog.com/entry/2015/07/21/164138
" next-alter
"---------------------------------------------------------
"Prefix
nmap <Leader>ano <Plug>(next-alter-open)
nnoremap <expr> <Leader>anb next_alter#open_mapexpr('vertical botright')
nnoremap <expr> <Leader>ant next_alter#open_mapexpr('vertical topleft')

" key is file extension, value is alternate file extension.
let g:next_alter#pair_extension = { 
            \ 'c'   : [ 'h' ],
            \ 'C'   : [ 'H' ],
            \ 'cc'  : [ 'h' ],
            \ 'CC'  : [ 'H', 'h'],
            \ 'cpp' : [ 'h', 'hpp' ],
            \ 'CPP' : [ 'H', 'HPP' ],
            \ 'cxx' : [ 'h', 'hpp' ],
            \ 'CXX' : [ 'H', 'HPP' ],
            \ 'h'   : [ 'c', 'cpp', 'cxx' ],
            \ 'H'   : [ 'C', 'CPP', 'CXX' ],
            \ 'hpp' : [ 'cpp', 'cxx'],
            \ 'HPP' : [ 'CPP', 'CXX'],
            \ }
" this list shows search directory to find alternate file.
let g:next_alter#search_dir = [ '.' , '..', './include', '../include' ]

" this is used when it opens alternate file buffer.
let g:next_alter#open_option = 'vertical topleft'

"------------------------------------------------------------
" terminal
packadd termdebug
autocmd BufRead,BufNewFile *.rs setfiletype rust
autocmd FileType rust let termdebugger="rust-gdb"
let g:termdebug_wide = 163

"------------------------------------------------------------
" quickfix
au QuickFixCmdPost *grep* cwindow
"------------------------------------------------------------
" vimgrep
"vim {pattern} `git ls-files`
"------------------------------------------------------------

autocmd FileType cpp map <F5> :w<CR>:!g++ % -o %:r && ./%:r<CR>
autocmd FileType cpp map <C-F5> :w<CR>:!g++ % && zsh ./test%:r.sh<CR>
autocmd FileType cpp map <S-F5> :w<CR>:e ./test%:r.sh<CR>:w<CR>
autocmd FileType c map <F5> :w<CR>:!gcc % -o %:r && ./%:r<CR>
autocmd FileType c map <C-F5> :w<CR>:!gcc % && zsh ./test%:r.sh<CR>
autocmd FileType c map <S-F5> :w<CR>:e ./test%:r.sh<CR>:w<CR>
autocmd FileType rs map <F5> :w<CR>:!cargo run<CR>
autocmd FileType py map <F5> :w<CR>:!python %<CR>

autocmd FileType markdown map <F5> :w<CR>:!pandoc % -o %:r.pdf -V documentclass=ltjarticle --pdf-engine=lualatex -N -H preamble_%:r.tex && apvlv %:r.pdf &<CR>

autocmd FileType cpp set keywordprg=/usr/bin/cppman

" http://daikishimada.github.io/vim_python_crash.html
" Disable omnifunc in Python
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.python = ''

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" rusty-tags
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

nmap <Leader><Leader>w [window]
nnoremap [window]h <C-w>h
nnoremap [window]j <C-w>j
nnoremap [window]k <C-w>k
nnoremap [window]l <C-w>l
nnoremap [window]H <C-w>h:bd<CR>
nnoremap [window]J <C-w>j:bd<CR>
nnoremap [window]K <C-w>k:bd<CR>
nnoremap [window]L <C-w>l:bd<CR>

"highlight IncSearch ctermbg=104
"highlight Search ctermbg=104

" TidalCycles
augroup Tidal
autocmd BufRead,BufNewFile *.tidal  set filetype=tidal
autocmd FileType tidal command! TidalInit call s:TidalInit()
function! s:TidalInit()
  term stack ghci
  file tidal
endfunction

autocmd FileType tidal command! -range=0 TidalRun call s:TidalRun(<count>, <line1>, <line2>)
function! s:TidalRun(range_given, line1, line2)
  if a:range_given
    call term_sendkeys("tidal", join([":{\n", join(getline(a:line1, a:line2), "\n"), "\n", ":}\n"],''))
  else
    call term_sendkeys("tidal", join([getline("."), "\n"]))
  endif
endfunction
autocmd FileType tidal map <F5> :TidalRun<CR>
augroup END

" Undo
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

" http://koturn.hatenablog.com/entry/2018/02/10/170000
" 入力キーの辞書
let s:compl_key_dict = {
      \ char2nr("\<C-l>"): "\<C-x>\<C-l>",
      \ char2nr("\<C-n>"): "\<C-x>\<C-n>",
      \ char2nr("\<C-p>"): "\<C-x>\<C-p>",
      \ char2nr("\<C-k>"): "\<C-x>\<C-k>",
      \ char2nr("\<C-t>"): "\<C-x>\<C-t>",
      \ char2nr("\<C-i>"): "\<C-x>\<C-i>",
      \ char2nr("\<C-]>"): "\<C-x>\<C-]>",
      \ char2nr("\<C-f>"): "\<C-x>\<C-f>",
      \ char2nr("\<C-d>"): "\<C-x>\<C-d>",
      \ char2nr("\<C-v>"): "\<C-x>\<C-v>",
      \ char2nr("\<C-u>"): "\<C-x>\<C-u>",
      \ char2nr("\<C-o>"): "\<C-x>\<C-o>",
      \ char2nr('s'): "\<C-x>s",
      \ char2nr("\<C-s>"): "\<C-x>s"
      \}
" 表示メッセージ
let s:hint_i_ctrl_x_msg = join([
      \ '<C-l>: While lines',
      \ '<C-n>: keywords in the current file',
      \ "<C-k>: keywords in 'dictionary'",
      \ "<C-t>: keywords in 'thesaurus'",
      \ '<C-i>: keywords in the current and included files',
      \ '<C-]>: tags',
      \ '<C-f>: file names',
      \ '<C-d>: definitions or macros',
      \ '<C-v>: Vim command-line',
      \ "<C-u>: User defined completion ('completefunc')",
      \ "<C-o>: omni completion ('omnifunc')",
      \ "s: Spelling suggestions ('spell')"
      \], "\n")
function! s:hint_i_ctrl_x() abort
  echo s:hint_i_ctrl_x_msg
  let c = getchar()
  return get(s:compl_key_dict, c, nr2char(c))
endfunction
 
inoremap <expr> <C-x>  <SID>hint_i_ctrl_x()

if !has('nvim')
  tnoremap <C-j> <C-\><C-n>
endif

"--------------------------------------------------------
" バッファの大きさを最大化する
" https://qiita.com/grohiro/items/e3dbcc93510bc8c4c812
let s:toggle_window_size = 0
function! ToggleWindowSize()
  if s:toggle_window_size == 1
    exec "normal \<C-w>="
    let s:toggle_window_size = 0
  else
    :resize
    :vertical resize
    let s:toggle_window_size = 1
  endif
endfunction
nnoremap <C-w><C-m> :call ToggleWindowSize()<CR>