PROGS = hanoi-c0 hanoi-c2 hanoi-asm

.PHONY: all
all: $(PROGS)

.PHONY: clean
clean:
	rm -f $(PROGS)

hanoi-c0: hanoi.c
	$(CC) -O0 -o $@ $<

hanoi-c2: hanoi.c
	$(CC) -O2 -o $@ $<

hanoi-asm: hanoi.s
	$(CC) -m64 -nostdlib -o $@ $<
