set nocompatible
set t_Co=256
set encoding=utf-8
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Valloric/YouCompleteMe'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'tpope/vim-fugitive'
Plugin 'jtratner/vim-flavored-markdown'
Plugin 'Yggdroot/indentLine'
Plugin 'SirVer/ultisnips'
Plugin 'vimwiki/vimwiki'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
" Plugin 'w0ng/vim-hybrid'
" Plugin 'morhetz/gruvbox'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin on
filetype plugin indent on    " required
syntax on
set background=dark
colorscheme mongolia_night
set number
set shortmess+=c
set laststatus=2
set cscopetag              " use ctags instead of tags when perform C-]
let g:c_no_curly_error = 1 " do not tag {} as error in ()
let g:cpp_class_scope_highlight = 1 " for vim-ccp-enhanced-highlight
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#close_symbol = ''
" let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline_theme = 'bubblegum'
let g:indentLine_setConceal = 1
let g:indentLine_setColors = 0 " use color from colorscheme
" let g:indentLine_color_term = 239
let g:indentLine_enabled = 1
let g:indentLine_char = '|'

" change airline symbols
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.notexists = ''
" fix for Terminess TTF nerd font
let g:airline_symbols.linenr = ''


" let g:ycm_python_binary_path = '/usr/bin/python'
let g:ycm_python_interpreter_path = '/usr/bin/python'
let g:ycm_python_sys_path = [
  \   '$HOME/.local/lib/python2.7/site-packages/pwnlib'
  \]
let g:ycm_extra_conf_vim_data = [
  \   'g:ycm_python_interpreter_path',
  \   'g:ycm_python_sys_path'
  \]
" no diagnostic information
let g:ycm_enable_diagnostic_signs = 0
"for which filetype should YCM be turned on
let g:ycm_filetype_whitelist = { 	
	\ 'cpp': 1,
	\ 'c': 1,
	\ 'python': 1
	\}
" set to 99, so identifier completion engine will not be triggered just 
" leaves semantic engine. default is 2.
" let g:ycm_min_num_of_chars_for_completion = 99

" tagbar should be sorted by sourecode order
let g:tagbar_sort = 0


" NERDTree auto close if there's only nerdtree window exist
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd  filetype  nerdtree silent! highlight ' . a:extension .' ctermbg='.  a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd  filetype nerdtree syn match ' . a:extension .' #^\s\+.*'.  a:extension .'$#'
endfunction

call NERDTreeHighlightFile('.c', 'Magenta', 'NONE', 'NONE', 'NONE')
call NERDTreeHighlightFile('.h', 'yellow', 'none', 'none', 'none')
call NERDTreeHighlightFile('.md', 'blue', 'none', 'none', 'none')
call NERDTreeHighlightFile('.cc', 'Magenta', 'none', 'none', 'none')
call NERDTreeHighlightFile('.cpp','Magenta', 'none', 'none', 'none')
call NERDTreeHighlightFile('Makefile', 'Red', 'none', 'none', 'none')
call NERDTreeHighlightFile('.py', 'cyan', 'none', 'none', 'none')


set completeopt=menuone
set tabstop=8		"use tab which 8 spaces long
set shiftwidth=8
set noexpandtab
set cindent 		"c-style indent
set hlsearch 		"highlight search
set wrapscan 		"when to the bottom,then back to top
set incsearch 		"use increment search
set showcmd 		"show cmd you entered
set ruler
set cursorline
set hidden 		"hidden buffer already gone
set wildmenu
set wildmode=longest,list " command line completion
set wildignore+=*.a,*.o	"ignore files of specific type
set wildignore+=*.jpg,*.png,*.bmp,*.ico
set wildignore+=*.swp,*~


"  different filetype different indentation
" autocmd Filetype c,h setlocal noexpandtab tabstop=8 shiftwidth=8
" autocmd Filetype cc,hh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd BufNewFile,BufRead *.c,*.h setlocal noexpandtab tabstop=8 shiftwidth=8
autocmd BufNewFile,BufRead *.cc,*.hh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
set cinoptions+=:0,g0,l1 "case/switch(C/C++) indent and publib/private/protected indent(C++)

" set different ycm_extra_conf.py for c and c++ source files
" typically it should be let b:variable, but here is a exception.
" Use Bear(Build ear) to generate compile_commands.json at project root, so no
" more relative include path failure.
autocmd BufNewFile,BufRead,BufFilePost,BufEnter *.c,*.h let g:ycm_global_ycm_extra_conf = '$HOME/.ycm_extra_conf_c.py'
autocmd BufNewFile,BufRead,BufFilePost,BufEnter *.cc,*.hh let g:ycm_global_ycm_extra_conf = '$HOME/.ycm_extra_conf_cc.py'
autocmd BufNewFile,BufRead,BufFilePost,BufEnter *.py let g:ycm_global_ycm_extra_conf = '$HOME/.ycm_extra_conf_python.py'

"  set to use github-flavored-markdown
autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown

"map some useful keys
"include no highlight search(not perminant turnoff)
	nmap .xs :nohlsearch<CR>
"map keys of window operation
	"map basic window movement keys
		nmap .k <C-W>k
		nmap .j <C-W>j
		nmap .h <C-W>h
		nmap .l <C-W>l
	"map keys of opening and closing a window
	 	nmap .s :split<CR>
		nmap .v :vsplit<CR>
		nmap .n :new<CR>
		nmap [n :vnew<CR>
	"map keys of chosing a window
		nmap .t <C-W>t
		nmap .b <C-W>b
		nmap [p <C-W>p
	"map key of exchanging two windows
		nmap .x <C-W>x
"map key of openning nerdtree
	nmap .2 :NERDTreeToggle<CR>
"map key of openning tagbar
	nmap .3 :TagbarToggle<CR>
"map key of openning taglist
	"nmap \3 :TlistToggle<CR>
"map hotkey of omnicppcomplation, use this to generate tags file 
	"map <C-F11> :!ctags -R  --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>
"map key of changing cursorline
	"map ,c :setlocal cursorline<CR>
	"map ,d :setlocal nocursorline<CR>

" cscope
if has("cscope")
        set csprg=/usr/bin/cscope
        set csto=0
	set cst
	"set nocsverb
	" add any database in current directory
	"if filereadable("cscope.out")
	"        cs add cscope.out
	" else add database pointed to by environment
	"elseif $CSCOPE_DB != ""
        	cs add $CSCOPE_DB
        "endif
        set csverb
endif
" cscope keymap
nmap .s :cs find s <C-R>=expand("<cword>")<CR><CR> "find symbol
nmap .g :cs find g <C-R>=expand("<cword>")<CR><CR> "find definition
nmap .x :cs find c <C-R>=expand("<cword>")<CR><CR> "find cross reference
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR> "find assignments to
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR> "find this egrep pattern
nmap <C-@>f :cs find f <C-R>=expand("<cword>")<CR><CR> "find this file
nmap <C-@>i :cs find i ^<C-R>=expand("<cword>")<CR>$<CR> " find file #include current file
nmap .d :cs find d <C-R>=expand("<cword>")<CR><CR> "find called functions

	


" Open a new buffer
" <leader> is "\" by default
nmap <leader>t :enew<CR> 
" Next buffer
nmap <leader>l :bnext<CR>
" Previous buffer
nmap <leader>h :bprevious<CR>
" Delete buffer
nmap <leader>d :bdelete<CR>


"map of Alternate Header file plugin a.vim
" nmap ,s :AS<CR>
" nmap ,v :AV<CR>
" nmap ,a :A<CR>
" nmap ,w :IHV<CR>
" nmap ,e :IHS<CR>
" nmap ,r :IH<CR>

"map of change shiftwidth to 2/4/8 spaces
nmap ,2 :set sw=2<CR> gg=G<CR>
nmap ,4 :set sw=4<CR> gg=G<CR>
nmap ,8 :set sw=8<CR> gg=G<CR>


"map of hex edit-function
nmap ,g :%!xxd -r<CR>
nmap ,h :%!xxd<CR>

"makes <CR> work like Ctrl+y in popup menu
:inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
