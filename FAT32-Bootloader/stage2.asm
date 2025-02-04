BITS 32
ORG 0x10000

stage2:
    mov esi, 0xb8000
    mov byte [esi], '7'
    mov byte [esi + 1], 0x07

jmp $
