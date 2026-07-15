" Bower.vim     Install browser components using Bower, right from Vim
" Author:       patrickkettner
" HomePage:     http://github.com/patrickkettner/bower.vim
" Readme:       http://github.com/patrickkettner/bower.vim/blob/master/README.md
" Version:      1.0.0

if exists('g:loaded_bower') || &compatible
  finish
endif
let g:loaded_bower = 1

command! -nargs=* -complete=customlist,bower#Complete Bower call bower#Run(<q-args>)
