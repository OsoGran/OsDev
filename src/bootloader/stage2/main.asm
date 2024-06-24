 bits 16

section _ENTRY class=CODE

extern _cstart_
global entry

entry: 
  cli                                 
  ; setup stack 
  ; Small memory model, stack and data segment should be the same
  mov ax, ds                      ; Data segment set up by stage 1, mov into ax
  mov ss, ax                      ; Set stack segment to data segment
  mov sp, 0                       ; Set base and stack pointer to 0
  mov bp, sp
  sti                             ; allow interrupts again       

  ; expect boot drive in dl, send it as argument to cstart function
  xor dh, dh                      ; clearing high byte of dx, set to 0
  push dx                         ; push boot drive onto stack
  call _cstart_

  cli                             ; cli and halt if return from _cstart_
  hlt
