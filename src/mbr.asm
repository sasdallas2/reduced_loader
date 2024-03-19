; ============================================================
; mbr.asm - The Master Boot Record loader for reduced_loader
; ============================================================
; (c) sasdallas, 2024

org 0x7c00                              ; Loaded in by BIOS at 0x7c00
bits 16                                 ; We start at 16-bit

start: jmp main                         ; Jump to main

; OEM Parameter Block for FAT/MBR
TIMES 0Bh-$+start DB 0
 
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	DB 2
bpbRootEntries: 	DW 224
bpbTotalSectors: 	DW 2880
bpbMedia: 	        DB 0xF0
bpbSectorsPerFAT: 	DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors:       DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 	        DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "reduced_ldr"
bsFileSystem: 	        DB "FAT12   "

print:
  mov ah, 0eh
.loop:
  lodsb                                 ; Load character from SI buffer
  or al, al                             ; Is it a zero?
  jz .print_done                        ; Done printing :D 
  int 10h                               ; Call BIOS
  jmp .loop                             ; Loop!
.print_done:
  ret                                   ; Return  



main:
  xor ax, ax                            ; Clear AX for use in DS and SS
  mov ds, ax                            ; Don't setup a 'proper' stack
  mov ss, ax

  ; Print loading message
  mov si, loading_msg
  call print

  cli                                   ; Clear interrupts
  hlt                                   ; Halt system


loading_msg db "Loading OS...", 0


times 510 - ($-$$) db 0                 ; Padding for size
dw 0xAA55                               ; Boot signature for BIOS
