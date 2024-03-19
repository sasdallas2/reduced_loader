; =======================================================
; start.asm - Startpoint for reduced_loader (after MBR)
; =======================================================

org 0x0                                         ; MBR loads us at 0x0
bits 16                                         ; 16-bit

jmp main

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


loading_msg db "reduced_loader is starting...", 0