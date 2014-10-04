BUFSIZE equ     4096

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

        mov     rax,[bufptr]
        mov     rbx,[buflen]
        add     rbx,rax
        call    match_regex
        test    rcx,rcx
        jz      .skip

        mov     rax,1
        mov     rdi,1
        mov     rsi,[bufptr]
        mov     rdx,[buflen]
        syscall
.skip:   

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


match_regex:
        push    rbp
        mov     rbp,rsp

        push    0
        push    0
        
;;; ;;
        
  cmp  rax,rbx
  jge  .fail
  cmp  byte  [rax],'m'
  jne  .fail

  inc  rax
  push rax
  push .l1
  jmp  .l0
.l0:
.l3:
  push rax
  push .l5
  jmp  .l4
.l4:
  cmp  rax,rbx
  jge  .fail
  cmp  byte  [rax],'o'
  jne  .fail
  inc  rax
  jmp  .l3
.l5:
  jmp  .l2
.l1:
  cmp  rax,rbx
  jge  .fail
  cmp  byte  [rax],'u'
  jne  .fail
  inc  rax
  cmp  rax,rbx
  jge  .fail
  cmp  byte  [rax],'!'
  jne  .fail
  inc  rax
.l2:


;;; ;;
        mov     rsp,rbp
        pop     rbp
        
        mov     rcx,1
        ret

.fail:
        pop     rsi
        pop     rax
        test    rsi,rsi
        jnz     .skip
        
        mov     rsp,rbp
        pop     rbp
        
        mov     rcx,0
        ret

.skip:
        jmp     rsi
