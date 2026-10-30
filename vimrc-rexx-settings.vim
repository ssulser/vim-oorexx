" Optional Taglist settings for ooRexx.
" Source this file from your vimrc only if Taglist and Universal Ctags are installed.
let Tlist_Ctags_Cmd = exepath('ctags')
nnoremap <silent> <F2> :TlistToggle<CR>
let tlist_rexx_settings =
      \ 'ooRexx;'
      \ . 'c:classes;'
      \ . 'm:methods;'
      \ . 'a:attributes;'
      \ . 'k:constants;'
      \ . 'r:routines;'
      \ . 'p:procedures;'
      \ . 'n:annotations;'
      \ . 's:resources;'
      \ . 'o:options;'
      \ . 'q:requires'
