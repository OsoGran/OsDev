org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
    jmp main

;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb               ; loads next character in al
    or al, al           ; verify if next character is null?
    jz .done            ; jumps to the .done label if the zero flag is set 
    mov ah, 0x0e        ; write character in TTY Mode
    mov bh, 0           ; set page number to 0
    int 0x10            ; bios video interrupt
    jmp .loop

.done:
    pop ax                ; popping registers off the stack and returns
    pop si
    ret

main: 
    
    ; setup data segments
    mov ax, 0           ; can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00      ; stack grows downwards from where we are loaded in memory

    ; print message
    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp .halt


msg_hello: db 'Hello world!', ENDL, 0       ; message to print using bios


times 510-($-$$) db 0
dw 0AA55h
