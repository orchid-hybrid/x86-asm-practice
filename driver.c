#include <stdio.h>
int asm_main(void);
void print_number(int i) { printf("%d\n",i); fflush(stdout); }
int main(void) { return asm_main(); }

