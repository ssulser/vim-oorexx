augroup filetypedetect_rexx
    autocmd!
    autocmd BufRead,BufNewFile *.rexx,*.rex setfiletype rexx
    autocmd BufRead,BufNewFile *.cls setlocal filetype=rexx
augroup END