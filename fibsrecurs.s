extern  print_number
        
section .text
	global  asm_main
asm_main:
        enter 0,0
        pusha

        push    dword 45
        call    fib
        add     esp,4

        push    ebp
        mov     ebp,esp
        push    eax
        call    print_number
        add     esp,4
        mov     esp,ebp
        pop     ebp
        
        popa
        mov     eax,0           ; return 0
        leave
        ret

fib:
        mov     eax,[esp+4]
        
        cmp     eax,0
        jne     skip_fib0
        ret
skip_fib0:      
        
        cmp     eax,1
        jne     skip_fib1
        ret
skip_fib1:
        
        dec     eax
        push    eax
        
        call    fib
        mov     ebx,eax
        
        pop     eax
        push    ebx             ;need to save ebx
        dec     eax
        push    eax
        call    fib
        add     esp,4
        mov     ebx,eax

        pop     eax
        add     eax,ebx

        ret
