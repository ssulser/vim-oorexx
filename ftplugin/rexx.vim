" Rexx-specific settings previously configured in the user's vimrc.
if exists('b:did_rexx_plugin_settings')
  finish
endif
let b:did_rexx_plugin_settings = 1

setlocal nosmartindent nocindent
setlocal omnifunc=syntaxcomplete#Complete
setlocal completeopt=menuone,noinsert

nnoremap <buffer> <silent> <F9> :write<CR>:!clear && rexx %<CR>

let b:undo_ftplugin = 'setlocal smartindent< cindent< omnifunc< completeopt< | silent! nunmap <buffer> <F9>'
