""  ------------------------------------------------------------
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
"   Platforms
" ---------------------------------------------------------------------------
" Identify platform {
silent function! IsMac()
    return has('macunix')
endfunction

silent function! IsLinux()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

silent function! IsWindows()
    return  (has('win32') || has('win64'))
endfunction
" }


" ---------------------------------------------------------------------------
"  Functions
" ---------------------------------------------------------------------------
function! dotvim.Initialize()
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = g:dotvim.tempdir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor

  " ------------------------------------------------------------
  " Windows Compatible
  " ---------------------------------------------------------------------------
  " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
  " across (heterogeneous) systems easier.
  if has('win32') || has('win64')
    set runtimepath=$HOME/.nvim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.nvim/after
    " Be nice and check for multi_byte even if the config requires
    " multi_byte support most of the time
    if has("multi_byte")
      " Windows cmd.exe still uses cp850. If Windows ever moved to
      " Powershell as the primary terminal, this would be utf-8
      set termencoding=cp850
      " Let Vim use utf-8 internally, because many scripts require this
      set encoding=utf-8
      setglobal fileencoding=utf-8
      " Windows has traditionally used cp1252, so it's probably wise to
      " fallback into cp1252 instead of eg. iso-8859-15.
      " Newer Windows files might contain utf-8 or utf-16 LE so we might
      " want to try them first.
      set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15,chinese,euc-jp,gb18030,gbk,big5,latin1
    endif
  endif
endfunction

" ---------------------------------------------------------------------------
"  Plugin Manager: Initialize vim-plug to manage plugins.
" ---------------------------------------------------------------------------
function! dotvim.InitializePlugins()
  if !filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    echo "[*] Installing Vim-Plug..."
    !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let g:dotvim.plugins.initialized = 0
  endif

  call plug#begin(expand('~/.config/nvim/plugins'))
  source ~/.nvim/plugins.vim
  call plug#end()

  if g:dotvim.plugins.initialized == 0
    :PlugInstall
  endif
endfunction


" ---------------------------------------------------------------------------
"  Setup:
" ---------------------------------------------------------------------------
call dotvim.Initialize()