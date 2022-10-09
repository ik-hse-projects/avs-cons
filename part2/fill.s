	.file	"fill.c"
	.intel_syntax noprefix
	.text
	.globl	fill_array
	.type	fill_array, @function # void fill_array(int n)
fill_array:
.LFB0:
	push	rbp                   # Стандартный пролог
	mov	rbp, rsp
	mov	DWORD PTR -20[rbp], edi   # Сохраняем аргумент на стек
	mov	DWORD PTR -4[rbp], 0      # В цикле в `int i` сразу присваивается ноль
	jmp	.L2                       # Замтем идёт проверка условия цикла
.L3:
	mov	eax, DWORD PTR -4[rbp]    # Загружаем счетчик цикла в rax
	cdqe                          # и не забываем sign-extend
	lea	rcx, 0[0+rax*4]           # Умножаем его на 4 и кладём в rcx
	lea	rdx, ARRAY[rip]           # В rdx кладём указатель на начало массива (rip[ARRAY])
	mov	eax, DWORD PTR -4[rbp]    # В eax снова загружаем счетчик цикла — значение элемента массива
	mov	DWORD PTR [rcx+rdx], eax  # *(rcx + rdx) = eax
	add	DWORD PTR -4[rbp], 1      # Увеличиваем счетчик на стеке на единицу
.L2:
	mov	eax, DWORD PTR -4[rbp]    # Загружаем `int i` из стека в eax
	cmp	eax, DWORD PTR -20[rbp]   # И сравниваем с `int n`
	jl	.L3                       # Если меньше, то следующая итерация
	pop	rbp
	ret
