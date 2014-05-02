section .data
	msg     db      "hello world"
        len     dd      $-msg

section .text
	global  _start
_start:
        mov     eax,4           ; sys_write
        mov     ebx,1           ; stdout
        mov     ecx,msg
        mov     edx,[len]
        int     0x80
        
        mov     eax,1	        ; sys_exit
        mov     ebx,0	        ; 0
        int     0x80
