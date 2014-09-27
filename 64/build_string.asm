section .data
        
section .bss
        string1 resb    64
string1_end:
        length  resq    1
        
section .text
        global _start

_start:
        call    print_number
        
        ;; print the string
        ;; rax=1 (sys_write),  rdi=1 (stdout),  rsi=buffer,  rdx=length
        mov     rax,1
        mov     rdi,1
        mov     rsi,string1
        mov     rdx,[length]
        syscall
        
        ;; exit
        xor     rdi,rdi
        mov     rax,60
        syscall

print_number:
        ;;
        mov     byte [string1+0],33
        mov     byte [string1+1],40
        mov     byte [string1+2],41

        mov     qword [length],3
        
        ret

