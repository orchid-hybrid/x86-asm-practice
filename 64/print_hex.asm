section .bss
        hex_buffer resb 16+2
        hex_buffer_end resb 1

section .text
global _start
_start:
        mov rax,12    ;; brk
        xor rdi,rdi   ;; 0
        syscall
        
        ;mov rax,0x6549871456122343
        call print_hex
        
        xor rdi,rdi
        mov rax,60
        syscall

print_hex:
        push rax
        mov rsi,hex_buffer_end
        mov rdx,0
.loop:
        dec rsi
        inc rdx
        test rax,rax
        jz .done
        mov bl,0xF
        and byte bl,al
        cmp bl,9
        jle .skip
        add bl,'a'-'0'-10
.skip:
        add bl,'0'
        mov byte [rsi],bl
        shr rax,4
        jmp .loop
.done:
        mov byte [rsi],'x'
        dec rsi
        inc rdx
        mov byte [rsi],'0'
        mov rax,1
        mov rdi,1
        syscall
        pop rax
        ret
