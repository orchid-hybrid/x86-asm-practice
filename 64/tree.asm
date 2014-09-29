section .data
        space   db     ' '
        open_str db     '('
        dot_str db     ' . '
        close_str db     ')'
        
section .bss
        string1 resb    64
string1_end:
        length  resq    1
        string  resq    1
        
section .text
        global _start

_start:
        push rbp
        mov rbp,rsp


        mov rax,1111
        shl rax,4
        or rax,0b0001
        push rax
        mov rax,333
        shl rax,4
        or rax,0b0001
        push rax
        mov rax,69
        shl rax,4
        or rax,0b0001
        push rax
        mov rax,45
        shl rax,4
        or rax,0b0001
        push rax
        mov rax,rbp
        sub rax,32
        push rax
        mov rax,rbp
        sub rax,24
        shl rax,4
        push rax
        mov rax,33
        shl rax,4
        or rax,0b0001
        push rax
        mov rax,77
        shl rax,4
        or rax,0b0001
        push rax
        mov rax,rbp
        sub rax,64
        push rax
        mov rax,rbp
        sub rax,56
        shl rax,4
        push rax
        mov rax,rbp
        sub rax,80
        push rax
        mov rax,rbp
        sub rax,48
        shl rax,4
        push rax
        mov rax,rbp
        sub rax,96
        push rax
        mov rax,rbp
        sub rax,16
        shl rax,4
        push rax
        mov rax,2222
        shl rax,4
        or rax,0b0001
        push rax
        mov rax,rbp
        sub rax,120
        push rax
        mov rax,rbp
        sub rax,112
        shl rax,4
        push rax
        mov rax,rbp
        sub rax,136
        push rax
        mov rax,rbp
        sub rax,8
        shl rax,4
        push rax
        mov rax,rbp
        sub rax,152

        call print_tree
        
        
;;; to view stack:
        ;; x/64xg $rbp-64
        ;; 
        ;; (gdb) x/g 0x00007fffffffe628
        ;; 0x7fffffffe628:	0x00000000080000de
        ;; (gdb) x/g 0x00007fffffffe630
        ;; 0x7fffffffe630:	0x000000000800006f
        ;; looks good!
        
        ;; exit
        xor     rdi,rdi
        mov     rax,60
        syscall



print_tree:
        mov     rbx,[rax]
        mov     rcx,rbx
        and     rbx,0xF
        test    rbx,rbx

        jnz     .number

        ;; cons

        mov     rbx,rcx
        mov     rcx,[rax+8]
        push    rcx
        push    rbx
        
        mov     rax,1
        mov     rdi,1
        mov     rsi,open_str
        mov     rdx,1
        syscall

        pop     rax
        shr     rax,4
        call    print_tree

        mov     rax,1
        mov     rdi,1
        mov     rsi,dot_str
        mov     rdx,3
        syscall

        pop     rax
        call    print_tree

        mov     rax,1
        mov     rdi,1
        mov     rsi,close_str
        mov     rdx,1
        syscall

        ret

.number:
        mov     rax,rcx
        shr     rax,4
        call    print_number

        ret
        
        
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

        ;; print the string
        ;; rax=1 (sys_write),  rdi=1 (stdout),  rsi=buffer,  rdx=length
        mov     rax,1
        mov     rdi,1
        mov     rsi,[string]
        mov     rdx,[length]
        syscall
        
        ret
