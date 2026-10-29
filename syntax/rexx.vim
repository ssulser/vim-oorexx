" Vim syntax file
" Language:     Rexx / ooRexx
" Maintainer:   Thomas Geulig <geulig@nentec.de>
" Last Change:  2026 Aug 09, ooRexx directive and ADDRESS option completion fixes
" Notes:        Adds ooRexx 5.x directives, namespaces, built-in classes,
"               environment symbols, directive completion, and gc().

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case ignore

" add to valid identifier chars
setlocal iskeyword+=.
setlocal iskeyword+=!
setlocal iskeyword+=?

" ---rgf, position important: must be before comments etc. !
syn match rexxOperator "[=|\/\\\+\*\[\],;:<>&\~%\-]"

" rgf syn match rexxIdentifier "\<[a-zA-Z\!\?_]\([a-zA-Z0-9._?!]\)*\>"
syn match rexxIdentifier "\<\K\k*\>"
syn match rexxEnvironmentSymbol "\<\.\k\+\>"

" ooRexx 5 namespace-qualified symbols, e.g. rexx:stream
syn match rexxNamespaceSymbol "\<\K\k*:\K\k*\>"

" A Keyword is the first symbol in a clause. A clause begins at the start
" of a line or after a semicolon. THEN, ELSE, OTHERWISE, and colons are always
" followed by an implied semicolon.
syn match rexxClause "\(^\|;\|:\|then \|else \|when \|otherwise \)\s*\S*" contains=ALLBUT,rexxParse2,rexxRaise2,rexxForward2

" Considered keywords when used together in a phrase and begin a clause
syn match rexxParse "\<parse\s*\(\(upper\|lower\|caseless\)\s*\)\?\(arg\|linein\|pull\|source\|var\|\<value\>\|version\)\>" containedin=rexxClause contains=rexxParse2
syn match rexxParse2 "\<with\>" containedin=rexxParse
syn match rexxKeyword contained "\<numeric \(digits\|form \(scientific\|engineering\|value\)\|fuzz\)\>"
syn match rexxKeyword contained "\<\(address\|trace\)\( value\)\?\>"
syn match rexxKeyword contained "\<procedure\(\s*expose\)\?\>"
syn match rexxKeyword contained "\<\(do\|loop\)\>\(\s\+label\s\+\k*\)\?\(\s\+forever\)\?\>"
syn match rexxKeyword contained "\<use\>\s*\(strict\s*\)\?\<arg\>"

" Another keyword phrase, separated to aid highlighting in rexxFunction
syn match rexxRegularCallSignal contained "\<\(call\|signal\)\s\(\s*on\>\|\s*off\>\)\@!\(\k\+\ze\|\ze(\)\(\s*\|;\|$\|(\)"
syn region rexxLabel contained start="\<\(call\|signal\)\>\s*\zs\(\k*\|(\)" end="\ze\(\s*\|;\|$\|(\)" containedin=rexxRegularCallSignal
syn match rexxExceptionHandling contained "\<\(call\|signal\)\>\s\+\<\(on\|off\)\>.*\(;\|$\)" contains=rexxComment

" hilite label given after keyword "name"
syn match rexxLabel "name\s\+\zs\k\+\ze" containedin=rexxExceptionHandling
" hilite condition name (serves as label)
syn match rexxLabel "\<\(call\|signal\)\>\s\+\<\(on\|off\)\>\s*\zs\k\+\ze\s*\(;\|$\)" containedin=rexxExceptionHandling

" user exception handling, hilite user defined name
syn region rexxLabel contained start="user\s\+\zs\k" end="\ze\(\s\|;\|$\)" containedin=rexxExceptionHandling

" Considered keywords when they begin a clause
syn match rexxKeywordStatements "\<\(arg\|case\|catch\|do\|drop\|end\|exit\|expose\|finally\|forward\|if\|interpret\|iterate\|leave\|loop\|nop\)\>"
syn match rexxKeywordStatements "\<\(options\|pull\|push\|queue\|raise\|reply\|return\|say\|select\|trace\)\>"

" Conditional keywords starting a new statement
syn match rexxConditional "\<\(then\|else\|when\|otherwise\)\(\s*\|;\|\_$\|\)\>" contains=rexxKeywordStatements

" Conditional phrases
syn match rexxLoopKeywords "\<\(to\|by\|for\|until\|while\|over\)\>" containedin=doLoopSelectLabelRegion

" must be after Conditional phrases!
syn match doLoopSelectLabelRegion "\<\(do\|loop\|select\)\>\s\+\(label\s\+\)\?\(\s\+\k\+\s\+\zs\<over\>\)\?\k*\(\s\+forever\)\?\(\s\|;\|$\)" contains=doLoopSelectLabelRegion,rexxStartValueAssignment,rexxLoopKeywords

" color label's name
syn match rexxLabel2 "\<\(do\|loop\|select\)\>\s\+label\s\+\zs\k*\ze" containedin=doLoopSelectLabelRegion

" make sure control variable is normal
" TODO: re-activate ?
"rgf syn match rexxControlVariable "\<\(do\|loop\)\>\(\s\+label\s\+\k*\)\?\s\+\zs.*\ze\s\+\<over\>" containedin=doLoopSelectLabelRegion

" make sure control variable assignment is normal
syn match rexxStartValueAssignment "\<\(do\|loop\)\>\(\s\+label\s\+\k*\)\?\s\+\zs.*\ze\(=.*\)\?\s\+\<to\>" containedin=doLoopSelectLabelRegion

" highlight label name
syn match endIterateLeaveLabelRegion "\<\(end\|leave\|iterate\)\>\(\s\+\K\k*\)" contains=rexxLabel2
syn match rexxLabel2 "\<\(end\|leave\|iterate\)\>\s\+\zs\k*\ze" containedin=endIterateLeaveLabelRegion

" Guard statement
syn match rexxGuard "\(^\|;\|:\)\s*\<guard\>\s\+\<\(on\|off\)\>"

" Trace statement
syn match rexxTrace "\(^\|;\|:\)\s*\<trace\>\s\+\<\K\k*\>"

" ADDRESS instruction options.
" ADDRESS itself is highlighted as rexxKeyword. The surrounding region is
" transparent so the rest of the clause keeps its normal syntax highlighting.
syn region rexxAddressClause
      \ matchgroup=rexxKeyword
      \ start="\(^\|;\|:\)\s*\zs\<address\>"
      \ end="\($\|;\)"
      \ transparent
      \ contains=rexxAddressKeyword,rexxString,rexxComment,rexxLineComment

" ADDRESS ... WITH INPUT/OUTPUT/ERROR
" Explicit keywords also make these words available to syntaxcomplete#Complete.
syn keyword rexxAddressKeyword contained with input output error


" Raise statement
syn match rexxRaise "\(^\|;\|:\)\s*\<raise\>\s*\<\(propagate\|error\|failure\|syntax\|user\)\>\?" contains=rexxRaise2
syn match rexxRaise2 "\<\(additional\|array\|description\|exit\|propagate\|return\)\>" containedin=rexxRaise

" Forward statement
syn match rexxForward "\(^\|;\|:\)\<forward\>\s*" contains=rexxForward2
syn match rexxForward2 "\<\(arguments\|array\|continue\|message\|class\|to\)\>" contained

" Functions/Procedures
syn match rexxFunction "\<\<[a-zA-Z\!\?_]\k*\>("me=e-1
syn match rexxFunction "[()]"

" ooRexx 5.2 adds gc() as a built-in function
syn match rexxBuiltinFunction "\<gc\s*("me=e-1

" String constants
syn region rexxString start=+"+ skip=+""+ end=+"\(x\|b\)\?+ oneline
syn region rexxString start=+'+ skip=+''+ end=+'\(x\|b\)\?+ oneline

syn region rexxParen transparent start='(' end=')' contains=ALLBUT,rexxParenError,rexxTodo,rexxLabel,rexxKeyword

" Catch errors caused by wrong parenthesis
syn match rexxParenError ")"
syn match rexxInParen "[\\[\\]{}]"

" Comments
syn region rexxComment start="/\*" end="\*/" contains=rexxTodo,rexxComment
syn match rexxCommentError "\*/"
syn region rexxLineComment start="--" end="\_$" oneline

" Highlight User Labels
" check for labels between comments, labels stated in a statement in the middle of a line
syn match rexxLabel "\(\_^\|;\)\s*\(\/\*.*\*\/\)*\s*\k\+\s*\(\/\*.*\*\/\)*\s*:"me=e-1 contains=rexxTodo,rexxComment

syn keyword rexxTodo contained TODO FIXME XXX

" ooRexx messages
syn region rexxMessageOperator start="\(\~\|\~\~\)" end="\(\S\|\s\)"me=e-1
syn match rexxMessage "\(\~\|\~\~\)\s*\<\.*[a-zA-Z]\([a-zA-Z0-9._?!]\)*\>" contains=rexxMessageOperator

" line continuations, take care of (line-)comments after it
syn match rexxLineContinue ",\ze\s*\(--.*\|\/\*.*\)*$"
" the following is necessary, otherwise three consecutive dashes will cause it to highlight the first one
syn match rexxLineContinue "-\ze-\@!\s*\(--.*\|\s*\/\*.*\)\?$"

" Special Variables
syn keyword rexxSpecialVariable sigl rc result self super
syn keyword rexxSpecialVariable .context .debuginput .environment .error .input .local .methods .output .resources .rs .stderr .stdin .stdout .stdque .syscargs .traceoutput

" Constants / environment symbols
syn keyword rexxConst .true .false .nil .endOfLine .line

" Rexx numbers
" int like number
syn match rexxNumber '\d\+' contained
syn match rexxNumber '[-+]\s*\d\+' contained
" Floating point number with decimal
syn match rexxNumber '\d\+\.\d*' contained
syn match rexxNumber '[-+]\s*\d\+\.\d*' contained
" Floating point like number with E
syn match rexxNumber '[-+]\s*\d*[eE][\-+]\d\+' contained
syn match rexxNumber '\d*[eE][\-+]\d\+' contained
" Floating point like number with E and decimal point (+,-)
syn match rexxNumber '[-+]\s*\d*\.\d*[eE][\-+]\d\+' contained
syn match rexxNumber '\d*\.\d*[eE][\-+]\d\+' contained

" ooRexx builtin classes, updated through ooRexx 5.3 reference manuals
syn keyword rexxBuiltinClass .Alarm .AlarmNotification .ArgUtil .Array .Bag .Buffer
syn keyword rexxBuiltinClass .CaselessColumnComparator .CaselessComparator .CaselessDescendingComparator
syn keyword rexxBuiltinClass .CircularQueue .Class .Collection .ColumnComparator .Comparable .Comparator
syn keyword rexxBuiltinClass .DateTime .DescendingComparator .Directory .EventSemaphore .File
syn keyword rexxBuiltinClass .IdentityTable .InputOutputStream .InputStream .InvertingComparator
syn keyword rexxBuiltinClass .Json .List .MapCollection .Message .MessageNotification .Method
syn keyword rexxBuiltinClass .Monitor .MutableBuffer .MutexSemaphore .Object .Orderable .OrderedCollection
syn keyword rexxBuiltinClass .OutputStream .Package .Pointer .Properties .Queue .RegularExpression
syn keyword rexxBuiltinClass .Relation .RexxContext .RexxInfo .RexxQueue .Routine .Set .SetCollection
syn keyword rexxBuiltinClass .Singleton .StackFrame .Stem .Stream .StreamSupplier .String .StringTable .Supplier
syn keyword rexxBuiltinClass .Table .Ticker .TimeSpan .TraceObject .Validate .VariableReference .WeakReference

" Windows-only classes
syn keyword rexxBuiltinClass .AdvancedControls .AnimatedButton .BaseDialog .ButtonControl
syn keyword rexxBuiltinClass .CategoryDialog .CheckBox .CheckList .ComboBox .DialogControl
syn keyword rexxBuiltinClass .DialogExtensions .DlgArea .DlgAreaU .DynamicDialog
syn keyword rexxBuiltinClass .EditControl .InputBox .IntegerBox .ListBox .ListChoice
syn keyword rexxBuiltinClass .ListControl .MenuObject .MessageExtensions .MultiInputBox
syn keyword rexxBuiltinClass .MultiListChoice .OLEObject .OLEVariant
syn keyword rexxBuiltinClass .PasswordBox .PlainBaseDialog .PlainUserDialog
syn keyword rexxBuiltinClass .ProgressBar .ProgressIndicator .PropertySheet .RadioButton
syn keyword rexxBuiltinClass .RcDialog .ResDialog .ScrollBar .SingleSelection .SliderControl
syn keyword rexxBuiltinClass .StateIndicator .StaticControl .TabControl .TimedMessage
syn keyword rexxBuiltinClass .TreeControl .UserDialog .VirtualKeyCodes .WindowBase
syn keyword rexxBuiltinClass .WindowExtensions .WindowObject .WindowsClassesBase .WindowsClipboard
syn keyword rexxBuiltinClass .WindowsEventLog .WindowsManager .WindowsProgramManager .WindowsRegistry

" BSF4ooRexx classes
syn keyword rexxBuiltinClass .BSF .bsf.dialog .bsf_proxy
syn keyword rexxBuiltinClass .UNO .UNO_ENUM .UNO_CONSTANTS .UNO_PROPERTIES

" Classes documented by the supplied extension manuals, beyond rexxref.
syn keyword rexxBuiltinClass .Chtype .CommandContext .CommandHandler .csvStream .HostInfo
syn keyword rexxBuiltinClass .InetAddress .JsonBoolean .JsonError .JsonString .JsonXmlEmitter
syn keyword rexxBuiltinClass .JsonXmlParser .LogicalWrapper .Mevent .MimeMultiPart .MimePart
syn keyword rexxBuiltinClass .NativeCommandHandler .NumericComparator .ooSQLCollation .ooSQLCollationNeeded .ooSQLExtensions
syn keyword rexxBuiltinClass .ooSQLFunction .ooSQLite .ooSQLiteBackup .ooSQLiteConnection .ooSQLiteMutex
syn keyword rexxBuiltinClass .ooSQLiteStmt .ooSQLLibrary .ooSQLPackage .ooSQLResult .ooSQLValue
syn keyword rexxBuiltinClass .Pad .SMTP .SMTPMsg .Socket .StreamSocket
syn keyword rexxBuiltinClass .Window .Yaml .YamlBoolean .YamlEmitter .YamlError
syn keyword rexxBuiltinClass .YamlTagged .YamlXmlEmitter .YamlXmlParser

" ooRexx directives.  Location is important; otherwise directives at top of file may not match.
"
" Keep directive names as explicit syntax keywords as well as region starters.
" syntaxcomplete#Complete can then offer them for omni completion after ::.
" ::END is handled separately below because it is case- and column-sensitive.
syn keyword rexxDirectiveName annotate annotation attribute class constant method options requires resource routine contained

" Keep END uppercase for completion without weakening the strict ::END syntax rule.
syn case match
syn keyword rexxEndDirectiveName END contained
syn case ignore

syn region rexxClassDirective      start="::\s*class\s*"ms=e+1      end="\ze\(\s\|;\|$\)"
syn region rexxMethodDirective     start="::\s*method\s*"ms=e+1     end="\ze\(\s\|;\|$\)"
syn region rexxRequiresDirective   start="::\s*requires\s*"ms=e+1   end="\ze\(\s\|;\|$\)"
syn region rexxRoutineDirective    start="::\s*routine\s*"ms=e+1    end="\ze\(\s\|;\|$\)"
syn region rexxAttributeDirective  start="::\s*attribute\s*"ms=e+1  end="\ze\(\s\|;\|$\)"
syn region rexxOptionsDirective    start="::\s*options\s*"ms=e+1    end="\ze\(\s\|;\|$\)"
syn region rexxConstantDirective   start="::\s*constant\s*"ms=e+1   end="\ze\(\s\|;\|$\)"
syn region rexxAnnotateDirective   start="::\s*annotat\(e\|ion\)\s*"ms=e+1 end="\ze\(\s\|;\|$\)"
syn region rexxResourceDirective   start="::\s*resource\s*"ms=e+1   end="\ze\(\s\|;\|$\)"
" ::END is special: by default it must be spelled exactly ::END,
" start in column 1, and contain no blanks.  Mark relaxed variants as errors.
syn region rexxIllegalEndDirective start="^\s*:\s*:\s*end\>"          end="\ze\(\s\|;\|$\)"
syn region rexxEndDirective        start="^::END\C\>"                 end="\ze\(\s\|;\|$\)"

syn match rexxDirectiveKeyword "\<\(abstract\|attribute\|class\|delegate\|digits\|external\|form\|fuzz\|get\|guarded\|inherit\|library\|metaclass\|mixinclass\|namespace\|private\|protected\|public\|set\|subclass\|trace\|unguarded\|unprotected\)\>" contained

syn region rexxDirective start="\(^\|;\)\s*::\s*\w\+" end="\($\|;\)" contains=rexxString,rexxNumber,rexxComment,rexxLineComment,rexxDirectiveName,rexxEndDirectiveName,rexxClassDirective,rexxMethodDirective,rexxRoutineDirective,rexxRequiresDirective,rexxAttributeDirective,rexxOptionsDirective,rexxConstantDirective,rexxAnnotateDirective,rexxResourceDirective,rexxIllegalEndDirective,rexxEndDirective,rexxDirectiveKeyword,rexxBuiltinClass,rexxNamespaceSymbol keepend

syn match rexxOptionsDirective2 "\<\(digits\|form\|fuzz\|trace\)\>" containedin=rexxOptionsDirective3
syn region rexxOptionsDirective3 start="\(^\|;\)\s*::\s*options\s"ms=e+1 end="\($\|;\)" contains=rexxString,rexxNumber,rexxVariable,rexxComment,rexxLineComment containedin=rexxDirective

syn region rexxVariable start="\zs\<\(\.\)\@!\K\k\+\>\ze\s*\(=\|,\|)\|%\|\]\|\\\||\|&\|+=\|-=\|<\|>\)" end="\(\_$\|.\)"me=e-1
syn match rexxVariable "\(=\|,\|)\|%\|\]\|\\\||\|&\|+=\|-=\|<\|>\)\s*\zs\K\k*\ze"

" rgf, 2007-07-22: unfortunately, the entire region is colored (not only the
" patterns), hence useless (vim 7.0)! (syntax-docs hint that that should work)
" attempt: just colorize the parenthesis in matching colors, keep content
" transparent to keep the formatting already done to it!
" TODO: test on 7.3
" syn region par1 matchgroup=par1 start="(" matchgroup=par1 end=")" transparent contains=par2
" syn region par2 matchgroup=par2 start="(" matchgroup=par2 end=")" transparent contains=par3 contained
" syn region par3 matchgroup=par3 start="(" matchgroup=par3 end=")" transparent contains=par4 contained
" syn region par4 matchgroup=par4 start="(" matchgroup=par4 end=")" transparent contains=par5 contained
" syn region par5 matchgroup=par5 start="(" matchgroup=par5 end=")" transparent contains=par1 contained
" this will colorize the entire region, removing any colorizing already done!
" syn region par1 matchgroup=par1 start="(" end=")" contains=par2
" syn region par2 matchgroup=par2 start="(" end=")" contains=par3 contained
" syn region par3 matchgroup=par3 start="(" end=")" contains=par4 contained
" syn region par4 matchgroup=par4 start="(" end=")" contains=par5 contained
" syn region par5 matchgroup=par5 start="(" end=")" contains=par1 contained

hi par1 ctermfg=red guifg=red "guibg=grey
hi par2 ctermfg=blue guifg=blue "guibg=grey
hi par3 ctermfg=darkgreen guifg=darkgreen "guibg=grey
hi par4 ctermfg=darkyellow guifg=darkyellow "guibg=grey
hi par5 ctermfg=darkgrey guifg=darkgrey "guibg=grey

" line continuation (trailing comma or single dash)
syn sync linecont "\(,\|-\ze-\@!\)\ze\s*\(--.*\|\/\*.*\)*$"

" always scan from start, PCs have long become to be powerful enough for that
exec "syn sync fromstart"

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
" make binary and hex strings stand out
hi rexxStringConstant term=bold,underline ctermfg=5 cterm=bold guifg=darkMagenta gui=bold

hi def link rexxLabel2 Function
hi def link doLoopSelectLabelRegion rexxKeyword
hi def link endIterateLeaveLabelRegion rexxKeyword
hi def link rexxLoopKeywords rexxKeyword
hi def link rexxNumber Normal
" hi def link rexxIdentifier DiffChange
hi def link rexxRegularCallSignal Statement
hi def link rexxExceptionHandling Statement
hi def link rexxLabel Function
hi def link rexxCharacter Character
hi def link rexxParenError rexxError
hi def link rexxInParen rexxError
hi def link rexxCommentError rexxError
hi def link rexxError Error
hi def link rexxKeyword Statement
hi def link rexxKeywordStatements Statement
hi def link rexxFunction Function
hi def link rexxBuiltinFunction Function
hi def link rexxString String
hi def link rexxComment Comment
hi def link rexxTodo Todo
hi def link rexxSpecialVariable Special
hi def link rexxConditional rexxKeyword
hi def link rexxOperator Operator
hi def link rexxMessageOperator rexxOperator
hi def link rexxLineComment Comment
hi def link rexxLineContinue WildMenu
hi def link rexxDirective rexxKeyword
hi def link rexxDirectiveName PreProc
hi def link rexxEndDirectiveName PreProc
hi def link rexxDirectiveKeyword Keyword
hi def link rexxClassDirective Type
hi def link rexxMethodDirective rexxFunction
hi def link rexxAttributeDirective rexxFunction
hi def link rexxRequiresDirective Include
hi def link rexxRoutineDirective rexxFunction
hi def link rexxOptionsDirective rexxFunction
hi def link rexxOptionsDirective2 rexxOptionsDirective
hi def link rexxOptionsDirective3 Normal
hi def link rexxConstantDirective rexxFunction
hi def link rexxAnnotateDirective PreProc
hi def link rexxResourceDirective PreProc
hi def link rexxIllegalEndDirective Error
hi def link rexxEndDirective PreProc
hi def link rexxConst Constant
hi def link rexxTypeSpecifier Type
hi def link rexxBuiltinClass rexxTypeSpecifier
hi def link rexxEnvironmentSymbol rexxConst
hi def link rexxNamespaceSymbol Type
hi def link rexxMessage rexxFunction
hi def link rexxParse rexxKeyword
hi def link rexxParse2 rexxParse
hi def link rexxGuard rexxKeyword
hi def link rexxTrace rexxKeyword
hi def link rexxAddressKeyword Keyword
hi def link rexxRaise rexxKeyword
hi def link rexxRaise2 rexxRaise
hi def link rexxForward rexxKeyword
hi def link rexxForward2 rexxForward

let b:current_syntax = "rexx"

"vim: ts=8
