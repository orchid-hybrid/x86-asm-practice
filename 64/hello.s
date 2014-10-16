section .data
    string1 db  "Hello World!",10,0

section .text
    global _start

    _start:
        ; calculate the length of string
        mov     rdi, dword string1
        mov     rcx, dword -1
        xor     al,al
        cld
        repnz scasb

        ; place the length of the string in RDX
        mov     rdx, dword -2
        sub     rdx, rcx

        ; print the string using write() system call 
        mov     rsi, dword string1
        push    0x1
        pop     rax
        mov     rdi,rax
        syscall

        ; exit from the application here
        xor     rdi,rdi
        push    0x3c
        pop     rax
        syscall
