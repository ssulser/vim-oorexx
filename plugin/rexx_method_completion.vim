" ooRexx message-method completion for Vim.
" Part of the vim-oorexx plugin. Runtime files are loaded by Vim automatically.
" It uses Vim's built-in 'completefunc' (CTRL-X CTRL-U) for classes, methods,
" routines, and directives; no external completion source is needed.
"
" Completion tables were extracted from the supplied ooRexx and extension
" manuals; see the repository README for source versions and coverage.
" User-defined classes and routines are not inferred.

if exists('g:loaded_rexx_method_completion')
  finish
endif
let g:loaded_rexx_method_completion = 1

" Make the plugin usable with a minimal vimrc: activate Vim's own filetype
" and syntax support.  No external completion plugin is needed.
filetype on
if has('syntax_items') && !exists('g:syntax_on')
  syntax enable
endif

" These lists were extracted from the supplied ooRexx, extension, and ooTest manuals.
" Class names in completion menus denote the documented class providing the method.
let s:method_classes = {
      \ 'Alarm': split('attachment cancel init scheduledTime triggered'),
      \ 'AlarmNotification': split('cancel'),
      \ 'Assert': split('assertEquals assertFalse assertNotEquals assertNotNull assertNotSame assertNull assertSame assertTrue'),
      \ 'Array': split('allIndexes allItems append at delete dimension dimensions empty fill first firstItem hasIndex hasItem index insert isEmpty items last lastItem makeArray makeString new next of previous put remove removeItem section size sort sortWith stableSort stableSortWith supplier toString'),
      \ 'Bag': split('allAt allIndex allIndexes allItems at difference empty hasIndex hasItem index intersection isEmpty items makeArray new of put putAll remove removeAll removeItem subset supplier union uniqueIndexes xor'),
      \ 'Buffer': split('new'),
      \ 'CaselessColumnComparator': split('compare init'),
      \ 'CaselessComparator': split('compare'),
      \ 'CaselessDescendingComparator': split('compare'),
      \ 'Chtype': split('Attr Char Colorpair New String'),
      \ 'CircularQueue': split('append init insert intersection makeArray makeString of push queue resize section size string supplier union xor'),
      \ 'Class': split('activate annotation annotations baseClass defaultName define defineMethods delete enhanced id inherit isAbstract isMetaclass isSubclassOf metaClass mixinClass new package queryMixinClass subclass subclasses superClass superClasses uninherit'),
      \ 'Collection': split('difference disjoint equivalent hasIndex hasItem intersection items makeArray subset supplier union xor'),
      \ 'ColumnComparator': split('compare init'),
      \ 'CommandContext': split('dropVar environment error getVar hasVar input isRedirected isValid output raise raiseError raiseFailure setVar variables'),
      \ 'CommandHandler': split('command deregister environments handler handlers register'),
      \ 'Comparable': split('compareTo'),
      \ 'Comparator': split('compare'),
      \ 'csvStream': split('Close CSVLineIn CSVLineOut GetHeaders INIT OPEN SetHeaders'),
      \ 'DateTime': split('addDays addHours addMicroseconds addMinutes addSeconds addWeeks addYears baseDate civilTime compareTo date day dayMicroseconds dayMinutes dayName daySeconds daysInMonth daysInYear elapsed europeanDate fromBaseDate fromCivilTime fromEuropeanDate fromIsoDate fromLongTime fromNormalDate fromNormalTime fromOrderedDate fromOrdinalDate fromStandardDate fromTicks fromUsaDate fromUtcIsoDate fromWeekNumberDate fullDate hashCode hours init isLeapYear isoDate languageDate longTime makeString maxDate microseconds minDate minutes month monthName normalDate normalTime offset orderedDate ordinalDate seconds standardDate string ticks timeOfDay today toLocalTime toTimezone toUtcTime usaDate utcDate utcIsoDate weekDay weekNumber weekNumberDate weekNumberYear weeksInYear year yearDay'),
      \ 'DescendingComparator': split('compare'),
      \ 'Directory': split('allIndexes allItems at empty entry hasEntry hasIndex hasItem index isEmpty items makeArray new put remove removeEntry removeItem setEntry setMethod supplier unknown unsetMethod'),
      \ 'EventSemaphore': split('isPosted new post reset uninit wait'),
      \ 'File': split('absoluteFile absolutePath canRead canWrite compareTo delete exists extension hashCode init isCaseSensitive isDirectory isFile isHidden lastAccessed lastModified length list listFiles listRoots makeDir makeDirs makeString name parent parentFile path pathSeparator readChars readLines renameTo searchPath separator setReadOnly setWritable string temporaryPath writeChars writeLines'),
      \ 'HostInfo': split('addr address alias makeStem name new'),
      \ 'IdentityTable': split('allIndexes allItems at empty hasIndex hasItem index isEmpty items makeArray new put remove removeItem supplier'),
      \ 'InetAddress': split('address family makeStem new port'),
      \ 'InputStream': split('arrayIn charOut close lineOut open position'),
      \ 'InvertingComparator': split('compare init'),
      \ 'Json': split('false fromJSON fromJsonFile init jsonToXml jsonToXmlFile parseXml parseXmlFile toJSON toJsonFile true'),
      \ 'JsonBoolean': split('false makeJSON true'),
      \ 'JsonError': split('column contextLine init lineNumber makeString message'),
      \ 'JsonString': split('makeJSON'),
      \ 'JsonXmlEmitter': split('emit init'),
      \ 'JsonXmlParser': split('parse'),
      \ 'List': split('allIndexes allItems append at delete empty first firstItem hasIndex hasItem index insert isEmpty items last lastItem makeArray new next of previous put remove removeItem section supplier'),
      \ 'LogicalWrapper': split('activate compareTo defaultName false hashCode init makeString of string true unknown value'),
      \ 'MapCollection': split('makeArray of putAll'),
      \ 'MenuObject': split('findItem findSubmenu idOf isChecked isMenu isSeparator isSubMenu items processItem submenu textOf'),
      \ 'Message': split('arguments completed errorCondition halt hasError hasResult messageComplete messageName new notify reply replyWith result send sendWith start startWith target triggered wait'),
      \ 'Method': split('annotation annotations isAbstract isAttribute isConstant isGuarded isPackage isPrivate isProtected loadExternalMethod new newFile package scope setGuarded setPrivate setProtected setSecurityManager setUnguarded source'),
      \ 'Mevent': split('Bstate Id X Y'),
      \ 'MimeMultiPart': split('addPart crlf id new string'),
      \ 'MimePart': split('addContent content crlf new string'),
      \ 'Monitor': split('current destination init unknown'),
      \ 'MutableBuffer': split('append caselessChangeStr caselessContains caselessContainsWord caselessCountStr caselessEndsWith caselessLastPos caselessMatch caselessMatchChar caselessPos caselessStartsWith caselessWordPos changeStr contains containsWord countStr delWord endsWith getBufferSize insert lastPos length lower makeArray makeString match matchChar new overlay pos replaceAt setBufferSize setText space startsWith string subChar substr subWord subWords translate upper verify word wordIndex wordLength wordPos words'),
      \ 'MutexSemaphore': split('acquire new release uninit'),
      \ 'NativeCommandHandler': split('command kind name'),
      \ 'NumericComparator': split('compare init'),
      \ 'Object': split('copy defaultName hashCode hasMethod identityHash init instanceMethod instanceMethods isA isInstanceOf isNil new objectName request send sendWith start startWith string'),
      \ 'OLEObject': split('addEventMethod connectEvents disconnectEvents dispatch getConstant getKnownEvents getKnownMethods getObject getOutParameters isConnectable isConnected new removeEventHandler removeEventMethod unknown'),
      \ 'ooSQLCollation': split('new'),
      \ 'ooSQLCollationNeeded': split('new'),
      \ 'ooSQLExtensions': split('autoBuiltin autoCollation autoCollationNeeded autoFunction autoPackage cancelAutoBuiltin getLibrary getPackage lastErrCode lastErrMsg listBuiltins loadLibrary loadPackage registerBuiltin resetAutoBuiltin'),
      \ 'ooSQLFunction': split('new'),
      \ 'ooSQLite': split('compileOptionGet compileOptionUsed complete enquote errStr libVersion libVersionNumber memoryHighWater memoryUsed null recordFormat releaseMemory softHeapLimit64 sourceID sqlite3Version status threadSafe version'),
      \ 'ooSQLiteBackup': split('finish finished getDestConn initCode lastErrCode lastErrMsg new pageCount remaining saveDestConn step'),
      \ 'ooSQLiteConnection': split('backupDestination busyHandler busyTimeOut changes close closed commitHook createCollation createFunction dbFileName dbMutex dbReadOnly dbReleaseMemory dbStatus errCode errMsg exec extendedErrCode extendedResultCodes fileName getAutocommit initCode interrupt lastErrCode lastErrMsg lastInsertRowID limit new nextStmt null pragma profile progressHandler recordFormat rollbackHook setAuthorizer tableColumnMetadata totalChanges trace updateHook'),
      \ 'ooSQLiteMutex': split('closed enter free isNull leave new try'),
      \ 'ooSQLiteStmt': split('bindBlob bindDouble bindInt bindInt64 bindNull bindParameterCount bindParameterIndex bindParameterName bindText bindValue bindZeroBlob clearBindings columnBlob columnBytes columnCount columnDataBaseName columnDeclType columnDouble columnIndex columnInt columnInt64 columnName columnOriginName columnTableName columnText columnType columnValue dataCount dbHandle finalize finalized initCode lastErrCode lastErrMsg new null recordFormat reset step stmtBusy stmtReadonly stmtStatus value'),
      \ 'ooSQLLibrary': split('lastErrCode lastErrMsg new'),
      \ 'ooSQLPackage': split('getCollation getCollationNeeded getFunction lastErrCode lastErrMsg new register'),
      \ 'ooSQLResult': split('blob'),
      \ 'ooSQLValue': split('blob'),
      \ 'Orderable': split('compareTo'),
      \ 'OrderedCollection': split('appendAll difference intersection sort sortWith stableSort stableSortWith subset union xor'),
      \ 'OutputStream': split('arrayOut charIn chars close lineIn lines open position'),
      \ 'Package': split('addClass addPackage addPublicClass addPublicRoutine addRoutine annotation annotations classes defaultOptions definedMethods digits findClass findNamespace findProgram findPublicClass findPublicRoutine findRoutine form fuzz importedClasses importedPackages importedRoutines loadLibrary loadPackage local name namespaces new options prolog publicClasses publicRoutines resource resources routines setSecurityManager source sourceLine sourceSize trace'),
      \ 'Pad': split('Echochar Mvwin Pechochar Pnoutrefresh Prefresh Redrawwin Refresh Scrl Scroll Scrollok Subpad Subwin Wnoutrefresh'),
      \ 'Pointer': split('isNull new'),
      \ 'Properties': split('getLogical getProperty getWhole load new put save setLogical setProperty setWhole'),
      \ 'Queue': split('allIndexes allItems append at delete empty first firstItem hasIndex hasItem index insert isEmpty items last lastItem makeArray new next of peek previous pull push put queue remove removeItem section size supplier'),
      \ 'RegularExpression': split('match new parse pos position'),
      \ 'Relation': split('allAt allIndex allIndexes allItems at difference empty hasIndex hasItem index intersection isEmpty items makeArray new put remove removeAll removeItem subset supplier union uniqueIndexes xor'),
      \ 'RexxContext': split('args condition digits executable form fuzz interpreter invocation line name package rs stackFrames thread variables'),
      \ 'RexxInfo': split('architecture caseSensitiveFiles date debug digits directorySeparator endofline executable form fuzz internalDigits internalMaxNumber internalMinNumber languageLevel libraryPath majorVersion maxArraySize maxExponent maxPathLength minExponent modification name package pathSeparator platform release revision version'),
      \ 'RexxQueue': split('create delete empty exists get init lineIn lineOut makeArray new open pull push queue queued say set'),
      \ 'Routine': split('annotation annotations call callWith loadExternalRoutine new newFile package setSecurityManager source'),
      \ 'Set': split('allIndexes allItems at empty hasIndex hasItem index intersection isEmpty items makeArray new of put putAll remove removeItem subset supplier union xor'),
      \ 'Singleton': split('new'),
      \ 'SMTP': split('cmdresponse connect localhost logoff new response send smtpErrno'),
      \ 'SMTPMsg': split('addRecipient new recipients'),
      \ 'Socket': split('accept bind close connect errno getHostByAddr getHostByName getHostId getHostName getOption getPeerName getSockName ioctl listen new recv recvFrom select Send setOption string'),
      \ 'StackFrame': split('arguments context executable invocation line makeString name string target traceLine type'),
      \ 'Stem': split('allIndexes allItems at empty hasIndex hasItem index isEmpty items makeArray new put remove removeItem request supplier toDirectory unknown'),
      \ 'Stream': split('arrayIn arrayOut charIn charOut chars close command description flush init lineIn lineOut lines makeArray new open position qualify query say seek state string supplier uninit'),
      \ 'StreamSocket': split('arrayIn arrayOut charIn charOut chars close description lineIn lineOut lines new open position say state string'),
      \ 'StreamSupplier': split('available index init item next'),
      \ 'String': split('abbrev abs alnum alpha append b2x bitAnd bitOr bitXor blank c2d c2x caselessAbbrev caselessChangeStr caselessCompare caselessCompareTo caselessContains caselessContainsWord caselessCountStr caselessEndsWith caselessEquals caselessLastPos caselessMatch caselessMatchChar caselessPos caselessStartsWith caselessWordPos ceiling changeStr cntrl compare compareTo contains containsWord copies countStr cr d2c d2x dataType decodeBase64 delStr delWord digit encodeBase64 endsWith equals floor format graph hashCode insert lastPos left length lower makeArray makeString match matchChar max min modulo new nl null overlay pos print punct replaceAt reverse right round sign space startsWith strip subChar substr subWord subWords tab translate trunc upper verify word wordIndex wordLength wordPos words x2b x2c x2d xdigit'),
      \ 'StringTable': split('allIndexes allItems at empty entry hasEntry hasIndex hasItem index isEmpty items makeArray new put remove removeEntry removeItem setEntry supplier unknown'),
      \ 'Supplier': split('allIndexes allItems available index item new next supplier'),
      \ 'Table': split('allIndexes allItems at empty hasIndex hasItem index isEmpty items makeArray new put remove removeItem supplier'),
      \ 'Ticker': split('attachment cancel init interval'),
      \ 'TimeSpan': split('addDays addHours addMicroseconds addMinutes addSeconds addWeeks compareTo days duration fromCivilTime fromDays fromHours fromLongTime fromMicroseconds fromMinutes fromNormalTime fromSeconds fromStringFormat hashCode hours init makeString microseconds minutes seconds sign string totalDays totalHours totalMicroseconds totalMinutes totalSeconds'),
      \ 'TestCase': split('new ooTestType'),
      \ 'ooTestCase': split('new ooTestType'),
      \ 'ooTestTypes': split('new ooTestType'),
      \ 'TraceObject': split('activate collector compareTo counter makeString makeStringImpl new notify option setMakeString unsetMakeString'),
      \ 'Validate': split('classType length logical nonNegativeNumber nonNegativeWholeNumber number numberRange position positiveNumber positiveWholeNumber requestClassType wholeNumber wholeNumberRange'),
      \ 'VariableReference': split('name request unknown value'),
      \ 'WeakReference': split('new value'),
      \ 'Window': split('Acs_map Addch Addchnstr Addchstr Addnstr Addstr Assume_default_colors Attroff Attron Attrset Baudrate Beep Bkgd Bkgdset Border Box Can_change_color Cbreak Chgat Clear Clearok Clrtobot Clrtoeol Color_pair Color_pairs Color_set Colors Cols Copywin Curs_set Curses_version Delch Deleteln Delwin Derwin Doupdate Dupwin Echo Echochar Endwin Erase Erasechar Filter Flash Flushinp Getbegyx Getbkgd Getch Getmaxyx Getmouse Getnstr Getparyx Getstr Getwin Getyx Halfdelay Has_colors Has_ic Has_il Hline Idcok Idlok Immedok Inch Inchnstr Inchstr Init_color Init_pair Innstr Insch Insdelln Insertln Insnstr Insstr Instr Intrflush Is_linetouched Is_wintouched Isbitset Isendwin Keyname Keypad Killchar Leaveok Lines Longname Meta Mouse_trafo Mousemask Move Mvaddch Mvaddchnstr Mvaddchstr Mvaddnstr Mvaddstr Mvchgat Mvderwin Mvgetch Mvgetnstr Mvgetstr Mvhline Mvinch Mvinchnstr Mvinchstr Mvinnstr Mvinsch Mvinsstr Mvinstr Mvvline Mvwin Napms Ncurses_mouse_version Ncurses_version Nl Nocbreak Nodelay Noecho Nonl Noqiflush Noraw Notimeout Overlay Overwrite Pair_content Pair_number Pechochar Pnoutrefresh Prefresh Putwin Qiflush Raw Redrawwin Refresh Scr_dump Scr_restore Scrl Scroll Scrollok Setscrreg Slk_attr Slk_attroff Slk_attron Slk_attrset Slk_clear Slk_color Slk_label Slk_noutrefresh Slk_refresh Slk_restore Slk_set Slk_touch Standend Standout Start_color Subpad Subwin Syncok Tabsize Termattrs Termname Timeout Touchline Touchwin Typeahead Unctrl Ungetch Untouchwin Use_default_colors Use_env Vline Wenclose Wnoutrefresh Wredrawln Wsyncdown Wsyncup Wtouchln'),
      \ 'WindowObject': split('assocWindow childAtPosition coordinates disable enable enumerateChildren findChild first firstChild focusItem focusNextItem focusPreviousItem getStyle handle hide id isMenu last maximize menu minimize moveTo next owner previous processMenuCommand pushButton resize restore sendChar sendCommand sendKey sendKeyDown sendKeyUp sendMenuCommand sendMessage sendMouseClick sendSyscommand sendText state systemMenu title title= toForeground wclass'),
      \ 'WindowsClipboard': split('copy empty isDataAvailable makeArray paste'),
      \ 'WindowsEventLog': split('clear close events getFirst getLast getLogNames getNumber isFull minimumRead minimumRead= minimumReadBuffer minimumReadMax minimumReadMin new open read readRecords write'),
      \ 'WindowsManager': split('broadcastSettingChanged consoleTitle consoleTitle= desktopWindow find foregroundWindow processMenuCommand pushButtonInWindow sendTextToWindow windowAtPosition'),
      \ 'WindowsProgramManager': split('addDesktopIcon addGroup addItem addShortCut deleteDesktopIcon deleteGroup deleteItem new showGroup'),
      \ 'WindowsRegistry': split('classes_root close connect create current_key current_key= current_user delete deleteKey deleteValue flush getValue list listValues load local_machine new open query replace restore save setValue unload users'),
      \ 'Yaml': split('anchorMap directivesMap false init mergeSourceMap parseAll parseAllFile parseArray parseFile parseFrontMatter parseFrontMatterFile parseString parseXml parseXmlFile readFileLines resolveTagHandle toYaml toYamlAll toYamlArray toYamlFile toYamlFMFile true yamlToXml yamlToXmlFile'),
      \ 'YamlBoolean': split('false makeYAML true'),
      \ 'YamlEmitter': split('emit init'),
      \ 'YamlError': split('column contextLine init lineNumber makeString message'),
      \ 'YamlTagged': split('init makeString tag value'),
      \ 'YamlXmlEmitter': split('emit init'),
      \ 'YamlXmlParser': split('directivesMap mergeSourceMap parse xmlAnchors')
      \ }
let s:routine_sources = {
      \ 'ABBREV': split('ooRexx'),
      \ 'ABS': split('ooRexx'),
      \ 'ADDRESS': split('ooRexx'),
      \ 'ARG': split('ooRexx'),
      \ 'B2X': split('ooRexx'),
      \ 'BEEP': split('ooRexx'),
      \ 'BITAND': split('ooRexx'),
      \ 'BITOR': split('ooRexx'),
      \ 'BITXOR': split('ooRexx'),
      \ 'C2D': split('ooRexx'),
      \ 'C2X': split('ooRexx'),
      \ 'CENTER': split('ooRexx'),
      \ 'CHANGESTR': split('ooRexx'),
      \ 'CHARIN': split('ooRexx'),
      \ 'CHAROUT': split('ooRexx'),
      \ 'CHARS': split('ooRexx'),
      \ 'COMPARE': split('ooRexx'),
      \ 'CONDITION': split('ooRexx'),
      \ 'COPIES': split('ooRexx'),
      \ 'COUNTSTR': split('ooRexx'),
      \ 'D2C': split('ooRexx'),
      \ 'D2X': split('ooRexx'),
      \ 'DATATYPE': split('ooRexx'),
      \ 'DATE': split('ooRexx'),
      \ 'DELSTR': split('ooRexx'),
      \ 'DELWORD': split('ooRexx'),
      \ 'DIGITS': split('ooRexx'),
      \ 'DIRECTORY': split('ooRexx'),
      \ 'ENDLOCAL': split('ooRexx'),
      \ 'ERRORTEXT': split('ooRexx'),
      \ 'FILESPEC': split('ooRexx'),
      \ 'FORM': split('ooRexx'),
      \ 'FORMAT': split('ooRexx'),
      \ 'FtpAnnotateLog': split('RxFtp'),
      \ 'FtpAppend': split('RxFtp'),
      \ 'FtpChDir': split('RxFtp'),
      \ 'FtpDelete': split('RxFtp'),
      \ 'FtpDir': split('RxFtp'),
      \ 'FtpGet': split('RxFtp'),
      \ 'FtpGetMode': split('RxFtp'),
      \ 'FtpGetType': split('RxFtp'),
      \ 'FtpLogoff': split('RxFtp'),
      \ 'FtpLs': split('RxFtp'),
      \ 'FtpMkDir': split('RxFtp'),
      \ 'FtpPut': split('RxFtp'),
      \ 'FtpPutUnique': split('RxFtp'),
      \ 'FtpPwd': split('RxFtp'),
      \ 'FtpQuote': split('RxFtp'),
      \ 'FtpRename': split('RxFtp'),
      \ 'FtpRmDir': split('RxFtp'),
      \ 'FtpSetMode': split('RxFtp'),
      \ 'FtpSetType': split('RxFtp'),
      \ 'FtpSetUser': split('RxFtp'),
      \ 'FtpSite': split('RxFtp'),
      \ 'FtpSys': split('RxFtp'),
      \ 'FtpTrace': split('RxFtp'),
      \ 'FtpTraceLog': split('RxFtp'),
      \ 'FtpTraceLogoff': split('RxFtp'),
      \ 'FtpVersion': split('RxFtp'),
      \ 'FUZZ': split('ooRexx'),
      \ 'GC': split('ooRexx'),
      \ 'INSERT': split('ooRexx'),
      \ 'LASTPOS': split('ooRexx'),
      \ 'LEFT': split('ooRexx'),
      \ 'LENGTH': split('ooRexx'),
      \ 'LINEIN': split('ooRexx'),
      \ 'LINEOUT': split('ooRexx'),
      \ 'LINES': split('ooRexx'),
      \ 'LOWER': split('ooRexx'),
      \ 'MathDropFuncs': split('RxMath'),
      \ 'MathLoadFuncs': split('RxMath'),
      \ 'MAX': split('ooRexx'),
      \ 'MIN': split('ooRexx'),
      \ 'OVERLAY': split('ooRexx'),
      \ 'POS': split('ooRexx'),
      \ 'QUALIFY': split('ooRexx'),
      \ 'QUEUED': split('ooRexx'),
      \ 'RANDOM': split('ooRexx'),
      \ 'REVERSE': split('ooRexx'),
      \ 'RIGHT': split('ooRexx'),
      \ 'RxCalcArcCos': split('RxMath'),
      \ 'RxCalcArcSin': split('RxMath'),
      \ 'RxCalcArcTan': split('RxMath'),
      \ 'RxCalcCos': split('RxMath'),
      \ 'RxCalcCosH': split('RxMath'),
      \ 'RxCalcCotan': split('RxMath'),
      \ 'RxCalcExp': split('RxMath'),
      \ 'RxCalcLog': split('RxMath'),
      \ 'RxCalcLog10': split('RxMath'),
      \ 'RxCalcPi': split('RxMath'),
      \ 'RxCalcPower': split('RxMath'),
      \ 'RxCalcSin': split('RxMath'),
      \ 'RxCalcSinH': split('RxMath'),
      \ 'RxCalcSqrt': split('RxMath'),
      \ 'RxCalcTan': split('RxMath'),
      \ 'RxCalcTanH': split('RxMath'),
      \ 'RXFUNCADD': split('ooRexx'),
      \ 'RXFUNCDROP': split('ooRexx'),
      \ 'RXFUNCQUERY': split('ooRexx'),
      \ 'RxMessageBox': split('ooRexx'),
      \ 'RXQUEUE': split('ooRexx'),
      \ 'RxWinExec': split('ooRexx'),
      \ 'SETLOCAL': split('ooRexx'),
      \ 'SIGN': split('ooRexx'),
      \ 'SockAccept': split('RxSock'),
      \ 'SockBind': split('RxSock'),
      \ 'SockClose': split('RxSock'),
      \ 'SockConnect': split('RxSock'),
      \ 'SockDropFuncs': split('RxSock'),
      \ 'SockGetHostByAddr': split('RxSock'),
      \ 'SockGetHostByName': split('RxSock'),
      \ 'SockGetHostId': split('RxSock'),
      \ 'SockGetPeerName': split('RxSock'),
      \ 'SockGetSockName': split('RxSock'),
      \ 'SockGetSockOpt': split('RxSock'),
      \ 'SockInit': split('RxSock'),
      \ 'SockIoctl': split('RxSock'),
      \ 'SockListen': split('RxSock'),
      \ 'SockLoadFuncs': split('RxSock'),
      \ 'SockPSock_Errno': split('RxSock'),
      \ 'SockRecv': split('RxSock'),
      \ 'SockRecvFrom': split('RxSock'),
      \ 'SockSelect': split('RxSock'),
      \ 'SockSend': split('RxSock'),
      \ 'SockSendTo': split('RxSock'),
      \ 'SockSetSockOpt': split('RxSock'),
      \ 'SockShutDown': split('RxSock'),
      \ 'SockSock_Errno': split('RxSock'),
      \ 'SockSocket': split('RxSock'),
      \ 'SockSoClose': split('RxSock'),
      \ 'SockVersion': split('RxSock'),
      \ 'SOURCELINE': split('ooRexx'),
      \ 'SPACE': split('ooRexx'),
      \ 'STREAM': split('ooRexx'),
      \ 'string2json': split('Rexx Extensions'),
      \ 'STRIP': split('ooRexx'),
      \ 'SUBSTR': split('ooRexx'),
      \ 'SUBWORD': split('ooRexx'),
      \ 'SYMBOL': split('ooRexx'),
      \ 'SysAccess': split('Unix Extensions'),
      \ 'SysAddRexxMacro': split('ooRexx'),
      \ 'SysBootDrive': split('ooRexx'),
      \ 'SysChmod': split('Unix Extensions'),
      \ 'SysChown': split('Unix Extensions'),
      \ 'SysChroot': split('Unix Extensions'),
      \ 'SysClearRexxMacroSpace': split('ooRexx'),
      \ 'SysClose': split('Unix Extensions'),
      \ 'SysCls': split('ooRexx'),
      \ 'SysCreatePipe': split('ooRexx'),
      \ 'SysCrypt': split('Unix Extensions'),
      \ 'SysCurPos': split('ooRexx'),
      \ 'SysCurState': split('ooRexx'),
      \ 'SysDriveInfo': split('ooRexx'),
      \ 'SysDriveMap': split('ooRexx'),
      \ 'SysDropRexxMacro': split('ooRexx'),
      \ 'SysDumpVariables': split('ooRexx'),
      \ 'SysEuidaccess': split('Unix Extensions'),
      \ 'SysFileCopy': split('ooRexx'),
      \ 'SysFileDelete': split('ooRexx'),
      \ 'SysFileExists': split('ooRexx'),
      \ 'SysFileMove': split('ooRexx'),
      \ 'SysFileSearch': split('ooRexx'),
      \ 'SysFileSystemType': split('ooRexx'),
      \ 'SysFileTree': split('ooRexx'),
      \ 'SysFork': split('ooRexx'),
      \ 'SysFormatMessage': split('ooRexx'),
      \ 'SysFromUnicode': split('ooRexx'),
      \ 'SysGetdirlist': split('Unix Extensions'),
      \ 'SysGetegid': split('Unix Extensions'),
      \ 'SysGeterrno': split('Unix Extensions'),
      \ 'SysGeterrnomsg': split('Unix Extensions'),
      \ 'SysGetErrorText': split('ooRexx'),
      \ 'SysGeteuid': split('Unix Extensions'),
      \ 'SysGetFileDateTime': split('ooRexx'),
      \ 'SysGetgid': split('Unix Extensions'),
      \ 'SysGetgrgid': split('Unix Extensions'),
      \ 'SysGetgrnam': split('Unix Extensions'),
      \ 'SysGethostname': split('Unix Extensions'),
      \ 'SysGetKey': split('ooRexx'),
      \ 'SysGetLongPathName': split('ooRexx'),
      \ 'SysGetMessage': split('ooRexx'),
      \ 'SysGetMessageX': split('ooRexx'),
      \ 'SysGetpgrp': split('Unix Extensions'),
      \ 'SysGetpid': split('Unix Extensions'),
      \ 'SysGetppid': split('Unix Extensions'),
      \ 'SysGetpwnam': split('Unix Extensions'),
      \ 'SysGetpwuid': split('Unix Extensions'),
      \ 'SysGetservbyname': split('Unix Extensions'),
      \ 'SysGetservbyport': split('Unix Extensions'),
      \ 'SysGetShortPathName': split('ooRexx'),
      \ 'SysGetSID': split('Unix Extensions'),
      \ 'SysGetsizeofptr': split('Unix Extensions'),
      \ 'SysGettid': split('Unix Extensions'),
      \ 'SysGettzname1': split('Unix Extensions'),
      \ 'SysGettzname2': split('Unix Extensions'),
      \ 'SysGetuid': split('Unix Extensions'),
      \ 'SysGetxattr': split('Unix Extensions'),
      \ 'SysIni': split('ooRexx'),
      \ 'SysIsFile': split('ooRexx'),
      \ 'SysIsFileCompressed': split('ooRexx'),
      \ 'SysIsFileDirectory': split('ooRexx'),
      \ 'SysIsFileEncrypted': split('ooRexx'),
      \ 'SysIsFileLink': split('ooRexx'),
      \ 'SysIsFileNotContentIndexed': split('ooRexx'),
      \ 'SysIsFileOffline': split('ooRexx'),
      \ 'SysIsFileSparse': split('ooRexx'),
      \ 'SysIsFileTemporary': split('ooRexx'),
      \ 'SysKill': split('Unix Extensions'),
      \ 'SysLchown': split('Unix Extensions'),
      \ 'SysLink': split('Unix Extensions'),
      \ 'SysLinVer': split('ooRexx'),
      \ 'SysListxattr': split('Unix Extensions'),
      \ 'SysLoadRexxMacroSpace': split('ooRexx'),
      \ 'SysMkDir': split('ooRexx'),
      \ 'SysMkdirUnix': split('Unix Extensions'),
      \ 'SysQueryProcess': split('ooRexx'),
      \ 'SysQueryRexxMacro': split('ooRexx'),
      \ 'SysRemovexattr': split('Unix Extensions'),
      \ 'SysReorderRexxMacro': split('ooRexx'),
      \ 'SysRmDir': split('ooRexx'),
      \ 'SysRmdirUnix': split('Unix Extensions'),
      \ 'SysSaveRexxMacroSpace': split('ooRexx'),
      \ 'SysSearchPath': split('ooRexx'),
      \ 'SysSetegid': split('Unix Extensions'),
      \ 'SysSeteuid': split('Unix Extensions'),
      \ 'SysSetFileDateTime': split('ooRexx'),
      \ 'SysSetgid': split('Unix Extensions'),
      \ 'SysSetpgid': split('Unix Extensions'),
      \ 'SysSetpgrp': split('Unix Extensions'),
      \ 'SysSetPriority': split('ooRexx'),
      \ 'SysSetsid': split('Unix Extensions'),
      \ 'SysSetuid': split('Unix Extensions'),
      \ 'SysSetxattr': split('Unix Extensions'),
      \ 'SysShutdownSystem': split('ooRexx'),
      \ 'SysSignal': split('Unix Extensions'),
      \ 'SysSleep': split('ooRexx'),
      \ 'SysStat': split('Unix Extensions'),
      \ 'SysStemCopy': split('ooRexx'),
      \ 'SysStemDelete': split('ooRexx'),
      \ 'SysStemInsert': split('ooRexx'),
      \ 'SysStemSort': split('ooRexx'),
      \ 'SysSwitchSession': split('ooRexx'),
      \ 'SysSymlink': split('Unix Extensions'),
      \ 'SysSystemDirectory': split('ooRexx'),
      \ 'SysTempFileName': split('ooRexx'),
      \ 'SysTextScreenRead': split('ooRexx'),
      \ 'SysTextScreenSize': split('ooRexx'),
      \ 'SysToUnicode': split('ooRexx'),
      \ 'SysUmask': split('Unix Extensions'),
      \ 'SysUname': split('Unix Extensions'),
      \ 'SysUnLink': split('Unix Extensions'),
      \ 'SysUtilVersion': split('ooRexx'),
      \ 'SysVersion': split('ooRexx'),
      \ 'SysVolumeLabel': split('ooRexx'),
      \ 'SysWait': split('ooRexx'),
      \ 'SysWaitNamedPipe': split('ooRexx'),
      \ 'SysWinDecryptFile': split('ooRexx'),
      \ 'SysWinEncryptFile': split('ooRexx'),
      \ 'SysWinGetDefaultPrinter': split('ooRexx'),
      \ 'SysWinGetPrinters': split('ooRexx'),
      \ 'SysWinSetDefaultPrinter': split('ooRexx'),
      \ 'SysWinVer': split('ooRexx'),
      \ 'SysWordexp': split('Unix Extensions'),
      \ 'TIME': split('ooRexx'),
      \ 'TRACE': split('ooRexx'),
      \ 'TRANSLATE': split('ooRexx'),
      \ 'TRUNC': split('ooRexx'),
      \ 'UPPER': split('ooRexx'),
      \ 'USERID': split('ooRexx'),
      \ 'VALUE': split('ooRexx'),
      \ 'VAR': split('ooRexx'),
      \ 'VERIFY': split('ooRexx'),
      \ 'WORD': split('ooRexx'),
      \ 'WORDINDEX': split('ooRexx'),
      \ 'WORDLENGTH': split('ooRexx'),
      \ 'WORDPOS': split('ooRexx'),
      \ 'WORDS': split('ooRexx'),
      \ 'X2B': split('ooRexx'),
      \ 'X2C': split('ooRexx'),
      \ 'X2D': split('ooRexx'),
      \ 'XRANGE': split('ooRexx')
      \ }
function! s:BuildIndex(class_methods) abort
  let l:index = {}
  for [l:source, l:names] in items(a:class_methods)
    for l:name in l:names
      let l:key = tolower(l:name)
      if !has_key(l:index, l:key)
        let l:index[l:key] = {'word': l:name, 'sources': []}
      endif
      if index(l:index[l:key].sources, l:source) < 0
        call add(l:index[l:key].sources, l:source)
      endif
    endfor
  endfor
  for l:item in values(l:index)
    call sort(l:item.sources)
  endfor
  return l:index
endfunction

function! s:BuildRoutineIndex() abort
  let l:index = {}
  for [l:name, l:sources] in items(s:routine_sources)
    let l:index[tolower(l:name)] = {"word": l:name, "sources": l:sources}
  endfor
  return l:index
endfunction

let s:class_names = split('Alarm AlarmNotification ArgUtil Array Bag Buffer CaselessColumnComparator CaselessComparator CaselessDescendingComparator CircularQueue Class Collection ColumnComparator Comparable Comparator DateTime DescendingComparator Directory EventSemaphore File IdentityTable InputOutputStream InputStream InvertingComparator Json List MapCollection Message MessageNotification Method Monitor MutableBuffer MutexSemaphore Object Orderable OrderedCollection OutputStream Package Pointer Properties Queue RegularExpression Relation RexxContext RexxInfo RexxQueue Routine Set SetCollection Singleton StackFrame Stem Stream StreamSupplier String StringTable Supplier Table Ticker TimeSpan TraceObject Validate VariableReference WeakReference AdvancedControls AnimatedButton BaseDialog ButtonControl CategoryDialog CheckBox CheckList ComboBox DialogControl DialogExtensions DlgArea DlgAreaU DynamicDialog EditControl InputBox IntegerBox ListBox ListChoice ListControl MenuObject MessageExtensions MultiInputBox MultiListChoice OLEObject OLEVariant PasswordBox PlainBaseDialog PlainUserDialog ProgressBar ProgressIndicator PropertySheet RadioButton RcDialog ResDialog ScrollBar SingleSelection SliderControl StateIndicator StaticControl TabControl TimedMessage TreeControl UserDialog VirtualKeyCodes WindowBase WindowExtensions WindowObject WindowsClassesBase WindowsClipboard WindowsEventLog WindowsManager WindowsProgramManager WindowsRegistry BSF bsf.dialog bsf_proxy UNO UNO_ENUM UNO_CONSTANTS UNO_PROPERTIES Chtype CommandContext CommandHandler csvStream HostInfo InetAddress JsonBoolean JsonError JsonString JsonXmlEmitter JsonXmlParser LogicalWrapper Mevent MimeMultiPart MimePart NativeCommandHandler NumericComparator ooSQLCollation ooSQLCollationNeeded ooSQLExtensions ooSQLFunction ooSQLite ooSQLiteBackup ooSQLiteConnection ooSQLiteMutex ooSQLiteStmt ooSQLLibrary ooSQLPackage ooSQLResult ooSQLValue Pad SMTP SMTPMsg Socket StreamSocket Window Yaml YamlBoolean YamlEmitter YamlError YamlTagged YamlXmlEmitter YamlXmlParser Assert TestCase ooTestCase ooTestTypes')
let s:directive_names = split('annotate annotation attribute class constant method options requires resource routine')
let s:method_index = s:BuildIndex(s:method_classes)
let s:routine_index = s:BuildRoutineIndex()

function! RexxMethodComplete(findstart, base) abort
  if a:findstart
    let l:prefix = strpart(getline('.'), 0, col('.') - 1)

    " Complete directive names after :: using this plugin's own source.
    let l:directive = match(l:prefix, '\%(^\|;\)\s*::\s*[A-Za-z0-9_]*$')
    if l:directive >= 0 && !s:InStringOrComment()
      let b:rexx_completion_kind = 'directive'
      setlocal completeopt+=noselect
      return matchend(l:prefix, '\%(^\|;\)\s*::\s*')
    endif

    " Complete only the identifier after a single or double message operator.
    let l:operator_start = match(l:prefix, '\~\~\?\s*[A-Za-z0-9._?!]*$')
    if l:operator_start >= 0
      let b:rexx_completion_kind = 'method'
      setlocal completeopt+=noselect
      let l:operator_end = matchend(strpart(l:prefix, l:operator_start), '\~\~\?\s*')
      return l:operator_start + l:operator_end
    endif

    " Complete documented class names after the leading class-reference dot.
    let l:class_dot = match(l:prefix, '\%(^\|\s\|[(:,=;]\)\zs\.\ze[A-Za-z0-9._?!]*$')
    if l:class_dot >= 0 && !s:InStringOrComment()
      let b:rexx_completion_kind = 'class'
      setlocal completeopt+=noselect
      return l:class_dot + 1
    endif

    " CTRL-X CTRL-U also completes documented routines in ordinary code.
    let l:token = matchstr(l:prefix, '[A-Za-z0-9_?!]*$')
    let l:start = strlen(l:prefix) - strlen(l:token)
    let l:before = strpart(l:prefix, 0, l:start)
    if !empty(l:token) || l:before =~? '\<call\s*$'
      let b:rexx_completion_kind = 'routine'
      return l:start
    endif
    return -1
  endif

  let l:matches = []
  let l:needle = tolower(a:base)
  let l:completion_kind = get(b:, 'rexx_completion_kind', 'method')
  if l:completion_kind ==# 'directive'
    for l:name in s:directive_names
      if stridx(tolower(l:name), l:needle) == 0
        call add(l:matches, {'word': l:name, 'menu': 'directive', 'kind': 'd'})
      endif
    endfor

    " ::END is special in ooRexx: exact uppercase and column one only.
    if getline('.') =~# '^::' && a:base ==# toupper(a:base)
          \ && stridx('END', toupper(a:base)) == 0
      call add(l:matches, {'word': 'END', 'menu': 'directive', 'kind': 'd'})
    endif
    return l:matches
  endif

  let l:method_completion = l:completion_kind ==# 'method'
  let l:index = l:method_completion ? s:method_index : s:routine_index
  if l:completion_kind ==# 'class'
    for l:name in s:class_names
      if stridx(tolower(l:name), l:needle) == 0
        call add(l:matches, {'word': l:name, 'menu': 'class', 'kind': 'c'})
      endif
    endfor
    return l:matches
  endif
  for l:key in sort(keys(l:index))
    if stridx(l:key, l:needle) == 0
      let l:item = l:index[l:key]
      call add(l:matches, {
            \ 'word': l:item.word,
            \ 'menu': join(l:item.sources, ', '),
            \ 'kind': l:method_completion ? 'm' : 'r'})
    endif
  endfor
  return l:matches
endfunction

function! s:InStringOrComment() abort
  let l:text = strpart(getline('.'), 0, col('.') - 1)
  let l:quote = ''
  let l:i = 0
  while l:i < strlen(l:text)
    let l:char = strpart(l:text, l:i, 1)
    let l:next = strpart(l:text, l:i + 1, 1)
    if !empty(l:quote)
      if l:char ==# l:quote
        if l:next ==# l:quote
          let l:i += 1
        else
          let l:quote = ''
        endif
      endif
    elseif l:char ==# '"' || l:char ==# "'"
      let l:quote = l:char
    elseif l:char ==# '-' && l:next ==# '-'
      return 1
    elseif l:char ==# '/' && l:next ==# '*'
      let l:end = match(l:text, '\*/', l:i + 2)
      if l:end < 0
        return 1
      endif
      let l:i = l:end + 1
    endif
    let l:i += 1
  endwhile

  if !empty(l:quote)
    return 1
  endif

  " This also catches a /* comment opened on an earlier line.
  if has('syntax_items') && col('.') > 1
    let l:group = synIDattr(synID(line('.'), col('.') - 1, 1), 'name')
    if l:group =~? 'rexxComment'
      return 1
    endif
  endif
  return 0
endfunction

function! RexxMethodCompletionTilde() abort
  if s:InStringOrComment()
    return '~'
  endif
  return "~\<C-X>\<C-U>"
endfunction

function! RexxClassCompletionDot() abort
  if s:InStringOrComment()
    return '.'
  endif
  let l:prefix = strpart(getline('.'), 0, col('.') - 1)
  if l:prefix =~# '\%(^\|\s\|[(:,=;]\)$'
    return ".\<C-X>\<C-U>"
  endif
  return '.'
endfunction

function! RexxDirectiveCompletionColon() abort
  if s:InStringOrComment()
    return ':'
  endif
  let l:prefix = strpart(getline('.'), 0, col('.') - 1)
  " Starting the second colon of a directive opens the directive list.
  if l:prefix =~# '\%(^\|;\)\s*:$'
    return ":\<C-X>\<C-U>"
  endif
  return ':'
endfunction

function! s:SetupBuffer() abort
  if &filetype !=# 'rexx'
    return
  endif
  setlocal nosmartindent nocindent
  setlocal completeopt=menuone,noinsert,noselect
  setlocal completefunc=RexxMethodComplete
  inoremap <buffer> <expr> ~ RexxMethodCompletionTilde()
  inoremap <buffer> <expr> . RexxClassCompletionDot()
  inoremap <buffer> <expr> : RexxDirectiveCompletionColon()
endfunction

augroup rexx_method_completion
  autocmd!
  autocmd FileType rexx call <SID>SetupBuffer()
augroup END

" Also configure the current buffer if this plugin was sourced after FileType.
call s:SetupBuffer()
