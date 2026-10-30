# vim-oorexx

Rexx and ooRexx support for Vim, with automatic filetype detection, syntax
highlighting, and completion for documented classes, message methods,
routines, and directives.

## Requirements

- Vim 8 or later, compiled with `+eval` and `+syntax`.
- Git to install the plugin using the commands below.

No additional completion plugin is required. The plugin enables Vim's
built-in filetype detection and syntax highlighting automatically.

## Installation

Choose one of the following installation methods.

### Native Vim packages

Install the plugin in Vim's default package directory:

```sh
mkdir -p ~/.vim/pack/oorexx/start
git clone https://github.com/ssulser/vim-oorexx \
  ~/.vim/pack/oorexx/start/vim-oorexx
```

Restart Vim after installation. No `.vimrc` changes are needed for filetype
detection, syntax highlighting, or completion.

If you use a custom `packpath`, place the plugin under
`pack/oorexx/start/vim-oorexx` inside one of its directories instead.

### vim-plug

If you use vim-plug, add `Plug 'ssulser/vim-oorexx'` to your existing plugin
block in `.vimrc`. For example:

```vim
call plug#begin('~/.vim/plugged')
Plug 'ssulser/vim-oorexx'
call plug#end()
```

Run `:PlugInstall` and restart Vim.

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

## Completion

Completion is available in Insert mode in Rexx buffers. Classes, message
methods, and directives open a menu automatically; routine completion is
invoked manually.

| Complete | How to open the menu | Example |
| --- | --- | --- |
| Classes | Type `.` in a class-reference position, such as after a space or `=`. | `.Arr` offers `Array`. |
| Message methods | Type `~` or `~~` after a receiver. | `items~app` offers `append`. |
| Directives | Type `::` at the start of a line, optionally indented, or after a semicolon. | `::met` offers `method`. |
| Routines | Type a prefix, then press **Ctrl-X, then Ctrl-U**. | `SysFi` offers `SysFileTree` and other matching routines. |

Continue typing to filter the list. Matching ignores case. The automatic
menus leave the first candidate unselected, so opening a menu does not insert
a suggestion. Use **Ctrl-N** and **Ctrl-P** to select a candidate,
**Ctrl-Y** to accept it, or **Ctrl-E** to dismiss the menu.

Press **Ctrl-X, then Ctrl-U** after a class-reference dot, a message operator,
or `::` to reopen the corresponding menu. You can also use it immediately
after `call ` to list documented routines without entering a prefix.

Method completion combines the documented methods of all supported classes.
The plugin does not infer the receiver's class; the menu shows which class
or classes provide each method. User-defined APIs are not inferred.

All four completion types use Vim's `completefunc`. **Ctrl-X, then Ctrl-O**
invokes `omnifunc`, a separate Vim feature that this plugin does not configure.

## Running Rexx files

To enable the buffer settings and `<F9>` mapping in `ftplugin/rexx.vim`, add
this to your `.vimrc`:

```vim
filetype plugin on
```

In Normal mode, press `<F9>` to save the current file, clear the terminal,
and run it with `rexx`. The mapping requires the ooRexx interpreter (`rexx`)
and the `clear` command to be available in `PATH`.

## Optional Taglist integration

Taglist displays classes, methods, routines, and directives in a navigable
outline. The core vim-oorexx features do not depend on Taglist. This setup uses
Universal Ctags because the included parser configuration defines an ooRexx
language and its tag kinds.

### Install Universal Ctags

On macOS with Homebrew:

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

On macOS, make sure Homebrew's Universal Ctags is found first in `PATH`;
Apple's `ctags` does not support the included parser configuration.

### Install Taglist

For native Vim packages:

```sh
git clone https://github.com/yegappan/taglist \
  ~/.vim/pack/oorexx/start/taglist
```

With vim-plug, add Taglist to your existing plugin block, then run
`:PlugInstall`:

```vim
Plug 'yegappan/taglist'
```

### Configure the ooRexx parser

Copy the included parser configuration to `~/.ctags.d`, where Universal
Ctags reads `*.ctags` files automatically.

For the native Vim package installation:

```sh
mkdir -p ~/.ctags.d
cp ~/.vim/pack/oorexx/start/vim-oorexx/ctags/oorexx.ctags ~/.ctags.d/oorexx.ctags
```

For the vim-plug installation:

```sh
mkdir -p ~/.ctags.d
cp ~/.vim/plugged/vim-oorexx/ctags/oorexx.ctags ~/.ctags.d/oorexx.ctags
```

Adjust the source path if you installed vim-oorexx in a different directory.
Copy the file again after a plugin update that changes the parser.

### Enable the Taglist settings

Source the included settings file from your `.vimrc`. For native Vim
packages:

```vim
source ~/.vim/pack/oorexx/start/vim-oorexx/vimrc-rexx-settings.vim
```

For vim-plug, add this after `call plug#end()`:

```vim
source ~/.vim/plugged/vim-oorexx/vimrc-rexx-settings.vim
```

This sets Taglist's `ctags` executable, configures the ooRexx tag groups, and
maps `<F2>` to `:TlistToggle`. Restart Vim, open a Rexx file, and press `<F2>`
to open or close the outline.

If `exepath('ctags')` selects the wrong executable, set `Tlist_Ctags_Cmd` to
the full path of Universal Ctags **after** sourcing the settings file, which
otherwise overwrites that setting.

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
