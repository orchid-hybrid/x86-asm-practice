extern  print_number
        
section .text
	global  asm_main
asm_main:
        enter 0,0
        pusha

        ;; The loop instruction decrements ECX and jumps to the address specified by arg unless decrementing ECX caused its value to become zero.
;;; calculate fib(ecx), must be 2 or more
        mov     ecx,1507

        mov     eax,0
        mov     ebx,1
        dec     ecx
        
iter:
        mov     edx,ebx
        add     ebx,eax
        mov     eax,edx
        loop    iter

        push    ebp
        mov     ebp,esp
        push    ebx
        call    print_number
        add     esp,4
        mov     esp,ebp
        pop     ebp
        
        popa
        mov     eax,0           ; return 0
        leave
        ret
