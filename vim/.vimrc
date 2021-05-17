" VIM Configuration
" TODO
" Add confirmation for <F9> to remove all whitespace

autocmd BufNewFile,BufRead *.sc set syntax=scala
set nocompatible                  " Use vim, rather than vi; must be called first
" packloadall

" Save folds when exiting
" TODO: confirm this is working
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" We need netrw >= v150f.
" Plugin 'eiginn/netrw'

" <Ctrl-^> should go to the last file, not to netrw.
let g:netrw_altfile = 1

"""""""
" Metals plugin
" http://scalameta.org/metals/docs/editors/vim.html
"""""""
" Enable comment highlighting for Json with comments
autocmd FileType json syntax match Comment +\/\/.\+$+
set cmdheight=2

" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

"""""""
" Gradle and syntastic plugin
"""""""
" Combinined with gradle-syntastic plugin these first two help manage the
" class path
let g:syntastic_java_checkers=['javac']
let g:syntastic_java_javac_config_file_enabled = 1

let g:syntastic_always_populate_loc_list = 1
" Turn off by default
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Function keys mappings
" <F5>    Toggle between (no)paste for pasting from clipboard
set pastetoggle=<F5>
" <F7>    Toggle spell check on/off
noremap <silent> <F7> :setlocal invspell<CR>
" <C-F7>  Toggle Syntastic display
noremap <silent> <C-F7> :SyntasticToggleMode<CR>
" <F9>    Remove trailing whitespace throughout the file
nnoremap <silent> <F9> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
" <Leader> t    Turn off trailing whitespace throughout the file
nnoremap <silent> <Leader>t :<C-u>call ShowTrailingWhitespace#Toggle(0)<Bar>echo (ShowTrailingWhitespace#IsSet() ? 'Show trailing whitespace' : 'Not showing trailing whitespace')<CR>

" Tab and Indentation Settings
set expandtab
set softtabstop=2
set shiftwidth=2

"
" Lightline config
"
set laststatus=2
" Add git info to status line
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'pomodoro' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ }}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Set colorscheme
colorscheme elflord

" Screen/File line movement
" These make k/j/0$ movements act on screen lines when lines are wrapped
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$

" Make arrow/home/end keys move based on screen line in insert mode
inoremap <silent> <Up> <C-o>gk
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Home> <C-o>g<Home>
inoremap <silent> <End> <C-o>g<End>

" General Settings
set encoding=utf-8                " Set the default char encoding used inside of vim
set fileencoding=utf-8            " Set the default char encoding when reading from a file
set backspace=indent,eol,start    " Allow backspacing over everything in insert mode
set title                         " Update the title of window/terminal
set number                        " Display line numbers
set relativenumber                " Use relative line numbers
set ruler                         " Display cursor position
set wrap                          " Wrap lines when they are too long
set lbr                           " Wrap by breaking on word breaks
set wildmode=longest,list         " Make tab completion works like Bash
set history=80		          " Keep /n/ lines of command line history
set showcmd		          " Display incomplete commands
set noerrorbells                  " Prevent Vim from beeping
set hidden                        " Hide buffers rather than abandoning them

" Search Settings
set ignorecase                    " Ignore case when searching
set smartcase                     " Case-sensitive search if cap letter is present; otherwise insensitive
set incsearch                     " Highlight search results while typing
set hlsearch                      " Highlight search results

" Clear search highlighting til next search
noremap <silent> <C-L> :nohlsearch<CR><C-L>

" Backup and related settings
set backup      		" Keep a backup file (restore to previous version)
set undofile	        	" Keep an undo file to allow undo changes after closing
set backupdir=~/.vim/backup,.  " Set backup directory
set directory=~/.vim/backup,.  " Set swap directory
set undodir=~/.vim/.backup,.    " Set undo dir

" GVim settings
set guioptions=T                " Enable the toolbar

" Enable 'smooth scrolling'
" TODO: doesn't seem to work
noremap <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>
noremap <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>

" Switch syntax highlighting on, when the terminal has colors
" Switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  " autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  augroup END
else
  set autoindent		" always set autoindenting on
endif

autocmd BufNewFile,BufRead */com/glai*.java setlocal tabstop=10 softtabstop=8 shiftwidth=8 noexpandtab

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
packadd matchit
