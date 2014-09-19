x86-asm-practice
================

<pre>
x86 assembly programming on linux with nasm
===========================================


Registers
=========

There are 6 general purpose 32 bit registers and two more 32 bit registers which have a fixed purpose:

EAX[    AX[AH|AL]] \
EBX[    BX[BH|BL]]  |
ECX[    CX[CH|CL]]   >  general purpose
EDX[    DX[DH|DL]]  |
ESI[             ]  |
EDI[             ] /
ESP[             ]      stack pointer
EBP[             ]      base pointer

the lower 16-bits of the first four registers may be treated as registers too, as can the lower and upper 8 bit parts.

Here is how you copy ebx into eax:   mov eax,ebx
Here is how you put 7 into ecx:      mov ecx,7

Some more notes about the meaning of the registers from:
https://patater.com/gbaguy/day1pc.htm

	AX - Accumulator, implicitly used in some math instructions.
	BX - Base register, also used in some math instructions.
	CX - Count register, used implicitly with the Loop instruction.
	DX - Data register, also used in some math instructions.
	CS - Points to the current memory segment that is currently being executed.
	DS - Points to the data segment of the program (same as CS for us.)
	SS - Points to the stack segment of the program (")
	ES - A scratch segment pointer.
	BP - Points to the base of the built-in CPU stack.
	SP - Points to the top of the built-in CPU stack.
	IP - Points to the location of the currently executing statement (can't explicitly access IP).

64-bit has loads of extra registers: R8, R9, R10, R11, R12, R13, R14, R15

Number Types/Sizes
==================

So you have the following number types/size:

name  | bits | res
---------------------
byte  | 8    | resb
word  | 16   | resw
dword | 32   | resd
qword | 64   | resq




System Calls
============

System calls are performed by the instruction: int 0x80

To do a system call you put the system call number into eax
then the parameters into ebx, ecx, edx, esi, edi, ebp
the return value is given in eax

Here is an example of using the write syscall to print hello world to stdout

section .data
    msg     db  'hello world',0xA
    len     equ $-msg
section .text
    mov     edx,len                             ;message length
    mov     ecx,msg                             ;message to write
    mov     ebx,1                               ;file descriptor (stdout)
    mov     eax,4                               ;system call number (sys_write)
    int     0x80                                ;call kernel


C Calling Convention
====================

To call C functions you need to linked in with libc, and follow the calling convention

* Caller obligations

* Callee obligations

* Need to know what registers are going to be changed and which are safe and stuff..


Examples

So here is a simple call to "puts" that saves and restores the ebp register
        
        push    ebp
        mov     ebp,esp
        push    msg
        call    puts
        add     esp,4
        pop     ebp

if you don't need the ebp register to be saved you could just

        mov     ebp,esp
        push    msg
        call    puts
        add     esp,4

* read about base pointer and check out what's really going on here



Here's an example from:
http://en.wikibooks.org/wiki/X86_Disassembly/Calling_Conventions

_cdecl int MyFunction1(int a, int b)
{
  return a + b;
}

compiles into

_MyFunction1:
        push ebp
        mov ebp, esp
        mov eax, [ebp + 8]
        mov edx, [ebp + 12]
        add eax, edx
        pop ebp
        ret

and

MyFunction1(2, 3);

compiles into

         push 3
         push 2
         call _MyFunction1
         add esp, 8



Building a standalone binary with nasm and ld
=============================================
Here is the file hello1.s:

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

* commands to assemble and link it



Linking a C driver with assembly to use c libraries
===================================================

Here is driver.c

int asm_main(void);
int main(void) { return asm_main(); }

and some assembly code that calls a C function:

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


* gcc -c it to get the .o file
* nasm the assembly code
* ld them together


A great makefile
================

The Makefile handles all that stuff for you



Memory Allocation
=================

* program breaks
* heaps..
* malloc?



Resources
=========

Trying to put best "value for money" links first
(how much you can get out of how easy they are to read)

http://www.drpaulcarter.com/pcasm/
A good PDF teaching assembly programming from scratch!

http://opensecuritytraining.info/IntroX86.html
http://unixwiz.net/techtips/win32-callconv-asm.html
teaches how hello world in C works with details on the calling convention
second link also explains well about c calling convention

http://unixwiz.net/techtips/x86-jumps.html
jump instruction reference

http://cs.lmu.edu/~ray/notes/x86assembly/
Nice font and CSS page that shows hello world in various settings

https://patater.com/gbaguy/x86asm.htm
just a little paragraph of info on each of a list of asm topics

http://www.nasm.us/doc/nasmdoc3.html
NASM docs showing examples of some opcodes and pseudo opcodes (hard to use)

http://x86asm.net/articles/memory-allocation-in-linux/
memory allocation

http://en.wikibooks.org/wiki/X86_Assembly
http://en.wikibooks.org/wiki/X86_Disassembly
http://en.wikibooks.org/wiki/X86_Assembly/Arithmetic
There's these wikibooks, the assembly one is basically worthless. The disassembly one looks like it might have some useful things in it.
actually the arithemtic section is ok

http://www.intel.com/content/www/us/en/processors/architectures-software-developer-manuals.html/
the hardcore
</pre>
