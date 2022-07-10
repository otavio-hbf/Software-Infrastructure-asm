org 0x7c00
jmp 0x0000:start

_clean:
    xor ax, ax
    mov cx, 0
    mov dx, 0
    ret

getchar:
    mov ah, 0x00
    int 16h
    ret

_putchar:
    mov ah, 0x0e
    int 10h
    ret

_delchar:
    mov al, 0x08
    call _putchar

    mov al, ''
    call _putchar

    mov al, 0x08
    call _putchar
ret

_printString:
    .loop:
        lodsb
        cmp al, 0
        je .endloop
        call _putchar
        jmp .loop

    .endloop:
        ret

_gets:
    xor cx, cx
    .loop:
        call getchar
        cmp al, 0x08
        je .backspace
        cmp al, 0x0d
        je .done
        cmp cl, 50
        je .loop
        stosb
        inc cl
        call _putchar
        jmp .loop

    .backspace:
        cmp cl, 0
        je .loop
        dec di
        dec cl
        mov byte[di], 0
        call _delchar
        jmp .loop

.done:
    mov al,0
    stosb
    ret

_reverse:
    mov di, si
    xor cx, cx

    .loop1:
        lodsb
        cmp al, 0
        je .endloop1
        inc cl
        push ax
        jmp .loop1

    .endloop1:

    .loop2:
        cmp cl, 0
        je .endloop2
        dec cl
        pop ax
        stosb
        jmp .loop2

        .endloop2:
        call _printString

start:
    call _clean
    call _gets
    call _reverse
    jmp end

end:
    jmp $

times 510 - ($ - $$) db 0
dw 0xaa55