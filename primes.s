extern  print_number
extern  puts

section .data
        msg     db      "LETS PRIMES.. 2",0

section .bss
prm:    resd    1
num:    resd    1
mem:    resd    130000

section .text
        global asm_main
asm_main:
        enter   0,0
        pusha

        push    ebp
        mov     ebp,esp
        push    msg
        call    puts
        add     esp,4
        pop     ebp

        mov     dword [num],0
        mov     dword [prm],3

.loop:
        ;; Here we put the prime we found
        ;; into the list of primes
        mov     eax,[prm]
        inc     dword [num]
        mov     ebx,[num]
        mov     [mem+4*ebx],eax
        
        mov     ebp,esp
        push    eax
        call    print_number
        add     esp,4
        
        call    next_prime
        jmp     .loop
        
        popa
        mov     eax,0           ; return 0
        leave
        ret

next_prime:
        add     dword [prm],2

        mov     ebx,0
.loop:
        inc     ebx
        
        mov     eax,[prm]
        mov     ecx,[mem+4*ebx]
        mov     edx,0
        div     ecx             ; eax/(ecx:edx)
        cmp     edx,0
        je      next_prime
        
        cmp     ebx,[num]
        jne     .loop
        
        ret
