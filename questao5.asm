org 0x7c00            ;
jmp 0x0000:start


.data:
    input times 8 db 0
    number times 8 db 0

_clear:
    xor ax, ax
    mov cx, 0
    mov dx, 0
    ret

_getchar:
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

_reverse:
    mov si, di
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
        mov di, 0
        call _printString

    
_gets:
    xor cx, cx
    .loop:
        call _getchar
        cmp al, 0x08
        je .backspace
        cmp al, 0x0d
        je .done
        cmp cl, 8
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

_stringToInt:

    xor cx, cx
    xor ax, ax

    .loop1:

        push ax
        lodsb
        mov cl, al
        pop ax
        cmp cl, 0
        je .endloop1

        sub cl, 48
        mov bx, 10
        mul bx
        add ax, cx
        jmp .loop1
    
    .endloop1:
        ret

_intToString:

    mov si, number
    lodsb
    push di

    .loop:
        cmp ax, 0
        je .endloop
        xor dx, dx
        mov bx, 10
        div bx
        xchg ax, dx
        jmp .loop

    .endloop:
        pop si
        cmp si, di
        jne .done
        mov al, 48
        stosb

    .done:
        mov al, 0
        stosb
        call _reverse
        ret


_triginput:

    mov si, number
    lodsb

    xor bx, bx
    mov bl, al
    add bl, 1
    mul bl

    xor bx, bx
    mov bl , 2
    div bl

    mov di, number
    stosb

    ret

start:

    call _clear
    mov di, input
    call _gets
    mov si, input
    call _stringToInt
    call _triginput
    mov si, input
    call _printString
    


times 510-($-$$) db 0
dw 0xaa55