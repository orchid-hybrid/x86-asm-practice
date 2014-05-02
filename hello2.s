extern  puts

section .data
	msg     db      "hello world",0

section .text
	global  asm_main
asm_main:
        enter 0,0
        pusha                   ; push all registers

        push    ebp             ; save ebp onto the stack
        mov     ebp,esp         ; save the stack pointer in ebp
        push    msg             ; push argument onto the stack
        call    puts
        add     esp,4	        ; skip past 'msg' on the stack
        mov     esp,ebp         ; reset the stack???
        pop     ebp             ; restore ebp
        
        popa
        mov     eax,0           ; return 0
        leave
        ret
