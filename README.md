# vim-oorexx

Vim support for Rexx and ooRexx: filetype detection, syntax highlighting, and
completion for documented classes, message methods, and routines.

## Requirements

- Vim 8 or later, compiled with `+eval` and `+syntax`.
- No completion plugin, plugin manager, or special `.vimrc` setup is required.
  The plugin enables Vim's built-in filetype and syntax support itself.

The ooRexx plugin itself must be installed and on Vim's `runtimepath`. For a
plugin-manager-free installation, use Vim's native packages:

```sh
mkdir -p ~/.vim/pack/oorexx/start
git clone https://github.com/ssulser/vim-oorexx \
  ~/.vim/pack/oorexx/start/vim-oorexx
```

With vim-plug, add the repository to your existing plugin block instead:

Publish this directory as a Git repository, then add it to the `plug#begin()`
block in `~/.vimrc`:

```vim
call plug#begin('~/.vim/plugged')
Plug 'ssulser/vim-oorexx'
call plug#end()
```

Run `:PlugInstall` and restart Vim. vim-plug is optional.

## Included files

- `ftdetect/rexx.vim` detects `.rexx`, `.rex`, and `.cls` files.
- `syntax/rexx.vim` provides Rexx/ooRexx syntax highlighting and includes
  documented classes from the extension manuals, including ooSQLite, RxSock,
  ooRexx extensions, ncurses, and Windows Extensions. It also recognizes the
  ooRexxUnit and ooTest framework classes. Function calls are highlighted by
  their call syntax, so extension routines such as `SockSocket()` do not need
  a separate hard-coded syntax list.
- `plugin/rexx_method_completion.vim` completes documented classes, message
  methods, and routines.
- `ftplugin/rexx.vim` applies optional Rexx-specific buffer settings and maps
  `<F9>` to save and run the current file with `rexx`.
- `ctags/oorexx.ctags` defines the ooRexx parser for Universal Ctags.
- `vimrc-rexx-settings.vim` contains optional Taglist settings and the `<F2>`
  toggle mapping.

The plugin does not infer the class of a receiver. Method completion is a
combined list of documented methods; the popup shows which class or classes
provide each method.

## Completion

The plugin uses one built-in `completefunc` for classes, methods, routines, and
directive names. It automatically opens its completion menu in Rexx buffers:

- Type `.` in a class-reference position, then continue typing to filter the
  class list. For example, typing `.A` narrows the list to names such as
  `.Array`.
- Type `~` or `~~` after a receiver to open message-method completion. Continue
  typing to filter the methods. The first candidate is not selected
  automatically.
- Type `::` at the start of a directive to open directive completion. This is
  handled by the plugin and does not use `omnifunc` or `syntaxcomplete`.

The completion functions can also be called manually in Insert mode:

- After a class-reference dot, a message operator, or `::`, press **Ctrl-X,
  then Ctrl-U** (`completefunc`) to reopen the plugin's completion list.
- For documented routines, type a prefix and press **Ctrl-X Ctrl-U**.

The plugin also detects `.rexx`, `.rex`, and `.cls` files itself. A custom
filetype-detection augroup in `.vimrc` is therefore optional. If you keep one,
it can remain the only ooRexx-specific `.vimrc` code.

## Optional Taglist integration

Taglist displays classes, methods, routines, and directives in a navigable
outline. The core vim-oorexx features do not depend on Taglist. This setup uses
Universal Ctags because the included parser configuration defines an ooRexx
language and its tag kinds.

Install Universal Ctags and Taglist. For example, on macOS with Homebrew:

```sh
brew install universal-ctags
```

On Debian or Ubuntu, install the `universal-ctags` package:

```sh
sudo apt install universal-ctags
```

On other Linux distributions, install Universal Ctags using the distribution's
package manager. Check `ctags --version` to confirm that the executable is
Universal Ctags.

Add Taglist to the vim-plug block:

```vim
Plug 'yegappan/taglist'
```

Universal Ctags reads `*.ctags` files from `~/.ctags.d` automatically. The
plugin stores the file in the visible `ctags/` directory; copy it to Ctags'
configuration directory:

```sh
mkdir -p ~/.ctags.d
cp ~/.vim/plugged/vim-oorexx/ctags/oorexx.ctags ~/.ctags.d/oorexx.ctags
```

If vim-plug installs plugins in a different directory, adjust the source path.
macOS also ships an Apple `ctags`, which does not support this parser
configuration; make sure Homebrew's Universal Ctags is the executable found
first in `PATH`.

Finally, source the optional settings file from `~/.vimrc`, after the plugin
manager block:

```vim
source ~/.vim/plugged/vim-oorexx/vimrc-rexx-settings.vim
```

This sets Taglist's `ctags` executable, configures the ooRexx tag groups, and
maps `<F2>` to `:TlistToggle`. The source file is optional and can be omitted
if you do not use Taglist. If `exepath('ctags')` selects the wrong executable,
set `Tlist_Ctags_Cmd` to the full path of Universal Ctags in your vimrc.

## Completion data

The class completion list contains 171 documented class names. The method
table covers 115 classes and 1,605 method entries; the routine table contains
281 documented routines. The data was extracted from the supplied manuals:
rexxref, rexxextensions, rxmath, rxsock, rxftp, unixextensions, orxncurses,
oosqlite, winextensions, and ootest. The core manuals identify themselves as
ooRexx 5.3.0; the Windows Extensions manual is 4.1.3 and ooSQLite is 1.0.0.
User-defined APIs are not inferred.

## Credits

Maintained by Simon Sulser. The syntax file builds on Thomas Geulig's original
Vim Rexx syntax file, with thanks to Dan Sharp and Rony G. Flatscher for their
comments and additions. The ooRexx-specific updates and completion data were
developed by Simon Sulser with assistance from ChatGPT.
