BUFSIZE equ 13
        
section .data
        nl db 0xA
        
section .bss
        buf resb BUFSIZE
        bufptr resq 1

        hex_buffer resb 16+2
        hex_buffer_end resb 1

section .text
global _start
_start:
        call sys_read
        test rax,rax
        jbe die
        push rax
        call print_buf
        call newline
        pop rax
        push rax
        call print_hex
        call newline
        pop rax
        cmp rax,0
        jne _start
die:
        call sys_exit
        
sys_read:
        xor rax,rax
        mov rdi,0
        mov rsi,buf
        mov rdx,BUFSIZE
        syscall
        ret

sys_exit:
        xor rdi,rdi
        mov rax,60
        syscall

newline:
        mov rax,1
        mov rdx,1
        mov rsi,nl
        mov rdi,1
        syscall
        ret

print_buf:
        push rax
        mov rax,1
        mov rdi,1
        mov rsi,buf
        pop rdx
        syscall
        ret

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
        dec rsi
        inc rdx
        mov byte [rsi],'x'
        dec rsi
        inc rdx
        mov byte [rsi],'0'
        mov rax,1
        mov rdi,1
        syscall
        pop rax
        ret
