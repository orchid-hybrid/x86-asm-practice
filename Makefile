BINS := hello1
LIBCBINS := hello2 primes
LIBCBINS2 := hello3 life
ARCH := 32

ifeq ($(ARCH),32)
  nasm_format := -f elf
  ld_emulation := -m elf_i386
else # ifeq 64
  nasm_format := -f elf64
  ld_emulation :=
endif

all: $(BINS) $(LIBCBINS) $(LIBCBINS2)

$(BINS): %: %.o
	ld $(ld_emulation) -s -o $@ $@.o

$(LIBCBINS): %: %.o
	gcc -m32 -c driver.c
	gcc -m32 -o $@ $@.o driver.o

$(LIBCBINS2): %: %.o
	gcc -m32 -o $@ $@.o

%.o: %.s
	nasm $(nasm_format) $<

clean:
	rm -f $(BINS) missing_operand_fix
	rm -f $(LIBCBINS) missing_operand_fix
	shopt -s nullglob && rm -f *.o missing_operand_fix
	rm -f *~ missing_operand_fix
