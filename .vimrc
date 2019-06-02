" Vim Env. configure
set number
set nocompatible
syntax enable
autocmd bufnewfile,bufread *.scpt,*.applescript :setl filetype=applescript
set smartindent
set tabstop=4
set shiftwidth=4
set ruler
set showmatch
"set mouse=niv 
set clipboard=unnamed
set backspace=start,eol,indent

"NeoBundle
set nocompatible               " be iMproved
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle/'))
endif

" Vimproc
" NeoBundle 'Shougo/vimproc', {
"  \ 'build' : {
"    \ 'windows' : 'make -f make_mingw32.mak',
"    \ 'cygwin' : 'make -f make_cygwin.mak',
"    \ 'mac' : 'make -f make_mac.mak',
"    \ 'unix' : 'make -f make_unix.mak',
"  \ },
"  \ }

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'tomasr/molokai'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'itchyny/lightline.vim'
NeoBundle '5t111111/neat-json.vim'

NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'yonchu/accelerated-smooth-scroll'

NeoBundle 'evidens/vim-twig'
"NeoBundle 'soramugi/auto-ctags.vim'
NeoBundle 'majutsushi/tagbar'

NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'nathanaelkane/vim-indent-guides'
" vim-scripts repos
NeoBundle 'rails.vim'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'tpope/vim-fugitive'

" php docs
NeoBundle 'PDV--phpDocumentor-for-Vim'

" non github repos
call neobundle#end()
NeoBundleCheck


"Bundle github repos
filetype plugin indent on     " required!
filetype indent on
syntax on
let g:auto_ctags = 1



"Unite.vim
 " The prefix key.
 nnoremap    [unite]   <Nop>
 nmap    <Leader>f [unite]
  
 " unite.vim keymap
 " https://github.com/alwei/dotfiles/blob/3760650625663f3b08f24bc75762ec843ca7e112/.vimrc
 nnoremap [unite]u  :<C-u>Unite -no-split<Space>
 nnoremap <silent> [unite]f :<C-u>Unite<Space>buffer<CR>
 nnoremap <silent> [unite]b :<C-u>Unite<Space>bookmark<CR>
 nnoremap <silent> [unite]m :<C-u>Unite<Space>file_mru<CR>
 nnoremap <silent> [unite]r :<C-u>UniteWithBufferDir file<CR>
 nnoremap <silent> ,vr :UniteResume<CR>
  
 " vinarise
 let g:vinarise_enable_auto_detect = 1
    
 " unite-build map
 nnoremap <silent> ,vb :Unite build<CR>
 nnoremap <silent> ,vcb :Unite build:!<CR>
 nnoremap <silent> ,vch :UniteBuildClearHighlight<CR>


"NeoComplCache
 let g:neocomplcache_enable_at_startup = 1
command GitBrowseRemote !git browse-remote --rev -L<line1>,<line2> <f-args> -- %
nnoremap <C-v> :<C-u>registers<Enter>

nnoremap <F1> :Unite tab<Enter>
nnoremap <F2> :<C-u>VimFilerExplorer -winwidth=50<Enter>
nnoremap <F3> :tab new<Enter>:<C-u>VimFilerExplorer -winwidth=50<CR>
nnoremap <F4> :tabc<CR>
nnoremap <F5> :Gstatus<Enter>
nnoremap <F6> :Gblame<Enter>
nnoremap <F7> :Gdiff<Enter>
nnoremap <F8> :TagbarToggle<CR>

nnoremap 1 :tabn 1<CR>
nnoremap 2 :tabn 2<CR>
nnoremap 3 :tabn 3<CR>
nnoremap 4 :tabn 4<CR>
nnoremap 5 :tabn 5<CR>
nnoremap 6 :tabn 6<CR>
nnoremap 7 :tabn 7<CR>
nnoremap 8 :tabn 8<CR>
nnoremap 9 :tabn 9<CR>
nnoremap 0 :tabn 0<CR>

cnoremap w!! w !sudo tee > /dev/null %<CR>

" 無名レジスタを使わない設定 
xnoremap p "0p

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

command! -nargs=+ -bang -complete=file Rename let pbnr=fnamemodify(bufname('%'), ':p')|exec 'f '.escape(<q-args>, ' ')|w<bang>|call delete(pbnr)

" php docs
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
" PHP documenter script bound to Control-P
autocmd FileType php inoremap <C-p> <ESC>:call PhpDocSingle()<CR>i
autocmd FileType php nnoremap <C-p> :call PhpDocSingle()<CR>
autocmd FileType php vnoremap <C-p> :call PhpDocRange()<CR>

" =======================================================================================================================
" lightline.vim
let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'mode_map': {'c': 'NORMAL'},
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ], [ 'fugitive','filedir', 'filename' ] , ['funcname' ] ]
			\ },
			\ 'inactive': {
			\   'left': [ [ 'mode', 'paste' ], [ 'fugitive','filedir', 'filename' ] , ['funcname' ] ]
			\ },
			\ 'component_function': {
			\   'modified': 'MyModified',
			\   'readonly': 'MyReadonly',
			\   'fugitive': 'MyFugitive',
			\   'filename': 'MyFilename',
			\   'filedir' : 'MyDirname',
			\   'fileformat': 'MyFileformat',
			\   'filetype': 'MyFiletype',
			\   'funcname': 'MyFunctionName',
			\   'fileencoding': 'MyFileencoding',
			\   'mode': 'MyMode'
			\ }
			\ }

function! MyModified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
	return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
				\ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
				\  &ft == 'unite' ? unite#get_status_string() :
				\  &ft == 'vimshell' ? vimshell#get_status_string() :
				\ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
				\ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyDirname()
	let dirs=split(expand('%:p:h'),'/')
    let cnt=0
    let result=""
    for name in reverse(dirs)
        if (cnt>2)
            break
        endif
        let result=name."/".result
        let cnt=cnt+1
    endfor
    return result
endfunction

function! MyFugitive()
	try
		if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
			return fugitive#head()
		endif
	catch
	endtry
	return ''
endfunction

function! MyFileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
	return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
	return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MyFunctionName()
	  return tagbar#currenttag('%s', '')
  endfunction

" =======================================================================================================================
" カラー設定
" =======================================================================================================================
set t_Co=256

hi Pmenu ctermbg=17
hi PmenuSel ctermbg=21
hi PmenuSel ctermfg=215
hi Folded ctermbg=232 ctermfg=237
hi Search ctermbg=022 ctermfg=002

hi Visual ctermbg=022 ctermfg=002 

hi Constant    term=standout  ctermfg=028
hi SpecialKey  term=standout  ctermfg=034
hi PreProc     term=standout  ctermfg=035
hi Special     term=standout  ctermfg=064
hi LineNr      term=underline ctermfg=047
hi Statement   term=standout  ctermfg=077
hi vimFuncName term=standout  ctermfg=085
hi Normal      term=standout  ctermfg=118
hi NonText     term=standout  ctermfg=118
hi Comment     term=standout  ctermfg=245
hi Identifier  term=bold      ctermfg=220
hi LightLineLeft_normal_1  term=standout      ctermbg=118 ctermfg=0
hi LightLineLeft_normal_2  term=standout      ctermbg=118 ctermfg=0
hi LightLineLeft_normal_3  term=standout      ctermbg=118 ctermfg=0

set hlsearch


" vim立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup=1
" ガイドをスタートするインデントの量
let g:indent_guides_start_level=1

" 自動カラーを無効にする
let g:indent_guides_auto_colors=0
" 奇数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#000055 ctermbg=232
" 偶数インデントのカラー
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#000055 ctermbg=233



autocmd FileType * setlocal formatoptions-=ro

set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%
set backupskip=/tmp/*,/private/tmp/*

set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set nowrap
autocmd filetype javascript set tabstop=2
autocmd filetype javascript set shiftwidth=2

augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif

  au BufReadPre  *.so let &so=1
  au BufReadPost *.so if &so | %!objdump -D /dev/stdin
  au BufReadPost *.so set ft=xxd | endif
  au BufWritePre *.so if &so | %!xxd -r
  au BufWritePre *.so endif
  au BufWritePost *.so if &so | %!xxd
  au BufWritePost *.so set nomod | endif
augroup END

" VilFiler
call unite#custom#profile('default', 'context', {
  \   'start_insert': 1,
  \   'winheight': 10,
  \   'auto_resize': 1,
  \   'vimfiler_enable_auto_cd': 1,
  \ })


" -- for PHP syntastic  -----------------------
let g:syntastic_mode_map = {
  \ 'mode': 'active',
  \ 'active_filetypes': ['php']
  \}
" let g:syntastic_auto_loc_list = 1
"let g:syntastic_javascript_checkers = ['jshint', 'eslint', 'gjslint']
let g:syntastic_javascript_checkers = ['jshint', 'eslint']
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_php_checkers = ['phpcs']
let g:syntastic_php_phpcs_args='--standard=psr2'
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '⚠'
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

let g:syntastic_javascript_eslint_args = "--rulesdir ~/dot_config/eslint_rules"

