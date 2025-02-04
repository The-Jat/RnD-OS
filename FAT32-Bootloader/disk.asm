[bits 16]

;-------------------------------------------------------------------------------
; DISK ADDRESS PACKET
dap:
    db 10h                     ; Size of Packet, 16B
    db 0                       ; Reserved
dap_sector_count: dw 28        ; Number of Sectors to Read
dap_offset:       dw 0x1000    ; Read Buffer Offset
dap_segment:      dw 0         ; Read Buffer Segment
dap_lba_lo:       dd 0         ; LBA lower 32 bit
dap_lba_hi:       dd 0         ; LBA higher 32 bit
;-------------------------------------------------------------------------------

read_sectors_lba:
    pusha
    mov dl, 0x80   ; Should be 0x80
    mov ah, 42h    ; Extended Read Sectors
    mov si, dap
    int 13h        ; Read Sectors
    jc .error

.success:
    mov ah, 0xe    ; Print function
    mov al, '.'    ; Print dot(.) character
    int 0x10       ; Trigger interrupt
    popa           ; Restore saved state of all general-purpose registers
ret

.error:
    ; Carry Flag Set
    mov al, '!'
    int 0x10
    cli
    hlt
    jmp $ ; Can't do anything, stay put

;-------------------------------------------------------------------------------
; Convert Cluster Number in AX to LBA Value
cluster_to_lba:
    ; First Two Clusters always reserved
    sub ax, 2
    ; Multiply by number of sectors to get our LBA count
    xor bx, bx
    mov bl, byte [sectors_per_cluster]
    mul bx
    add ax, word [reserved_sectors]
    ; THIS IS NOT PORTABLE.
    ; DO NOT ASSUME THERE ARE TWO FATS BY DEFAULT.
    add ax, [ebpb_sectors_per_fat]
    add ax, [ebpb_sectors_per_fat]
ret
;-------------------------------------------------------------------------------
