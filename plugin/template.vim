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
    let pos=[1, 1]
    call cursor(1, 1)
    let hasfind=searchpos('\C'.a:text)
    while hasfind!=[0,0]
        let pos = hasfind
        let line = substitute(getline('.'), a:text, a:repl, a:flag)
        call setline('.', line)

        let hasfind = 'g'==a:flag?searchpos('\C'.a:text,'W'):[0,0]
    endwhile

    return pos
endfunction

fun! s:filename(default)
	let filename = expand('%:t:r')
    return ''==filename ? a:default : filename
endf
fun! s:Filename(default)
    return substitute(s:filename(a:default), '\<.', '\U\0', 'g')
endf
fun! s:FILENAME(default)
    return substitute(s:filename(a:default), '.*', '\U\0', '')
endf

function! s:template()
    call s:replace('${datetime}', strftime("%Y/%m/%d %H:%M:%S"), 'g')
    call s:replace('${date}', strftime("%Y/%m/%d"), 'g')
    call s:replace('${FILENAME}', s:FILENAME('UNAMED'), 'g')
    call s:replace('${FileName}', s:Filename('Unamed'), 'g')
    call s:replace('${filename}', s:filename('unamed'), 'g')
    call s:replace('${author}', g:template_author, 'g')
    let cur = s:replace('${cursor}', '', '')
    call setpos(".", [0, cur[0], cur[1]])
    "call cursor(cur)

    return ''
endfunction

exec 'autocmd! BufNewFile * silent! 0r '.g:template_dir.'template.%:e|:call <SID>template()'
