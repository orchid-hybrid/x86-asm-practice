section .data
        
section .bss
        string1 resb    64
string1_end:
        length  resq    1
        string  resq    1
        
section .text
        global _start

_start:
        mov     rax,3954281
        call    print_number
        
        ;; print the string
        ;; rax=1 (sys_write),  rdi=1 (stdout),  rsi=buffer,  rdx=length
        mov     rax,1
        mov     rdi,1
        mov     rsi,[string]
        mov     rdx,[length]
        syscall
        
        ;; exit
        xor     rdi,rdi
        mov     rax,60
        syscall

print_number:
;;; http://tptp.cc/mirrors/siyobik.info/instruction/CWD%252FCDQ%252FCQO.html
        mov     rcx,string1_end
        mov     rsi,0
        mov     rbx,10
        ;; cqo
.loop:
        mov     rdx,0
        idiv    rbx             ; rax=quotient, rdx=remainder

        dec     rcx
        inc     rsi
        add     rdx,'0'
        mov     byte [rcx],dl
        
        test    rax,rax
        jnz      .loop
        
.done:
        mov     qword [string],rcx
        mov     qword [length],rsi
        
        ret

