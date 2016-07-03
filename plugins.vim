" ------------------------------------------------------------
" *  @author     Jim Zhan <jim.zhan@me.com>
" *
" Copyright © 2016 Jim Zhan.
" ------------------------------------------------------------
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"     http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.
" ---------------------------------------------------------------------------
" Plugins Settings: Custom Plugins Settings.
" ---------------------------------------------------------------------------
Plug 'moll/vim-bbye'
Plug 'yonchu/accelerated-smooth-scroll'
Plug 'Shougo/vimshell.vim' | Plug 'Shougo/vimproc.vim', { 'do': 'make' } "{
  let g:vimshell_enable_smart_case   = 1
  let g:vimshell_prompt              = '➤ '
  let g:vimshell_user_prompt         = 'fnamemodify(getcwd(), ":~")'
  let g:vimshell_temporary_directory = "/tmp/vimshell"
  let g:vimshell_right_prompt        = 'system("date")'
"}


" ---------------------------------------------------------------------------
"  Plugins: File Manager
" ---------------------------------------------------------------------------
Plug 'scrooloose/nerdtree' | Plug 'jistr/vim-nerdtree-tabs' "{
  map <leader>b :Bookmark<CR>
  map <C-o> :NERDTreeTabsToggle<CR>
  nnoremap <leader>n :NERDTree .<CR>

  let NERDTreeChDirMode = 2
  let NERDTreeShowBookmarks=1
  let NERDTreeIgnore = ['\.py[cd]$',
\   '\~$', '\.scssc$', '\.swo$', '\.swp$', '.sass-cache',
\   '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$', '.DS_Store',
\   'node_modules']
  let NERDTreeMinimalUI = 0
  let NERDTreeQuitOnOpen = 1
  let NERDTreeMouseMode = 2
  let NERDTreeShowHidden = 1
  let NERDTreeKeepTreeInNewTab = 1

  let g:NERDTreeDirArrowExpandable = '▸'
  let g:NERDTreeDirArrowCollapsible = '▾'

  let g:nerdtree_tabs_open_on_gui_startup=0
  let g:nerdtree_tabs_open_on_console_startup = 0

  " direct shortcuts for CRUD without marking.
  autocmd FileType NERDTree nmap <buffer> <silent>dd   m-d
  autocmd FileType NERDTree nmap <buffer> <silent><Leader>d   m-d
  autocmd FileType NERDTree nmap <buffer> <silent><Leader>n   m-a
  autocmd FileType NERDTree nmap <buffer> <silent><Leader>c   m-c
  autocmd FileType NERDTree nmap <buffer> <silent><Leader>m   m-m
"}


" ---------------------------------------------------------------------------
Plug 'Shougo/neomru.vim' | Plug 'Shougo/unite.vim' "{
  let g:unite_prompt              = '➤ '
  let g:unite_winheight           = 15
  let g:unite_split_rule          = 'botright'
  let g:unite_enable_ignore_case  = 1
  let g:unite_enable_smart_case   = 1
  let g:unite_enable_start_insert = 1

  let g:unite_data_directory = g:dotvim.tempdir . 'unite'
  let g:unite_source_file_mru_limit = 200
  let g:unite_source_history_yank_enable = 1
  let g:unite_source_rec_max_cache_files=5000

  " ctrl-p style finder.
  nnoremap <C-p>      :Unite -buffer-name=files -start-insert -auto-resize file_rec/async:.<cr>
  nnoremap <Leader>/  :Unite -buffer-name=grep  -start-insert -auto-resize grep:.<cr>
  nnoremap <Leader>y  :Unite -buffer-name=yank  -start-insert -auto-resize history/yank<cr>
  nnoremap <Leader>s  :Unite -buffer-name=buffer -quick-match buffer<cr>
  nnoremap <Leader>n  :Unite -buffer-name=New -profile-name=files file/new<cr>

  autocmd FileType unite call s:unite_my_settings()
  function! s:unite_my_settings()
    imap <silent><buffer> <C-k> <C-p>
    imap <silent><buffer> <C-j> <C-n>
    imap <silent><buffer> <C-d> <CR>
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])
    call unite#custom#source(
          \ 'file_rec/async,file',
          \ 'ignore_pattern',
          \ '\.atom\|data\|bower_components\|dist\|fonts\|node_modules\|jspm_packages\|maps\|\.png$\|\.jpg$\|\.svg$\|\.gif$')
  endfunction

  if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
    let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --hidden --ignore ' .
                                        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
  endif
"}
" ---------------------------------------------------------------------------


" ---------------------------------------------------------------------------
"  Plugins: Comment Helper
" ---------------------------------------------------------------------------
Plug 'scrooloose/nerdcommenter'


" ---------------------------------------------------------------------------
"  Plugins: Status Line Enhancement
" ---------------------------------------------------------------------------
Plug 'vim-airline/vim-airline-themes' | Plug 'vim-airline/vim-airline' "{
  let g:airline_powerline_fonts=1
  let g:airline_theme='murmur'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
"}


" ---------------------------------------------------------------------------
"  Plugins: Static Syntax Checking
" ---------------------------------------------------------------------------
Plug 'scrooloose/syntastic' "{
  hi SyntasticErrorSign ctermfg=196 guifg=#FF0000
  let g:syntastic_enable_signs = 1
  let g:syntastic_error_symbol = "✘"
  let g:syntastic_warning_symbol = "➤ "
  let g:syntastic_style_error_symbol = '✠'
  let g:syntastic_style_warning_symbol = '☢'
  let g:syntastic_check_on_open = 1
  let g:syntastic_objc_compiler = "gcc"

  if has('balloon_eval')
    let g:syntastic_enable_balloons = 1
  endif

  let g:syntastic_typescript_tsc_args = '--target ES7'
  let g:syntastic_javascript_checkers = ['eslint']

  autocmd FileType javascript :call dotvim.SyntasticESlintChecker()
"}


" ---------------------------------------------------------------------------
"  Editing:
"   * Emmet: previously known as Zen Coding is a web-developer’s toolkit that
"           can greatly improve HTML/CSS workflow by combining shortcuts & snippets.
"   * Surround: CRUD for parentheses, brackets, quotes, XML tags, and more.
"   * AutoPairs: Insert or delete brackets, parens, quotes in pair.
"   * Multiple Curosr: Multiple selection/editing like Sublime Text.
" ---------------------------------------------------------------------------
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular' "{
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
"}
Plug 'mattn/emmet-vim' "{
  let g:user_emmet_settings = {
  \    'indentation' : '  '
  \}
  let g:user_emmet_expandabbr_key="<C-e>"
"}
Plug 'terryma/vim-multiple-cursors' "{
function! Multiple_cursors_before()
  exe 'NeoCompleteLock'
  echo 'Disabled autocomplete'
endfunction

function! Multiple_cursors_after()
  exe 'NeoCompleteUnlock'
  echo 'Enabled autocomplete'
endfunction
"}
Plug 'ntpeters/vim-better-whitespace' "{
  let g:better_whitespace_enabled = 1
  let g:better_whitespace_filetypes_blacklist=['vimfiler']
  "highlight ExtraWhitespace ctermbg=166
"}
Plug 'sjl/gundo.vim' "{
  let g:gundo_right = 1
  nnoremap <Leader>u :GundoToggle<CR>
"}


" ---------------------------------------------------------------------------
"  AutoComplete: AutoComplete & Code Snippets/Templates
" ---------------------------------------------------------------------------
Plug 'Shougo/neocomplete' "{
  set completeopt-=preview
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  let g:neocomplete#enable_at_startup       = 1
  let g:neocomplete#enable_smart_case       = 1
  let g:neocomplete#enable_ignore_case      = 1
  let g:neocomplete#enable_fuzzy_completion = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  inoremap <expr><TAB>    pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><CR>     pumvisible() ? neocomplete#close_popup() : "\<CR>"
  if !exists('g:neocomplete#omni_patterns')
    let g:neocomplete#omni_patterns = {}
  endif
  let g:neocomplete#omni_patterns.go = '\h\w*\.\?'
"}
Plug 'marijnh/tern_for_vim', { 'do': 'npm install' } "{
  autocmd FileType javascript nested setlocal omnifunc=javascriptcomplete#CompleteJS
"}
" ---------------------------------------------------------------------------
Plug 'aperezdc/vim-template' " {
  let g:templates_directory = expand('~/.vim/templates')
"}
Plug 'honza/vim-snippets' | Plug 'SirVer/ultisnips' " {
  let g:UltiSnipsEditSplit="vertical"
  let g:UltiSnipsExpandTrigger="<TAB>"
  let g:UltiSnipsJumpForwardTrigger="<TAB>"
  let g:UltiSnipsJumpBackwardTrigger="<S-TAB>"
  let g:UltiSnipsRemoveSelectModeMappings = 0
  let g:ultisnips_python_style = "google"     " Available Styles: doxygen | sphinx | google
"}



" ---------------------------------------------------------------------------
"  Plugins: Color Themes
" ---------------------------------------------------------------------------
Plug 'chriskempson/base16-vim' "{
  let base16colorspace=256
"}
Plug 'frankier/neovim-colors-solarized-truecolor-only'