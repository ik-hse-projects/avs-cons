
%.s: %.c
	gcc -S -masm=intel "$<" -o "$@"

%.o: %.s
	gcc -c -masm=intel "$<" -o "$@"

asm: main.s fill.s get_res.s

obj: main.o fill.o get_res.o

foo.exe: main.o fill.o get_res.o
	gcc -lc main.o fill.o get_res.o -o foo.exe

.PHONY: asm obj
