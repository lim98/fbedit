
.const

szDefine					db '#define',0
szTypedef					db 'typedef',0
szStruct					db 'struct',0
szUnion						db 'union',0
szStatic					db 'static',0
szConst						db 'const',0
szFar						db 'far',0

;Skip
szUnaligned					db 'unaligned',0
szInclude					db '#include',0
szInline					db 'inline',0
szClass						db 'class',0
szEnum						db 'enum',0
szExtern					db 'extern',0
szIfdef						db '#ifdef',0
szIfndef					db '#ifndef',0
szIf						db '#if',0
szElif						db '#elif',0
szElse						db '#else',0
szEndif						db '#endif',0
szPragma					db '#pragma',0
szNew						db 'new',0
szUndef						db '#undef',0
szError						db '#error',0
szDECLARE_INTERFACE			db 'DECLARE_INTERFACE',0
szDECLARE_INTERFACE_		db 'DECLARE_INTERFACE_',0
szDECLARE_MAPI_INTERFACE_	db 'DECLARE_MAPI_INTERFACE_',0
szCppString					db '"',"'",0,0

.data?

cppbuff						db 16384 dup(?)
cppbuff1					db 16384 dup(?)
cppbuff2					db 16384 dup(?)
lpFunSt						dd ?
lpFunEn						dd ?
lpFunPos					dd ?

.code

CppDestroyString proc lpMem:DWORD

	mov		eax,lpMem
	movzx	ecx,byte ptr [eax]
	inc		eax
	.while byte ptr [eax]!=0 && byte ptr [eax]!=VK_RETURN
		mov		dx,[eax]
		.if dx==cx
			mov		word ptr [eax],'  '
			lea		eax,[eax+2]
		.else
			inc		eax
			.break .if dl==cl
			mov		byte ptr [eax-1],20h
		.endif
	.endw
	ret

CppDestroyString endp

CppDestroyCmntBlock proc uses esi,lpMem:DWORD
	LOCAL	buffer[512]:BYTE

	mov		esi,lpMem
	invoke strcpy,addr buffer,addr [ebx].RAPROPERTY.defgen.szCmntBlockSt
	invoke strlen,addr buffer
	.if eax
		.if word ptr buffer=="*/"
			.while byte ptr [esi]
				.if byte ptr [esi]=='"' || byte ptr [esi]=="'"
					invoke CppDestroyString,esi
					mov		esi,eax
				.elseif word ptr [esi]=="//"
					invoke DestroyToEol,esi
					mov		esi,eax
				.elseif word ptr [esi]=="*/"
					invoke SearchMemDown,addr [esi+2],addr [ebx].RAPROPERTY.defgen.szCmntBlockEn,FALSE,FALSE,[ebx].RAPROPERTY.lpchartab
					.if eax
						lea		edx,[eax+1]
						.while esi<=edx
							mov		al,[esi]
							.if al!=0Dh
								mov		byte ptr [esi],' '
							.endif
							inc		esi
						.endw
					.else
						invoke DestroyToEof,esi
						mov		esi,eax
					.endif
				.else
					inc		esi
				.endif
			.endw
		.endif
	.endif
	ret

CppDestroyCmntBlock endp

CppDestroyCommentsStrings proc uses esi,lpMem:DWORD

	mov		esi,lpMem
	mov		ecx,'//'
	mov		edx,dword ptr szCppString
	.while byte ptr [esi]
		.if word ptr [esi]==cx
			invoke DestroyToEol,esi
			mov		esi,eax
		.elseif byte ptr [esi]==dl
			invoke CppDestroyString,esi
			mov		esi,eax
			mov		ecx,'//'
			mov		edx,dword ptr szCppString
		.elseif byte ptr [esi]==VK_TAB
			mov		byte ptr [esi],VK_SPACE
		.else
			inc		esi
		.endif
	.endw
	ret

CppDestroyCommentsStrings endp

CppPreParse proc uses esi,lpMem:DWORD

	invoke CppDestroyCmntBlock,lpMem
	invoke CppDestroyCommentsStrings,lpMem
	ret

CppPreParse endp

SearchType proc uses esi,lpType:DWORD

	mov		esi,[ebx].RAPROPERTY.lpmem
	.while [esi].PROPERTIES.nSize
		movzx	eax,[esi].PROPERTIES.nType
		.if eax=='T' || eax=='t' || eax=='S' || eax=='s'
			call	CppCompare
			je		@f
		.endif
		mov		eax,[esi].PROPERTIES.nSize
		lea		esi,[esi+eax+sizeof PROPERTIES]
	.endw
  @@:
	ret

CppCompare:
	lea		edx,[esi+sizeof PROPERTIES]
	mov		ecx,lpType
  @@:
	mov		al,[ecx]
	mov		ah,[edx]
	inc		ecx
	inc		edx
	.if al>='a' && al<='z'
		and		al,5Fh
	.endif
	.if al>='a' && al<='z'
		and		al,5Fh
	.endif
	sub		al,ah
	jne		@f
	cmp		al,ah
	jne		@b
  @@:
	retn

SearchType endp

IsWord proc lpSrc:DWORD,nLen:DWORD,lpWord:DWORD,lpCharTab:DWORD

	invoke strlen,lpWord
	.if eax==nLen
		push	esi
		push	edi
		mov		esi,lpSrc
		mov		edi,lpWord
		mov		edx,lpCharTab
		xor		ecx,ecx
		xor		eax,eax
		inc		eax
		.while ecx<nLen
			movzx	eax,byte ptr [esi+ecx]
			.if al==[edi+ecx]
				xor		eax,eax
			.else
				movzx	eax,byte ptr [edx+eax+256]
				.if al==[edi+ecx]
					xor		eax,eax
				.else
					.break
				.endif
			.endif
			inc		ecx
		.endw
		pop		edi
		pop		esi
		.if !eax
			inc		eax
		.else
			xor		eax,eax
		.endif
	.else
		xor		eax,eax
	.endif
	ret

IsWord endp

CppSkipScope proc lpnpos:DWORD

	mov		edx,lpnpos
	xor		eax,eax
	xor		ecx,ecx
	call	CppSkipScope1
	ret

CppSkipScope1:
	mov		al,[esi]
	or		al,al
	je		@f
	inc		esi
	.if al==ah
		dec		ecx
		retn
	.elseif al=='['
		push	eax
		inc		ecx
		mov		ah,']'
		call	CppSkipScope1
		pop		eax
	.elseif al=='('
		push	eax
		inc		ecx
		mov		ah,')'
		call	CppSkipScope1
		pop		eax
	.elseif al=='{'
		; Begin / End
		push	eax
		inc		ecx
		mov		ah,'}'
		call	CppSkipScope1
		pop		eax
	.elseif al=='"' || al=="'"
		; String
		inc		ecx
		.while al!=[esi] && byte ptr [esi]
			.if byte ptr [esi]==VK_RETURN
				inc		dword ptr [edx]
			.endif
			inc		esi
		.endw
		.if al==[esi]
			inc		esi
			dec		ecx
		.endif
	.elseif al==VK_RETURN
		inc		dword ptr [edx]
	.endif
	or		ecx,ecx
	jne		CppSkipScope1
  @@:
	retn

CppSkipScope endp

CppSkipLine proc uses esi,lpMem:DWORD,lpnpos:DWORD

	mov		eax,lpMem
	mov 	ecx,'\'
	.while byte ptr [eax] && byte ptr [eax]!=VK_RETURN
		.if cl==byte ptr [eax]
			inc		eax
			.while byte ptr [eax]==VK_SPACE
				inc		eax
			.endw
			.if byte ptr [eax]==VK_RETURN
				mov		edx,lpnpos
				inc		dword ptr [edx]
				.if byte ptr [eax+1]==0Ah
					inc		eax
				.endif
			.endif
		.endif
		inc		eax
	.endw
	.if byte ptr [eax]==VK_RETURN
		inc		eax
	.endif
	.if byte ptr [eax]==0Ah
		inc		eax
	.endif
	ret

CppSkipLine endp

CppFixUnknown proc uses ebx esi edi

	mov		esi,[ebx].RAPROPERTY.lpmem
	.if esi
		.if ![ebx].RAPROPERTY.hMemArray
			; Setup array of pointers to T and S types
			invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,1024*1024*4
			mov		[ebx].RAPROPERTY.hMemArray,eax
		.endif
		mov		edi,[ebx].RAPROPERTY.hMemArray
		mov		edx,'TS'
		mov		ecx,'s'
		.while [esi].PROPERTIES.nSize
			mov		al,[esi].PROPERTIES.nType
			.if al==dl || al==dh || al==cl
				mov		[edi],esi
				lea		edi,[edi+4]
			.endif
			mov		eax,[esi].PROPERTIES.nSize
			lea		esi,[esi+eax+sizeof PROPERTIES]
		.endw
		mov		dword ptr [edi],0
		; Find U types and change it to d if found in array
		mov		esi,[ebx].RAPROPERTY.lpmem
		add		esi,[ebx].RAPROPERTY.rpproject
		.while [esi].PROPERTIES.nSize
			.if [esi].PROPERTIES.nType=='U'
				lea		ecx,[esi+sizeof PROPERTIES]
				.while byte ptr [ecx]
					inc		ecx
				.endw
				inc		ecx
				push	ebx
				mov		ebx,[ebx].RAPROPERTY.hMemArray
				xor		eax,eax
				.while dword ptr [ebx]
					mov		edi,[ebx]
					xor		edx,edx
				  @@:
					mov		al,[ecx+edx]
					mov		ah,[edi+edx+sizeof PROPERTIES]
					or		ah,ah
					je		@f
					inc		edx
					sub		al,ah
					je		@b
				  @@:
					.if !eax
						mov		[esi].PROPERTIES.nType,'d'
						.break
					.endif
					lea		ebx,[ebx+4]
				.endw
				pop		ebx
			.endif
			mov		eax,[esi].PROPERTIES.nSize
			lea		esi,[esi+eax+sizeof PROPERTIES]
		.endw
	.endif
	ret

CppFixUnknown endp

CppParseFile proc uses ebx esi edi,nOwner:DWORD,lpMem:DWORD
	LOCAL	len:DWORD
	LOCAL	lpFun:DWORD
	LOCAL	lpParamSt:DWORD
	LOCAL	lpParamEn:DWORD
	LOCAL	nNest:DWORD
	LOCAL	lpTemp:DWORD
	LOCAL	fTypedef:DWORD
	LOCAL	lpBegin:DWORD
	LOCAL	lpEnd:DWORD
	LOCAL	lpRet:DWORD
	LOCAL	lenRet:DWORD
	LOCAL	lpCharTab
	LOCAL	npos:DWORD
	LOCAL	nline:DWORD

	push	ebx
	mov		eax,[ebx].RAPROPERTY.lpchartab
	mov		lpCharTab,eax
	mov		esi,lpMem
	mov		npos,0
	mov		nNest,0
	.while byte ptr [esi]
		mov		eax,npos
		mov		nline,eax
		mov		fTypedef,0
		call	GetWrd
		.if len
;invoke PrintWord,esi,len
			mov		lpRet,esi
			call	_Skip
			or		eax,eax
			jne		Nxt
;			call	_Include
;			or		eax,eax
;			jne		Nxt
			call	_Constant
			or		eax,eax
			jne		Nxt
			call	_Typedef
			or		eax,eax
			jne		Nxt
			call	_Struct
			or		eax,eax
			jne		Nxt
			call	_Function
			or		eax,eax
			jne		Nxt
			call	_Unknown
		.else
			mov		al,[esi]
			.if al=='"' || al=='{' || al=='('
				invoke CppSkipScope,addr npos
			.elseif al==VK_RETURN
				inc		esi
				inc		dword ptr npos
			.else
				inc		esi
			.endif
		.endif
;		invoke CppSkipLine,esi,addr npos
;		inc		npos
;		mov		esi,eax
	  Nxt:
	.endw
	pop		ebx
	invoke CppFixUnknown
	ret

_Begin:
	mov		eax,esi
	mov		edx,npos
	.while byte ptr [esi]!=';' && byte ptr [esi]!='{' && byte ptr [esi]
		.if byte ptr [esi]==VK_RETURN
			inc		dword ptr npos
		.endif
		inc		esi
	.endw
	.if byte ptr [esi]!='{'
		mov		npos,edx
		mov		esi,eax
		xor		eax,eax
	.endif
	retn

GetArray:
	call	SkipSpc
	.if byte ptr [esi]=='['
		mov		ebx,esi
		invoke CppSkipScope,addr npos
		mov		eax,esi
		sub		eax,ebx
		.if eax==2
			mov		byte ptr [edi],'['
			inc		edi
			call	SkipSpc
			.if byte ptr [esi]=='='
				inc		esi
				call	SkipSpc
				.if byte ptr [esi]=='"' || byte ptr [esi]=="'"
					;szTest[]="Test";
					mov		ebx,esi
					invoke CppSkipScope,addr npos
					mov		eax,esi
					sub		eax,ebx
					dec		eax
					invoke DwToAscii,eax,edi
					invoke strlen,edi
					lea		edi,[edi+eax]
				.endif
			.endif
			mov		byte ptr [edi],']'
			inc		edi
		.else
			.while ebx<esi
				mov		al,[ebx]
				mov		[edi],al
				inc		ebx
				inc		edi
			.endw
		  @@:
			call	SkipSpc
			.if byte ptr [esi]=='['
				mov		byte ptr [edi-1],';'
				lea		ebx,[esi+1]
				invoke CppSkipScope,addr npos
				.while ebx<esi
					mov		al,[ebx]
					mov		[edi],al
					inc		ebx
					inc		edi
				.endw
				jmp		@b
			.endif
		.endif
	.endif
	retn

_Skip:
;PrintText "Skip"
	invoke IsWord,esi,len,offset szInline,lpCharTab
	or		eax,eax
	jne		SkipSc
	invoke IsWord,esi,len,offset szClass,lpCharTab
	or		eax,eax
	jne		SkipSc
	invoke IsWord,esi,len,offset szEnum,lpCharTab
	or		eax,eax
	jne		SkipSc
	invoke IsWord,esi,len,offset szDECLARE_INTERFACE,lpCharTab
	or		eax,eax
	jne		SkipSc
	invoke IsWord,esi,len,offset szDECLARE_INTERFACE_,lpCharTab
	or		eax,eax
	jne		SkipSc
	invoke IsWord,esi,len,offset szDECLARE_MAPI_INTERFACE_,lpCharTab
	or		eax,eax
	jne		SkipSc
_SkipDf:
	invoke IsWord,esi,len,offset szInclude,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szExtern,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szIfdef,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szIfndef,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szIf,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szElif,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szElse,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szEndif,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szPragma,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szUndef,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szError,lpCharTab
	or		eax,eax
	jne		SkipLn
	invoke IsWord,esi,len,offset szStatic,lpCharTab
	or		eax,eax
	jne		SkipWd
	invoke IsWord,esi,len,offset szConst,lpCharTab
	or		eax,eax
	jne		SkipWd
	xor		eax,eax
	retn
  SkipSc:
	add		esi,len
	call	_Begin
	.if eax
		invoke CppSkipScope,addr npos
	.endif
	mov		eax,TRUE
	retn
  SkipLn:
	.while byte ptr [esi]!=VK_RETURN && byte ptr [esi]
		inc		esi
	.endw
	.if byte ptr [esi]==VK_RETURN
		inc		esi
		inc		dword ptr npos
	.endif
	mov		eax,TRUE
	retn
  SkipWd:
	add		esi,len
	mov		eax,TRUE
	retn

_Typedef:
;PrintText "Typedef"
	; typedef LNG(ULONG);
	invoke IsWord,esi,len,offset szTypedef,lpCharTab
	.if eax
		mov		fTypedef,TRUE
		add		esi,len
		call	GetWrd
		call	_Struct
		.if !eax
			mov		ecx,len
			inc		ecx
			invoke strcpyn,offset cppbuff,esi,ecx
			add		esi,len
			call	GetWrd
			.if !ecx && byte ptr [esi]=='('
				inc		esi
				call	GetWrd
				.if ecx
					inc		ecx
					invoke strcpyn,offset cppbuff1,esi,ecx
					add		esi,len
					invoke strlen,offset cppbuff
					invoke strcpy,addr cppbuff[eax+1],offset cppbuff1
					mov		edx,'t'
					invoke AddWordToWordList,edx,nOwner,nline,npos,addr cppbuff,2
				.endif
			.endif
		.endif
		mov		eax,TRUE
		retn
	.endif
	xor		eax,eax
	retn

_Struct:
;PrintText "Struct"
	; typedef struct tagHEBMK
	; {
	;	HWND hWin;
	;	UINT nLine;
	; } HEBMK;
	invoke IsWord,esi,len,offset szUnaligned,lpCharTab
	.if eax
		add		esi,len
		call	GetWrd
	.endif
	invoke IsWord,esi,len,offset szStruct,lpCharTab
	.if !eax
		invoke IsWord,esi,len,offset szUnion,lpCharTab
	.endif
	.if eax
		add		esi,len
		call	GetWrd
		.if ecx
			.if !fTypedef
				inc		ecx
				invoke strcpyn,offset cppbuff,esi,ecx
			.endif
			add		esi,len
			call	_Begin
			.if eax
				push	esi
				invoke CppSkipScope,addr npos
				mov		edx,esi
				pop		esi
				.if !ecx
					mov		al,[edx]
					push	eax
					push	edx
					mov		byte ptr [edx],0
					mov		edi,offset cppbuff1
					mov		byte ptr [edi],0
					.while byte ptr [esi]
					  @@:
						call	GetWrd
						mov		ecx,len
						.if ecx
							inc		ecx
							invoke strcpyn,offset cppbuff2,esi,ecx
							add		esi,len
							call	GetWrd
							.if ecx
								inc		ecx
								invoke strcpyn,edi,esi,ecx
								invoke strlen,edi
								lea		edi,[edi+eax]
								call	GetArray
								mov		word ptr [edi],':'
								inc		edi
								xor		ecx,ecx
								.while cppbuff2[ecx]
									mov		al,cppbuff2[ecx]
									.if al>='a' && al<='z'
										and		al,5Fh
									.endif
									mov		[edi],al
									inc		ecx
									inc		edi
								.endw
								mov		word ptr [edi],','
								inc		edi
								add		esi,len
							.endif
						.else
							.if byte ptr [esi]=='('
								invoke CppSkipScope,addr npos
							.elseif byte ptr [esi]
								inc		esi
							.endif
						.endif
						call	SkipSpc
						.while byte ptr [esi]==';' || byte ptr [esi]==VK_RETURN
							.if byte ptr [esi]==VK_RETURN
								inc		dword ptr npos
							.endif
							inc		esi
						.endw
					.endw
					pop		esi
					pop		eax
					mov		[esi],al
					dec		edi
					.if byte ptr [edi]==','
						mov		byte ptr [edi],0
						.if fTypedef
							call	GetWrd
							.if ecx
								inc		ecx
								invoke strcpyn,offset cppbuff,esi,ecx
								add		esi,len
							.endif
						.endif
						invoke strlen,offset cppbuff
						invoke strcpy,addr cppbuff[eax+1],offset cppbuff1
						mov		edx,'s'
						invoke AddWordToWordList,edx,nOwner,nline,npos,addr cppbuff,2
						mov		eax,TRUE
					.endif
				.endif
			.endif
		.endif
		mov		eax,TRUE
		retn
	.endif
	xor		eax,eax
	retn

_Constant:
;PrintText "#define"
	; Constant
	; #define MYCONSTANT 0x01
	invoke IsWord,esi,len,offset szDefine,lpCharTab
	.if eax
		add		esi,len
		call	GetWrd
		inc		ecx
		invoke strcpyn,offset cppbuff,esi,ecx
		invoke IsWord,esi,len,offset szNew,lpCharTab
		.if eax
			jmp		SkipLn
		.endif
		add		esi,len
		call	GetWrd
		invoke strlen,offset cppbuff
		mov		ecx,len
		inc		ecx
		invoke strcpyn,addr cppbuff[eax+1],esi,ecx
		add		esi,len
		mov		edx,'c'
		invoke AddWordToWordList,edx,nOwner,nline,npos,addr cppbuff,2
		mov		eax,TRUE
	.endif
	retn

;_Include:
;;PrintText "#include"
;	; Include
;	; #include <windows.h>
;	; #include "MyInclude.h"
;	invoke IsWord,esi,len,offset szInclude,lpCharTab
;	.if eax
;		add		esi,len
;		call	SkipSpc
;		.if byte ptr [esi]=='"'
;			invoke CppSkipScope,addr npos
;		.elseif byte ptr [esi]=='<'
;			.while byte ptr [esi]!='>' && byte ptr [esi]!=VK_RETURN && byte ptr [esi]
;				inc		esi
;			.endw
;			.if byte ptr [esi]=='>'
;				inc		esi
;			.endif
;		.endif
;		mov		eax,TRUE
;	.endif
;	retn

_Function:
;PrintText "Function"
	; Function
	; int TestIt()
	; {
	; }
	mov		lpTemp,esi
	xor		edx,edx
	mov		lpFun,edx
	mov		lpParamSt,edx
	inc		edx
	.while byte ptr [esi]!=';' && byte ptr [esi]!='{' && byte ptr [esi]
	  @@:
		push	edx
		call	GetWrd
		pop		edx
		.if ecx
			mov		edi,esi
			add		esi,ecx
			jmp		@b
		.elseif byte ptr [esi]=='('
			mov		lpFun,edi
			mov		lpParamSt,esi
			invoke CppSkipScope,addr npos
			mov		lpParamEn,esi
			mov		edx,ecx
		.else
			.if byte ptr [esi]==VK_RETURN
				inc		esi
				inc		dword ptr npos
				.if byte ptr [esi]==0Ah
					inc		esi
				.endif
			.else
				jmp		@f
			.endif
		.endif
	.endw
	push	edx
	call	_Begin
	mov		lpBegin,esi
	mov		lpEnd,esi
	pop		edx
	.if eax && lpFun && !edx
		mov		eax,lpTemp
		.if eax<=lpFunPos
			mov		lpFunSt,eax
			mov		lpFunEn,-1
		.endif
		mov		lpTemp,esi
		mov		esi,lpFun
		call	GetWrd
		inc		ecx
		invoke strcpyn,offset cppbuff,esi,ecx
		invoke strlen,offset cppbuff
		lea		edi,cppbuff[eax+1]
		mov		dword ptr [edi],0
		mov		esi,lpParamSt
		inc		esi
		dec		lpParamEn
		.while esi<lpParamEn
			call	GetWrd
			mov		ebx,esi
			add		esi,len
			push	len
			call	GetWrd
			invoke IsWord,esi,len,offset szFar,lpCharTab
			.if eax
				add		esi,len
				pop		eax
				mov		eax,esi
				sub		eax,ebx
				push	eax
				call	GetWrd
			.endif
			.if !len
				push	esi
				xor		edx,edx
				.while byte ptr [esi]=='*'
					inc		edx
					inc		esi
				.endw
				push	edx
				call	GetWrd
				pop		edx
				pop		esi
				add		len,edx
				add		ecx,edx
			.endif
			pop		edx
			.if edx && len
				.while ecx
					mov		al,[esi]
					mov		[edi],al
					inc		esi
					inc		edi
					dec		ecx
				.endw
				mov		byte ptr [edi],':'
				inc		edi
				.while edx
					mov		al,[ebx]
					.if al>='a' && al<='z'
						and		al,5Fh
					.endif
					mov		[edi],al
					inc		ebx
					inc		edi
					dec		edx
				.endw
				call	GetWrd
				.if byte ptr [esi]==','
					inc		esi
					mov		byte ptr [edi],','
					inc		edi
				.endif
			.else
				.break
			.endif
		.endw
		mov		dword ptr [edi],0
		inc		edi
		mov		esi,lpTemp
		invoke CppSkipScope,addr npos
		.if lpFunEn==-1
			mov		lpFunEn,esi
			.if  esi>=lpFunPos
				ret
			.endif
		.endif
		push	esi
		xchg	esi,lpTemp
		.while esi<lpTemp
			call	GetWrd
			invoke IsWord,esi,ecx,offset szStatic,lpCharTab
			.if eax
				add		esi,len
				call	GetWrd
			.endif
			mov		ecx,len
			.if ecx
				inc		ecx
				invoke strcpyn,offset cppbuff2,esi,ecx
				add		esi,len
				call	GetWrd
				.if ecx
					invoke SearchType,offset cppbuff2
					.if !eax
					  NxtLocal:
						call	GetWrd
						.if ecx
							inc		ecx
							invoke strcpyn,edi,esi,ecx
							add		edi,len
							add		esi,len
							call	GetArray
							mov		byte ptr [edi],':'
							inc		edi
							xor		ecx,ecx
							.while cppbuff2[ecx]
								mov		al,cppbuff2[ecx]
								.if al>='a' && al<='z'
									and		al,5Fh
								.endif
								mov		[edi],al
								inc		ecx
								inc		edi
							.endw
							mov		word ptr [edi],','
							inc		edi
							.if byte ptr [esi]==','
								inc		esi
								jmp		NxtLocal
							.endif
						.endif
					.endif
				.endif
			.endif
			.while byte ptr [esi]!=VK_RETURN && byte ptr [esi]
				inc		esi
			.endw
			.if byte ptr [esi]==VK_RETURN
				inc		esi
				inc		dword ptr npos
			.endif
		.endw
		.if byte ptr [edi-1]==','
			mov		dword ptr [edi-1],0
		.else
			mov		dword ptr [edi-1],0
			inc		edi
		.endif
		mov		esi,lpRet
		call	GetWrd
		.while esi<lpFun
			invoke strcpyn,edi,esi,addr [ecx+1]
			add		edi,len
			mov		byte ptr [edi],' '
			inc		edi
			add		esi,len
			call	GetWrd
		.endw
		.if byte ptr [edi-1]==' '
			dec		edi
		.endif
		mov		dword ptr [edi],0
		pop		esi
		mov		edx,'p'
		invoke AddWordToWordList,edx,nOwner,nline,npos,addr cppbuff,4


		xor		ecx,ecx
		mov		edx,lpBegin
		inc		edx
		inc		ecx
		.while ecx
			.break .if !byte ptr [edx]
			.if byte ptr [edx]=='{'
				inc		ecx
			.elseif byte ptr [edx]=='}'
				dec		ecx
			.endif
			inc		edx
		.endw
		mov		lpEnd,edx
mov		esi,lpEnd
mov eax,TRUE
retn

		mov		edi,offset cppbuff
		invoke strlen,edi
		lea		edi,[edi+eax+1]
		mov		eax,lpBegin
		sub		eax,lpMem
		invoke DwToAscii,eax,edi
		invoke strlen,edi
		lea		edi,[edi+eax]
		mov		byte ptr [edi],','
		inc		edi
		mov		eax,lpEnd
		sub		eax,lpMem
		invoke DwToAscii,eax,edi
		invoke strlen,edi
		lea		edi,[edi+eax+1]
		mov		byte ptr [edi],','
		mov		edx,'l'
		invoke AddWordToWordList,edx,nOwner,nline,npos,addr cppbuff,2
		mov		eax,TRUE
		retn
	.endif
  @@:
	mov		esi,lpTemp
	call	GetWrd
	xor		eax,eax
	retn

_Unknown:
;PrintText "Unknown"
	; Datatype
	mov		ecx,len
	inc		ecx
	invoke strcpyn,offset cppbuff1,esi,ecx
	add		esi,len
	mov		lpTemp,esi
_Unknown1:
	.if byte ptr [esi]==VK_RETURN
		inc		esi
		inc		dword ptr npos
	.endif
	call	GetWrd
	.if ecx
		; Unknown (might be global data)
		; Name
		inc		ecx
		mov		edi,offset cppbuff
		invoke strcpyn,edi,esi,ecx
		add		esi,len
		add		edi,len
		call	SkipSpc
		.if byte ptr [esi]==VK_RETURN
			inc		esi
			inc		dword ptr npos
		.endif
		call	GetWrd
		mov		al,[esi]
		.if !ecx && al!='('
			call	GetArray
			mov		byte ptr [edi],':'
			inc		edi
			xor		ecx,ecx
			.while cppbuff1[ecx]
				mov		al,cppbuff1[ecx]
				.if al>='a' && al<='z'
					and		al,5Fh
				.endif
				mov		[edi],al
				inc		ecx
				inc		edi
			.endw
			mov		byte ptr [edi],0
			inc		edi
			invoke strcpy,edi,offset cppbuff1
			mov		edx,'U'
			invoke AddWordToWordList,edx,nOwner,nline,npos,addr cppbuff,2
			.if byte ptr [esi]=='='
				inc		esi
			.endif
			.if byte ptr [esi]=='"' || byte ptr [esi]=="'"
				invoke CppSkipScope,addr npos
			.endif
			.if byte ptr [esi]==','
				inc		esi
				jmp		_Unknown1
			.endif
		.endif
		.while byte ptr [esi]!=';' && byte ptr [esi]
			inc		esi
		.endw
		mov		eax,TRUE
		retn
	.endif
	mov		esi,lpTemp
	xor		eax,eax
	retn

SkipSpc:
	.while byte ptr [esi]==VK_SPACE || byte ptr [esi]==VK_TAB
		inc		esi
	.endw
	.if byte ptr [esi]=='\'
		inc		esi
		.while byte ptr [esi]!=VK_RETURN && byte ptr [esi]
			inc		esi
		.endw
		.if byte ptr [esi]==VK_RETURN
			inc		esi
			inc		dword ptr npos
			jmp		SkipSpc
		.endif
	.endif
	retn

GetWrd:
	call	SkipSpc
	mov		edx,lpCharTab
	xor		ecx,ecx
	dec		ecx
  @@:
	inc		ecx
	movzx	eax,byte ptr [esi+ecx]
	cmp		byte ptr [eax+edx],1
	je		@b
	cmp		eax,'+'
	je		@b
	cmp		eax,'-'
	je		@b
	cmp		eax,'#'
	je		@b
	.if word ptr [esi+ecx]=='::'
		inc		ecx
		jmp		@b
	.endif
	mov		len,ecx
	retn

CppParseFile endp

