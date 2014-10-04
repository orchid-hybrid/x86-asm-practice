BUFSIZE equ     1024

section .data

section .bss
        buf     resb    BUFSIZE
        bufend  resq    1

        bufptr  resq    1
        buflen  resq    1

section .text
        global _start

_start:
        call    read_data
.lines:
        call    find_line

;;; ;;;;;;

        mov     rax,1
        mov     rdi,1
        mov     rsi,[bufptr]
        mov     rdx,[buflen]
        syscall

;;; ;;;;;;;

        ;; move on to the next line
        mov     rdx,[buflen]
        add     [bufptr],rdx

        jmp     .lines
        
        call    exit_program

read_data:      
        mov     rax,0
        mov     rdi,0
        mov     rsi,buf
        mov     rdx,BUFSIZE
        syscall
        test    rax,rax
        jz      exit_program

        add     rax,buf
        mov     [bufend],rax
        mov     qword [bufptr],buf
        
        ret
exit_program:   
        xor     rdi,rdi
        mov     rax,60
        syscall

find_line:
        mov     rax,[bufptr]
        mov     rdx,[bufend]
        
        cmp     rax,rdx         ;this dies if the file isn't nl terminated
        jge     exit_program    ;it should be inside the loop for that, but then you'd want to handle that properly, emacs wont let me create a file that doesnt end in newline so I can't test it
        
.loop:
        cmp     byte [rax],0xA
        je      .done
        inc     rax
        jmp     .loop
.done:
        mov     rbx,rax
        sub     rbx,[bufptr]
        inc     rbx             ;keep the newline
        mov     [buflen],rbx
        ret
