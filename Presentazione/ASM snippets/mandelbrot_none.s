	.file	"mandelbrot.c"
	.text
	.globl	mandelbrot
	.type	mandelbrot, @function
mandelbrot:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, %eax
	movl	$0, %edx
	movq	%xmm0, %rax
	movq	%xmm1, %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movl	$0, -4(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -32(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	jmp	.L2
.L5:
	movsd	-32(%rbp), %xmm1
	movsd	-32(%rbp), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm2
	movsd	-24(%rbp), %xmm1
	mulsd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	subsd	%xmm2, %xmm1
	movsd	-48(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-32(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	addsd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-40(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-16(%rbp), %xmm0
	movsd	%xmm0, -32(%rbp)
	addl	$1, -4(%rbp)
.L2:
	movsd	-32(%rbp), %xmm1
	movsd	-32(%rbp), %xmm0
	mulsd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm2
	movsd	-24(%rbp), %xmm0
	mulsd	%xmm2, %xmm0
	addsd	%xmm0, %xmm1
	movsd	.LC1(%rip), %xmm0
	comisd	%xmm1, %xmm0
	jbe	.L3
	cmpl	$65534, -4(%rbp)
	jle	.L5
.L3:
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	mandelbrot, .-mandelbrot
	.globl	mandelbrot_set
	.type	mandelbrot_set, @function
mandelbrot_set:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -104(%rbp)
	movsd	.LC2(%rip), %xmm0
	movsd	%xmm0, -8(%rbp)
	movsd	.LC2(%rip), %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	$4194304, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -72(%rbp)
	movsd	-16(%rbp), %xmm0
	movsd	%xmm0, -80(%rbp)
	movsd	-8(%rbp), %xmm0
	movsd	%xmm0, -88(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, -96(%rbp)
	leaq	-96(%rbp), %rax
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$mandelbrot_set._omp_fn.0, %edi
	call	GOMP_parallel
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	mandelbrot_set, .-mandelbrot_set
	.globl	allocate_image
	.type	allocate_image, @function
allocate_image:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	-20(%rbp), %eax
	imull	-24(%rbp), %eax
	cltq
	movl	$1, %esi
	movq	%rax, %rdi
	call	calloc
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	allocate_image, .-allocate_image
	.globl	free_image
	.type	free_image, @function
free_image:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	free_image, .-free_image
	.section	.rodata
.LC3:
	.string	"wb"
.LC4:
	.string	"Error opening file\n"
.LC5:
	.string	"P5\n%d %d\n255\n"
	.text
	.globl	save_image
	.type	save_image, @function
save_image:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movl	%ecx, -40(%rbp)
	movq	-24(%rbp), %rax
	movl	$.LC3, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L13
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$19, %edx
	movl	$1, %esi
	movl	$.LC4, %edi
	call	fwrite
	jmp	.L12
.L13:
	movl	-40(%rbp), %ecx
	movl	-36(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	$.LC5, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-36(%rbp), %eax
	imull	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-8(%rbp), %rcx
	movq	-32(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fwrite
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	save_image, .-save_image
	.section	.rodata
.LC6:
	.string	"w"
.LC7:
	.string	"%d,"
	.text
	.globl	save_image_as_text
	.type	save_image_as_text, @function
save_image_as_text:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movl	%ecx, -40(%rbp)
	movq	-24(%rbp), %rax
	movl	$.LC6, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L16
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$19, %edx
	movl	$1, %esi
	movl	$.LC4, %edi
	call	fwrite
	jmp	.L15
.L16:
	movl	$0, -4(%rbp)
	jmp	.L18
.L20:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %edx
	movq	-16(%rbp), %rax
	movl	$.LC7, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	-4(%rbp), %eax
	addl	$1, %eax
	cltd
	idivl	-36(%rbp)
	movl	%edx, %eax
	testl	%eax, %eax
	jne	.L19
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc
.L19:
	addl	$1, -4(%rbp)
.L18:
	movl	-36(%rbp), %eax
	imull	-40(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L20
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	save_image_as_text, .-save_image_as_text
	.section	.rodata
.LC8:
	.string	"mandelbrot.pgm"
	.text
	.globl	main
	.type	main, @function
main:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$2048, %esi
	movl	$2048, %edi
	call	allocate_image
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	mandelbrot_set
	movq	-8(%rbp), %rax
	movl	$2048, %ecx
	movl	$2048, %edx
	movq	%rax, %rsi
	movl	$.LC8, %edi
	call	save_image
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free_image
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	main, .-main
	.type	mandelbrot_set._omp_fn.0, @function
mandelbrot_set._omp_fn.0:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$104, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -104(%rbp)
	movq	-104(%rbp), %rax
	movl	24(%rax), %eax
	movl	%eax, -24(%rbp)
	movq	-104(%rbp), %rax
	movsd	16(%rax), %xmm0
	movsd	%xmm0, -32(%rbp)
	movq	-104(%rbp), %rax
	movsd	8(%rax), %xmm0
	movsd	%xmm0, -40(%rbp)
	movq	-104(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movl	-24(%rbp), %eax
	cltq
	leaq	-72(%rbp), %rcx
	leaq	-80(%rbp), %rdx
	movq	%rcx, %r9
	movq	%rdx, %r8
	movl	$4, %ecx
	movl	$1, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	GOMP_loop_nonmonotonic_dynamic_start
	testb	%al, %al
	je	.L24
.L26:
	movq	-80(%rbp), %rax
	movl	%eax, -20(%rbp)
	movq	-72(%rbp), %rax
	movl	%eax, %ebx
.L25:
	movl	-20(%rbp), %eax
	leal	2047(%rax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$11, %eax
	movl	%eax, -52(%rbp)
	movl	-20(%rbp), %edx
	movl	%edx, %eax
	sarl	$31, %eax
	shrl	$21, %eax
	addl	%eax, %edx
	andl	$2047, %edx
	subl	%eax, %edx
	movl	%edx, -56(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-52(%rbp), %xmm0
	mulsd	-40(%rbp), %xmm0
	movsd	.LC9(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -96(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-56(%rbp), %xmm0
	mulsd	-32(%rbp), %xmm0
	movsd	.LC9(%rip), %xmm1
	subsd	%xmm1, %xmm0
	movsd	%xmm0, -88(%rbp)
	movq	-96(%rbp), %rax
	movsd	-88(%rbp), %xmm1
	movq	%rax, %xmm0
	call	mandelbrot
	movl	%eax, -60(%rbp)
	movl	-60(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$-2147450879, %rdx, %rdx
	shrq	$32, %rdx
	addl	%eax, %edx
	movl	%edx, %ecx
	sarl	$15, %ecx
	cltd
	subl	%edx, %ecx
	movl	%ecx, %edx
	sall	$16, %edx
	subl	%ecx, %edx
	subl	%edx, %eax
	movl	%eax, -60(%rbp)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movl	-60(%rbp), %edx
	movb	%dl, (%rax)
	addl	$1, -20(%rbp)
	cmpl	%ebx, -20(%rbp)
	jl	.L25
	leaq	-72(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GOMP_loop_nonmonotonic_dynamic_next
	testb	%al, %al
	jne	.L26
.L24:
	call	GOMP_loop_end_nowait
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	mandelbrot_set._omp_fn.0, .-mandelbrot_set._omp_fn.0
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	1074790400
	.align 8
.LC2:
	.long	0
	.long	1063256064
	.align 8
.LC9:
	.long	0
	.long	1073741824
	.ident	"GCC: (GNU) 13.2.1 20240316 (Red Hat 13.2.1-7)"
	.section	.note.GNU-stack,"",@progbits
