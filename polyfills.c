// https://git.musl-libc.org/cgit/musl/tree/arch/x86_64/syscall_arch.h
static __inline long __syscall0(long n)
{
	unsigned long ret;
	__asm__ __volatile__ ("syscall" : "=a"(ret) : "a"(n) : "rcx", "r11", "memory");
	return ret;
}

static __inline long __syscall1(long n, long a1)
{
	unsigned long ret;
	__asm__ __volatile__ ("syscall" : "=a"(ret) : "a"(n), "D"(a1) : "rcx", "r11", "memory");
	return ret;
}

static __inline long __syscall2(long n, long a1, long a2)
{
	unsigned long ret;
	__asm__ __volatile__ ("syscall" : "=a"(ret) : "a"(n), "D"(a1), "S"(a2)
						  : "rcx", "r11", "memory");
	return ret;
}

static __inline long __syscall3(long n, long a1, long a2, long a3)
{
	unsigned long ret;
	__asm__ __volatile__ ("syscall" : "=a"(ret) : "a"(n), "D"(a1), "S"(a2),
						  "d"(a3) : "rcx", "r11", "memory");
	return ret;
}

static __inline long __syscall4(long n, long a1, long a2, long a3, long a4)
{
	unsigned long ret;
	register long r10 __asm__("r10") = a4;
	__asm__ __volatile__ ("syscall" : "=a"(ret) : "a"(n), "D"(a1), "S"(a2),
						  "d"(a3), "r"(r10): "rcx", "r11", "memory");
	return ret;
}

static __inline long __syscall5(long n, long a1, long a2, long a3, long a4, long a5)
{
	unsigned long ret;
	register long r10 __asm__("r10") = a4;
	register long r8 __asm__("r8") = a5;
	__asm__ __volatile__ ("syscall" : "=a"(ret) : "a"(n), "D"(a1), "S"(a2),
						  "d"(a3), "r"(r10), "r"(r8) : "rcx", "r11", "memory");
	return ret;
}

static __inline long __syscall6(long n, long a1, long a2, long a3, long a4, long a5, long a6)
{
	unsigned long ret;
	register long r10 __asm__("r10") = a4;
	register long r8 __asm__("r8") = a5;
	register long r9 __asm__("r9") = a6;
	__asm__ __volatile__ ("syscall" : "=a"(ret) : "a"(n), "D"(a1), "S"(a2),
						  "d"(a3), "r"(r10), "r"(r8), "r"(r9) : "rcx", "r11", "memory");
	return ret;
}

/*
 * Some syscalls
 */

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wint-conversion"
static __inline unsigned long read(int fd, char* buffer, unsigned long length) {
	return __syscall3(0, fd, buffer, length);
}

static __inline unsigned long write(int fd, char* buffer, unsigned long length) {
	return __syscall3(1, fd, buffer, length);
}

static __inline void* mmap(unsigned long addr, unsigned long len, unsigned long prot, unsigned long flags, unsigned long fd, unsigned long off) {
	return __syscall6(9, addr, len, prot, flags, fd, off);
}

static __inline void exit(int code) {
	__syscall1(60, code);
}

static __inline int open(char* path, int flags, int mode) {
	return __syscall3(2, path, flags, mode);
}
#pragma GCC diagnostic pop

/*
 * rand.c
 */
static unsigned long seed;

static __inline void srand(unsigned long s)
{
	seed = s-1;
}

static __inline int rand()
{
	seed = 6364136223846793005ULL*seed + 1;
	return seed>>33;
}

/*
 * string.c
 */
static __inline unsigned long strlen(const char *s)
{
	const char *a = s;
	for (; *s; s++);
	return s-a;
}

/*
 * math.c
 */
const double M_PI = 3.14;
static __inline double sqrt(double x)
{
	asm("sqrtsd    %0, %0\n"
	    :"=x"(x) :"x0"(x));
	return x;
}
