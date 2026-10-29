# vim-oorexx

Vim support for Rexx and ooRexx: filetype detection, syntax highlighting, and
completion for documented classes, message methods, and routines.

## Requirements

- Vim 8 or later with syntax support (`+syntax`).
- No other Vim plugin is required for filetype detection, syntax highlighting,
  or the plugin's class, method, and routine completion.
- `asyncomplete.vim` and `asyncomplete-omni.vim` are optional. They add
  automatic completion through Vim's `omnifunc`, including syntax completion
  for directives. See [Optional asyncomplete setup](#optional-asyncomplete-setup).

Make sure Vim filetype and syntax support are enabled in `~/.vimrc`:

```vim
filetype plugin on
syntax on
```

## Install with vim-plug

Publish this directory as a Git repository, then add it to the `plug#begin()`
block in `~/.vimrc`:

```vim
call plug#begin('~/.vim/plugged')
Plug 'YOUR-ACCOUNT/vim-oorexx'
call plug#end()
```

Replace `YOUR-ACCOUNT` with the GitHub account or organization that hosts the
repository. Run `:PlugInstall` and restart Vim.

## Included files

- `ftdetect/rexx.vim` detects `.rexx`, `.rex`, and `.cls` files.
- `syntax/rexx.vim` provides Rexx/ooRexx syntax highlighting and includes
  documented classes from the extension manuals, including ooSQLite, RxSock,
  ooRexx extensions, ncurses, and Windows Extensions.
- `plugin/rexx_method_completion.vim` completes documented classes, message
  methods, and routines.
- `ftplugin/rexx.vim` applies Rexx-specific buffer settings: it disables
  `smartindent` and `cindent`, sets `omnifunc=syntaxcomplete#Complete`, sets
  `completeopt=menuone,noinsert,noselect`, and maps `<F9>` to save and run the
  current file with `rexx`.

The plugin does not infer the class of a receiver. Method completion is a
combined list of documented methods; the popup shows which class or classes
provide each method.

## Completion

The plugin automatically opens its completion menu in Rexx buffers:

- Type `.` in a class-reference position, then continue typing to filter the
  class list. For example, typing `.A` narrows the list to names such as
  `.Array`.
- Type `~` or `~~` after a receiver to open message-method completion. Continue
  typing to filter the methods. The first candidate is not selected
  automatically.

The completion functions can also be called manually in Insert mode:

- After a class-reference dot or a message operator, press **Ctrl-X, then
  Ctrl-U** (`completefunc`). For example, type `.A`, press **Ctrl-X Ctrl-U**,
  and select `.Array` with **Ctrl-N/Ctrl-P**. Press **Ctrl-Y** to accept the
  selected candidate.
- For documented routines, type a prefix and press **Ctrl-X Ctrl-U**.
- For Vim syntax completion, such as directive names after `::`, press
  **Ctrl-X, then Ctrl-O** (`omnifunc`).

`completefunc` and `omnifunc` serve different completion sources. This plugin
uses `completefunc` for its class, method, and routine lists, and leaves
`omnifunc` available for syntax completion.

## Optional asyncomplete setup

The plugin's `.` and `~` mappings work without asyncomplete. Install
asyncomplete if you also want its automatic popup behavior for Vim's
`omnifunc`, for example to show syntax completion while typing directive names.
The asyncomplete Omni source calls `omnifunc`; it does not replace this plugin's
`completefunc` completion.

For asyncomplete, use Vim 8 or later with the `+timers` feature.

With vim-plug, add both optional plugins:

```vim
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'yami-beta/asyncomplete-omni.vim'
```

The Rexx ftplugin already sets `omnifunc=syntaxcomplete#Complete`. Register the
Omni source for the `rexx` filetype in `~/.vimrc`:

```vim
let g:asyncomplete_min_chars = 2

augroup asyncomplete_rexx
  autocmd!
  autocmd User asyncomplete_setup call asyncomplete#register_source(
        \ asyncomplete#sources#omni#get_source_options({
        \   'name': 'omni-rexx',
        \   'allowlist': ['rexx'],
        \   'completor': function('asyncomplete#sources#omni#completor'),
        \   'refresh_pattern': '\k\+$',
        \ }))
augroup END
```

If you already register a generic Omni source for all filetypes, you do not
need to register a second Rexx source. Make sure `rexx` is not in that source's
`blocklist`. Keep the Rexx `omnifunc` setting; the plugin's ftplugin sets it
automatically.

If you do not use asyncomplete, no asyncomplete-related `.vimrc` changes are
needed. Remove the old Rexx-specific `BufRead,BufNewFile` and `FileType rexx`
autocommands if they duplicate the plugin's filetype detection or buffer
settings. Keep unrelated settings, such as Taglist configuration, as needed.

## Completion data

The completion tables contain 111 classes, 1,591 method entries, and 281
documented routines. They were extracted from the supplied manuals: rexxref,
rexxextensions, rxmath, rxsock, rxftp, unixextensions, orxncurses, oosqlite,
and winextensions. The core manuals identify themselves as ooRexx 5.3.0; the
Windows Extensions manual is 4.1.3 and ooSQLite is 1.0.0. The ooTest manual
was not supplied. User-defined APIs are not inferred.
