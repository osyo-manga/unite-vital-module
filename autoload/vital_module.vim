scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:V = vital#of("unite_vital_module")
let s:L= s:V.import("Data.List")
let s:FP= s:V.import("System.Filepath")

function! vital_module#get_vital_DataList()
	return s:L
endfunction


function! vital_module#has_vital(...)
	let root = get(a:, 1, getcwd())
	return filereadable(root . "/autoload/vital.vim")
endfunction


function! s:is_camel_case(str)
  return !empty(matchstr(a:str, '^\%([0-9A-Z]\l*\)\+$'))
endfunction

function! s:is_module_name(str)
  return s:L.and(map(split(a:str, '\.'), 's:is_camel_case(v:val)'))
endfunction

function! s:module2file(name)
  let target = a:name ==# '' ? '' : '/' . substitute(a:name, '\W\+', '/', 'g')
  return printf('autoload/vital/__latest__%s.vim', target)
endfunction

function! vital_module#module2file(name)
	return s:module2file(a:name)
endfunction

function! s:file2module(file)
  let filename = s:FP.unify_separator(a:file)
  let tail = matchstr(filename, 'autoload/vital/_\w\+/\zs.*\ze\.vim$')
  return join(split(tail, '[\\/]\+'), '.')
endfunction

function! s:available_module_names(...)
  return sort(s:L.uniq(filter(map(split(globpath(&runtimepath,
  \          'autoload/vital/__latest__/**/*.vim', 1), "\n"),
  \          's:file2module(v:val)'), 's:is_module_name(v:val)')))
endfunction


function! vital_module#get_all()
	return s:available_module_names()
endfunction


function! vital_module#get_installed_modules(...)
  return sort(s:L.uniq(filter(map(split(glob('autoload/vital/*/**', 1), "\n"), 's:file2module(v:val)'), 'len(v:val) && s:is_module_name(v:val)')))
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
