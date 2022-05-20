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
if !exists('g:template_email')
  let g:template_email = ''
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
function! s:toNameWithDefault(fileName, default)
  return '' == a:fileName ? a:default : a:fileName
endfunction

function! s:toUpperCaseFirstLetter(fileName, default)
  return substitute(s:toNameWithDefault(a:fileName, a:default), '\<.', '\U\0', 'g')
endfunction

function! s:toUpperCase(fileName, default)
  return toupper(s:toNameWithDefault(a:fileName, a:default))
  " return substitute(s:toNameWithDefault(a:fileName, a:default), '.*', '\U\0', '')
endfunction

function! s:template(fileName, fileExt)
  call s:replace('${datetime}', strftime("%Y-%m-%d %H:%M:%S"), 'g')
  call s:replace('${date}', strftime("%Y-%m-%d"), 'g')
  call s:replace('${week}', strftime("%A"), 'g')
  call s:replace('${year}', strftime("%Y"), 'g')
  call s:replace('${month}', strftime("%m"), 'g')

  let dirs = split(expand("%:p:h"), '[/\\]')
  call s:replace('${dir-1}', get(dirs, -1, ''), 'g')
  call s:replace('${dir-2}', get(dirs, -2, ''), 'g')
  call s:replace('${dir-3}', get(dirs, -3, ''), 'g')
  call s:replace('${dir-4}', get(dirs, -4, ''), 'g')
  call s:replace('${dir-5}', get(dirs, -5, ''), 'g')

  let pathtime = strptime("%Y-%m-%d", get(dirs, -2, '') . "-" . get(dirs, -1, '') . "-" . a:fileName)
  call s:replace('${week-by-filepath}', strftime("%A", pathtime), 'g')
  let filenametime = strptime("%Y-%m-%d", a:fileName)
  call s:replace('${week-by-filename}', strftime("%A", filenametime), 'g')

  call s:replace('${FILENAME}', s:toUpperCase(a:fileName, 'UNAMED'), 'g')
  call s:replace('${FileName}', s:toUpperCaseFirstLetter(a:fileName, 'Unamed'), 'g')
  call s:replace('${filename}', s:toNameWithDefault(a:fileName, 'unamed'), 'g')

  call s:replace('${FILEEXT}', s:toUpperCase(a:fileExt, ''), 'g')
  call s:replace('${FileExt}', s:toUpperCaseFirstLetter(a:fileExt, ''), 'g')
  call s:replace('${fileext}', s:toNameWithDefault(a:fileExt, ''), 'g')

  call s:replace('${author}', g:template_author, 'g')
  call s:replace('${email}', g:template_email, 'g')

  let cur = s:replace('${cursor}', '', '')
  call setpos(".", [0, cur[0], cur[1]])
  "call cursor(cur)

  return ''
endfunction

" {FileType:FileExt}
let s:FILE_TYPES = {
  \ "typescript" : "ts",
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

  let fullFileName = s:getFileName()
  let fileName = fullFileName
  let fileExt = s:getFileExt()
  let fileType = s:getFileType()

  if filereadable(g:template_dir . '/' . fileName)
    " 如果存在和文件名同名的模板，直接使用。

    let templateFileName = fullFileName
    let fileName = fullFileName
    let fileExt = ""

  elseif "" != fileExt
    " 有文件后缀

    let lastIndex = 0
    while 1
      let index = stridx(fullFileName, ".", lastIndex)
      if (index >= 0)
        let ext = strpart(fullFileName, index)
        if filereadable(g:template_dir . '/template' . ext)
          let fileExt = ext
          let fileName = strpart(fullFileName, 0, index)
          break
        endif
        let lastIndex = index + 1
      else
        let fileName = expand("%:p:t")
        let fileExt = expand('%:e')
        break
      endif
    endwhile

    let templateFileName = 'template' . fileExt

  elseif "" == fullFileName && "" != fileType
    " 没有文件名，但是有文件类型
    " 主要用于设置好 filetype 后执行 :Template 命令。

    let templateFileName = 'template.' . (has_key(s:FILE_TYPES, fileType) ? s:FILE_TYPES[ fileType ] : fileType)
    let fileName = fullFileName
    let fileExt = ""

  endif

  let templateFilePath = g:template_dir . '/' .templateFileName

  try
    exec '0r '.templateFilePath
    call s:template(fileName, fileExt)
  catch /.*/
    return 'template'
  endtry

  return ''
endfunction

if 0 != g:template_autoload
  autocmd! BufNewFile * silent! :call LoadTemplate()
endif
command! -nargs=0 Template call LoadTemplate()
