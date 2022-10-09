	.file	"get_res.c"
	.intel_syntax noprefix
	.text
	.globl	get_result
	.type	get_result, @function   # int get_result(int n)
get_result:
.LFB0:
	push	rbp                  # Стандартный пролог
	mov	rbp, rsp                 #
	mov	DWORD PTR -20[rbp], edi  # Загружаем аргумент `int n` на стек
	mov	eax, DWORD PTR -20[rbp]  # eax := int n
	mov	edx, eax                 # / Хитрое деление
	shr	edx, 31                  # |
	add	eax, edx                 # |
	sar	eax                      # \
	mov	DWORD PTR -8[rbp], eax   # Созраняем полученный индекс на стек
	mov	eax, DWORD PTR -8[rbp]   # …и загружаем его обратно в eax
	cdqe                         # …не забывая про sign-extend
	lea	rdx, 0[0+rax*4]          # rdx := rax * 4
	lea	rax, ARRAY[rip]          # rax := rip[ARRAY]
	mov	eax, DWORD PTR [rdx+rax] # eax := *(rdx + rax)
	mov	DWORD PTR -4[rbp], eax   # result := eax
	mov	eax, DWORD PTR -4[rbp]   # eax содержит возвращаемое значение, а у нас return result;
	pop	rbp                      # Стандартный эпилог
	ret                          #
