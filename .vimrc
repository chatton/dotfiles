
" enable syntax higlighting
:syntax on

" enable line numbers
:set number

" specify md as markdown files.
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
