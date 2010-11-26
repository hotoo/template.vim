" File: template.vim
" Desption: autoload content from template file.
" Author: 闲耘™(hotoo.cn[AT]gmail.com)
" Last Change: 2010/11/25

if exists('loaded_smart_template')
    finish
endif
let loaded_smart_template=1

if !exists('g:template_dir')
    let g:template_dir = substitute(globpath(&rtp, 'template/'), "\n", ',', 'g')
endif
if !exists('g:template_author')
    let g:template_author = ''
endif

function! s:replace(text, repl, flag)
    let hasfind=search('\C'.a:text)
    while hasfind
        let pos = getpos('.')
        let line = substitute(getline('.'), a:text, a:repl, '')
        call setline('.', line)

        let hasfind = 'g'==a:flag?search('\C'.a:text,'W'):0
    endwhile

    return [1,1]
endfunction

fun! s:Filename(...)
    if 0==a:0
        let filename = s:filename()
    elseif 1==a:0
        let filename = s:filename(a:1)
    else
        let filename = s:filename(a:1, a:2)
    endif
    return substitute(filename, '^.', '\u&', '')
endf
fun! s:filename(...)
	let filename = expand('%:t:r')
	if filename == '' | return a:0 == 2 ? a:2 : '' | endif
	return !a:0 || a:1 == '' ? filename : substitute(a:1, '$1', filename, 'g')
endf

function! s:template()
    call s:replace('${datetime}', strftime("%Y/%m/%d %H:%M:%S"), 'g')
    call s:replace('${date}', strftime("%Y/%m/%d"), 'g')
    call s:replace('${FileName}', s:Filename('', 'Page Title'), 'g')
    call s:replace('${filename}', s:filename('', 'page title'), 'g')
    call s:replace('${author}', g:template_author, 'g')
    let cur = s:replace('${cursor}', '', '')
    "call setpos('.', cur)

    return ''
endfunction

exec 'autocmd! BufNewFile * silent! 0r '.g:template_dir.'template.%:e|:call <SID>template()'
