section .data
        string1 db  "true!",10,0
        string2 db  "fals!",10,0

section .text
        global _start

_start:
        call    true
        call    true
        call    false
        call    exit

true:   
        mov     rsi, dword string1
        push    0x1
        pop     rax
        mov     rdi, rax
        mov     rdx, 6
        syscall
        ret

false:  
        mov     rsi, dword string2
        push    0x1
        pop     rax
        mov     rdi, rax
        mov     rdx, 6
        syscall
        ret

exit:   
                                ; exit from the application here
        xor     rdi,rdi
        push    0x3c
        pop     rax
        syscall
