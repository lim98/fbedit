.code

GetWinPos proc
	LOCAL	buffer[MAX_PATH]:BYTE

	;Main window
	invoke GetPrivateProfileString,addr szIniWin,addr szIniPos,NULL,addr buffer,sizeof buffer,addr da.szRadASMIni
	invoke GetItemInt,addr buffer,10
	mov		da.win.x,eax
	invoke GetItemInt,addr buffer,10
	mov		da.win.y,eax
	invoke GetItemInt,addr buffer,780
	mov		da.win.wt,eax
	invoke GetItemInt,addr buffer,580
	mov		da.win.ht,eax
	invoke GetItemInt,addr buffer,0
	mov		da.win.fmax,eax
	invoke GetItemInt,addr buffer,0
	mov		da.win.ftopmost,eax
	invoke GetItemInt,addr buffer,0
	mov		da.win.fcldmax,eax
	invoke GetItemInt,addr buffer,VIEW_STATUSBAR
	mov		da.win.fView,eax
	invoke GetItemInt,addr buffer,200
	.if eax<100
		mov		eax,100
	.endif
	mov		da.win.ccwt,eax
	invoke GetItemInt,addr buffer,150
	.if eax<100
		mov		eax,100
	.endif
	mov		da.win.ccht,eax
	;Resource editor
	invoke GetPrivateProfileString,addr szIniWin,addr szIniPosRes,NULL,addr buffer,sizeof buffer,addr da.szRadASMIni
	invoke GetItemInt,addr buffer,200
	mov		da.winres.htpro,eax
	invoke GetItemInt,addr buffer,200
	mov		da.winres.wtpro,eax
	invoke GetItemInt,addr buffer,55
	mov		da.winres.wttbx,eax
	invoke GetItemInt,addr buffer,50
	mov		da.winres.ptstyle.x,eax
	invoke GetItemInt,addr buffer,50
	mov		da.winres.ptstyle.y,eax
	invoke GetPrivateProfileString,addr szIniResource,addr szIniOption,NULL,addr buffer,sizeof buffer,addr da.szRadASMIni
	invoke GetItemInt,addr buffer,3
	mov		da.resopt.gridx,eax
	invoke GetItemInt,addr buffer,3
	mov		da.resopt.gridy,eax
	invoke GetItemInt,addr buffer,RESOPT_GRID or RESOPT_SNAP
	mov		da.resopt.fopt,eax
	ret

GetWinPos endp

PutWinPos proc
	LOCAL	buffer[256]:BYTE
	LOCAL	rect:RECT

	;Main window
	mov		buffer,0
	invoke IsZoomed,ha.hWnd
	mov 	da.win.fmax,eax
	.if !eax
		invoke IsIconic,ha.hWnd
		.if !eax
			invoke GetWindowRect,ha.hWnd,addr rect
			mov		eax,rect.left
			mov		da.win.x,eax
			mov		eax,rect.top
			mov		da.win.y,eax
			mov		eax,rect.right
			sub		eax,rect.left
			mov		da.win.wt,eax
			mov		eax,rect.bottom
			sub		eax,rect.top
			mov		da.win.ht,eax
		.endif
	.endif
	invoke PutItemInt,addr buffer,da.win.x
	invoke PutItemInt,addr buffer,da.win.y
	invoke PutItemInt,addr buffer,da.win.wt
	invoke PutItemInt,addr buffer,da.win.ht
	invoke PutItemInt,addr buffer,da.win.fmax
	invoke PutItemInt,addr buffer,da.win.ftopmost
	invoke PutItemInt,addr buffer,da.win.fcldmax
	invoke PutItemInt,addr buffer,da.win.fView
	invoke GetWindowRect,ha.hCC,addr rect
	mov		eax,rect.right
	sub		eax,rect.left
	mov		edx,rect.bottom
	sub		edx,rect.top
	.if eax>10 && edx>10
		mov		da.win.ccwt,eax
		mov		da.win.ccht,edx
		invoke PutItemInt,addr buffer,da.win.ccwt
		invoke PutItemInt,addr buffer,da.win.ccht
		invoke WritePrivateProfileString,addr szIniWin,addr szIniPos,addr buffer[1],addr da.szRadASMIni
	.endif
	;Resource editor
	mov		buffer,0
	invoke PutItemInt,addr buffer,da.winres.htpro
	invoke PutItemInt,addr buffer,da.winres.wtpro
	invoke PutItemInt,addr buffer,da.winres.wttbx
	invoke PutItemInt,addr buffer,da.winres.ptstyle.x
	invoke PutItemInt,addr buffer,da.winres.ptstyle.y
	invoke WritePrivateProfileString,addr szIniWin,addr szIniPosRes,addr buffer[1],addr da.szRadASMIni
	mov		buffer,0
	invoke PutItemInt,addr buffer,da.resopt.gridx
	invoke PutItemInt,addr buffer,da.resopt.gridy
	invoke PutItemInt,addr buffer,da.resopt.fopt
	invoke WritePrivateProfileString,addr szIniResource,addr szIniOption,addr buffer[1],addr da.szRadASMIni
	ret

PutWinPos endp

GetProjectAssembler proc

	;Assembler
	invoke GetPrivateProfileString,addr szIniSession,addr szIniAssembler,NULL,addr da.szAssembler,sizeof da.szAssembler,addr da.szProject
	.if !eax
		mov		dword ptr da.szAssembler,'msam'
	.endif
	ret

GetProjectAssembler endp

GetSessionAssembler proc

	;Assembler
	invoke GetPrivateProfileString,addr szIniSession,addr szIniAssembler,NULL,addr da.szAssembler,sizeof da.szAssembler,addr da.szRadASMIni
	.if !eax
		mov		dword ptr da.szAssembler,'msam'
	.endif
	ret

GetSessionAssembler endp

GetProjectFiles proc uses ebx esi edi
	LOCAL	fi:FILEINFO
	LOCAL	pbi:PBITEM
	LOCAL	buffer[MAX_PATH]:BYTE
	LOCAL	nopen:DWORD
	LOCAL	chrg:CHARRANGE
	LOCAL	hEdt:HWND

	;File browser path
	invoke GetPrivateProfileString,addr szIniProject,addr szIniPath,addr da.szAppPath,addr da.szFBPath,sizeof da.szFBPath,addr da.szProject
	;Check if path exist
	invoke GetFileAttributes,addr da.szFBPath
	.if eax==INVALID_HANDLE_VALUE
		invoke strcpy,addr da.szFBPath,addr da.szProjectPath
	.endif
	invoke SendMessage,ha.hFileBrowser,FBM_SETPATH,TRUE,addr da.szFBPath
	;Get groups
	invoke GetPrivateProfileString,addr szIniProject,addr szIniGroup,addr szNULL,addr tmpbuff,sizeof tmpbuff,addr da.szProject
	.if eax
		invoke SendMessage,ha.hProjectBrowser,RPBM_SETGROUPING,FALSE,RPBG_GROUPS
		invoke RtlZeroMemory,addr pbi,sizeof PBITEM
		invoke GetItemInt,addr tmpbuff,0
		.if sdword ptr eax>0
			invoke SendMessage,ha.hProjectBrowser,RPBM_SETGROUPING,FALSE,eax
		.endif
		xor		ebx,ebx
		.while tmpbuff
			invoke GetItemInt,addr tmpbuff,0
			mov		pbi.id,eax
			invoke GetItemInt,addr tmpbuff,0
			mov		pbi.idparent,eax
			invoke GetItemInt,addr tmpbuff,0
			mov		pbi.expanded,eax
			invoke GetItemStr,addr tmpbuff,addr szNULL,addr pbi.szitem
			invoke SendMessage,ha.hProjectBrowser,RPBM_ADDITEM,ebx,addr pbi
			inc		ebx
		.endw
		;Get files
		mov		esi,1
		push	da.win.fcldmax
		mov		da.win.fcldmax,FALSE
		mov		nopen,0
		.while esi<100
			invoke GetFileInfo,esi,addr szIniProject,addr da.szProject,addr fi
			.if eax
				invoke RtlZeroMemory,addr pbi,sizeof PBITEM
				mov		pbi.id,esi
				mov		eax,fi.idparent
				mov		pbi.idparent,eax
				invoke strcpy,addr pbi.szitem,addr fi.filename
				invoke GetFileAttributes,addr pbi.szitem
				.if eax!=INVALID_HANDLE_VALUE
					invoke SendMessage,ha.hProjectBrowser,RPBM_ADDITEM,ebx,addr pbi
					.if fi.fopen
						invoke OpenTheFile,addr pbi.szitem,fi.ID
						mov		edi,eax
						invoke GetWindowLong,edi,GWL_USERDATA
						mov		hEdt,eax
						invoke MoveWindow,edi,fi.rect.left,fi.rect.top,fi.rect.right,fi.rect.bottom,TRUE
						invoke UpdateWindow,edi
						.if fi.ID==ID_EDITCODE || fi.ID==ID_EDITTEXT
							invoke SendMessage,hEdt,EM_LINEINDEX,fi.nline,0
							mov		chrg.cpMin,eax
							mov		chrg.cpMax,eax
							invoke SendMessage,hEdt,EM_EXSETSEL,0,addr chrg
							invoke SendMessage,hEdt,REM_VCENTER,0,0
							invoke SendMessage,hEdt,EM_SCROLLCARET,0,0
						.endif
						inc		nopen
					.endif
					inc		ebx
				.endif
			.endif
			inc		esi
		.endw
		pop		da.win.fcldmax
		.if nopen
			mov		dword ptr buffer,'0F'
			invoke GetPrivateProfileInt,addr szIniProject,addr buffer,0,addr da.szProject
			invoke SendMessage,ha.hTab,TCM_SETCURSEL,eax,0
			.if eax==-1
				invoke SendMessage,ha.hTab,TCM_SETCURSEL,0,0
			.endif
			.if eax!=-1
				mov		eax,TRUE
			.else
				xor		eax,eax
			.endif
		.else
			xor		eax,eax
		.endif
		push	eax
		invoke SendMessage,ha.hProjectBrowser,RPBM_SETGROUPING,TRUE,RPBG_GROUPS
		invoke SendMessage,ha.hTabProject,TCM_SETCURSEL,1,0
		invoke ShowWindow,ha.hProjectBrowser,SW_SHOWNA
		invoke ShowWindow,ha.hFileBrowser,SW_HIDE
		pop		eax
	.endif
	ret

GetProjectFiles endp

GetSessionFiles proc uses ebx edi
	LOCAL	fi:FILEINFO
	LOCAL	buffer[MAX_PATH]:BYTE
	LOCAL	chrg:CHARRANGE
	LOCAL	hEdt:HWND

	;File browser path
	invoke GetPrivateProfileString,addr szIniSession,addr szIniPath,addr da.szAppPath,addr da.szFBPath,sizeof da.szFBPath,addr da.szRadASMIni
	invoke GetFileAttributes,addr da.szFBPath
	;Check if path exist
	.if eax==INVALID_HANDLE_VALUE
		invoke strcpy,addr da.szFBPath,addr da.szAppPath
	.endif
	invoke SendMessage,ha.hFileBrowser,FBM_SETPATH,TRUE,addr da.szFBPath
	mov		ebx,1
	push	da.win.fcldmax
	mov		da.win.fcldmax,FALSE
	.while ebx<100
		invoke GetFileInfo,ebx,addr szIniSession,addr da.szRadASMIni,addr fi
		.break .if !eax
		invoke GetFileAttributes,addr fi.filename
		.if eax!=INVALID_HANDLE_VALUE
			invoke OpenTheFile,addr fi.filename,fi.ID
			mov		edi,eax
			invoke GetWindowLong,edi,GWL_USERDATA
			mov		hEdt,eax
			invoke MoveWindow,edi,fi.rect.left,fi.rect.top,fi.rect.right,fi.rect.bottom,TRUE
			invoke UpdateWindow,edi
			.if fi.ID==ID_EDITCODE || fi.ID==ID_EDITTEXT
				invoke SendMessage,hEdt,EM_LINEINDEX,fi.nline,0
				mov		chrg.cpMin,eax
				mov		chrg.cpMax,eax
				invoke SendMessage,hEdt,EM_EXSETSEL,0,addr chrg
				invoke SendMessage,hEdt,REM_VCENTER,0,0
				invoke SendMessage,hEdt,EM_SCROLLCARET,0,0
			.endif
		.endif
		inc		ebx
	.endw
	pop		da.win.fcldmax
	.if ebx>1
		mov		dword ptr buffer,'0F'
		invoke GetPrivateProfileInt,addr szIniSession,addr buffer,0,addr da.szRadASMIni
		invoke SendMessage,ha.hTab,TCM_SETCURSEL,eax,0
		.if eax==-1
			invoke SendMessage,ha.hTab,TCM_SETCURSEL,0,0
		.endif
		.if eax!=-1
			mov		eax,TRUE
		.else
			xor		eax,eax
		.endif
	.else
		xor		eax,eax
	.endif
	ret

GetSessionFiles endp

PutProject proc uses ebx esi
	LOCAL	fi:FILEINFO
	LOCAL	buffer[8]:BYTE

	mov		dword ptr buffer,0
	invoke WritePrivateProfileSection,addr szIniSession,addr buffer,addr da.szRadASMIni
	;Project
	invoke WritePrivateProfileString,addr szIniSession,addr szIniProject,addr da.szProject,addr da.szRadASMIni
	;File browser path
	invoke WritePrivateProfileString,addr szIniProject,addr szIniPath,addr da.szFBPath,addr da.szProject
	;Project groups
	mov		tmpbuff,0
	;Update expanded flags
	invoke SendMessage,ha.hProjectBrowser,RPBM_GETEXPAND,0,0
	;Get selected grouping
	invoke SendMessage,ha.hProjectBrowser,RPBM_GETGROUPING,0,0
	invoke PutItemInt,addr tmpbuff,eax
	;Get groups
	xor		ebx,ebx
	.while TRUE
		invoke SendMessage,ha.hProjectBrowser,RPBM_GETITEM,ebx,0
		.if eax
			mov		esi,eax
			.break .if ![esi].PBITEM.id
			.if sdword ptr [esi].PBITEM.id<0
				invoke PutItemInt,addr tmpbuff,[esi].PBITEM.id
				invoke PutItemInt,addr tmpbuff,[esi].PBITEM.idparent
				invoke PutItemInt,addr tmpbuff,[esi].PBITEM.expanded
				invoke PutItemStr,addr tmpbuff,addr [esi].PBITEM.szitem
			.endif
		.else
			.break
		.endif
		inc		ebx
	.endw
	invoke WritePrivateProfileString,addr szIniProject,addr szIniGroup,addr tmpbuff[1],addr da.szProject
	;Get files
	xor		ebx,ebx
	.while ebx<100
		invoke SetFileInfo,ebx,addr fi
		.if eax
			mov		tmpbuff,0
			invoke PutItemInt,addr tmpbuff,fi.fopen
			invoke PutItemInt,addr tmpbuff,fi.idparent
			invoke PutItemInt,addr tmpbuff,fi.ID
			invoke PutItemInt,addr tmpbuff,fi.rect.left
			invoke PutItemInt,addr tmpbuff,fi.rect.top
			invoke PutItemInt,addr tmpbuff,fi.rect.right
			invoke PutItemInt,addr tmpbuff,fi.rect.bottom
			invoke PutItemInt,addr tmpbuff,fi.nline
			invoke PutItemStr,addr tmpbuff,addr fi.filename
			mov		buffer,'F'
			invoke BinToDec,fi.pid,addr buffer[1]
			invoke WritePrivateProfileString,addr szIniProject,addr buffer,addr tmpbuff[1],addr da.szProject
		.endif
		inc		ebx
	.endw
	ret

PutProject endp

PutSession proc uses ebx
	LOCAL	fi:FILEINFO
	LOCAL	buffer[8]:BYTE

	mov		dword ptr buffer,0
	invoke WritePrivateProfileSection,addr szIniSession,addr buffer,addr da.szRadASMIni
	;Assembler
	invoke WritePrivateProfileString,addr szIniSession,addr szIniAssembler,addr da.szAssembler,addr da.szRadASMIni
	;File browser path
	invoke WritePrivateProfileString,addr szIniSession,addr szIniPath,addr da.szFBPath,addr da.szRadASMIni
	.if ha.hMdi
		;Files
		invoke ShowWindow,ha.hClient,SW_HIDE
		;Current tab
		invoke SendMessage,ha.hTab,TCM_GETCURSEL,0,0
		invoke BinToDec,eax,addr tmpbuff
		mov		dword ptr buffer,'0F'
		invoke WritePrivateProfileString,addr szIniSession,addr buffer,addr tmpbuff,addr da.szRadASMIni
		;Open files
		mov		eax,da.win.fcldmax
		push	eax
		.if eax
			invoke SendMessage,ha.hClient,WM_MDIRESTORE,ha.hMdi,0
		.endif
		xor		ebx,ebx
		.while ebx<100
			mov		tmpbuff,0
			invoke SetFileInfo,ebx,addr fi
			.break .if !eax
			invoke PutItemInt,addr tmpbuff,fi.ID
			invoke PutItemInt,addr tmpbuff,fi.rect.left
			invoke PutItemInt,addr tmpbuff,fi.rect.top
			invoke PutItemInt,addr tmpbuff,fi.rect.right
			invoke PutItemInt,addr tmpbuff,fi.rect.bottom
			invoke PutItemInt,addr tmpbuff,fi.nline
			invoke PutItemStr,addr tmpbuff,addr fi.filename
			inc		ebx
			mov		buffer,'F'
			invoke BinToDec,ebx,addr buffer[1]
			invoke WritePrivateProfileString,addr szIniSession,addr buffer,addr tmpbuff[1],addr da.szRadASMIni
		.endw
		pop		da.win.fcldmax
	.endif
	ret

PutSession endp

GetColors proc uses ebx
	LOCAL	racolor:RACOLOR

	invoke GetPrivateProfileString,addr szIniColors,addr szIniColors,NULL,addr tmpbuff,sizeof tmpbuff,addr da.szAssemblerIni
	.if eax
		xor		ebx,ebx
		.while ebx<sizeof RADCOLOR/4
			invoke GetItemInt,addr tmpbuff,0
			mov		dword ptr da.radcolor[ebx*4],eax
			inc		ebx
		.endw
	.else
		invoke RtlMoveMemory,addr da.radcolor,addr defcol,sizeof RADCOLOR
	.endif
	invoke SendMessage,ha.hOutput,REM_GETCOLOR,0,addr racolor
	mov		eax,da.radcolor.toolback
	mov		racolor.bckcol,eax
	mov		eax,da.radcolor.tooltext
	mov		racolor.txtcol,eax
	invoke SendMessage,ha.hOutput,REM_SETCOLOR,0,addr racolor
	invoke SendMessage,ha.hImmediate,REM_SETCOLOR,0,addr racolor
	invoke SendMessage,ha.hFileBrowser,FBM_SETBACKCOLOR,0,da.radcolor.toolback
	invoke SendMessage,ha.hFileBrowser,FBM_SETTEXTCOLOR,0,da.radcolor.tooltext
	invoke SendMessage,ha.hProjectBrowser,RPBM_SETBACKCOLOR,0,da.radcolor.toolback
	invoke SendMessage,ha.hProjectBrowser,RPBM_SETTEXTCOLOR,0,da.radcolor.tooltext
	invoke SendMessage,ha.hProperty,PRM_SETBACKCOLOR,0,da.radcolor.toolback
	invoke SendMessage,ha.hProperty,PRM_SETTEXTCOLOR,0,da.radcolor.tooltext
	ret

GetColors endp

PutColors proc uses ebx

	mov		tmpbuff,0
	xor		ebx,ebx
	.while ebx<sizeof RADCOLOR/4
		mov		eax,dword ptr da.radcolor[ebx*4]
		invoke PutItemInt,addr tmpbuff,eax
		inc		ebx
	.endw
	invoke WritePrivateProfileString,addr szIniColors,addr szIniColors,addr tmpbuff[1],addr da.szAssemblerIni
	ret

PutColors endp

GetAssembler proc

	invoke strcpy,addr da.szAssemblerIni,addr da.szAppPath
	invoke strcat,addr da.szAssemblerIni,addr szBS
	invoke strcat,addr da.szAssemblerIni,addr da.szAssembler
	invoke strcat,addr da.szAssemblerIni,addr szDotIni
	invoke SendMessage,ha.hStatus,SB_SETTEXT,2,addr da.szAssembler
	invoke GetPrivateProfileString,addr szIniFile,addr szIniCode,NULL,addr da.szCodeFiles,sizeof da.szCodeFiles,addr da.szAssemblerIni
	invoke GetPrivateProfileString,addr szIniFile,addr szIniText,NULL,addr da.szTextFiles,sizeof da.szTextFiles,addr da.szAssemblerIni
	invoke GetPrivateProfileString,addr szIniFile,addr szIniHex,NULL,addr da.szHexFiles,sizeof da.szHexFiles,addr da.szAssemblerIni
	invoke GetPrivateProfileString,addr szIniFile,addr szIniResource,NULL,addr da.szResourceFiles,sizeof da.szResourceFiles,addr da.szAssemblerIni
	ret

GetAssembler endp

GetBlockDef proc uses ebx esi edi
	LOCAL	buffer[16]:BYTE

	mov		esi,offset da.rabdstr
	mov		edi,offset da.rabd
	invoke RtlZeroMemory,edi,sizeof da.rabd
	mov		ebx,1
	.while ebx<33
		invoke BinToDec,ebx,addr buffer
		invoke GetPrivateProfileString,addr szIniCodeBlock,addr buffer,NULL,addr tmpbuff,sizeof tmpbuff,addr da.szAssemblerIni
		.break .if !eax
		invoke GetItemStr,addr tmpbuff,addr szNULL,esi
		.if byte ptr [esi]
			mov		[edi].RABLOCKDEF.lpszStart,esi
			invoke strlen,esi
			lea		esi,[esi+eax+2]
		.endif 
		invoke GetItemStr,addr tmpbuff,addr szNULL,esi 
		.if byte ptr [esi]
			mov		[edi].RABLOCKDEF.lpszEnd,esi
			invoke strlen,esi
			lea		esi,[esi+eax+2]
		.endif 
		invoke GetItemStr,addr tmpbuff,addr szNULL,esi 
		.if byte ptr [esi]
			mov		[edi].RABLOCKDEF.lpszNot1,esi
			invoke strlen,esi
			lea		esi,[esi+eax+2]
		.endif 
		invoke GetItemStr,addr tmpbuff,addr szNULL,esi 
		.if byte ptr [esi]
			mov		[edi].RABLOCKDEF.lpszNot2,esi
			invoke strlen,esi
			lea		esi,[esi+eax+2]
		.endif 
		invoke GetItemInt,addr tmpbuff,0
		push	eax
		invoke GetItemInt,addr tmpbuff,0
		pop		edx
		shl		eax,16
		or		eax,edx
		mov		[edi].RABLOCKDEF.flag,eax
		inc		ebx
		lea		edi,[edi+sizeof RABLOCKDEF]
	.endw
	;Reset block defs
	invoke SendMessage,ha.hOutput,REM_ADDBLOCKDEF,0,0
	mov		esi,offset da.rabd
	.while [esi].RABLOCKDEF.lpszStart
		invoke SendMessage,ha.hOutput,REM_ADDBLOCKDEF,0,esi
		mov		eax,[esi].RABLOCKDEF.lpszStart
		call	TestIt
		mov		eax,[esi].RABLOCKDEF.lpszEnd
		call	TestIt
		lea		esi,[esi+sizeof RABLOCKDEF]
	.endw
	invoke GetPrivateProfileString,addr szIniCodeBlock,addr szIniCmnt,NULL,addr tmpbuff,64,addr da.szAssemblerIni
	invoke GetItemStr,addr tmpbuff,addr szNULL,addr da.szCmntStart
	invoke GetItemStr,addr tmpbuff,addr szNULL,addr da.szCmntEnd
	invoke SendMessage,ha.hOutput,REM_SETCOMMENTBLOCKS,addr da.szCmntStart,addr da.szCmntEnd
	ret

TestIt:
	.if eax
		.while byte ptr [eax]
			.if byte ptr [eax]=='|'
				mov		byte ptr [eax],0
			.endif
			inc		eax
		.endw
	.endif
	retn

GetBlockDef endp

GetOption proc

	invoke GetPrivateProfileString,addr szIniEdit,addr szIniBraceMatch,NULL,addr da.szBraceMatch,sizeof da.szBraceMatch,addr da.szAssemblerIni
	invoke SendMessage,ha.hOutput,REM_BRACKETMATCH,0,offset da.szBraceMatch
	invoke GetPrivateProfileString,addr szIniEdit,addr szIniOption,NULL,addr tmpbuff,sizeof tmpbuff,addr da.szAssemblerIni
	invoke GetItemInt,addr tmpbuff,4
	mov		da.edtopt.tabsize,eax
	invoke GetItemInt,addr tmpbuff,EDTOPT_INDENT or EDTOPT_LINENR
	mov		da.edtopt.fopt,eax
	invoke GetPrivateProfileString,addr szIniFile,addr szIniFilter,NULL,addr tmpbuff,sizeof da.szFilter+2,addr da.szAssemblerIni
	invoke GetItemInt,addr tmpbuff,1
	invoke SendMessage,ha.hFileBrowser,FBM_SETFILTER,TRUE,eax
	invoke GetItemStr,addr tmpbuff,addr szDefFilter,addr da.szFilter
	invoke SendMessage,ha.hFileBrowser,FBM_SETFILTERSTRING,TRUE,addr da.szFilter
	ret

GetOption endp

GetParesDef proc
	LOCAL	buffcbo[128]:BYTE
	LOCAL	bufftype[128]:BYTE
	LOCAL	deftype:DEFTYPE
	LOCAL	buffer[256]:BYTE
	LOCAL	defgen:DEFGEN

	invoke SendMessage,ha.hProperty,PRM_RESET,0,0
	invoke GetPrivateProfileInt,addr szIniParse,addr szIniAssembler,0,addr da.szAssemblerIni
	mov		da.nAsm,eax
	invoke SendMessage,ha.hProperty,PRM_SETLANGUAGE,da.nAsm,0
	invoke SendMessage,ha.hProperty,PRM_SETCHARTAB,0,da.lpCharTab
	invoke GetItemStr,addr buffer,addr szNULL,addr defgen.szCmntBlockSt
	invoke GetItemStr,addr buffer,addr szNULL,addr defgen.szCmntBlockEn
	invoke GetItemStr,addr buffer,addr szNULL,addr defgen.szCmntChar
	invoke GetItemStr,addr buffer,addr szNULL,addr defgen.szString
	invoke GetItemStr,addr buffer,addr szNULL,addr defgen.szLineCont
	invoke SendMessage,ha.hProperty,PRM_SETGENDEF,0,addr defgen
	invoke GetPrivateProfileString,addr szIniParse,addr szIniDef,NULL,addr buffer,sizeof buffer,addr da.szAssemblerIni
	invoke GetPrivateProfileString,addr szIniParse,addr szIniType,NULL,addr buffcbo,sizeof buffcbo,addr da.szAssemblerIni
	.if eax
		.while buffcbo
			invoke GetItemStr,addr buffcbo,addr szNULL,addr bufftype
			.if bufftype
				invoke GetPrivateProfileString,addr szIniParse,addr bufftype,NULL,addr buffer,sizeof buffer,addr da.szAssemblerIni
				.while buffer
					invoke GetItemInt,addr buffer,0
					mov		deftype.nType,al
					invoke GetItemInt,addr buffer,0
					mov		deftype.nDefType,al
					invoke GetItemStr,addr buffer,addr szNULL,addr deftype.Def
					invoke GetItemStr,addr buffer,addr szNULL,addr deftype.szWord
					invoke strlen,addr deftype.szWord
					mov		deftype.len,al
					invoke SendMessage,ha.hProperty,PRM_ADDDEFTYPE,0,addr deftype
				.endw
				movzx	edx,deftype.Def
				invoke SendMessage,ha.hProperty,PRM_ADDPROPERTYTYPE,edx,addr bufftype
			.endif
		.endw
		invoke GetPrivateProfileString,addr szIniParse,addr szIniIgnore,NULL,addr buffer,sizeof buffer,addr da.szAssemblerIni
		.while buffer
			invoke GetItemInt,addr buffer,0
			push	eax
			invoke GetItemStr,addr buffer,addr szNULL,addr bufftype
			pop		edx
			.if bufftype
				invoke SendMessage,ha.hProperty,PRM_ADDIGNORE,edx,addr bufftype
			.endif
		.endw
		invoke SendMessage,ha.hProperty,PRM_SELECTPROPERTY,'p',0
	.endif
	ret

GetParesDef endp

DeleteDuplicates proc uses esi edi,lpszType:DWORD
	LOCAL	nCount:DWORD

	invoke SendMessage,ha.hProperty,PRM_GETSORTEDLIST,lpszType,addr nCount
	mov		esi,eax
	push	esi
	xor		ecx,ecx
	mov		edi,offset szNULL
	.while ecx<nCount
		push	ecx
		invoke strcmp,edi,[esi]
		.if !eax
			mov		eax,[esi]
			lea		eax,[eax-sizeof PROPERTIES]
			mov		[eax].PROPERTIES.nType,255
		.else
			mov		edi,[esi]
		.endif
		pop		ecx
		inc		ecx
		lea		esi,[esi+4]
	.endw
	pop		esi
	invoke GlobalFree,esi
	invoke SendMessage,ha.hProperty,PRM_COMPACTLIST,FALSE,0
	ret

DeleteDuplicates endp

GetCodeComplete proc uses ebx
	LOCAL	buffer[256]:BYTE
	LOCAL	apifile[MAX_PATH]:BYTE

	invoke GetPrivateProfileString,addr szIniCodeComplete,addr szIniTrig,NULL,addr da.szCCTrig,sizeof da.szCCTrig,addr da.szAssemblerIni
	invoke GetPrivateProfileString,addr szIniCodeComplete,addr szIniInc,NULL,addr da.szCCInc,sizeof da.szCCInc,addr da.szAssemblerIni
	invoke GetPrivateProfileString,addr szIniCodeComplete,addr szIniLib,NULL,addr da.szCCLib,sizeof da.szCCLib,addr da.szAssemblerIni

	invoke GetPrivateProfileString,addr szIniCodeComplete,addr szIniApi,NULL,addr tmpbuff,sizeof tmpbuff,addr da.szAssemblerIni
	.while tmpbuff
		invoke GetItemStr,addr tmpbuff,addr szNULL,addr buffer
		movzx	ebx,buffer
		invoke GetItemStr,addr tmpbuff,addr szNULL,addr buffer
		.if ebx && buffer
			invoke strcpy,addr apifile,addr da.szAppPath
			invoke strcat,addr apifile,addr szBSApiBS
			invoke strcat,addr apifile,addr buffer
			invoke SendMessage,ha.hProperty,PRM_ADDPROPERTYFILE,ebx,addr apifile
		.endif
	.endw
	;Add 'C' list to 'W' list
	mov		dword ptr buffer,'C'
	invoke SendMessage,ha.hProperty,PRM_FINDFIRST,addr buffer,addr buffer[1]
	.while eax
		mov		esi,eax
		invoke strlen,esi
		lea		esi,[esi+eax+1]
		invoke strcpy,offset tmpbuff,esi
		mov		eax,2 shl 8 or 'W'
		invoke SendMessage,ha.hProperty,PRM_ADDPROPERTYLIST,eax,offset tmpbuff
		invoke SendMessage,ha.hProperty,PRM_FINDNEXT,0,0
	.endw
	;Add 'M' list to 'W' list
	mov		dword ptr buffer,'M'
	invoke SendMessage,ha.hProperty,PRM_FINDFIRST,addr buffer,addr buffer[1]
	.while eax
		mov		esi,eax
		invoke strlen,esi
		lea		esi,[esi+eax+1]
		.while byte ptr [esi]
			.if byte ptr [esi]=='['
				inc		esi
				mov		edi,offset tmpbuff
				.while byte ptr [esi]!=']'
					mov		al,[esi]
					mov		[edi],al
					inc		esi
					inc		edi
				.endw
				mov		byte ptr [edi],0
				mov		eax,2 shl 8 or 'W'
				invoke SendMessage,ha.hProperty,PRM_ADDPROPERTYLIST,eax,offset tmpbuff
			.endif
			inc		esi
		.endw
		invoke SendMessage,ha.hProperty,PRM_FINDNEXT,0,0
	.endw
	;Delete duplicates
	mov		dword ptr buffer,'W'
	invoke DeleteDuplicates,addr buffer
	ret

GetCodeComplete endp

GetKeywords proc
	LOCAL	hMem:HGLOBAL
	LOCAL	buffer[16]:BYTE
	LOCAL	nInx:DWORD

	invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,65536*8
	mov		hMem,eax
	invoke SetHiliteWords,0,0
	mov		buffer,'C'
	mov		nInx,0
	.while nInx<16
		invoke BinToDec,nInx,addr buffer[1]
		invoke GetPrivateProfileString,addr szIniKeywords,addr buffer,NULL,addr tmpbuff,sizeof tmpbuff,addr da.szAssemblerIni
		.if eax
			mov		eax,nInx
			mov		eax,dword ptr da.radcolor[eax*4]
			invoke SetHiliteWords,eax,addr tmpbuff
		.endif
		inc		nInx
	.endw
	;Add api calls to Group#15
	invoke RtlZeroMemory,hMem,65536*8
	mov		dword ptr buffer,'P'
	mov		edi,hMem
	invoke SendMessage,ha.hProperty,PRM_FINDFIRST,addr buffer,addr buffer[2]
	.while eax
		mov		byte ptr [edi],'^'
		inc		edi
		invoke strcpy,edi,eax
		invoke strlen,edi
		lea		edi,[edi+eax]
		mov		byte ptr [edi],' '
		inc		edi
		invoke SendMessage,ha.hProperty,PRM_FINDNEXT,0,0
	.endw
	mov		byte ptr [edi],0
	invoke SetHiliteWords,da.radcolor.kwcol[15*4],hMem
	;Add api constants to Group#14
	invoke RtlZeroMemory,hMem,65536*8
	mov		dword ptr buffer,'C'
	mov		edi,hMem
	invoke SendMessage,ha.hProperty,PRM_FINDFIRST,addr buffer,addr buffer[2]
	mov		esi,eax
	.while esi
		invoke strlen,esi
		lea		esi,[esi+eax+1]
		mov		byte ptr [edi],'^'
		inc		edi
		.while byte ptr [esi]
			mov		al,[esi]
			.if al==','
				mov		byte ptr [edi],' '
				inc		edi
				mov		al,'^'
			.endif
			mov		[edi],al
			inc		esi
			inc		edi
		.endw
		invoke SendMessage,ha.hProperty,PRM_FINDNEXT,0,0
		mov		esi,eax
	.endw
	mov		byte ptr [edi],0
	invoke SetHiliteWords,da.radcolor.kwcol[14*4],hMem
	;Add api words to Group#14
	invoke RtlZeroMemory,hMem,65536*8
	mov		dword ptr buffer,'W'
	mov		edi,hMem
	invoke SendMessage,ha.hProperty,PRM_FINDFIRST,addr buffer,addr buffer[2]
	.while eax
		mov		byte ptr [edi],'^'
		inc		edi
		invoke strcpy,edi,eax
		invoke strlen,edi
		lea		edi,[edi+eax]
		mov		byte ptr [edi],' '
		inc		edi
		invoke SendMessage,ha.hProperty,PRM_FINDNEXT,0,0
	.endw
	mov		byte ptr [edi],0
	invoke SetHiliteWords,da.radcolor.kwcol[14*4],hMem
	;Add api structs to Group#13
	invoke RtlZeroMemory,hMem,65536*8
	mov		dword ptr buffer,'S'
	mov		edi,hMem
	invoke SendMessage,ha.hProperty,PRM_FINDFIRST,addr buffer,addr buffer[2]
	.while eax
		mov		byte ptr [edi],'^'
		inc		edi
		invoke strcpy,edi,eax
		invoke strlen,edi
		lea		edi,[edi+eax]
		mov		byte ptr [edi],' '
		inc		edi
		invoke SendMessage,ha.hProperty,PRM_FINDNEXT,0,0
	.endw
	mov		byte ptr [edi],0
	invoke SetHiliteWords,da.radcolor.kwcol[13*4],hMem
	;Add api types to Group#12
	invoke RtlZeroMemory,hMem,65536*8
	mov		dword ptr buffer,'T'
	mov		edi,hMem
	invoke SendMessage,ha.hProperty,PRM_FINDFIRST,addr buffer,addr buffer[2]
	.while eax
		mov		cl,[eax]
		mov		ch,cl
		and		cl,5Fh
		.if cl==ch
			;Case sensitive
			mov		byte ptr [edi],'^'
			inc		edi
		.endif
		invoke strcpy,edi,eax
		invoke strlen,edi
		lea		edi,[edi+eax]
		mov		byte ptr [edi],' '
		inc		edi
		invoke SendMessage,ha.hProperty,PRM_FINDNEXT,0,0
	.endw
	mov		byte ptr [edi],0
	invoke SetHiliteWords,da.radcolor.kwcol[12*4],hMem
	invoke GlobalFree,hMem
	ret

GetKeywords endp
