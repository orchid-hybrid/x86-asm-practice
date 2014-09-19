        section .data
buflen: dd      10
        
        section .bss
num:    resd    1               ; the number to print

start:    resd    1               ; where the string starts
len:    resd    1               ; how long the string is

buf:    resb    10
bufend: ; buffer of size 10 to hold the characters

section .text
	global  _start
_start:
        mov     dword [num], 2923165534

        call    print_number
        
        mov     eax,4           ; sys_write
        mov     ebx,1           ; stdout
        mov     ecx,[start]       ; start points to a buffer
        mov     edx,[len]
        int     0x80
        
        mov     eax,1	        ; sys_exit
        mov     ebx,0	        ; 0
        int     0x80

print_number:
        ;; This procedure:
        ;; Input: a number in the variable num
        ;; Output: writes the string into the end of buf
        ;;         gives the length of the string
        ;;         gives a pointer (start) to the start
        ;; Uses: ecx to store the pointer
        ;;       eax to hold the number
        ;;       the remainder of division is computed into edx

;;;  Reference:
;;;         numbers start at ascii 0x30
;;; 
;;;         DIV: unsigned divide
;;;         dividend 	                AX 	DX:AX 	EDX:EAX
;;;         remainder stored in: 	AH 	DX 	EDX
;;;         quotient stored in: 	AL 	AX 	EAX
;;; 
;;;         CDQ:
;;;         Converts signed DWORD in EAX to a signed quad word in EDX:EAX by
;;;         extending the high order bit of EAX throughout EDX
;;;
        mov     ecx,bufend
        mov     dword [len],0
        
        mov     eax,[num]
        cdq

        mov     ebx,10
        
print_number_loop:
        
        mov     edx,0
        div     ebx
        
        add     dl,'0'
        dec     ecx
        mov     byte [ecx],dl
        inc     dword [len]

        test    eax,eax
        jne     print_number_loop

        mov     dword [start],ecx
        
        ret


        ;; $ ./print_number
        ;; 2923165534
