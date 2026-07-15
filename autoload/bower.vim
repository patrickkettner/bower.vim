" Bower.vim     Install browser components using Bower, right from Vim
" Author:       patrickkettner
" HomePage:     http://github.com/patrickkettner/bower.vim
" Readme:       http://github.com/patrickkettner/bower.vim/blob/master/README.md
" Version:      1.0.0

if !exists('g:bower_path')
  let g:bower_path = 'bower'
endif

if !exists('g:bower_root_patterns')
  let g:bower_root_patterns = ['bower.json', '.bowerrc', 'bower_components/', 'components/', '.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
endif

function! s:BowerInstalled()
  if executable(g:bower_path)
    return 1
  endif

  echohl WarningMsg |
        \ echomsg 'Bower.vim requires bower - install it with npm install -g bower, or set g:bower_path' |
        \ echohl None
  return 0
endfunction

function! s:FindInCurrentPath(pattern)
  " stolen from vim-rooter

  " Don't try to change directories when on a virtual filesystem (netrw, fugitive,...).
  if match(expand('%:p'), '^\w\+://.*') != -1
    return ''
  endif

  let dir_current_file = expand('%:p:h')
  if empty(dir_current_file)
    let dir_current_file = getcwd()
  endif

  " Check for directory or a file
  let is_dir_pattern = stridx(a:pattern, '/') != -1
  if is_dir_pattern
    let pattern = substitute(a:pattern, '/', '', '')
    let pattern_dir = finddir(pattern, escape(dir_current_file, ' ,') . ';')
  else
    let pattern_dir = findfile(a:pattern, escape(dir_current_file, ' ,') . ';')
  endif

  " If we're at the project root or we can't find one above us
  if empty(pattern_dir)
    return ''
  endif

  " The project root holds the matched file or directory
  if is_dir_pattern
    return fnamemodify(pattern_dir, ':p:h:h')
  endif

  return fnamemodify(pattern_dir, ':p:h')
endfunction

" The directory bower commands should run from: the closest directory at or
" above the current file that looks like a bower project (or a VCS root),
" falling back to the current working directory
function! bower#Root()
  for pattern in g:bower_root_patterns
    let result = s:FindInCurrentPath(pattern)
    if !empty(result)
      return result
    endif
  endfor

  return getcwd()
endfunction

function! bower#Run(args)
  if !s:BowerInstalled()
    return
  endif

  let cd = haslocaldir() ? 'lcd' : (exists('*haslocaldir') && haslocaldir(-1, 0) ? 'tcd' : 'cd')
  let original_directory = getcwd()

  execute cd . ' ' . fnameescape(bower#Root())

  try
    execute ':!' . g:bower_path . ' ' . escape(a:args, '!%#')
  finally
    execute cd . ' ' . fnameescape(original_directory)
  endtry
endfunction

function! bower#Complete(arglead, cmdline, cursorpos)
  " only complete the subcommand itself
  if strpart(a:cmdline, 0, a:cursorpos) !~# '^\s*Bower\s\+\S*$'
    return []
  endif

  let commands = ['cache', 'help', 'home', 'info', 'init', 'install', 'link',
        \ 'list', 'login', 'lookup', 'prune', 'register', 'search', 'update',
        \ 'uninstall', 'unregister', 'version']
  return filter(commands, 'stridx(v:val, a:arglead) == 0')
endfunction
