.PHONY: all
all: hanoi-c hanoi-asm

hanoi-c: hanoi.c
	$(CC) -O0 -o $@ $<

hanoi-asm: hanoi.s
	$(CC) -m64 -nostdlib -o $@ $<
