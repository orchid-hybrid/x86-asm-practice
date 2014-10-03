BUFSIZE         equ     1024

section .data
        
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
        
        ;; print the string
        ;; rax=1 (sys_write),  rdi=1 (stdout),  rsi=buffer,  rdx=length
        mov     rax,1
        mov     rdi,1
        mov     rsi,buf
        mov     rdx,[len]
        syscall

        jmp     _start

done:   
        ;; exit
        xor     rdi,rdi
        mov     rax,60
        syscall
