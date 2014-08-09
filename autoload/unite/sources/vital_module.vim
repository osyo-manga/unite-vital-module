scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:v_modules()
	return vital_module#get_all()
" 	return vitalizer#complete("", "Vitalize . ", 12)
endfunction


let s:source = {
\	"name" : "vital-module",
\	"action_table" : {
\		"add" : {
\			"is_selectable" : 1,
\		},
\	},
\	"default_action" : "add"
\}


function! s:source.action_table.add.func(candidates)
	let modules = "+" . join(map(a:candidates, 'v:val.action__vital_module'), ' +')
	execute "Vitalize . " . modules
endfunction


function! s:source.gather_candidates(args, context)
	let path = a:context.path == "" ? "." : a:context.path
	let modules = s:v_modules()
	return map(modules, '{
\		"word" : v:val,
\		"action__path" : vital_module#module2file(v:val),
\		"action__vitalize_path" : path,
\		"action__vital_module" : v:val,
\		"kind" : "file",
\		"default_action" : "add"
\	}')
endfunction


function! unite#sources#vital_module#define()
	return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
