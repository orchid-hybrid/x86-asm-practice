BUFSIZE         equ     1024

section .data
        nl      db      0x0A

section .bss
        len     resq    1
        buf     resb    BUFSIZE
        
section .text
        global _start

_start:
        mov     rax,0           ; read
        mov     rdi,0
        mov     rsi,buf
        mov     rdx,BUFSIZE
        syscall
        test    rax,rax
        jz      done
        dec     rax             ; strip newline
        mov     [len],rax

        mov     rax,buf

        cmp     byte [rax],'m'
        jne     _start
        inc     rax
        
label_o:        
        cmp     byte [rax],'o'
        jne     bang
        inc     rax
        jmp     label_o

bang:   
        
        cmp     byte [rax],'!'
        jne     _start
        inc     rax
        
        ;; print the string
        ;; rax=1 (sys_write),  rdi=1 (stdout),  rsi=buffer,  rdx=length
        mov     rax,1
        mov     rdi,1
        mov     rsi,buf
        mov     rdx,[len]
        syscall

        mov     rax,1
        mov     rdi,1
        mov     rsi,nl
        mov     rdx,1
        syscall

        jmp     _start

done:   
        ;; exit
        xor     rdi,rdi
        mov     rax,60
        syscall
