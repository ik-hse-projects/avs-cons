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
	mov	DWORD PTR -36[rbp], edi  # rbp[-36] := edi — это первый аргумент, `argc` (rdi)
	mov	QWORD PTR -48[rbp], rsi  # rbp[-48] := rsi — это второй аргумент, `argv` (rsi)
	xor	eax, eax                 # Обнуляет eax
	lea	rax, -20[rbp]            # rax := rbp[-20] — переменная N на стеке
	mov	rsi, rax                 # rsi := rax
	lea	rax, .LC0[rip]           # rax := rip[.LC0] — наша строка "%d"
	mov	rdi, rax                 # rdi := rax
	mov	eax, 0                   # Обнуляет eax (но уже другим способом, пхпх)
	call	scanf@PLT            # Вызывает функцию `scanf`. В этот момент в регистрах: rax=0, rdi=rip[.LC0], rsi=rbp[-20], 
	mov	DWORD PTR -16[rbp], 0    # rbp[-16] := 0 — счетчик цикла
	jmp	.L2                      # переход к метке .L2: ниже по коду, там проверка условия цикла
.L3:
	mov	eax, DWORD PTR -16[rbp]  # eax := rbp[-16]
	cdqe                         # Convert Doubleword to Qwadword — у нас был eax, стал нормальный rax, делает sign-extend
	lea	rcx, 0[0+rax*4]          # / rcx := rax * 4 — прикольные трюки с вычислением: вычисляет адрес (rax*4)[0], который равен rax*4
	lea	rdx, ARRAY[rip]          # | rdx := &rip[ARRAY] — адрес начала массива
	mov	eax, DWORD PTR -16[rbp]  # | eax := rbp[-16]
	mov	DWORD PTR [rcx+rdx], eax # \ [rcx + rdx] := eax — наконец, записать в rdx[rcx] := eax
	add	DWORD PTR -16[rbp], 1    # rbp[-16] += 1
.L2:
	mov	eax, DWORD PTR -20[rbp]  # eax := rbp[-20]         (загрузка N из стека в регистр)
	cmp	DWORD PTR -16[rbp], eax  # сравнить rbp[-16] и eax (это счетчик цикла и N)
	jl	.L3                      # если меньше, то перейти к .L3: (иначе выйти из цикла)
	mov	eax, DWORD PTR -20[rbp]  # eax := rbp[-20] — снова загрузка N из стека в регистр
	mov	edx, eax                 # / edx := eax
	shr	edx, 31                  # | edx >>= 31 — оставляет только один старший бит
	add	eax, edx                 # | eax += edx
	sar	eax                      # \ eax /= 2, unsigned
	mov	DWORD PTR -16[rbp], eax  # rbp[-16] := eax — записать в i полученное число…
	mov	eax, DWORD PTR -16[rbp]  # eax := rbp[-16] — …и загрузить его сразу обратно
	cdqe                         # sign-extend, ибо дальше собираемся использовать rax
	lea	rdx, 0[0+rax*4]          # / rdx := rax * 4
	lea	rax, ARRAY[rip]          # | rax := &rip[ARRAY]
	mov	eax, DWORD PTR [rdx+rax] # | eax := *(rdx + rax)
	mov	DWORD PTR -12[rbp], eax  # \ rbp[-12] := eax
	mov	eax, DWORD PTR -12[rbp]  # eax := rbp[-12]
	mov	esi, eax                 # esi := eax
	lea	rax, .LC0[rip]           # rax := rip[.LC0] — снова строчка "%d"
	mov	rdi, rax                 # rdi := rax
	mov	eax, 0                   # eax := 0
	call	printf@PLT           # вызов printf
	leave                        # / Эпилог (1/2)
	ret                          # \ Эпилог (2/2)
