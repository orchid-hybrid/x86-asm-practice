num_primes      equ     5000
        
section .data
        space   db     ' '
        
section .bss
        string1 resb    64
string1_end:
        length  resq    1
        string  resq    1

        primes  resb    num_primes
        
section .text
        global _start

_start:
        call    sieve

        push    1
.loop:
        pop     rax
        inc     rax
        cmp     rax,num_primes
        jge     .done
        push    rax
        
        mov     byte bl,[primes+rax]
        test    bl,bl
        jnz     .loop
        
        call    print_number
        
        ;; print the string
        ;; rax=1 (sys_write),  rdi=1 (stdout),  rsi=buffer,  rdx=length
        mov     rax,1
        mov     rdi,1
        mov     rsi,[string]
        mov     rdx,[length]
        syscall
        
        mov     rax,1
        mov     rdi,1
        mov     rsi,space
        mov     rdx,1
        syscall
        
        jmp     .loop
.done:   
        
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


sieve:
        mov     rsi,2
.sieve_loop:
        mov     byte al,[primes+rsi]
        test    al,al
        jz      .sieve_step
        inc     rsi
        jmp     .sieve_loop
        
.sieve_step:
        mov     bl,1
        mov     rax,rsi

.loop:   
        add     rax,rsi
        cmp     rax,num_primes
        jge     .done
        mov     byte [primes+rax],bl
        jmp     .loop
.done:   
        inc     rsi
        cmp     rsi,100
        jle     .sieve_loop
        
        ret
