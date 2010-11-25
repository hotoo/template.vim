" File: template.vim
" Desption: autoload content from template file.
" Author: 闲耘™(hotoo.cn[AT]gmail.com)
" Last Change: 2010/11/25


function! s:find(text, repl)
    let hasfind=search('\C'.a:text)
    if hasfind
        let pos = getpos('.')
        let line = substitute(getline('.'), a:text, a:repl, '')
        call setline('.', line)
        return pos
    endif
    return [1,1]
endfunction

fun! s:Filename(...)
	let filename = expand('%:t:r')
	if filename == '' | return a:0 == 2 ? a:2 : '' | endif
	let filename = !a:0 || a:1 == '' ? filename : substitute(a:1, '$1', filename, 'g')
    return substitute(filename, '^.', '\u&', '')
endf
fun! s:filename(...)
	let filename = expand('%:t:r')
	if filename == '' | return a:0 == 2 ? a:2 : '' | endif
	return !a:0 || a:1 == '' ? filename : substitute(a:1, '$1', filename, 'g')
endf

function! s:cursor()
    try | call s:find('${date}', strftime("%Y/%m/%d")) | catch /.*/ | endtry
    try | call s:find('${filename}', s:filename('', 'page title')) | catch /.*/ | endtry
    try | call s:find('${FileName}', s:Filename('', 'Page Title')) | catch /.*/ | endtry
    try
        let cur = s:find('${cursor}', '')
        call setpos('.', cur)
    catch /.*/
    endtry

    return ''
endfunction

autocmd! BufNewFile * silent! 0r $VIM/vimfiles/template/template.%:e|:call <SID>cursor()
