" vim-oorexx handles filetype detection and Rexx buffer options automatically.
" Keep this optional Taglist configuration in your vimrc only if you use Taglist.
let Tlist_Ctags_Cmd = system('brew --prefix')->trim() . '/bin/ctags'
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
