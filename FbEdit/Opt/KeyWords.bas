
'KeyWords.dlg
#Define IDD_DLGKEYWORDS						4000
#Define IDC_BTNKWAPPLY						4002
#Define IDC_LSTKWCOLORS						4001
#Define IDC_CHKITALIC						4003
#Define IDC_CHKBOLD							4004
#Define IDC_BTNACTIVE						4008
#Define IDC_BTNHOLD							4009
#Define IDC_BTNDEL							4010
#Define IDC_BTNADD							4011
#Define IDC_EDTKW								4012
#Define IDC_LSTKWHOLD						4013
#Define IDC_LSTKWACTIVE						4014
#Define IDC_CHKRCFILE						4005
#Define IDC_LSTCOLORS						4015
#Define IDC_EDTCODEFILES					4030
#Define IDC_EDTTABSIZE						4018
#Define IDC_SPNTABSIZE						4017
#Define IDC_CHKEXPAND						4019
#Define IDC_CHKAUTOINDENT					4020
#Define IDC_CHKHILITELINE					4021
#Define IDC_STCCODEFONT						4022
#Define IDC_STCLNRFONT						4023
#Define IDC_BTNCODEFONT						4024
#Define IDC_BTNLNRFONT						4025
#Define IDC_CHKHILITECMNT					4026
#Define IDC_CHKSINGLEINSTANCE				4031
#Define IDC_CBOTHEME							4007
#Define IDC_BTNSAVETHEME					4016
#Define IDC_EDTTHEME							4027
#Define IDC_CHKLINENUMBERS					4006
#Define IDC_EDTBACKUP						4029
#Define IDC_SPNBACKUP						4028
#Define IDC_CHKBRACEMATCH					4032
#Define IDC_CHKAUTOBRACE					4033
#Define IDC_CHKAUTOBLOCK					4035
#Define IDC_CHKAUTOFORMAT					4036
#Define IDC_CHKCOLORBOLD					4038
#Define IDC_CHKCOLORITALIC					4037
#Define IDC_CHKCODECOMPLETE				4039
#Define IDC_CHKSAVE							4034
#Define IDC_CHKAUTOLOAD						4044
#Define IDC_CHKAUTOWIDTH					4045
#Define IDC_CHKAUTOINCLUDE					4046
#Define IDC_CHKTOOLTIP						4048
#define IDC_CHKCLOSEONLOCKS				4047
#Define IDC_CHKSMARTMATHS					4049
#Define IDC_RBNCASENONE						4040
#Define IDC_RBNCASEMIXED					4041
#Define IDC_RBNCASELOWER					4042
#Define IDC_RBNCASEUPPER					4043

Dim Shared hCFont As HFONT
Dim Shared hLFont As HFONT
Dim Shared oldsel As Integer

Const sColors="Back,Text,Selected back,Selected text,Comments,Strings,Operators,Comments back,Active line back,Indent markers,Selection bar,Selection bar pen,Line numbers,Numbers & hex,Tools Back,Tools Text,Dialog Back,Dialog Text,CodeComplete Back,CodeComplete Text,CodeTip Back,CodeTip Text,CodeTip Api,CodeTip Sel,Properties parameters"

Sub SetToolsColors(ByVal hWin As HWND)
	Dim racol As RACOLOR
	Dim rescol As RARESEDCOLOR
	Dim lpRESMEM As RESMEM Ptr
	Dim cccol As CC_COLOR
	Dim ttcol As TT_COLOR

	lpRESMEM=Cast(RESMEM Ptr,GetWindowLong(ah.hres,0))
	SendMessage(ah.hprj,TVM_SETBKCOLOR,0,fbcol.toolback)
	SendMessage(ah.hprj,TVM_SETTEXTCOLOR,0,fbcol.tooltext)
	SendMessage(ah.hfib,FBM_SETBACKCOLOR,0,fbcol.toolback)
	SendMessage(ah.hfib,FBM_SETTEXTCOLOR,0,fbcol.tooltext)
	SendMessage(ah.hpr,PRM_SETBACKCOLOR,0,fbcol.toolback)
	SendMessage(ah.hpr,PRM_SETTEXTCOLOR,0,fbcol.tooltext)
	SendMessage(ah.hpr,PRM_SETOPRCOLOR,0,fbcol.propertiespar)
	SendMessage(ah.hout,REM_GETCOLOR,0,Cast(Integer,@racol))
	racol.bckcol=fbcol.toolback
	racol.txtcol=fbcol.tooltext
	SendMessage(ah.hout,REM_SETCOLOR,0,Cast(Integer,@racol))
	rescol.back=fbcol.dialogback
	rescol.text=fbcol.dialogtext
	SendMessage(lpRESMEM->hResEd,DEM_SETCOLOR,0,Cast(Integer,@rescol))
	cccol.back=fbcol.codelistback
	cccol.text=fbcol.codelisttext
	SendMessage(ah.hcc,CCM_SETCOLOR,0,Cast(LPARAM,@cccol))
	ttcol.back=fbcol.codetipback
	ttcol.text=fbcol.codetiptext
	ttcol.api=fbcol.codetipapi
	ttcol.hilite=fbcol.codetipsel
	SendMessage(ah.htt,TTM_SETCOLOR,0,Cast(LPARAM,@ttcol))

End Sub

Sub SetHiliteWords(ByVal hWin As HWND)

	' Reset all words
	SendMessage(ah.hout,REM_SETHILITEWORDS,0,0)
	' Set colors and words to hilite
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C0"),@C0,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C0,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C1"),@C1,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C1,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C2"),@C2,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C2,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C3"),@C3,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C3,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C4"),@C4,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C4,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C5"),@C5,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C5,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C6"),@C6,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C6,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C7"),@C7,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C7,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C8"),@C8,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C8,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C9"),@C9,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C9,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C10"),@C10,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C10,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C11"),@C11,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C11,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C12"),@C12,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C12,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C13"),@C13,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C13,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C14"),@C14,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C14,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C15"),@C15,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C15,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C16"),@C16,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C16,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C17"),@C17,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C17,Cast(Integer,@buff))
	GetPrivateProfileString(StrPtr("Edit"),StrPtr("C18"),@C18,@buff,SizeOf(buff),@ad.IniFile)
	SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C18,Cast(Integer,@buff))

End Sub

Sub SetHiliteWordsFromApi(ByVal hWin As HWND)
	Dim lret As Integer
	Dim sItem As ZString*256
	Dim x As Integer
	Dim y As Integer

	' Data types
	lret=SendMessage(ah.hpr,PRM_FINDFIRST,Cast(Integer,StrPtr("T")),Cast(Integer,StrPtr("")))
	Do While lret
		sItem= "^"
		lstrcpy(@sItem,Cast(ZString Ptr,lret))
		If sItem=UCase(sItem) Then
			' Case sensitive
			sItem="^" & sItem
		EndIf
		SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C12,Cast(Integer,@sItem))
		lret=SendMessage(ah.hpr,PRM_FINDNEXT,0,0)
	Loop
	' Api struct
	lret=SendMessage(ah.hpr,PRM_FINDFIRST,Cast(Integer,StrPtr("S")),Cast(Integer,StrPtr("")))
	Do While lret
		sItem= "^"
		lstrcat(@sItem,Cast(ZString Ptr,lret))
		SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C13,Cast(Integer,@sItem))
		lret=SendMessage(ah.hpr,PRM_FINDNEXT,0,0)
	Loop
	' Api words
	lret=SendMessage(ah.hpr,PRM_FINDFIRST,Cast(Integer,StrPtr("W")),Cast(Integer,StrPtr("")))
	Do While lret
		sItem= "^"
		lstrcat(@sItem,Cast(ZString Ptr,lret))
		SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C14,Cast(Integer,@sItem))
		lret=SendMessage(ah.hpr,PRM_FINDNEXT,0,0)
	Loop
	' Api constants
	lret=SendMessage(ah.hpr,PRM_FINDFIRST,Cast(Integer,StrPtr("A")),Cast(Integer,StrPtr("")))
	Do While lret
		lret=lret+Len(*Cast(ZString Ptr,lret))+1
		lstrcpy(@buff,Cast(ZString Ptr,lret))
'''*** This is a bit slow
'		lret=1
'		while TRUE
'			x=instr(lret,buff,",")
'			if x then
'				sItem="^" & mid(buff,lret,x-lret)
'				SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C14,@sItem)
'				lret=x+1
'			else
'				sItem="^" & mid(buff,lret)
'				SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C14,@sItem)
'				exit while
'			endif
'		wend
'''***

'''*** Speed it up with some inline assembly
		Asm
			push	esi
			push	edi
			lea	esi,buff
			lea	edi,s
			mov	al,&H5e
			mov	[edi],al
			Inc	edi
		NextChar0:
			mov	ax,[esi]
			add	esi,2
			cmp	ax,&H2c30
			je		NextChar0
			cmp	ax,&H2c31
			je		NextChar0
			cmp	ax,&H2c32
			je		NextChar0
			cmp	ax,&H2c33
			je		NextChar0
			cmp	ax,&H34
			je		EndLine
			dec	esi
			dec	esi
		NextChar:
			mov	ax,[esi]
			cmp	al,&H2c
			jne	NextChar1
			mov	al,&H20
			mov	[edi],al
			Inc	edi
			mov	al,&H5e
		NextChar1:
			mov	[edi],al
			Inc	esi
			Inc	edi
			Or		al,al
			jne	NextChar
		EndLine:
			Xor	al,al
			mov	[edi],al
			pop	edi
			pop	esi
		End Asm
		If s<>"^" Then
			SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C14,Cast(Integer,@s))
		EndIf
'''***
		lret=SendMessage(ah.hpr,PRM_FINDNEXT,0,0)
	Loop
	' Api calls
	lret=SendMessage(ah.hpr,PRM_FINDFIRST,Cast(Integer,StrPtr("P")),Cast(Integer,StrPtr("")))
	Do While lret
		'sItem= "^"
		'lstrcat(@sItem,Cast(ZString ptr,lret))
		lstrcpy(@sItem,Cast(ZString Ptr,lret))
		SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C15,Cast(Integer,@sItem))
		lret=SendMessage(ah.hpr,PRM_FINDNEXT,0,0)
	Loop

End Sub

Sub HLUDT()
	Dim lret As ZString Ptr
	Dim sItem As ZString*256
	
	lret=Cast(ZString Ptr,SendMessage(ah.hpr,PRM_FINDFIRST,Cast(Integer,StrPtr("s")),Cast(Integer,StrPtr(""))))
	Do While lret
		sItem= "^"
		lstrcat(@sItem,lret)
		SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C16,Cast(Integer,@sItem))
		lret=Cast(ZString Ptr,SendMessage(ah.hpr,PRM_FINDNEXT,0,0))
	Loop

End Sub

Sub HLConstants()
	Dim lret As ZString Ptr
	Dim sItem As ZString*256
	
	lret=Cast(ZString Ptr,SendMessage(ah.hpr,PRM_FINDFIRST,Cast(Integer,StrPtr("c")),Cast(Integer,StrPtr(""))))
	Do While lret
		sItem= "^"
		lstrcat(@sItem,lret)
		SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C17,Cast(Integer,@sItem))
		lret=Cast(ZString Ptr,SendMessage(ah.hpr,PRM_FINDNEXT,0,0))
	Loop

End Sub

Sub HLFunction()
	Dim lret As ZString Ptr
	Dim sItem As ZString*256
	
	lret=Cast(ZString Ptr,SendMessage(ah.hpr,PRM_FINDFIRST,Cast(Integer,StrPtr("p")),Cast(Integer,StrPtr(""))))
	Do While lret
		sItem= "^"
		lstrcat(@sItem,lret)
		SendMessage(ah.hout,REM_SETHILITEWORDS,kwcol.C18,Cast(Integer,@sItem))
		lret=Cast(ZString Ptr,SendMessage(ah.hpr,PRM_FINDNEXT,0,0))
	Loop

End Sub

Sub PropertyHL(ByVal bUpdate As Integer)

	If bUpdate Then
		HLUDT()
		HLConstants()
		HLFunction()
	Else
		SetHiliteWords(ah.hwnd)
		SetHiliteWordsFromApi(ah.hwnd)
	EndIf
	SendMessage(ah.hred,REM_REPAINT,0,TRUE)
	
End Sub

Sub GetTheme(ByVal hWin As HWND,ByVal nInx As Integer)
	Dim ofs As Any Ptr
	Dim col As Integer

	ofs=@thme(nInx)
	nInx=0
	Do While nInx<18
		ofs=ofs+4
		RtlMoveMemory(@col,ofs,4)
		SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_SETITEMDATA,nInx,col)
		nInx=nInx+1
	Loop
	InvalidateRect(GetDlgItem(hWin,IDC_LSTKWCOLORS),NULL,TRUE)
	nInx=0
	Do While nInx<25
		ofs=ofs+4
		RtlMoveMemory(@col,ofs,4)
		SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_SETITEMDATA,nInx,col)
		nInx=nInx+1
	Loop
	InvalidateRect(GetDlgItem(hWin,IDC_LSTCOLORS),NULL,TRUE)

End Sub

Sub PutTheme(ByVal hWin As HWND,ByVal nInx As Integer)
	Dim ofs As Any Ptr
	Dim col As Integer

	ofs=@thme(nInx)
	nInx=0
	Do While nInx<18
		ofs=ofs+4
		col=SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_GETITEMDATA,nInx,0)
		RtlMoveMemory(ofs,@col,4)
		nInx=nInx+1
	Loop
	nInx=0
	Do While nInx<25
		ofs=ofs+4
		col=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETITEMDATA,nInx,0)
		RtlMoveMemory(ofs,@col,4)
		nInx=nInx+1
	Loop

End Sub

Sub SaveEditOpt(ByVal hWin As HWND)
	Dim nInx As Integer
	Dim ofs As Any Ptr
	Dim col As Integer
	Dim lfnt As LOGFONT
	Dim sItem As ZString*256

	' Window colors
	ofs=@fbcol
	nInx=0
	Do While nInx<25
		col=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETITEMDATA,nInx,0)
		RtlMoveMemory(ofs,@col,4)
		ofs=ofs+4
		nInx=nInx+1
	Loop
	SaveToIni(StrPtr("Win"),StrPtr("Colors"),"4444444444444444444444444",@fbcol,FALSE)
	' Keyword colors
	ofs=@kwcol
	nInx=0
	Do While nInx<19
		col=SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_GETITEMDATA,nInx,0)
		RtlMoveMemory(ofs,@col,4)
		ofs=ofs+4
		nInx=nInx+1
	Loop
	SaveToIni(StrPtr("Edit"),StrPtr("Colors"),"4444444444444444444",@kwcol,FALSE)
	' Custom colors
	SaveToIni(StrPtr("Edit"),StrPtr("CustColors"),"4444444444444444444",@custcol,FALSE)
	' KeyWords
	nInx=0
	Do While nInx<20
		buff=Chr(34) & sKeyWords(nInx) & Chr(34)
		WritePrivateProfileString("Edit","C" & Str(nInx),@buff,@ad.IniFile)
		nInx=nInx+1
	Loop
	' Fonts
	DeleteObject(ah.rafnt.hFont)
	DeleteObject(ah.rafnt.hIFont)
	DeleteObject(ah.rafnt.hLnrFont)
	GetObject(hCFont,SizeOf(LOGFONT),@lfnt)
	edtfnt.size=lfnt.lfHeight
	edtfnt.charset=lfnt.lfCharSet
	lstrcpy(edtfnt.szFont,lfnt.lfFaceName)
	SaveToIni(StrPtr("Edit"),StrPtr("EditFont"),"440",@edtfnt,FALSE)
	ah.rafnt.hFont=CreateFontIndirect(@lfnt)
	lfnt.lfItalic=TRUE
	ah.rafnt.hIFont=CreateFontIndirect(@lfnt)
	GetObject(hLFont,SizeOf(LOGFONT),@lfnt)
	lnrfnt.size=lfnt.lfHeight
	lnrfnt.charset=lfnt.lfCharSet
	lstrcpy(lnrfnt.szFont,lfnt.lfFaceName)
	SaveToIni(StrPtr("Edit"),StrPtr("LnrFont"),"440",@lnrfnt,FALSE)
	ah.rafnt.hLnrFont=CreateFontIndirect(@lfnt)
	' Edit options
	edtopt.tabsize=GetDlgItemInt(hWin,IDC_EDTTABSIZE,NULL,FALSE)
	edtopt.expand=IsDlgButtonChecked(hWin,IDC_CHKEXPAND)
	edtopt.hiliteline=IsDlgButtonChecked(hWin,IDC_CHKHILITELINE)
	edtopt.autoindent=IsDlgButtonChecked(hWin,IDC_CHKAUTOINDENT)
	edtopt.hilitecmnt=IsDlgButtonChecked(hWin,IDC_CHKHILITECMNT)
	edtopt.linenumbers=IsDlgButtonChecked(hWin,IDC_CHKLINENUMBERS)
	wpos.singleinstance=IsDlgButtonChecked(hWin,IDC_CHKSINGLEINSTANCE)
	edtopt.backup=GetDlgItemInt(hWin,IDC_EDTBACKUP,NULL,FALSE)
	edtopt.bracematch=IsDlgButtonChecked(hWin,IDC_CHKBRACEMATCH)
	edtopt.autobrace=IsDlgButtonChecked(hWin,IDC_CHKAUTOBRACE)
	If IsDlgButtonChecked(hWin,IDC_RBNCASENONE) Then
		edtopt.autocase=0
	ElseIf IsDlgButtonChecked(hWin,IDC_RBNCASEMIXED) Then
		edtopt.autocase=1
	ElseIf IsDlgButtonChecked(hWin,IDC_RBNCASELOWER) Then
		edtopt.autocase=2
	ElseIf IsDlgButtonChecked(hWin,IDC_RBNCASEUPPER) Then
		edtopt.autocase=3
	EndIf
	edtopt.autoblock=IsDlgButtonChecked(hWin,IDC_CHKAUTOBLOCK)
	edtopt.autoformat=IsDlgButtonChecked(hWin,IDC_CHKAUTOFORMAT)
	edtopt.codecomplete=IsDlgButtonChecked(hWin,IDC_CHKCODECOMPLETE)
	edtopt.autosave=IsDlgButtonChecked(hWin,IDC_CHKSAVE)
	edtopt.autoload=IsDlgButtonChecked(hWin,IDC_CHKAUTOLOAD)
	edtopt.autowidth=IsDlgButtonChecked(hWin,IDC_CHKAUTOWIDTH)
	edtopt.autoinclude=IsDlgButtonChecked(hWin,IDC_CHKAUTOINCLUDE)
	edtopt.closeonlocks=IsDlgButtonChecked(hWin,IDC_CHKCLOSEONLOCKS)
	edtopt.tooltip=IsDlgButtonChecked(hWin,IDC_CHKTOOLTIP)
	edtopt.smartmath=IsDlgButtonChecked(hWin,IDC_CHKSMARTMATHS)
	SaveToIni(StrPtr("Edit"),StrPtr("EditOpt"),"44444444444444444444",@edtopt,FALSE)
	SaveToIni(StrPtr("Win"),StrPtr("Winpos"),"444444444444444",@wpos,FALSE)
	' Save theme
	sItem=String(32,0)
	WritePrivateProfileSection(StrPtr("Theme"),@sItem,@ad.IniFile)
	nInx=SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_GETCURSEL,0,0)
	sItem=Str(nInx)
	WritePrivateProfileString(StrPtr("Theme"),StrPtr("Current"),@sItem,@ad.IniFile)
	PutTheme(hWin,nInx)
	For nInx=1 To 15
		If lstrlen(thme(nInx).sztheme) Then
			SaveToIni(StrPtr("Theme"),Str(nInx),"044444444444444444444444444444444444444444",@thme(nInx),FALSE)
		EndIf
	Next nInx
	GetDlgItemText(hWin,IDC_EDTCODEFILES,@sCodeFiles,SizeOf(sCodeFiles))
	If Right(sCodeFiles,1)<>"." Then
		sCodeFiles=sCodeFiles & "."
	EndIf
	WritePrivateProfileString(StrPtr("Edit"),StrPtr("CodeFiles"),@sCodeFiles,@ad.IniFile)
	If edtopt.bracematch Then
		SendMessage(ah.hout,REM_BRACKETMATCH,0,Cast(Integer,@szBracketMatch))
	Else
		SendMessage(ah.hout,REM_BRACKETMATCH,0,Cast(Integer,StrPtr("")))
	EndIf
	SetToolsColors(ah.hwnd)
	SetHiliteWords(ah.hwnd)
	SetHiliteWordsFromApi(ah.hwnd)
	UpdateAllTabs(1)

End Sub

Sub GetList(ByVal hWin As HWND)
	Dim nInx As Integer
	Dim sItem As String*256
	Dim x As Integer
	
	buff=""
	nInx=0
	Do While SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_GETTEXT,nInx,Cast(Integer,@sItem))<>LB_ERR
		buff=buff & sItem & " "
		nInx=nInx+1
	Loop
	sKeyWords(oldsel)=buff
	x=SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_GETITEMDATA,oldsel,0)
	x=x And &HFFFFFF
	If IsDlgButtonChecked(hWin,IDC_CHKBOLD) Then
		x=x Or (1 Shl 24)
	EndIf
	If IsDlgButtonChecked(hWin,IDC_CHKITALIC) Then
		x=x Or (1 Shl 25)
	EndIf
	If IsDlgButtonChecked(hWin,IDC_CHKRCFILE) Then
		x=x Or (1 Shl 28)
	EndIf
	SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_SETITEMDATA,oldsel,x)

End Sub

Sub FillList(ByVal hWin As HWND)
	Dim nInx As Integer
	Dim sItem As String*256
	Dim x As Integer

	SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_RESETCONTENT,0,0)
	nInx=SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_GETCURSEL,0,0)
	buff=sKeyWords(nInx) & szNULL
	Do While Len(buff)
		x=InStr(buff," ")
		If x=0 Then
			x=Len(buff)+1
		EndIf
		sItem=Left(buff,x-1)
		SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_ADDSTRING,0,Cast(Integer,@sItem))
		buff=Mid(buff,x+1)
	Loop
	x=SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_GETITEMDATA,nInx,0)
	CheckDlgButton(hWin,IDC_CHKBOLD,((x Shr 24) And 1))
	CheckDlgButton(hWin,IDC_CHKITALIC,((x Shr 25) And 1))
	CheckDlgButton(hWin,IDC_CHKRCFILE,((x Shr 28) And 1))
	oldsel=nInx

End Sub

Sub GetHold(ByVal hWin As HWND)
	Dim nInx As Integer
	Dim sItem As ZString*256
	
	buff=""
	nInx=0
	Do While SendDlgItemMessage(hWin,IDC_LSTKWHOLD,LB_GETTEXT,nInx,Cast(Integer,@sItem))<>LB_ERR
		buff=buff & sItem & " "
		nInx=nInx+1
	Loop
	sKeyWords(19)=buff

End Sub

Sub FillHold(ByVal hWin As HWND)
	Dim nInx As Integer
	Dim sItem As ZString*256
	Dim x As Integer

	buff=sKeyWords(19)
	Do While Len(buff)
		x=InStr(buff," ")
		If x=0 Then
			x=Len(buff)+1
		EndIf
		sItem=Left(buff,x-1)
		SendDlgItemMessage(hWin,IDC_LSTKWHOLD,LB_ADDSTRING,0,Cast(Integer,@sItem))
		buff=Mid(buff,x+1)
	Loop
	oldsel=nInx
End Sub

Function KeyWordsDlgProc(ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event
	Static hBtnApply As HWND
	Dim lfnt As LOGFONT
	Dim cf As ChooseFont
	Dim hCtl As HWND
	Dim lpDRAWITEMSTRUCT As DRAWITEMSTRUCT Ptr
	Dim sItem As ZString*256
	Dim nInx As Integer
	Dim rect As RECT
	Dim hBr As HBRUSH
	Dim ofs As Any Ptr
	Dim col As Integer
	Dim cc As ChooseColor
	Dim x As Integer

	Select Case uMsg
		Case WM_INITDIALOG
			TranslateDialog(hWin,IDD_DLGKEYWORDS)
			' Themes
			SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_ADDSTRING,0,Cast(Integer,StrPtr("New Theme")))
			nInx=0
			For col=1 To 15
				sItem=Str(col)
				thme(col).sztheme=String(32,0)
				LoadFromIni(StrPtr("Theme"),@sItem,"044444444444444444444444444444444444444444",@thme(col),FALSE)
				If lstrlen(thme(col).sztheme) Then
					sItem=String(32,0)
					lstrcpy(@sItem,thme(col).sztheme)
					nInx=SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_ADDSTRING,0,Cast(Integer,@sItem))
				EndIf
			Next col
			If nInx=0 Then
				PutTheme(hWin,1)
				thme(1).sztheme="Default"
				SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_ADDSTRING,0,Cast(Integer,StrPtr("Default")))
			EndIf
			nInx=GetPrivateProfileInt(StrPtr("Theme"),StrPtr("Current"),1,@ad.IniFile)
			SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_SETCURSEL,nInx,0)
			SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_GETLBTEXT,nInx,Cast(Integer,@sItem))
			SendDlgItemMessage(hWin,IDC_EDTTHEME,WM_SETTEXT,0,Cast(Integer,@sItem))
			' Keywords
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C0"),@C0,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(0)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C1"),@C1,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(1)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C2"),@C2,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(2)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C3"),@C3,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(3)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C4"),@C4,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(4)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C5"),@C5,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(5)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C6"),@C6,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(6)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C7"),@C7,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(7)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C8"),@C8,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(8)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C9"),@C9,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(9)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C10"),@C10,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(10)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C11"),@C11,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(11)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C12"),@C12,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(12)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C13"),@C13,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(13)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C14"),@C14,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(14)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C15"),@C15,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(15)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C16"),@C16,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(16)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C17"),@C17,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(17)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C18"),@C18,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(18)=buff
			GetPrivateProfileString(StrPtr("Edit"),StrPtr("C19"),@C15,@buff,SizeOf(buff),@ad.IniFile)
			sKeyWords(19)=buff
			' Misc
			SendDlgItemMessage(hWin,IDC_SPNTABSIZE,UDM_SETRANGE,0,&H00010014)		' Set range
			SendDlgItemMessage(hWin,IDC_SPNTABSIZE,UDM_SETPOS,0,edtopt.tabsize)	' Set default value
			'
			SendDlgItemMessage(hWin,IDC_SPNBACKUP,UDM_SETRANGE,0,&H00000009)		' Set range
			SendDlgItemMessage(hWin,IDC_SPNBACKUP,UDM_SETPOS,0,edtopt.backup)	' Set default value
			'
			CheckDlgButton(hWin,IDC_CHKEXPAND,edtopt.expand)
			CheckDlgButton(hWin,IDC_CHKAUTOINDENT,edtopt.autoindent)
			CheckDlgButton(hWin,IDC_CHKHILITELINE,edtopt.hiliteline)
			CheckDlgButton(hWin,IDC_CHKHILITECMNT,edtopt.hilitecmnt)
			CheckDlgButton(hWin,IDC_CHKLINENUMBERS,edtopt.linenumbers)
			CheckDlgButton(hWin,IDC_CHKSINGLEINSTANCE,wpos.singleinstance)
			CheckDlgButton(hWin,IDC_CHKBRACEMATCH,edtopt.bracematch)
			CheckDlgButton(hWin,IDC_CHKAUTOBRACE,edtopt.autobrace)
			CheckDlgButton(hWin,IDC_RBNCASENONE+edtopt.autocase,BST_CHECKED)
			CheckDlgButton(hWin,IDC_CHKAUTOBLOCK,edtopt.autoblock)
			CheckDlgButton(hWin,IDC_CHKAUTOFORMAT,edtopt.autoformat)
			CheckDlgButton(hWin,IDC_CHKCODECOMPLETE,edtopt.codecomplete)
			CheckDlgButton(hWin,IDC_CHKSAVE,edtopt.autosave)
			CheckDlgButton(hWin,IDC_CHKAUTOLOAD,edtopt.autoload)
			CheckDlgButton(hWin,IDC_CHKAUTOWIDTH,edtopt.autowidth)
			CheckDlgButton(hWin,IDC_CHKAUTOINCLUDE,edtopt.autoinclude)
			CheckDlgButton(hWin,IDC_CHKCLOSEONLOCKS,edtopt.closeonlocks)
			CheckDlgButton(hWin,IDC_CHKTOOLTIP,edtopt.tooltip)
			CheckDlgButton(hWin,IDC_CHKSMARTMATHS,edtopt.smartmath)
			' Fonts
			GetObject(ah.rafnt.hFont,SizeOf(LOGFONT),@lfnt)
			hCFont=CreateFontIndirect(@lfnt)
			SendDlgItemMessage(hWin,IDC_STCCODEFONT,WM_SETFONT,Cast(Integer,hCFont),FALSE)
			GetObject(ah.rafnt.hLnrFont,SizeOf(LOGFONT),@lfnt)
			hLFont=CreateFontIndirect(@lfnt)
			SendDlgItemMessage(hWin,IDC_STCLNRFONT,WM_SETFONT,Cast(Integer,hLFont),FALSE)
			hBtnApply=GetDlgItem(hWin,IDC_BTNKWAPPLY)
			' Colors
			buff=sColors
			ofs=@fbcol
			Do While Len(buff)
				nInx=InStr(buff,",")
				If nInx=0 Then
					nInx=Len(buff)+1
				EndIf
				sItem=Left(buff,nInx-1)
				buff=Mid(buff,nInx+1)
				RtlMoveMemory(@col,ofs,4)
				nInx=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_ADDSTRING,0,Cast(Integer,@sItem))
				SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_SETITEMDATA,nInx,col)
				ofs=ofs+4
			Loop
			SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_SETCURSEL,0,0)
			' Keyword colors
			ofs=@kwcol
			nInx=0
			Do While nInx<19
				If nInx<12 Then
					sItem="C" & Str(nInx)
				ElseIf nInx=12 Then
					sItem="Data types"
				ElseIf nInx=13 Then
					sItem="Api struct"
				ElseIf nInx=14 Then
					sItem="Api const"
				ElseIf nInx=15 Then
					sItem="Api calls"
				ElseIf nInx=16 Then
					sItem="Custom1" 		'struct's project
				ElseIf nInx=17 Then
					sItem="Custom2" 		'const's project
				ElseIf nInx=18 Then
					sItem="Custom3" 		'sub/function's project
				EndIf
				RtlMoveMemory(@col,ofs,4)
				SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_ADDSTRING,0,Cast(Integer,@sItem))
				SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_SETITEMDATA,nInx,col)
				ofs=ofs+4
				nInx=nInx+1
			Loop
			SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_SETCURSEL,0,0)
			SetDlgItemText(hWin,IDC_EDTCODEFILES,@sCodeFiles)
			FillList(hWin)
			FillHold(hWin)
			EnableWindow(hBtnApply,FALSE)
			'
		Case WM_CLOSE
			EndDialog(hWin, 0)
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select Case Event
				Case BN_CLICKED
					Select Case id
						Case IDOK
							If IsWindowEnabled(hBtnApply) Then
								GetList(hWin)
								GetHold(hWin)
								SaveEditOpt(hWin)
							EndIf
							SendMessage(hWin,WM_CLOSE,0,0)
							'
						Case IDCANCEL
							SendMessage(hWin,WM_CLOSE,0,0)
							'
						Case IDC_BTNKWAPPLY
							GetList(hWin)
							GetHold(hWin)
							SaveEditOpt(hWin)
							EnableWindow(hBtnApply,FALSE)
							'
						Case IDC_BTNACTIVE
							nInx=0
							Do While TRUE
								col=SendDlgItemMessage(hWin,IDC_LSTKWHOLD,LB_GETSEL,nInx,0)
								If col=LB_ERR Then
									Exit Do
								ElseIf col Then
									SendDlgItemMessage(hWin,IDC_LSTKWHOLD,LB_GETTEXT,nInx,Cast(Integer,@buff))
									SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_ADDSTRING,0,Cast(Integer,@buff))
									SendDlgItemMessage(hWin,IDC_LSTKWHOLD,LB_DELETESTRING,nInx,0)
									EnableWindow(hBtnApply,TRUE)
								Else
									nInx=nInx+1
								EndIf
							Loop
							EnableWindow(GetDlgItem(hWin,IDC_BTNACTIVE),FALSE)
							'
						Case IDC_BTNHOLD
							nInx=0
							Do While TRUE
								col=SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_GETSEL,nInx,0)
								If col=LB_ERR Then
									Exit Do
								ElseIf col Then
									SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_GETTEXT,nInx,Cast(Integer,@buff))
									SendDlgItemMessage(hWin,IDC_LSTKWHOLD,LB_ADDSTRING,0,Cast(Integer,@buff))
									SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_DELETESTRING,nInx,0)
									EnableWindow(hBtnApply,TRUE)
								Else
									nInx=nInx+1
								EndIf
							Loop
							EnableWindow(GetDlgItem(hWin,IDC_BTNDEL),FALSE)
							EnableWindow(GetDlgItem(hWin,IDC_BTNHOLD),FALSE)
							'
						Case IDC_BTNADD
							GetDlgItemText(hWin,IDC_EDTKW,@buff,32)
							SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_ADDSTRING,0,Cast(Integer,@buff))
							SetDlgItemText(hWin,IDC_EDTKW,StrPtr(""))
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_BTNDEL
							nInx=0
							Do While TRUE
								col=SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_GETSEL,nInx,0)
								If col=LB_ERR Then
									Exit Do
								ElseIf col Then
									SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_DELETESTRING,nInx,0)
								Else
									nInx=nInx+1
								EndIf
							Loop
							nInx=SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_GETSELCOUNT,0,0)
							EnableWindow(GetDlgItem(hWin,IDC_BTNDEL),nInx)
							EnableWindow(GetDlgItem(hWin,IDC_BTNHOLD),nInx)
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKITALIC
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKBOLD
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKRCFILE
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKEXPAND
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKAUTOINDENT
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKHILITELINE
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKHILITECMNT
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKLINENUMBERS
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKSINGLEINSTANCE
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKBRACEMATCH
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKAUTOBRACE
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_RBNCASENONE
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_RBNCASEMIXED
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_RBNCASELOWER
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_RBNCASEUPPER
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKAUTOBLOCK
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKAUTOFORMAT
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKCODECOMPLETE
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKSAVE
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKAUTOLOAD
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKAUTOWIDTH
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKAUTOINCLUDE
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKTOOLTIP
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKCLOSEONLOCKS
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKSMARTMATHS
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_CHKCOLORBOLD
							EnableWindow(hBtnApply,TRUE)
							nInx=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETCURSEL,0,0)
							col=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETITEMDATA,nInx,0)
							col=col And (-1 Xor 2^24)
							If IsDlgButtonChecked(hWin,IDC_CHKCOLORBOLD) Then
								col=col Or 2^24
							EndIf
							SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_SETITEMDATA,nInx,col)
							'
						Case IDC_CHKCOLORITALIC
							EnableWindow(hBtnApply,TRUE)
							nInx=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETCURSEL,0,0)
							col=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETITEMDATA,nInx,0)
							col=col And (-1 Xor 2^25)
							If IsDlgButtonChecked(hWin,IDC_CHKCOLORITALIC) Then
								col=col Or 2^25
							EndIf
							SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_SETITEMDATA,nInx,col)
							'
						Case IDC_BTNCODEFONT
							GetObject(hCFont,SizeOf(LOGFONT),@lfnt)
							cf.lStructSize=SizeOf(cf)
							cf.hwndOwner=hWin
							cf.lpLogFont=@lfnt
							cf.Flags=CF_SCREENFONTS Or CF_INITTOLOGFONTSTRUCT
							If ChooseFont(@cf) Then
								DeleteObject(hCFont)
								hCFont=CreateFontIndirect(@lfnt)
								SendDlgItemMessage(hWin,IDC_STCCODEFONT,WM_SETFONT,Cast(Integer,hCFont),TRUE)
								EnableWindow(hBtnApply,TRUE)
							EndIf
							'
						Case IDC_BTNLNRFONT
							GetObject(hLFont,SizeOf(LOGFONT),@lfnt)
							cf.lStructSize=SizeOf(cf)
							cf.hwndOwner=hWin
							cf.lpLogFont=@lfnt
							cf.Flags=CF_SCREENFONTS Or CF_INITTOLOGFONTSTRUCT
							If ChooseFont(@cf) Then
								DeleteObject(hLFont)
								hLFont=CreateFontIndirect(@lfnt)
								SendDlgItemMessage(hWin,IDC_STCLNRFONT,WM_SETFONT,Cast(Integer,hLFont),TRUE)
								EnableWindow(hBtnApply,TRUE)
							EndIf
							'
						Case IDC_BTNSAVETHEME
							GetDlgItemText(hWin,IDC_EDTTHEME,@sItem,32)
							nInx=SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_ADDSTRING,0,Cast(Integer,@sItem))
							SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_SETCURSEL,nInx,0)
							thme(nInx).sztheme=sItem
							PutTheme(hWin,nInx)
							EnableWindow(hBtnApply,TRUE)
							'
					End Select
					'
				Case EN_CHANGE
					Select Case id
						Case IDC_EDTTABSIZE
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_EDTBACKUP
							EnableWindow(hBtnApply,TRUE)
							'
						Case IDC_EDTKW
							hCtl=GetDlgItem(hWin,IDC_BTNADD)
							EnableWindow(hCtl,GetDlgItemText(hWin,IDC_EDTKW,@buff,32))
							'
						Case IDC_EDTCODEFILES
							EnableWindow(hBtnApply,TRUE)
							'
					End Select
					'
				Case LBN_SELCHANGE
					Select Case id
						Case IDC_LSTKWCOLORS
							GetList(hWin)
							FillList(hWin)
							EnableWindow(GetDlgItem(hWin,IDC_BTNDEL),FALSE)
							EnableWindow(GetDlgItem(hWin,IDC_BTNHOLD),FALSE)
							'
						Case IDC_LSTKWACTIVE
							nInx=SendDlgItemMessage(hWin,IDC_LSTKWACTIVE,LB_GETSELCOUNT,0,0)
							EnableWindow(GetDlgItem(hWin,IDC_BTNDEL),nInx)
							EnableWindow(GetDlgItem(hWin,IDC_BTNHOLD),nInx)
							'
						Case IDC_LSTKWHOLD
							nInx=SendDlgItemMessage(hWin,IDC_LSTKWHOLD,LB_GETSELCOUNT,0,0)
							EnableWindow(GetDlgItem(hWin,IDC_BTNACTIVE),nInx)
							'
						Case IDC_CBOTHEME
							nInx=SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_GETCURSEL,0,0)
							x=SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_GETCOUNT,0,0)
							If x<16 And nInx=0 Then
								x=TRUE
							Else
								x=FALSE
							EndIf
							EnableWindow(GetDlgItem(hWin,IDC_BTNSAVETHEME),x)
							EnableWindow(GetDlgItem(hWin,IDC_EDTTHEME),x)
							SendDlgItemMessage(hWin,IDC_CBOTHEME,CB_GETLBTEXT,nInx,Cast(Integer,@sItem))
							SendDlgItemMessage(hWin,IDC_EDTTHEME,WM_SETTEXT,0,Cast(Integer,@sItem))
							If nInx Then
								GetTheme(hWin,nInx)
								EnableWindow(hBtnApply,TRUE)
							EndIf
							'
						Case IDC_LSTCOLORS
							nInx=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETCURSEL,0,0)
							If nInx=4 Or nInx=5 Or nInx=6 Or nInx=13 Then
								EnableWindow(GetDlgItem(hWin,IDC_CHKCOLORBOLD),TRUE)
								EnableWindow(GetDlgItem(hWin,IDC_CHKCOLORITALIC),TRUE)
							Else
								EnableWindow(GetDlgItem(hWin,IDC_CHKCOLORBOLD),FALSE)
								EnableWindow(GetDlgItem(hWin,IDC_CHKCOLORITALIC),FALSE)
							EndIf
							col=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETITEMDATA,nInx,0)
							CheckDlgButton(hWin,IDC_CHKCOLORBOLD,IIf(col And 2^24,BST_CHECKED,BST_UNCHECKED))
							CheckDlgButton(hWin,IDC_CHKCOLORITALIC,IIf(col And 2^25,BST_CHECKED,BST_UNCHECKED))
							'
					End Select
					'
				Case LBN_DBLCLK
					Select Case id
						Case IDC_LSTCOLORS
							cc.lStructSize=SizeOf(ChooseColor)
							cc.hwndOwner=hWin
							cc.hInstance=Cast(Any Ptr,hInstance)
							cc.lpCustColors=Cast(Any Ptr,@custcol)
							cc.Flags=CC_FULLOPEN Or CC_RGBINIT
							cc.lCustData=0
							cc.lpfnHook=0
							cc.lpTemplateName=0
							nInx=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETCURSEL,0,0)
							col=SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_GETITEMDATA,nInx,0)
							cc.rgbResult=col And &HFFFFFF
							If ChooseColor(@cc) Then
								col=(col And &HFF000000) Or cc.rgbResult
								SendDlgItemMessage(hWin,IDC_LSTCOLORS,LB_SETITEMDATA,nInx,col)
								InvalidateRect(GetDlgItem(hWin,IDC_LSTCOLORS),NULL,TRUE)
								EnableWindow(hBtnApply,TRUE)
							EndIf
							'
						Case IDC_LSTKWCOLORS
							cc.lStructSize=SizeOf(ChooseColor)
							cc.hwndOwner=hWin
							cc.hInstance=Cast(Any Ptr,hInstance)
							cc.lpCustColors=Cast(Any Ptr,@custcol)
							cc.Flags=CC_FULLOPEN Or CC_RGBINIT
							cc.lCustData=0
							cc.lpfnHook=0
							cc.lpTemplateName=0
							nInx=SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_GETCURSEL,0,0)
							col=SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_GETITEMDATA,nInx,0)
							cc.rgbResult=col And &HFFFFFF
							If ChooseColor(@cc) Then
								col=(col And &HFF000000) Or cc.rgbResult
								SendDlgItemMessage(hWin,IDC_LSTKWCOLORS,LB_SETITEMDATA,nInx,col)
								InvalidateRect(GetDlgItem(hWin,IDC_LSTKWCOLORS),NULL,TRUE)
								EnableWindow(hBtnApply,TRUE)
							EndIf
							'
					End Select
					'
			End Select
			'
		Case WM_DRAWITEM
			lpDRAWITEMSTRUCT=Cast(DRAWITEMSTRUCT Ptr,lParam)
			' Select back and text colors
			If lpDRAWITEMSTRUCT->itemState And ODS_SELECTED Then
				SetTextColor(lpDRAWITEMSTRUCT->hdc,GetSysColor(COLOR_HIGHLIGHTTEXT))
				SetBkColor(lpDRAWITEMSTRUCT->hdc,GetSysColor(COLOR_HIGHLIGHT))
			Else
				SetTextColor(lpDRAWITEMSTRUCT->hdc,GetSysColor(COLOR_WINDOWTEXT))
				SetBkColor(lpDRAWITEMSTRUCT->hdc,GetSysColor(COLOR_WINDOW))
			EndIf
			' Draw selected / unselected back color
			ExtTextOut(lpDRAWITEMSTRUCT->hdc,0,0,ETO_OPAQUE,@lpDRAWITEMSTRUCT->rcItem,NULL,0,NULL)
			' Draw the color
			rect.left=lpDRAWITEMSTRUCT->rcItem.left+1
			rect.right=rect.left+25
			rect.top=lpDRAWITEMSTRUCT->rcItem.top+1
			rect.bottom=lpDRAWITEMSTRUCT->rcItem.bottom-1
			hBr=CreateSolidBrush(lpDRAWITEMSTRUCT->itemData And &HFFFFFF)
			FillRect(lpDRAWITEMSTRUCT->hdc,@rect,hBr)
			DeleteObject(hBr)
			' Draw a black frame
			FrameRect(lpDRAWITEMSTRUCT->hdc,@rect,GetStockObject(BLACK_BRUSH))
			' Draw the text
			SendMessage(lpDRAWITEMSTRUCT->hwndItem,LB_GETTEXT,lpDRAWITEMSTRUCT->itemID,Cast(Integer,@sItem))
			TextOut(lpDRAWITEMSTRUCT->hdc,lpDRAWITEMSTRUCT->rcItem.left+30,lpDRAWITEMSTRUCT->rcItem.top,@sItem,Len(sItem))
			If lpDRAWITEMSTRUCT->hwndItem=GetFocus() Then
				' Let windows draw the focus rectangle
				Return FALSE
			EndIf
			'
		Case WM_CLOSE
			DeleteObject(hCFont)
			DeleteObject(hLFont)
			EndDialog(hWin, 0)
			'
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
