	.file	"mandelbrot.c"
	.text
	.p2align 4
	.type	mandelbrot_set._omp_fn.0, @function
mandelbrot_set._omp_fn.0:
.LFB29:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	movsd	16(%rdi), %xmm9
	movsd	8(%rdi), %xmm10
	movq	(%rdi), %rbx
	leaq	24(%rsp), %rsi
	leaq	16(%rsp), %rdi
	movsd	%xmm9, 8(%rsp)
	movsd	%xmm10, (%rsp)
	call	GOMP_loop_nonmonotonic_dynamic_next
	testb	%al, %al
	je	.L8
	movsd	.LC1(%rip), %xmm8
	movsd	.LC2(%rip), %xmm7
	movsd	(%rsp), %xmm10
	movsd	8(%rsp), %xmm9
.L2:
	movl	24(%rsp), %esi
	movslq	16(%rsp), %rdx
	.p2align 4,,10
	.p2align 3
.L7:
	testl	%edx, %edx
	leal	2047(%rdx), %eax
	pxor	%xmm6, %xmm6
	movl	%edx, %ecx
	cmovns	%edx, %eax
	sarl	$31, %ecx
	pxor	%xmm5, %xmm5
	pxor	%xmm0, %xmm0
	shrl	$21, %ecx
	movapd	%xmm0, %xmm3
	movapd	%xmm0, %xmm4
	sarl	$11, %eax
	movapd	%xmm0, %xmm1
	cvtsi2sdl	%eax, %xmm6
	leal	(%rcx,%rdx), %eax
	andl	$2047, %eax
	subl	%ecx, %eax
	cvtsi2sdl	%eax, %xmm5
	xorl	%eax, %eax
	mulsd	%xmm10, %xmm6
	mulsd	%xmm9, %xmm5
	subsd	%xmm8, %xmm6
	subsd	%xmm8, %xmm5
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L19:
	cmpl	$65535, %eax
	je	.L18
.L5:
	movapd	%xmm3, %xmm2
	subsd	%xmm4, %xmm1
	addl	$1, %eax
	addsd	%xmm2, %xmm2
	movapd	%xmm1, %xmm3
	mulsd	%xmm2, %xmm0
	addsd	%xmm6, %xmm3
	movapd	%xmm3, %xmm1
	mulsd	%xmm3, %xmm1
	addsd	%xmm5, %xmm0
	movapd	%xmm0, %xmm4
	mulsd	%xmm0, %xmm4
	movapd	%xmm1, %xmm2
	addsd	%xmm4, %xmm2
	comisd	%xmm2, %xmm7
	ja	.L19
	movl	%eax, %edi
	movq	%rdi, %rcx
	salq	$16, %rcx
	addq	%rdi, %rcx
	salq	$15, %rcx
	addq	%rdi, %rcx
	shrq	$47, %rcx
	addl	%ecx, %eax
.L6:
	movb	%al, (%rbx,%rdx)
	addq	$1, %rdx
	cmpl	%edx, %esi
	jg	.L7
	leaq	24(%rsp), %rsi
	leaq	16(%rsp), %rdi
	movsd	%xmm10, 8(%rsp)
	movsd	%xmm9, (%rsp)
	call	GOMP_loop_nonmonotonic_dynamic_next
	movsd	(%rsp), %xmm9
	movsd	8(%rsp), %xmm10
	testb	%al, %al
	movsd	.LC2(%rip), %xmm7
	movsd	.LC1(%rip), %xmm8
	jne	.L2
.L8:
	call	GOMP_loop_end_nowait
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L18:
	.cfi_restore_state
	xorl	%eax, %eax
	jmp	.L6
	.cfi_endproc
.LFE29:
	.size	mandelbrot_set._omp_fn.0, .-mandelbrot_set._omp_fn.0
	.p2align 4
	.globl	mandelbrot
	.type	mandelbrot, @function
mandelbrot:
.LFB22:
	.cfi_startproc
	pxor	%xmm2, %xmm2
	movsd	.LC2(%rip), %xmm7
	xorl	%eax, %eax
	movapd	%xmm2, %xmm5
	movapd	%xmm2, %xmm6
	movapd	%xmm2, %xmm3
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L26:
	cmpl	$65535, %eax
	je	.L20
.L23:
	movapd	%xmm5, %xmm4
	subsd	%xmm6, %xmm3
	addl	$1, %eax
	addsd	%xmm4, %xmm4
	movapd	%xmm3, %xmm5
	mulsd	%xmm4, %xmm2
	addsd	%xmm0, %xmm5
	movapd	%xmm5, %xmm3
	mulsd	%xmm5, %xmm3
	addsd	%xmm1, %xmm2
	movapd	%xmm2, %xmm6
	mulsd	%xmm2, %xmm6
	movapd	%xmm3, %xmm4
	addsd	%xmm6, %xmm4
	comisd	%xmm4, %xmm7
	ja	.L26
.L20:
	ret
	.cfi_endproc
.LFE22:
	.size	mandelbrot, .-mandelbrot
	.p2align 4
	.globl	mandelbrot_set
	.type	mandelbrot_set, @function
mandelbrot_set:
.LFB23:
	.cfi_startproc
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movsd	.LC4(%rip), %xmm0
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%rdi, (%rsp)
	movl	$1, %r9d
	movl	$4194304, %r8d
	movl	$mandelbrot_set._omp_fn.0, %edi
	unpcklpd	%xmm0, %xmm0
	movups	%xmm0, 8(%rsp)
	pushq	$0
	.cfi_def_cfa_offset 56
	pushq	$4
	.cfi_def_cfa_offset 64
	leaq	16(%rsp), %rsi
	call	GOMP_parallel_loop_nonmonotonic_dynamic
	addq	$56, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE23:
	.size	mandelbrot_set, .-mandelbrot_set
	.p2align 4
	.globl	allocate_image
	.type	allocate_image, @function
allocate_image:
.LFB24:
	.cfi_startproc
	imull	%esi, %edi
	movl	$1, %esi
	movslq	%edi, %rdi
	jmp	calloc
	.cfi_endproc
.LFE24:
	.size	allocate_image, .-allocate_image
	.p2align 4
	.globl	free_image
	.type	free_image, @function
free_image:
.LFB25:
	.cfi_startproc
	jmp	free
	.cfi_endproc
.LFE25:
	.size	free_image, .-free_image
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC5:
	.string	"wb"
.LC6:
	.string	"Error opening file\n"
.LC7:
	.string	"P5\n%d %d\n255\n"
	.text
	.p2align 4
	.globl	save_image
	.type	save_image, @function
save_image:
.LFB26:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	%ecx, %r13d
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rsi, %r12
	movl	$.LC5, %esi
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movl	%edx, %ebx
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	call	fopen
	testq	%rax, %rax
	je	.L34
	movl	%ebx, %edx
	imull	%r13d, %ebx
	movq	%rax, %rbp
	movl	%r13d, %ecx
	movq	%rax, %rdi
	movl	$.LC7, %esi
	xorl	%eax, %eax
	call	fprintf
	movq	%r12, %rdi
	movq	%rbp, %rcx
	movl	$1, %esi
	movslq	%ebx, %rdx
	call	fwrite
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%rbp, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	jmp	fclose
.L34:
	.cfi_restore_state
	movl	$19, %edx
	movl	$1, %esi
	movl	$.LC6, %edi
	movq	stderr(%rip), %rcx
	popq	%rax
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	jmp	fwrite
	.cfi_endproc
.LFE26:
	.size	save_image, .-save_image
	.section	.rodata.str1.1
.LC8:
	.string	"w"
.LC9:
	.string	"%d,"
	.text
	.p2align 4
	.globl	save_image_as_text
	.type	save_image_as_text, @function
save_image_as_text:
.LFB27:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rsi, %r13
	movl	$.LC8, %esi
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movl	%edx, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movl	%ecx, %ebx
	call	fopen
	testq	%rax, %rax
	je	.L36
	movl	%ebx, %ecx
	movq	%rax, %r12
	movl	$1, %ebx
	imull	%ebp, %ecx
	movslq	%ecx, %r14
	testl	%ecx, %ecx
	jg	.L40
	jmp	.L38
	.p2align 4,,10
	.p2align 3
.L39:
	leaq	1(%rbx), %rax
	cmpq	%rbx, %r14
	je	.L38
.L41:
	movq	%rax, %rbx
.L40:
	movzbl	-1(%r13,%rbx), %edx
	movl	$.LC9, %esi
	movq	%r12, %rdi
	xorl	%eax, %eax
	call	fprintf
	movl	%ebx, %eax
	cltd
	idivl	%ebp
	testl	%edx, %edx
	jne	.L39
	movq	%r12, %rsi
	movl	$10, %edi
	call	fputc
	leaq	1(%rbx), %rax
	cmpq	%rbx, %r14
	jne	.L41
.L38:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movq	%r12, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	jmp	fclose
.L36:
	.cfi_restore_state
	popq	%rbx
	.cfi_def_cfa_offset 40
	movl	$19, %edx
	popq	%rbp
	.cfi_def_cfa_offset 32
	movl	$1, %esi
	movq	stderr(%rip), %rcx
	popq	%r12
	.cfi_def_cfa_offset 24
	movl	$.LC6, %edi
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	jmp	fwrite
	.cfi_endproc
.LFE27:
	.size	save_image_as_text, .-save_image_as_text
	.section	.rodata.str1.1
.LC10:
	.string	"mandelbrot.pgm"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB28:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	$1, %esi
	movl	$4194304, %edi
	call	calloc
	movq	%rax, %rbx
	movq	%rax, %rdi
	call	mandelbrot_set
	movq	%rbx, %rsi
	movl	$2048, %ecx
	movl	$2048, %edx
	movl	$.LC10, %edi
	call	save_image
	movq	%rbx, %rdi
	call	free
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE28:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	1073741824
	.align 8
.LC2:
	.long	0
	.long	1074790400
	.align 8
.LC4:
	.long	0
	.long	1063256064
	.ident	"GCC: (GNU) 13.2.1 20240316 (Red Hat 13.2.1-7)"
	.section	.note.GNU-stack,"",@progbits
