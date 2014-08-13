scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:L = vital_module#get_vital_DataList()

function! s:v_modules()
	return vital_module#get_all()
endfunction


function! s:installed_modules()
	return vital_module#get_installed_modules()
endfunction


function! s:module_candidates(...)
	let path = get(a:, 1, getcwd())
	let installed = s:installed_modules()
	let modules   = s:L.uniq(sort(installed + s:v_modules()))
	return map(modules, '{
\		"word" : index(installed, v:val) == -1 ? ("  " . v:val) : ("@ " . v:val),
\		"action__path" : vital_module#module2file(v:val),
\		"action__vitalize_path" : path,
\		"action__vital_module" : v:val,
\		"kind" : "file",
\		"default_action" : "add"
\	}')
endfunction


let s:source = {
\	"name" : "vital-module",
\	"action_table" : {
\		"add" : {
\			"is_selectable" : 1,
\		},
\		"delete" : {
\			"is_selectable" : 1,
\		},
\	},
\	"default_action" : "add"
\}


function! s:source.action_table.add.func(candidates)
	let modules = "+" . join(map(a:candidates, 'v:val.action__vital_module'), ' +')
	if unite#util#input_yesno("Install " . string(modules))
		execute "Vitalize . " . modules
	endif
endfunction


function! s:source.action_table.delete.func(candidates)
	let modules = "-" . join(map(a:candidates, 'v:val.action__vital_module'), ' +')
	if unite#util#input_yesno("Remove " . string(modules))
		execute "Vitalize . " . modules
	endif
" 	let modules = "-" . join(map(a:candidates, 'v:val.action__vital_module'), ' +')
" 	echom "Vitalize . " . modules
" 	execute "Vitalize . " . modules
endfunction


function! s:source.gather_candidates(args, context)
	call unite#print_source_message( '@: installed', self.name)
	let path = a:context.path == "" ? "." : a:context.path
	return s:module_candidates(path)
endfunction


function! unite#sources#vital_module#define()
	return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
