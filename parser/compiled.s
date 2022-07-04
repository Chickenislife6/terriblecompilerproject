	.text
	.def	printf;	.scl	3;	.type	32;	.endef
	.seh_proc	printf
printf:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$56, %rsp
	.seh_stackalloc	56
	leaq	48(%rsp), %rbp
	.seh_setframe	%rbp, 48
	.seh_endprologue
	movq	%rcx, 32(%rbp)
	movq	%rdx, 40(%rbp)
	movq	%r8, 48(%rbp)
	movq	%r9, 56(%rbp)
	leaq	40(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rbx
	movl	$1, %ecx
	movq	__imp___acrt_iob_func(%rip), %rax
	call	*%rax
	movq	%rbx, %r8
	movq	32(%rbp), %rdx
	movq	%rax, %rcx
	call	__mingw_vfprintf
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.seh_endproc
	.data
	.globl word
	.align 4
word:
	.long 3
	.data
	.globl bean
	.align 4
bean:
	.long 2
	.globl helloworld
	.section .rdata,"dr"
.LC0:
	.ascii "hello world!\0"
	.data
	.align 8
helloworld:
	.quad .LC0
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
.L1:
	movq word(%rip), %r9
	movq bean(%rip), %r10
	cmpq %r9, %r10
	jl .L0
	movq word(%rip), %rcx
	call printf
	movq word(%rip), %r11
	subq $1, %r11
	movq %r11, word(%rip)
	jmp .L1
.L0:
	movl	$0, %eax
	addq	$32, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident "GCC: (Rev5, Built by MSYS2 project) 10.3.0"
	.def __mingw_vfprintf; .scl 2; .type 32; .endef
