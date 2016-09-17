" File: template.vim
" Desption: autoload content from template file.
" Author: 闲耘™(hotoo.cn[AT]gmail.com)

if exists('loaded_smart_template')
  finish
endif
let loaded_smart_template = 1

if !exists('g:template_autoload')
  let g:template_autoload = 1
endif
if !exists('g:template_author')
  let g:template_author = ''
endif

if !exists('g:template_dir')
  let paths = split(globpath(&rtp, 'template'), "\n")
  if(0 == len(paths))
    echoerr '[template.vim] Not found template dir.'
  endif
  let g:template_dir = paths[0]
endif

function! s:replace(text, repl, flag)
  let pos = [1, 1]
  call cursor(1, 1)
  let hasfind = searchpos('\C' . a:text)
  while hasfind != [0, 0]
    let pos = hasfind
    let line = substitute(getline('.'), a:text, a:repl, a:flag)
    call setline('.', line)

    let hasfind = 'g' == a:flag ? searchpos('\C' . a:text, 'W') : [0, 0]
  endwhile

  return pos
endfunction

" template placehoders
function! s:filename(default)
	let filename = expand('%:t:r')
  return '' == filename ? a:default : filename
endfunction

function! s:Filename(default)
  return substitute(s:filename(a:default), '\<.', '\U\0', 'g')
endfunction

function! s:FILENAME(default)
  return substitute(s:filename(a:default), '.*', '\U\0', '')
endfunction

function! s:template()
  call s:replace('${datetime}', strftime("%Y-%m-%d %H:%M:%S"), 'g')
  call s:replace('${date}', strftime("%Y-%m-%d"), 'g')
  call s:replace('${FILENAME}', s:FILENAME('UNAMED'), 'g')
  call s:replace('${FileName}', s:Filename('Unamed'), 'g')
  call s:replace('${filename}', s:filename('unamed'), 'g')
  call s:replace('${author}', g:template_author, 'g')
  let cur = s:replace('${cursor}', '', '')
  call setpos(".", [0, cur[0], cur[1]])
  "call cursor(cur)

  return ''
endfunction

" {FileType:FileExt}
let s:FILE_TYPES = {
  \ "javascript" : "js",
  \ "actionscript": "as",
  \ "aspvbs" : "asp",
  \ "markdown": "md"
\ }

function! s:getFileExt()
  let ext = expand("%:e")
  if ext == ''
    return ext
  endif
  return '.' . ext
endfunction

function! s:getFileType()
  return &ft
endfunction

function! s:getFileName()
  return expand('%:p:t')
endfunction


function! LoadTemplate()
  " 默认模板
  let templateFileName = 'template'

  let fileExt = s:getFileExt()
  let fileName = s:getFileName()
  let fileType = s:getFileType()
  if "" != fileExt
    " 有文件后缀

    let fullFileName = expand('%:p:t')
    let ext = matchstr(fullFileName, '\..*')
    while ext != ''
      if filereadable(g:template_dir . '/template' . ext)
        let fileExt = ext
        break
      endif
      let fullFileName = substitute(ext, '[^.]*\.', '', '')
      let ext = matchstr(fullFileName, '\..*')
    endwhile

    let templateFileName = 'template' . fileExt
  elseif "" != fileName
    " 没有后缀，有文件名
    let templateFileName = fileName
  elseif "" == fileName && "" != fileType
    " 没有文件名，但是有文件类型
    let templateFileName = 'template.' . (has_key(s:FILE_TYPES, fileType) ? s:FILE_TYPES[ fileType ] : fileType)
  endif

  let templateFilePath = g:template_dir . '/' .templateFileName

  try
    exec '0r '.templateFilePath
    call s:template()
  catch /.*/
    return 'template'
  endtry

  return ''
endfunction

if 0 != g:template_autoload
  autocmd! BufNewFile * silent! :call LoadTemplate()
endif
command! -nargs=0 Template call LoadTemplate()
