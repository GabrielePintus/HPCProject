	.file	"mandelbrot.c"
# GNU C17 (GCC) version 13.3.1 20240522 (Red Hat 13.3.1-1) (x86_64-redhat-linux)
#	compiled by GNU C version 13.3.1 20240522 (Red Hat 13.3.1-1), GMP version 6.2.1, MPFR version 4.2.0-p12, MPC version 1.3.1, isl version none
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O3
	.text
	.p2align 4
	.globl	mandelbrot
	.type	mandelbrot, @function
mandelbrot:
.LFB22:
	.cfi_startproc
# mandelbrot.c:42:     Complex z = {0, 0};
	pxor	%xmm2, %xmm2	# z$y
	movsd	.LC1(%rip), %xmm7	#, tmp108
# mandelbrot.c:41:     int n = 0;
	xorl	%eax, %eax	# <retval>
# mandelbrot.c:42:     Complex z = {0, 0};
	movapd	%xmm2, %xmm5	#, temp
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm2, %xmm6	#, _8
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm2, %xmm3	#, _7
	jmp	.L4	#
	.p2align 4,,10
	.p2align 3
.L8:
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	cmpl	$65535, %eax	#, <retval>
	je	.L1	#,
.L4:
	movapd	%xmm5, %xmm4	# temp, z$x
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	subsd	%xmm6, %xmm3	# _8, tmp98
# mandelbrot.c:47:         ++n;
	addl	$1, %eax	#, <retval>
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	addsd	%xmm4, %xmm4	# z$x, tmp99
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	movapd	%xmm3, %xmm5	# tmp98, tmp98
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	mulsd	%xmm4, %xmm2	# tmp99, tmp100
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	addsd	%xmm0, %xmm5	# c, tmp98
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm5, %xmm3	# temp, _7
	mulsd	%xmm5, %xmm3	# temp, _7
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	addsd	%xmm1, %xmm2	# c, z$y
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm2, %xmm6	# z$y, _8
	mulsd	%xmm2, %xmm6	# z$y, _8
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm3, %xmm4	# _7, tmp101
	addsd	%xmm6, %xmm4	# _8, tmp101
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	comisd	%xmm4, %xmm7	# tmp101, tmp108
	ja	.L8	#,
.L1:
# mandelbrot.c:50: }
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
	movsd	.LC2(%rip), %xmm9	#, tmp144
	movsd	.LC1(%rip), %xmm7	#, tmp143
# mandelbrot.c:57: void mandelbrot_set(uint8_t *image) {
	movq	%rdi, %rsi	# tmp148, image
	xorl	%ecx, %ecx	# ivtmp.35
	movsd	.LC3(%rip), %xmm8	#, tmp145
	.p2align 4,,10
	.p2align 3
.L14:
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	pxor	%xmm6, %xmm6	# tmp106
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	pxor	%xmm5, %xmm5	# tmp111
# mandelbrot.c:42:     Complex z = {0, 0};
	pxor	%xmm0, %xmm0	# z$y
# mandelbrot.c:66:         int x = i / HEIGHT; // int x = i >> WIDTH_EXP; 
	movl	%ecx, %eax	# ivtmp.35, x
# mandelbrot.c:42:     Complex z = {0, 0};
	movapd	%xmm0, %xmm3	#, temp
# mandelbrot.c:66:         int x = i / HEIGHT; // int x = i >> WIDTH_EXP; 
	sarl	$11, %eax	#, x
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm0, %xmm4	#, _20
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm0, %xmm1	#, _15
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	cvtsi2sdl	%eax, %xmm6	# x, tmp106
# mandelbrot.c:67:         int y = i % HEIGHT; // int y = i & (HEIGHT-1); 
	movl	%ecx, %eax	# ivtmp.35, y
	andl	$2047, %eax	#, y
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	cvtsi2sdl	%eax, %xmm5	# y, tmp111
# mandelbrot.c:41:     int n = 0;
	xorl	%eax, %eax	# n
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	mulsd	%xmm9, %xmm6	# tmp144, tmp107
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	mulsd	%xmm9, %xmm5	# tmp144, tmp112
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	subsd	%xmm8, %xmm6	# tmp145, _3
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	subsd	%xmm8, %xmm5	# tmp145, _6
	jmp	.L12	#
	.p2align 4,,10
	.p2align 3
.L20:
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	cmpl	$65535, %eax	#, n
	je	.L19	#,
.L12:
	movapd	%xmm3, %xmm2	# temp, z$x
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	subsd	%xmm4, %xmm1	# _20, tmp115
# mandelbrot.c:47:         ++n;
	addl	$1, %eax	#, n
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	addsd	%xmm2, %xmm2	# z$x, tmp116
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	movapd	%xmm1, %xmm3	# tmp115, tmp115
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	mulsd	%xmm2, %xmm0	# tmp116, tmp117
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	addsd	%xmm6, %xmm3	# _3, tmp115
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm3, %xmm1	# temp, _15
	mulsd	%xmm3, %xmm1	# temp, _15
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	addsd	%xmm5, %xmm0	# _6, z$y
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm0, %xmm4	# z$y, _20
	mulsd	%xmm0, %xmm4	# z$y, _20
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movapd	%xmm1, %xmm2	# _15, tmp118
	addsd	%xmm4, %xmm2	# _20, tmp118
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	comisd	%xmm2, %xmm7	# tmp118, tmp143
	ja	.L20	#,
# mandelbrot.c:74:         iter = iter % MAX_ITER;
	movl	%eax, %edi	# n, n
	movq	%rdi, %rdx	# n, tmp123
	salq	$16, %rdx	#, tmp123
	addq	%rdi, %rdx	# n, tmp124
	salq	$15, %rdx	#, tmp125
	addq	%rdi, %rdx	# n, tmp126
	shrq	$47, %rdx	#, tmp120
# mandelbrot.c:77:         image[i] = iter;
	addl	%edx, %eax	# tmp120, _63
.L13:
	movb	%al, (%rsi,%rcx)	# _63, MEM[(uint8_t *)image_17(D) + ivtmp.35_54 * 1]
# mandelbrot.c:64:     for (int i = 0; i < total_size; ++i) {
	addq	$1, %rcx	#, ivtmp.35
	cmpq	$4194304, %rcx	#, ivtmp.35
	jne	.L14	#,
# mandelbrot.c:79: }
	ret	
.L19:
	xorl	%eax, %eax	# _63
	jmp	.L13	#
	.cfi_endproc
.LFE23:
	.size	mandelbrot_set, .-mandelbrot_set
	.p2align 4
	.globl	allocate_image
	.type	allocate_image, @function
allocate_image:
.LFB24:
	.cfi_startproc
# mandelbrot.c:91:     uint8_t *image = (uint8_t *)calloc(width * height, sizeof(uint8_t));
	imull	%esi, %edi	# tmp90, tmp87
# mandelbrot.c:91:     uint8_t *image = (uint8_t *)calloc(width * height, sizeof(uint8_t));
	movl	$1, %esi	#,
	movslq	%edi, %rdi	# tmp87, tmp88
	jmp	calloc	#
	.cfi_endproc
.LFE24:
	.size	allocate_image, .-allocate_image
	.p2align 4
	.globl	free_image
	.type	free_image, @function
free_image:
.LFB25:
	.cfi_startproc
# mandelbrot.c:102:     free(image);
	jmp	free	#
	.cfi_endproc
.LFE25:
	.size	free_image, .-free_image
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC4:
	.string	"wb"
.LC5:
	.string	"Error opening file\n"
.LC6:
	.string	"P5\n%d %d\n255\n"
	.text
	.p2align 4
	.globl	save_image
	.type	save_image, @function
save_image:
.LFB26:
	.cfi_startproc
	pushq	%r13	#
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movl	%ecx, %r13d	# tmp96, height
	pushq	%r12	#
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rsi, %r12	# tmp94, image
# mandelbrot.c:116:     fp = fopen(filename, "wb");
	movl	$.LC4, %esi	#,
# mandelbrot.c:114: {
	pushq	%rbp	#
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx	#
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movl	%edx, %ebx	# tmp95, width
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 48
# mandelbrot.c:116:     fp = fopen(filename, "wb");
	call	fopen	#
# mandelbrot.c:117:     if (fp == NULL) {
	testq	%rax, %rax	# tmp90
	je	.L26	#,
# mandelbrot.c:121:     fprintf(fp, "P5\n%d %d\n255\n", width, height);
	movl	%ebx, %edx	# width,
# mandelbrot.c:122:     fwrite(image, sizeof(uint8_t), width * height, fp);
	imull	%r13d, %ebx	# height, tmp91
	movq	%rax, %rbp	# tmp97, tmp90
# mandelbrot.c:121:     fprintf(fp, "P5\n%d %d\n255\n", width, height);
	movl	%r13d, %ecx	# height,
	movq	%rax, %rdi	# tmp90,
	movl	$.LC6, %esi	#,
	xorl	%eax, %eax	#
	call	fprintf	#
# mandelbrot.c:122:     fwrite(image, sizeof(uint8_t), width * height, fp);
	movq	%r12, %rdi	# image,
	movq	%rbp, %rcx	# tmp90,
	movl	$1, %esi	#,
	movslq	%ebx, %rdx	# tmp91, tmp92
	call	fwrite	#
# mandelbrot.c:124: }
	addq	$8, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 40
# mandelbrot.c:123:     fclose(fp);
	movq	%rbp, %rdi	# tmp90,
# mandelbrot.c:124: }
	popq	%rbx	#
	.cfi_def_cfa_offset 32
	popq	%rbp	#
	.cfi_def_cfa_offset 24
	popq	%r12	#
	.cfi_def_cfa_offset 16
	popq	%r13	#
	.cfi_def_cfa_offset 8
# mandelbrot.c:123:     fclose(fp);
	jmp	fclose	#
.L26:
	.cfi_restore_state
# mandelbrot.c:118:         fprintf(stderr, "Error opening file\n");
	movl	$19, %edx	#,
	movl	$1, %esi	#,
	movl	$.LC5, %edi	#,
	movq	stderr(%rip), %rcx	# stderr,
# mandelbrot.c:124: }
	popq	%rax	#
	.cfi_def_cfa_offset 40
	popq	%rbx	#
	.cfi_def_cfa_offset 32
	popq	%rbp	#
	.cfi_def_cfa_offset 24
	popq	%r12	#
	.cfi_def_cfa_offset 16
	popq	%r13	#
	.cfi_def_cfa_offset 8
# mandelbrot.c:118:         fprintf(stderr, "Error opening file\n");
	jmp	fwrite	#
	.cfi_endproc
.LFE26:
	.size	save_image, .-save_image
	.section	.rodata.str1.1
.LC7:
	.string	"w"
.LC8:
	.string	"%d,"
	.text
	.p2align 4
	.globl	save_image_as_text
	.type	save_image_as_text, @function
save_image_as_text:
.LFB27:
	.cfi_startproc
	pushq	%r14	#
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13	#
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rsi, %r13	# tmp103, image
# mandelbrot.c:129:     fp = fopen(filename, "w");
	movl	$.LC7, %esi	#,
# mandelbrot.c:127: {
	pushq	%r12	#
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp	#
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movl	%edx, %ebp	# tmp104, width
	pushq	%rbx	#
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
# mandelbrot.c:127: {
	movl	%ecx, %ebx	# tmp105, height
# mandelbrot.c:129:     fp = fopen(filename, "w");
	call	fopen	#
# mandelbrot.c:130:     if (fp == NULL) {
	testq	%rax, %rax	# fp
	je	.L28	#,
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	movl	%ebx, %ecx	# height, height
	movq	%rax, %r12	# tmp106, fp
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	movl	$1, %ebx	#, ivtmp.56
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	imull	%ebp, %ecx	# width, height
	movslq	%ecx, %r14	# _27, _9
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	testl	%ecx, %ecx	# _27
	jg	.L32	#,
	jmp	.L30	#
	.p2align 4,,10
	.p2align 3
.L31:
	leaq	1(%rbx), %rax	#, ivtmp.56
	cmpq	%rbx, %r14	# ivtmp.56, _9
	je	.L30	#,
.L33:
	movq	%rax, %rbx	# ivtmp.56, ivtmp.56
.L32:
# mandelbrot.c:136:         fprintf(fp, "%d,", image[i]);
	movzbl	-1(%r13,%rbx), %edx	# MEM[(const uint8_t *)image_21(D) + -1B + ivtmp.56_26 * 1], MEM[(const uint8_t *)image_21(D) + -1B + ivtmp.56_26 * 1]
	movl	$.LC8, %esi	#,
	movq	%r12, %rdi	# fp,
	xorl	%eax, %eax	#
	call	fprintf	#
# mandelbrot.c:137:         if ((i + 1) % width == 0) {
	movl	%ebx, %eax	# ivtmp.56, tmp101
	cltd
	idivl	%ebp	# width
# mandelbrot.c:137:         if ((i + 1) % width == 0) {
	testl	%edx, %edx	# tmp100
	jne	.L31	#,
# mandelbrot.c:138:             fprintf(fp, "\n");
	movq	%r12, %rsi	# fp,
	movl	$10, %edi	#,
	call	fputc	#
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	leaq	1(%rbx), %rax	#, ivtmp.56
	cmpq	%rbx, %r14	# ivtmp.56, _9
	jne	.L33	#,
.L30:
# mandelbrot.c:142: }
	popq	%rbx	#
	.cfi_remember_state
	.cfi_def_cfa_offset 40
# mandelbrot.c:141:     fclose(fp);
	movq	%r12, %rdi	# fp,
# mandelbrot.c:142: }
	popq	%rbp	#
	.cfi_def_cfa_offset 32
	popq	%r12	#
	.cfi_def_cfa_offset 24
	popq	%r13	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
# mandelbrot.c:141:     fclose(fp);
	jmp	fclose	#
.L28:
	.cfi_restore_state
# mandelbrot.c:142: }
	popq	%rbx	#
	.cfi_def_cfa_offset 40
# mandelbrot.c:131:         fprintf(stderr, "Error opening file\n");
	movl	$19, %edx	#,
# mandelbrot.c:142: }
	popq	%rbp	#
	.cfi_def_cfa_offset 32
# mandelbrot.c:131:         fprintf(stderr, "Error opening file\n");
	movl	$1, %esi	#,
	movq	stderr(%rip), %rcx	# stderr,
# mandelbrot.c:142: }
	popq	%r12	#
	.cfi_def_cfa_offset 24
# mandelbrot.c:131:         fprintf(stderr, "Error opening file\n");
	movl	$.LC5, %edi	#,
# mandelbrot.c:142: }
	popq	%r13	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
# mandelbrot.c:131:         fprintf(stderr, "Error opening file\n");
	jmp	fwrite	#
	.cfi_endproc
.LFE27:
	.size	save_image_as_text, .-save_image_as_text
	.section	.rodata.str1.1
.LC9:
	.string	"mandelbrot.pgm"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB28:
	.cfi_startproc
	pushq	%rbx	#
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
# mandelbrot.c:91:     uint8_t *image = (uint8_t *)calloc(width * height, sizeof(uint8_t));
	movl	$1, %esi	#,
	movl	$4194304, %edi	#,
	call	calloc	#
	movq	%rax, %rbx	# tmp86, tmp84
# mandelbrot.c:157:     mandelbrot_set(image);
	movq	%rax, %rdi	# tmp84,
	call	mandelbrot_set	#
# mandelbrot.c:160:     save_image("mandelbrot.pgm", image, WIDTH, HEIGHT);
	movq	%rbx, %rsi	# tmp84,
	movl	$2048, %ecx	#,
	movl	$2048, %edx	#,
	movl	$.LC9, %edi	#,
	call	save_image	#
# mandelbrot.c:102:     free(image);
	movq	%rbx, %rdi	# tmp84,
	call	free	#
# mandelbrot.c:167: }
	xorl	%eax, %eax	#
	popq	%rbx	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE28:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	0
	.long	1074790400
	.align 8
.LC2:
	.long	0
	.long	1063256064
	.align 8
.LC3:
	.long	0
	.long	1073741824
	.ident	"GCC: (GNU) 13.3.1 20240522 (Red Hat 13.3.1-1)"
	.section	.note.GNU-stack,"",@progbits
