section .data
        string1 db  "true!",10,0
        string2 db  "fals!",10,0

section .text
        global _start

_start:
        or      bl,-1           ;truth
        call    truth
        
        xor     bl,bl           ;false
        call    truth

        or      bl,-1           ;not true
        not     bl
        test    bl,bl
        call    truth
        
        xor     bl,bl           ;not false
        not     bl
        test    bl,bl
        call    truth

        or      al,-1           ;and true true
        or      bl,-1
        call    logic_and
        call    truth
        
        or      al,-1           ;and true false
        xor     bl,bl
        call    logic_and
        call    truth
        
        xor     al,al           ;and false true
        or      bl,-1
        call    logic_and
        call    truth
        
        xor     al,al           ;and false false
        xor     bl,bl
        call    logic_and
        call    truth

        or      al,-1           ;or true true
        or      bl,-1
        call    logic_or
        call    truth
        
        or      al,-1           ;or true false
        xor     bl,bl
        call    logic_or
        call    truth
        
        xor     al,al           ;or false true
        or      bl,-1
        call    logic_or
        call    truth
        
        xor     al,al           ;or false false
        xor     bl,bl
        call    logic_or
        call    truth

        mov     rax,3547
        mov     rbx,1247
        call    logic_compare
        call    truth
        
        mov     rax,1247
        mov     rbx,3547
        call    logic_compare
        call    truth
        
        call    exit

logic_compare:
        cmp     rax,rbx
        cmovl   bl,-1
        ret

logic_and:
;;;  Perform logical and of al with bl
;;; <COMPUTE AL HERE>
        test    al,al
        jz      .and            ;short circuit, dont compute bl if we know al false
;;; <COMPUTE BL HERE>
        test    bl,bl
        .and:
        ret

logic_or:
;;;  Perform logical and of al with bl
;;; <COMPUTE AL HERE>
        test    al,al
        jnz     .or            ;short circuit, dont compute bl if we know al true
;;; <COMPUTE BL HERE>
        test    bl,bl
        .or:
        ret

truth:
        jz      .truth1
        call    true
        jmp     .truth2
        .truth1:
        call    false
        .truth2:
        
        ret

true:   
        mov     rsi, dword string1
        push    0x1
        pop     rax
        mov     rdi, rax
        mov     rdx, 6
        syscall
        ret

false:  
        mov     rsi, dword string2
        push    0x1
        pop     rax
        mov     rdi, rax
        mov     rdx, 6
        syscall
        ret

exit:   
                                ; exit from the application here
        xor     rdi,rdi
        push    0x3c
        pop     rax
        syscall
