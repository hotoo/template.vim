# template.vim

Smart load template file for Vim.

## Install

### By vim-plug

```viml
Plug "hotoo/template.vim"
```

### By Manual

Put `plugin/template.vim` into `$VIM/vimfiles/plugin/` for Windows,
or into `.vim/plugin/` for *nix.

Put `template/template.*` into `$VIM/vimfiles/template/` for Windows,
or into `.vim/template/` for *nix.

If your vim installed snipMate.vim, append `snippets/_.snippet` content
to `$VIM/snippets/_.snippet` for Windows,
or to `.vim/snippets/_.snippet` for *nix.

## Usage

`:new file.html`

`:tabnew file.css`

If current buffer has been set filetype, you can use command: `:Template` to
load template.

If your Vim has installed snipMate plugin, input `template<Tab>` to smart load
the template(when the buffer has suffix or &filetype).

## Optional

### g:template_autoload

If you didn't want auto load template every time, `let g:template_autoload = 0`.

### g:template_dir

Set you custom template dir.

### g:template_author

Author name for template placeholder.

### g:template_email

Email address for template placeholder.

## Custom Template

Support following placeholder.

- `${cursor}` - default cursor position.
- `${filename}` - get origin file name.
- `${FileName}` - file-name to File-Name.
- `${FILENAME}` - filename to FILENAME.
- `${fileext}` - get origin file extension.
- `${FileExt}` - Camel case file-ext to File-Ext.
- `${FILEEXT}` - Upper case fileext to FILEEXT.
- `${date}` - today.
- `${datetime}` - now.
- `${year}` - the year of now.
- `${month}` - the month of now.
- `${week}` - today's day of week.
- `${week-by-filepath}` - the day of week from file path like "xxx/2022/04/01.md".
- `${week-by-filename}` - the day of week from file name like "xxx/2022-04-01.md".
- `${dir-1}` - the last of dir name. eg: "04" in file path "xxx/2022/04/01.md".
- `${dir-2}` - the last but one of dir name. eg: "2022" in file path "xxx/2022/04/01.md".
- `${dir-3}` - the last but two of dir name. eg: "xxx" in file path "xxx/2022/04/01.md".
- `${dir-4}` - the last but three of dir name. eg: "yyy" in file path "zzz/yyy/xxx/2022/04/01.md".
- `${dir-5}` - the last but four of dir name. eg: "zzz" in file path "zzz/yyy/xxx/2022/04/01.md".
- `${author}` - Need `let g:template_author = "You Name"` in your vimrc.
- `${email}` - Need `let g:template_email = "email@addr.ess"` in your vimrc.

## License

[MIT](https://hotoo.mit-license.org/)
