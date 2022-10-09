# Замены:
# * rbp[-16] -> r12d
# * rbp[-20] -> r13d

    .intel_syntax noprefix       # Используем синтаксис в стиле Intel
    .text                        # Начало секции
	.local	ARRAY                # Объявляем символ ARRAY, но не экспортируем его
	.comm	ARRAY,4194304,32     # Неинициализированный массив (https://sourceware.org/binutils/docs/as/bss.html)
	.section	.rodata          # Переходим в секцию .rodata
.LC0:                            # Метка `.LC0:`…
	.string	"%d"                 # …прямо перед тем, как положить в файл строку "%d\0"
	.text                        # WTF
	.globl	main                 # Объявляем и экспортируем вовне символ `main`
main:                            # Теперь метка `main:`, именно её мы и экспортируем
.LFB0:                           # Ещё какая-то внутренняя метка `.LBF0:`
	push	rbp                  # / Пролог функции (1/3). Сохранили предыдущий rbp на стек.
	mov	rbp, rsp                 # | Пролог функции (2/3). Вместо rbp записали rsp.
	sub	rsp, 48                  # \ Пролог функции (3/3). А сам rsp сдвинули на 48 байт
	lea	rsi, -20[rbp]            # rsi := rbp[-20] — переменная N на стеке
	lea	rdi, .LC0[rip]           # rdi := rip[.LC0] — наша строка "%d"
	call	scanf@PLT            # Вызывает функцию `scanf`. В этот момент в регистрах: rax=0, rdi=rip[.LC0], rsi=rbp[-20], 
    mov r13d, -20[rbp]           # XXX
	mov	r12, 0                   # rbp[-16] := 0 — счетчик цикла
	jmp	.L2                      # переход к метке .L2: ниже по коду, там проверка условия цикла
.L3:
	mov	eax, r12d                # eax := rbp[-16]
	lea	rcx, 0[0+rax*4]          # / rcx := rax * 4 — прикольные трюки с вычислением: вычисляет адрес (rax*4)[0], который равен rax*4
	lea	rdx, ARRAY[rip]          # | rdx := &rip[ARRAY] — адрес начала массива
	mov	eax, r12d                # | eax := rbp[-16]
	mov	DWORD PTR [rcx+rdx], eax # \ [rcx + rdx] := eax — наконец, записать в rdx[rcx] := eax
	add	r12               , 1    # rbp[-16] += 1
.L2:
	mov	eax, r13d                # eax := rbp[-20]         (загрузка N из стека в регистр)
	cmp	r12d, eax                # сравнить rbp[-16] и eax (это счетчик цикла и N)
	jl	.L3                      # если меньше, то перейти к .L3: (иначе выйти из цикла)
	mov	eax, r13d                # eax := rbp[-20] — снова загрузка N из стека в регистр
	sar	eax                      # eax /= 2, unsigned
	lea	rdx, 0[0+rax*4]          # / rdx := rax * 4
	lea	rax, ARRAY[rip]          # | rax := &rip[ARRAY]
	mov	esi, DWORD PTR [rdx+rax] # | esi := *(rdx + rax)
	lea	rdi, .LC0[rip]           # rax := rip[.LC0] — снова строчка "%d"
	call	printf@PLT           # вызов printf
	leave                        # / Эпилог (1/2)
	ret                          # \ Эпилог (2/2)
