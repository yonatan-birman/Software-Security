[bits 32]

jmp begin

; eax, ebx = ptr to strs
; ret eax=0 equal
CmpStr:
    push ebx
    push ecx
    mov ecx, eax
    xor eax, eax
CmpStrLoop:
    mov al, [ecx]
    cmp al, [ebx]
    jne CmpStrEnd
    test al, al
    jz CmpStrEnd
    inc ecx
    inc ebx
    jmp CmpStrLoop
CmpStrEnd:
    pop ecx
    pop ebx
    ret

; eax = ptr to str
; ret eax
GetExportByName:
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ebx, eax

    xor ecx, ecx
    mov ecx, fs:[ecx + 0x30]    ; eax = PEB
    add ecx, 8
    mov ecx, [ecx + 4]         ; eax = _PEB_LDR_DATA
    add ecx, 8
    mov ecx, [ecx + 4]         ; eax = process
    dec ecx
    mov ecx, [ecx + 1]          ; eax = ntdll.dll

    mov ecx, [ecx + 0x18]       ; ecx = ntdll.dll base
    mov edx, [ecx + 0x3C]       ; edx = header offset
    mov edx, [ecx + edx + 0x78] ; edx = export table offset

    inc edx
    mov esi, [ecx + edx + 0x1F] ; esi = names offset
    dec edx
    add esi, ecx                ; esi = names address
    mov edi, -1
GetExportByNameLoop:
    inc edi
    mov eax, [esi + edi * 4]
    add eax, ecx
    call CmpStr
    test eax, eax
    jnz GetExportByNameLoop

    ; now edi = name index
    mov esi, [ecx + edx + 0x24] ; esi = names ordinals offset
    add esi, ecx                ; esi = address of names ordinals
    xor eax, eax
    mov ax, [esi + edi * 2]    ; eax = ordinal

    mov esi, [ecx + edx + 0x1c] ; esi = address of funtions offset
    add esi, ecx                ; esi = address of address of functions
    mov eax, [esi + eax * 4]    ; eax = offset of function
    add eax, ecx                ; eax = address of function

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    ret

begin:
    mov eax, esp
    sub ah, 8
    mov esp, eax

    ; allocate space for parameters
    sub esp, 16

    ; get address of NtQuerySystemTime
    push 'meSy'
    push 'stem'
    push 'TimQ'
    mov eax, esp
    call GetExportByName

    ; call NtQuerySystemTime
    push esp
    call eax
	
	; calculate current year
    mov ecx, [esp]
    mov ebx, [esp+4]
    mov eax, ebx
    mov edx, 0
	mov ebx, 600000000
    div ebx ; divide by 10^8
	mov ebx, 525600
    ; mov edx, 0
    div ebx ; divide by minutes in a year
    add eax, 1601 ; add offset for year 0

    ; prepare format string for printf
    push eax
    push '%d'
    mov eax, esp

    ; call printf
    push eax
    mov eax, 0x772F5DF0 ; address of printf
    call eax

    ; clean up stack and exit
    add esp, 20 ; remove parameters from stack
    xor eax, eax ; set exit code to 0
    ret ; exit program