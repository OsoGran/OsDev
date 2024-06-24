bits 16

section _TEXT class=CODE

;
; int 10h ah=0Eh
; args: character, page
;
global _x86_Video_WriteCharTeletype
_x86_Video_WriteCharTeletype:

  ; make new call frame 
  ;   BP: base pointer, reg that points to base of stack
  ;   frame's data in the stack segment. BP mainly helps in referencing the
  ;   parameter variables passed to a subroutine. Points at some place on
  ;   the stack)
  ;   
  ;   SP: stack pointer, points at the top of the stack
  ;   SS: stack segment, holds the segment used by the stack
  push bp                             ; save old call frame
  mov bp, sp                          ; init new call frame

  ; save bx (will be manipulating it to print to screen)
  push bx
  
  ; [bp + 0] - old call frame
  ; [bp + 2] - return address (small memory model => 2 bytes)
  ; [bp + 4] - first argument (character)
  ; [bp + 6] - second argument (page)
  ; note: bytes aren't converted to words (you can't push a single byte on the stack)
  ; note: the following is setup for calling int 10h (bios interrupt 10)
  ;         ah: bios function
  mov ah, 0Eh                         ; ah contains the bios function
  mov al, [bp + 4]                    ; al contains the character to print
  mov bh, [bp + 6]                    ; bh contains the page

  int 10h

  ; restore bx
  pop bx

  ; restore old call frame
  mov sp, bp                          ; moves the top of the stack to base
  pop bp                              ; pops previous base from old frame
  ret
