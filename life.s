        
;;; 0010 0000 for space
;;; 0110 1111 for o
        
section .data
        nl      db      0xA,0
        clear   db      0x1B,"c"

  timeval:
    tv_sec  dd 0
    tv_usec dd 0
        
section .bss
neb:     resd    1              ;scratch variable used in programming
rows:    resd    1
cols:    resd    1
cells:   resb    10000              ; rows*cols <= 10000

section .text
        global main
main:
        enter   0,0
        pusha

;;; READ thE INPUT FILE RECTANGLE INTO LINEAR ARROAY ADN NOTE ITS ROWS AND COLS

        inc     dword [rows]
        mov     ecx,cells
read_first_line:
        call    read_byte

        ;; push    ecx
        ;; push    ebp
        ;; mov     ebp,esp
        ;; push    cells
        ;; call    puts
        ;; add     esp,4
        ;; pop     ebp
        ;; pop     ecx

        mov     eax,ecx
        
        
        cmp     byte [eax],0xA
        je      read_next_line
        inc     ecx
        inc     dword [cols]
        jmp     read_first_line
read_next_line:
        mov     edx,[cols]
        call    read_bytes
        cmp     eax,[cols]
        jne     finished_reading
        inc     dword [rows]
        add     ecx,[cols]
        call    read_byte       ;skip newline
        
        ;; push    ecx
        ;; push    ebp
        ;; mov     ebp,esp
        ;; push    cells
        ;; call    puts
        ;; add     esp,4
        ;; pop     ebp
        ;; pop     ecx

        jmp     read_next_line
finished_reading:
        ;; this was used for debuiggn/testing
         ;; mov     eax,1           ;exit syscall
         ;; mov     ebx,[cols]
         ;; int     0x80

;;; CLEARN SCREEN
;;; PRINT GAME OF LIFE
;;; ITERATE/SLEEP

iterate:        
        call    clear_screen
        call    print_matrix
        call    live
        mov dword [tv_sec], 0
        mov dword [tv_usec], 30000000
        mov eax, 162
        mov ebx, timeval
        mov ecx, 0
        int 0x80

        jmp     iterate
        
        popa
        mov     eax,0           ; return 0
        leave
        ret

clear_screen:
        mov     eax,4           ; sys_write
        mov     ebx,1           ; stdout
        mov     ecx,clear
        mov     edx,2
        int     0x80
        
        ret
        
read_byte:
        mov     edx,1           ; read a single byte only
read_bytes:
        ;; this reads a single byte into ecx
        ;; 
        ;; uses ssize_t read(int fd, void *buf, size_t count);
        mov     ebx,0           ; stdin
        ;; mov     ecx,cells       ; read it into the cells buffer
        mov     eax,3           ; read system call
        int     0x80            ; actually perform the write
        ret

print_matrix:
        push    dword [rows]
        push    cells
        
.loop:
        mov     eax,4           ; sys_write
        mov     ebx,1           ; stdout
        mov     ecx,[esp]
        mov     edx,[cols]
        int     0x80

        mov     eax,4           ; sys_write
        mov     ebx,1           ; stdout
        mov     ecx,nl
        mov     edx,1
        int     0x80

        pop     eax
        pop     ebx
        dec     ebx
        jnz     .skip_ret
        ret
.skip_ret:
        
        add     eax,[cols]
        push    ebx
        push    eax
        jmp     .loop


live:
;;; THS WORKS ON TWO PASSES
        ;;  FURST PASS: COUNT
        
;;; registers:
;;; eax is index into the cells
;;; ebx is current row
;;; ecx is current col
;;; [neb] is how many neighbours
        mov     ebx,1
        inc     ebx
.loop_col:
        dec     ebx
        mov     ecx,1

        inc     ecx
.loop_row:
        dec     ecx
        
        ;;; check all 8 places in the normal cases

        mov     dword [neb],0

        dec     ebx
        dec     ecx
        call    calculate_index_inc
        inc     ecx
        call    calculate_index_inc
        inc     ecx
        call    calculate_index_inc

        inc     ebx
        call    calculate_index_inc
        dec     ecx
        dec     ecx
        call    calculate_index_inc
        
        inc     ebx
        call    calculate_index_inc
        inc     ecx
        call    calculate_index_inc
        inc     ecx
        call    calculate_index_inc
        dec     ebx
        dec     ecx

        call    calculate_index
        movzx   edx,byte [cells+eax]
        and     edx,1
        cmp     edx,0
        je      .empty_case
        jmp     .filled_case

.empty_case:
        cmp     dword [neb],3
        jne     .done
        or      byte [cells+eax],0x80
        jmp     .done
.filled_case:
        cmp     dword [neb],3
        je      .okay
        cmp     dword [neb],2
        jne     .done
.okay:
        or      byte [cells+eax],0x80
.done:
        
        ;; look a byte from the cell and zero extend it into a register
        movzx   eax, byte [cells + eax]

        inc     ecx

.finish_cases:
        inc     ecx
        cmp     ecx,[cols]
        jne     .loop_row

        inc     ebx
        inc     ebx
        cmp     ebx,[rows]
        jne     .loop_col

;;; SCCCOND PASS:: UPDATE
        mov     ebx,0
.loop_col2:
        mov     ecx,0
        
.loop_row2:
        call    calculate_index
        movzx   edx,byte [cells+eax]
        and     edx,0x80
        cmp     edx,0
        je      .skip2
        mov     byte [cells+eax],0x6F
        jmp     .skip3
.skip2:
        mov     byte [cells+eax],32
.skip3: 
        
        inc     ecx
        cmp     ecx,[cols]
        jne     .loop_row2
        inc     ebx
        cmp     ebx,[rows]
        jne     .loop_col2
        
        ret

calculate_index:
        ;; calculate the cell index: eax = ebx*[cols]+ecx
        mov     eax,ebx
        mov     edx,[cols]
        mul     edx
        add     eax,ecx

        ret

calculate_index_inc:
        ;; calculate the cell index: eax = ebx*[cols]+ecx
        mov     eax,ebx
        mov     edx,[cols]
        mul     edx
        add     eax,ecx

        movzx   edx, byte [cells+eax]
        and     edx, 0x01
        add     dword [neb],edx

        ret

