	.file	"foo.c"
	.intel_syntax noprefix
	.text
	.globl	THRESHOLD
	.section	.rodata
	.align 4
	.type	THRESHOLD, @object
	.size	THRESHOLD, 4
THRESHOLD:
	.long	2147483637
	.text
	.globl	timespecDiff
	.type	timespecDiff, @function
timespecDiff:
.LFB6:
	push	rbp
	mov	rbp, rsp
	mov	rax, rsi
	mov	r8, rdi
	mov	rsi, r8
	mov	rdi, r9
	mov	rdi, rax
	mov	QWORD PTR -32[rbp], rsi
	mov	QWORD PTR -24[rbp], rdi
	mov	QWORD PTR -48[rbp], rdx
	mov	QWORD PTR -40[rbp], rcx
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	imul	rax, rax, 1000000000
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	add	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	imul	rax, rax, 1000000000
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	add	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	sub	rax, QWORD PTR -8[rbp]
	pop	rbp
	ret

	.section	.rodata         # /
.LC0:                           # |
	.string	"Elapsed: %ld ns"   # \ В .rodata лежит строчка

	.text
	.globl	main
main:
	push	rbp                  # / Классический пролог
	mov	rbp, rsp                 # |
	sub	rsp, 96                  # \

	mov	DWORD PTR -84[rbp], edi  # / Аргументы на стек
	mov	QWORD PTR -96[rbp], rsi  # |
	cmp	DWORD PTR -84[rbp], 2    # if rbp[-82] != 2
	jne	.L4                      # then goto return 1;

    mov	rax, QWORD PTR -96[rbp]  # rax := rbp[-96] == argv
	mov	rax, QWORD PTR 8[rax]    # rax := rax[8]   == argv[1]
	mov	QWORD PTR -64[rbp], rax  # rbp[-64] := rax — присвоение в `char* arg`
	mov	rdi, QWORD PTR -64[rbp]  # rdi := rbp[-64] — первый аргумент для atoi
	call	atoi@PLT
	mov	DWORD PTR -68[rbp], eax  # rbp[-68] = eax — присовение результата в `int seed`
	mov	edi, DWORD PTR -68[rbp]  # edi := rbp[-68]
	call	srand@PLT            # srand(edi)

	mov	edi, 1                   # edi := 1 — это константа CLOCK_MONOTONIC в первый аргумент
	lea	rsi, -48[rbp]            # rsi := &rbp[-48] — вторым аргументом указатель на start
	call	clock_gettime@PLT    # clock_gettime()

	mov	DWORD PTR -72[rbp], 0    # rbp[-72] := 0 — обнуляем n
	jmp	.L7                      # идём проверять условие цикла
.L4:
	mov	eax, 1                   # return value = 1
	jmp	.L9                      # goto return;
.L8:
	call	rand@PLT             # вызываем rand без аргументов
	mov	DWORD PTR -72[rbp], eax  # результат сохраняем на стек в `int n`
.L7:
	mov	eax, 2147483637          # это константа THRESHOLD
	cmp	DWORD PTR -72[rbp], eax  # и если rbp[-72] < eax
	jl	.L8                      # то идём в тело цикла: .L8

	lea	rsi, -32[rbp]            # иначе rsi := &rbp[-32] — указатель на end
	mov	edi, 1                   # первым аргументов константа CLOCK_MONOTONIC
	call	clock_gettime@PLT    # clock_gettime()

	mov	rdi, QWORD PTR -32[rbp]
	mov	rsi, QWORD PTR -24[rbp]
	mov	rdx, QWORD PTR -48[rbp]
	mov	rcx, QWORD PTR -40[rbp]
	call	timespecDiff         # timespecDiff() от четырех аргументов
	mov	QWORD PTR -56[rbp], rax  # результат в rbp[-56]

    mov	rsi, QWORD PTR -56[rbp]  # загружаем elapsed_ns в rsi
	lea	rdi, .LC0[rip]           # rdi := &rip[.LC0] — строчка "Elapsed: %ld ns"
	call	printf@PLT           # printf()

	mov	eax, 0                   # return value = 0
.L9:                             # do return
	leave
	ret
