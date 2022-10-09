    .file   "main.c"
    .intel_syntax noprefix
	.text                    # Новая секция
	.globl	ARRAY            # В ней лежит символ ARRAY
	.bss                     # Который неинициализирован (секция .bss)
	.align 32                # Выравнивание, на x86_64 не очень-то и нужно
	.type	ARRAY, @object 
	.size	ARRAY, 4194304   # В нём 1048576 * 4 байт (длина массива на размер инта)
ARRAY:
	.zero	4194304          # Заполним его нулями, хотя это не имеет смысла, т.к. .bss и так всегда обнуляется
	.section	.rodata      # Дальше переходим в секцию .rodata
.LC0:
	.string	"r"              # .LC0: "r"
.LC1:
	.string	"input.txt"      # .LC1: "input.txt"
.LC2:
	.string	"%d"             # .LC2: "%d"
.LC3:
	.string	"w"              # .LC3: "w"
.LC4:
	.string	"output.txt"     # .LC4: "output.txt"
	.text
	.globl	main
	.type	main, @function
main:
	push	rbp                  # Стандартный пролог
	mov	rbp, rsp                 # 
	sub	rsp, 48                  # 

    lea	rdi, .LC1[rip]           # rdi := rip[.LC1] — строчка "input.txt"
	lea	rsi, .LC0[rip]           # rsi := rip[.LC0] — строчка "r"
	call	fopen@PLT
    mov	QWORD PTR -24[rbp], rax  # rbp[-24] := rax — сохраняем `FILE* input` на стек

	mov	rdi, QWORD PTR -24[rbp]  # rdi := rbp[-24]
	lea	rsi, .LC2[rip]           # rsi := rip[.LC2] — строчка "%d"
	lea	rdx, -32[rbp]            # rdx := &rbp[-32]
	call	__isoc99_fscanf@PLT  # fscanf(input, "%d", &n)

    mov	edi, DWORD PTR -32[rbp]  # edi := rbp[-32] — загружвем `int n` из стека в аргументы
	call	fill_array@PLT       # fill_array(n)

    lea	rdi, .LC4[rip]           # rdi := rip[.LC4] — строчка "output.txt"
	lea	rsi, .LC3[rip]           # rsi := rip[.LC3] — строчка "w"
	call	fopen@PLT            # fopen("output.txt", "w")
	mov	QWORD PTR -16[rbp], rax  # Результат сохраняем на стек в `output`

	mov	edi, DWORD PTR -32[rbp]  # edi := rbp[-32]
	call	get_result@PLT       # get_result(n)
	mov	DWORD PTR -28[rbp], eax  # Результат на стек в `int result`

	mov	rdi, QWORD PTR -16[rbp]  # rdi := rbp[-16] — загружаем `int output`
	lea	rsi, .LC2[rip]           # rsi := rip[.LC2] — строчка "%d"
	mov	edx, DWORD PTR -28[rbp]  # edx := rbp[-28] — а это уже `int result`
	call	fprintf@PLT

	mov	eax, 0
	leave
	ret
