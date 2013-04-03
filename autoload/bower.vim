" Bower.vim     Install browser components using Twitter's Bower package manager
" Author:       patrickkettner
" HomePage:     http://github.com/patrickkettner/bower.vim
" Readme:       http://github.com/patrickkettner/bower.vim/blob/master/README.md
" Version:      0.1.0

if !exists("g:bower_path")
    let g:bower_path = "bower"
endif

if !exists("g:node_path")
  let g:node_path = "node"
endif

if !exists("g:npm_path")
  let g:npm_path = "npm"
endif

if !exists('g:bower_root_patterns')
  let g:bower_root_patterns = ['.git/', '.git', '_darcs/', '.hg/', '.bzr/', '.svn/']
endif

function! s:NodeInstalled()

  if executable(g:node_path)
    let rawNodeVersion = substitute(system(g:node_path . ' --version'), '\n', '', '')
    let nodeVersion = matchlist(rawNodeVersion, 'v\?\(\d*\)\.\(\d*\)\.\(\d*\)')
    let nodeMajor = nodeVersion[1]
    let nodeMinor = nodeVersion[2]

    if (nodeMajor > 0 || (nodeMajor == 0 && nodeMinor >= 8))
      return 1
    else
      echohl WarningMsg |
            \ echomsg "Bower requires NodeJS v0.8+, you have " .
            \ "Node " . rawNodeVersion . ". Please upgrade Node " .
            \ "or set g:node_path" |
            \ echohl None
      return 0
    endif
  else
    echohl WarningMsg |
          \ echomsg "Bower.vim requires NodeJS to be installed" |
          \ echohl None
    return 0

  endif
endfunction


function! s:NpmInstalled()
  if executable(g:npm_path)
    return 1
  else
    echohl WarningMsg |
          \ echomsg "Bower.vim requires npm to be installed" |
          \ echohl None
    return 0
  endif
endfunction


function! s:BowerInstalled()
  if executable(g:bower_path)
    return 1
  else
    echohl WarningMsg |
          \ echomsg "Bower.vim requires bower - install it with npm install -g bower" |
          \ echohl None
    return 0
  endif
endfunction

function! s:FindInCurrentPath(pattern)
  " stolen from vim-rooter

  " Don't try to change directories when on a virtual filesystem (netrw, fugitive,...).
  if match(expand('%:p'), '^\w\+://.*') != -1
    return ""
  endif

  let dir_current_file = fnameescape(expand("%:p:h"))
  let pattern_dir = ""

  " Check for directory or a file
  if (stridx(a:pattern, "/")) != -1
    let pattern = substitute(a:pattern, "/", "", "")
    let pattern_dir = finddir(a:pattern, dir_current_file . ";")
  else
    let pattern_dir = findfile(a:pattern, dir_current_file . ";")
  endif

  " If we're at the project root or we can't find one above us
  if pattern_dir == a:pattern || empty(pattern_dir)
    return ""
  else
    return substitute(pattern_dir, a:pattern . "$", "", "")
  endif
endfunction


function! s:FindVCSRootDirectory()
  for pattern in g:bower_root_patterns
    let result = s:FindInCurrentPath(pattern)
    if !empty(result)
      return result
    endif
  endfor
endfunction


function! FindComponentsDirectory()
  let dir = expand('%:p:h', 1)

  " quick check
  while isdirectory(dir) && dir !=# fnamemodify(dir, ':h')
    let dir = fnamemodify(dir, ':h')
    if isdirectory(dir. '/components')
        return dir
    endif
  endwhile

  " check for a vcs root, then search from there for a components directory
  let subdir = split(globpath(s:FindVCSRootDirectory()."/**", "components"), '\n')
  if ! empty(subdir)
    return fnamemodify(ssubdir[0], ":h")
  endif

  " finally, just use the current directory
  return expand('%:p:h')
endfunction

function! s:bower(bang, args)
  if s:NodeInstalled() && s:NpmInstalled() && s:BowerInstalled()
    let original_directory = getcwd()

    execute ":cd " . FindComponentsDirectory()

    let cmd = 'bower '.a:args
    execute ':!'.cmd

    execute ":cd " . original_directory
  endif
endfunction

command! -bar -bang -nargs=* Bower call s:bower(<bang>0,<q-args>)
