org 0x0
bits 16

%define ENDL 0x0D, 0x0A

start:
    ; print hello world message
    mov si, msg_hello
    call puts

.halt:
    cli
    hlt

;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    ; save registers we will modify
    push si
    push ax
    push bx

.loop:
    lodsb               ; loads next character in al
    or al, al           ; verify if next character is null?
    jz .done            ; jumps to the .done label if the zero flag is set 
    
    mov ah, 0x0E        ; write character in TTY Mode
    mov bh, 0           ; set page number to 0
    int 0x10            ; bios video interrupt

    jmp .loop

.done:
    pop bx                ; popping registers off the stack and returns
    pop ax
    pop si
    ret

msg_hello: db 'Hello world from the kernel!', ENDL, 0       ; message to print using bios
