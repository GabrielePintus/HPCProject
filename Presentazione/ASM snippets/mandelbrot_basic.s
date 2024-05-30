	.file	"mandelbrot.c"
# GNU C17 (GCC) version 13.3.1 20240522 (Red Hat 13.3.1-1) (x86_64-redhat-linux)
#	compiled by GNU C version 13.3.1 20240522 (Red Hat 13.3.1-1), GMP version 6.2.1, MPFR version 4.2.0-p12, MPC version 1.3.1, isl version none
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64
	.text
	.globl	mandelbrot
	.type	mandelbrot, @function
mandelbrot:
.LFB6:
	.cfi_startproc
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	movl	$0, %eax	#, tmp105
	movl	$0, %edx	#,
	movq	%xmm0, %rax	# tmp106, tmp105
	movq	%xmm1, %rdx	# tmp107,
	movq	%rax, -48(%rbp)	# tmp105, c
	movq	%rdx, -40(%rbp)	#, c
# mandelbrot.c:41:     int n = 0;
	movl	$0, -4(%rbp)	#, n
# mandelbrot.c:42:     Complex z = {0, 0};
	pxor	%xmm0, %xmm0	# tmp108
	movsd	%xmm0, -32(%rbp)	# tmp108, z.x
	pxor	%xmm0, %xmm0	# tmp109
	movsd	%xmm0, -24(%rbp)	# tmp109, z.y
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	jmp	.L2	#
.L5:
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	movsd	-32(%rbp), %xmm1	# z.x, _1
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	movsd	-32(%rbp), %xmm0	# z.x, _2
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	mulsd	%xmm1, %xmm0	# _1, _3
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	movsd	-24(%rbp), %xmm2	# z.y, _4
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	movsd	-24(%rbp), %xmm1	# z.y, _5
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	mulsd	%xmm1, %xmm2	# _5, _6
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	movapd	%xmm0, %xmm1	# _3, _3
	subsd	%xmm2, %xmm1	# _6, _3
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	movsd	-48(%rbp), %xmm0	# c.x, _8
# mandelbrot.c:44:         double temp = z.x * z.x - z.y * z.y + c.x;
	addsd	%xmm1, %xmm0	# _7, tmp110
	movsd	%xmm0, -16(%rbp)	# tmp110, temp
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	movsd	-32(%rbp), %xmm0	# z.x, _9
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	movapd	%xmm0, %xmm1	# _9, _9
	addsd	%xmm0, %xmm1	# _9, _9
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	movsd	-24(%rbp), %xmm0	# z.y, _11
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	mulsd	%xmm0, %xmm1	# _11, _12
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	movsd	-40(%rbp), %xmm0	# c.y, _13
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	addsd	%xmm1, %xmm0	# _12, _14
# mandelbrot.c:45:         z.y = 2 * z.x * z.y + c.y;
	movsd	%xmm0, -24(%rbp)	# _14, z.y
# mandelbrot.c:46:         z.x = temp;
	movsd	-16(%rbp), %xmm0	# temp, tmp111
	movsd	%xmm0, -32(%rbp)	# tmp111, z.x
# mandelbrot.c:47:         ++n;
	addl	$1, -4(%rbp)	#, n
.L2:
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movsd	-32(%rbp), %xmm1	# z.x, _15
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movsd	-32(%rbp), %xmm0	# z.x, _16
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	mulsd	%xmm0, %xmm1	# _16, _17
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movsd	-24(%rbp), %xmm2	# z.y, _18
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movsd	-24(%rbp), %xmm0	# z.y, _19
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	mulsd	%xmm2, %xmm0	# _18, _20
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	addsd	%xmm0, %xmm1	# _20, _21
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	movsd	.LC1(%rip), %xmm0	#, tmp112
	comisd	%xmm1, %xmm0	# _21, tmp112
	jbe	.L3	#,
# mandelbrot.c:43:     while ((z.x * z.x + z.y * z.y) < 4 && n < MAX_ITER) {
	cmpl	$65534, -4(%rbp)	#, n
	jle	.L5	#,
.L3:
# mandelbrot.c:49:     return n;
	movl	-4(%rbp), %eax	# n, _32
# mandelbrot.c:50: }
	popq	%rbp	#
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
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$80, %rsp	#,
	movq	%rdi, -72(%rbp)	# image, image
# mandelbrot.c:58:     double dx = (X_MAX - X_MIN) / WIDTH;
	movsd	.LC2(%rip), %xmm0	#, tmp91
	movsd	%xmm0, -16(%rbp)	# tmp91, dx
# mandelbrot.c:59:     double dy = (Y_MAX - Y_MIN) / HEIGHT;
	movsd	.LC2(%rip), %xmm0	#, tmp92
	movsd	%xmm0, -24(%rbp)	# tmp92, dy
# mandelbrot.c:61:     const int total_size = WIDTH * HEIGHT;
	movl	$4194304, -28(%rbp)	#, total_size
# mandelbrot.c:64:     for (int i = 0; i < total_size; ++i) {
	movl	$0, -4(%rbp)	#, i
# mandelbrot.c:64:     for (int i = 0; i < total_size; ++i) {
	jmp	.L9	#
.L10:
# mandelbrot.c:66:         int x = i / HEIGHT; // int x = i >> WIDTH_EXP; 
	movl	-4(%rbp), %eax	# i, tmp94
	leal	2047(%rax), %edx	#, tmp96
	testl	%eax, %eax	# tmp95
	cmovs	%edx, %eax	# tmp96,, tmp95
	sarl	$11, %eax	#, tmp97
	movl	%eax, -32(%rbp)	# tmp97, x
# mandelbrot.c:67:         int y = i % HEIGHT; // int y = i & (HEIGHT-1); 
	movl	-4(%rbp), %edx	# i, tmp99
	movl	%edx, %eax	# tmp99, tmp100
	sarl	$31, %eax	#, tmp100
	shrl	$21, %eax	#, tmp101
	addl	%eax, %edx	# tmp101, tmp102
	andl	$2047, %edx	#, tmp103
	subl	%eax, %edx	# tmp101, tmp104
	movl	%edx, -36(%rbp)	# tmp104, y
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	pxor	%xmm0, %xmm0	# _1
	cvtsi2sdl	-32(%rbp), %xmm0	# x, _1
	mulsd	-16(%rbp), %xmm0	# dx, _2
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	movsd	.LC3(%rip), %xmm1	#, tmp105
	subsd	%xmm1, %xmm0	# tmp105, _3
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	movsd	%xmm0, -64(%rbp)	# _3, c.x
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	pxor	%xmm0, %xmm0	# _4
	cvtsi2sdl	-36(%rbp), %xmm0	# y, _4
	mulsd	-24(%rbp), %xmm0	# dy, _5
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	movsd	.LC3(%rip), %xmm1	#, tmp106
	subsd	%xmm1, %xmm0	# tmp106, _6
# mandelbrot.c:70:         Complex c = {X_MIN + x * dx, Y_MIN + y * dy};
	movsd	%xmm0, -56(%rbp)	# _6, c.y
# mandelbrot.c:73:         int iter = mandelbrot(c);
	movq	-64(%rbp), %rax	# c, tmp107
	movsd	-56(%rbp), %xmm1	# c, tmp108
	movq	%rax, %xmm0	# tmp107,
	call	mandelbrot	#
	movl	%eax, -40(%rbp)	# tmp109, iter
# mandelbrot.c:74:         iter = iter % MAX_ITER;
	movl	-40(%rbp), %eax	# iter, tmp111
	movslq	%eax, %rdx	# tmp111, tmp112
	imulq	$-2147450879, %rdx, %rdx	#, tmp112, tmp113
	shrq	$32, %rdx	#, tmp114
	addl	%eax, %edx	# tmp111, tmp115
	movl	%edx, %ecx	# tmp115, tmp115
	sarl	$15, %ecx	#, tmp115
	cltd
	subl	%edx, %ecx	# tmp117, tmp110
	movl	%ecx, %edx	# tmp110, tmp118
	sall	$16, %edx	#, tmp119
	subl	%ecx, %edx	# tmp110, tmp118
	subl	%edx, %eax	# tmp118, tmp120
	movl	%eax, -40(%rbp)	# tmp120, iter
# mandelbrot.c:77:         image[i] = iter;
	movl	-4(%rbp), %eax	# i, tmp121
	movslq	%eax, %rdx	# tmp121, _7
	movq	-72(%rbp), %rax	# image, tmp122
	addq	%rdx, %rax	# _7, _8
# mandelbrot.c:77:         image[i] = iter;
	movl	-40(%rbp), %edx	# iter, tmp123
	movb	%dl, (%rax)	# _9, *_8
# mandelbrot.c:64:     for (int i = 0; i < total_size; ++i) {
	addl	$1, -4(%rbp)	#, i
.L9:
# mandelbrot.c:64:     for (int i = 0; i < total_size; ++i) {
	movl	-4(%rbp), %eax	# i, tmp124
	cmpl	-28(%rbp), %eax	# total_size, tmp124
	jl	.L10	#,
# mandelbrot.c:79: }
	nop	
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
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$32, %rsp	#,
	movl	%edi, -20(%rbp)	# width, width
	movl	%esi, -24(%rbp)	# height, height
# mandelbrot.c:91:     uint8_t *image = (uint8_t *)calloc(width * height, sizeof(uint8_t));
	movl	-20(%rbp), %eax	# width, tmp86
	imull	-24(%rbp), %eax	# height, _1
# mandelbrot.c:91:     uint8_t *image = (uint8_t *)calloc(width * height, sizeof(uint8_t));
	cltq
	movl	$1, %esi	#,
	movq	%rax, %rdi	# _2,
	call	calloc	#
	movq	%rax, -8(%rbp)	# tmp87, image
# mandelbrot.c:92:     return image;
	movq	-8(%rbp), %rax	# image, _8
# mandelbrot.c:93: }
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
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$16, %rsp	#,
	movq	%rdi, -8(%rbp)	# image, image
# mandelbrot.c:102:     free(image);
	movq	-8(%rbp), %rax	# image, tmp82
	movq	%rax, %rdi	# tmp82,
	call	free	#
# mandelbrot.c:103: }
	nop	
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE9:
	.size	free_image, .-free_image
	.section	.rodata
.LC4:
	.string	"wb"
.LC5:
	.string	"Error opening file\n"
.LC6:
	.string	"P5\n%d %d\n255\n"
	.text
	.globl	save_image
	.type	save_image, @function
save_image:
.LFB10:
	.cfi_startproc
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$48, %rsp	#,
	movq	%rdi, -24(%rbp)	# filename, filename
	movq	%rsi, -32(%rbp)	# image, image
	movl	%edx, -36(%rbp)	# width, width
	movl	%ecx, -40(%rbp)	# height, height
# mandelbrot.c:116:     fp = fopen(filename, "wb");
	movq	-24(%rbp), %rax	# filename, tmp85
	movl	$.LC4, %esi	#,
	movq	%rax, %rdi	# tmp85,
	call	fopen	#
	movq	%rax, -8(%rbp)	# tmp86, fp
# mandelbrot.c:117:     if (fp == NULL) {
	cmpq	$0, -8(%rbp)	#, fp
	jne	.L15	#,
# mandelbrot.c:118:         fprintf(stderr, "Error opening file\n");
	movq	stderr(%rip), %rax	# stderr, stderr.0_1
	movq	%rax, %rcx	# stderr.0_1,
	movl	$19, %edx	#,
	movl	$1, %esi	#,
	movl	$.LC5, %edi	#,
	call	fwrite	#
# mandelbrot.c:119:         return;
	jmp	.L14	#
.L15:
# mandelbrot.c:121:     fprintf(fp, "P5\n%d %d\n255\n", width, height);
	movl	-40(%rbp), %ecx	# height, tmp87
	movl	-36(%rbp), %edx	# width, tmp88
	movq	-8(%rbp), %rax	# fp, tmp89
	movl	$.LC6, %esi	#,
	movq	%rax, %rdi	# tmp89,
	movl	$0, %eax	#,
	call	fprintf	#
# mandelbrot.c:122:     fwrite(image, sizeof(uint8_t), width * height, fp);
	movl	-36(%rbp), %eax	# width, tmp90
	imull	-40(%rbp), %eax	# height, _2
# mandelbrot.c:122:     fwrite(image, sizeof(uint8_t), width * height, fp);
	movslq	%eax, %rdx	# _2, _3
	movq	-8(%rbp), %rcx	# fp, tmp91
	movq	-32(%rbp), %rax	# image, tmp92
	movl	$1, %esi	#,
	movq	%rax, %rdi	# tmp92,
	call	fwrite	#
# mandelbrot.c:123:     fclose(fp);
	movq	-8(%rbp), %rax	# fp, tmp93
	movq	%rax, %rdi	# tmp93,
	call	fclose	#
.L14:
# mandelbrot.c:124: }
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE10:
	.size	save_image, .-save_image
	.section	.rodata
.LC7:
	.string	"w"
.LC8:
	.string	"%d,"
	.text
	.globl	save_image_as_text
	.type	save_image_as_text, @function
save_image_as_text:
.LFB11:
	.cfi_startproc
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$48, %rsp	#,
	movq	%rdi, -24(%rbp)	# filename, filename
	movq	%rsi, -32(%rbp)	# image, image
	movl	%edx, -36(%rbp)	# width, width
	movl	%ecx, -40(%rbp)	# height, height
# mandelbrot.c:129:     fp = fopen(filename, "w");
	movq	-24(%rbp), %rax	# filename, tmp90
	movl	$.LC7, %esi	#,
	movq	%rax, %rdi	# tmp90,
	call	fopen	#
	movq	%rax, -16(%rbp)	# tmp91, fp
# mandelbrot.c:130:     if (fp == NULL) {
	cmpq	$0, -16(%rbp)	#, fp
	jne	.L18	#,
# mandelbrot.c:131:         fprintf(stderr, "Error opening file\n");
	movq	stderr(%rip), %rax	# stderr, stderr.1_1
	movq	%rax, %rcx	# stderr.1_1,
	movl	$19, %edx	#,
	movl	$1, %esi	#,
	movl	$.LC5, %edi	#,
	call	fwrite	#
# mandelbrot.c:132:         return;
	jmp	.L17	#
.L18:
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	movl	$0, -4(%rbp)	#, i
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	jmp	.L20	#
.L22:
# mandelbrot.c:136:         fprintf(fp, "%d,", image[i]);
	movl	-4(%rbp), %eax	# i, tmp92
	movslq	%eax, %rdx	# tmp92, _2
	movq	-32(%rbp), %rax	# image, tmp93
	addq	%rdx, %rax	# _2, _3
	movzbl	(%rax), %eax	# *_3, _4
# mandelbrot.c:136:         fprintf(fp, "%d,", image[i]);
	movzbl	%al, %edx	# _4, _5
	movq	-16(%rbp), %rax	# fp, tmp94
	movl	$.LC8, %esi	#,
	movq	%rax, %rdi	# tmp94,
	movl	$0, %eax	#,
	call	fprintf	#
# mandelbrot.c:137:         if ((i + 1) % width == 0) {
	movl	-4(%rbp), %eax	# i, tmp95
	addl	$1, %eax	#, _6
# mandelbrot.c:137:         if ((i + 1) % width == 0) {
	cltd
	idivl	-36(%rbp)	# width
	movl	%edx, %eax	# tmp96, _7
# mandelbrot.c:137:         if ((i + 1) % width == 0) {
	testl	%eax, %eax	# _7
	jne	.L21	#,
# mandelbrot.c:138:             fprintf(fp, "\n");
	movq	-16(%rbp), %rax	# fp, tmp98
	movq	%rax, %rsi	# tmp98,
	movl	$10, %edi	#,
	call	fputc	#
.L21:
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	addl	$1, -4(%rbp)	#, i
.L20:
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	movl	-36(%rbp), %eax	# width, tmp99
	imull	-40(%rbp), %eax	# height, _8
# mandelbrot.c:135:     for (int i = 0; i < width * height; ++i) {
	cmpl	%eax, -4(%rbp)	# _8, i
	jl	.L22	#,
# mandelbrot.c:141:     fclose(fp);
	movq	-16(%rbp), %rax	# fp, tmp100
	movq	%rax, %rdi	# tmp100,
	call	fclose	#
.L17:
# mandelbrot.c:142: }
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE11:
	.size	save_image_as_text, .-save_image_as_text
	.section	.rodata
.LC9:
	.string	"mandelbrot.pgm"
	.text
	.globl	main
	.type	main, @function
main:
.LFB12:
	.cfi_startproc
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$16, %rsp	#,
# mandelbrot.c:154:     uint8_t *image = allocate_image(WIDTH, HEIGHT);
	movl	$2048, %esi	#,
	movl	$2048, %edi	#,
	call	allocate_image	#
	movq	%rax, -8(%rbp)	# tmp84, image
# mandelbrot.c:157:     mandelbrot_set(image);
	movq	-8(%rbp), %rax	# image, tmp85
	movq	%rax, %rdi	# tmp85,
	call	mandelbrot_set	#
# mandelbrot.c:160:     save_image("mandelbrot.pgm", image, WIDTH, HEIGHT);
	movq	-8(%rbp), %rax	# image, tmp86
	movl	$2048, %ecx	#,
	movl	$2048, %edx	#,
	movq	%rax, %rsi	# tmp86,
	movl	$.LC9, %edi	#,
	call	save_image	#
# mandelbrot.c:163:     free_image(image);
	movq	-8(%rbp), %rax	# image, tmp87
	movq	%rax, %rdi	# tmp87,
	call	free_image	#
# mandelbrot.c:166:     return 0;
	movl	$0, %eax	#, _7
# mandelbrot.c:167: }
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE12:
	.size	main, .-main
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
.LC3:
	.long	0
	.long	1073741824
	.ident	"GCC: (GNU) 13.3.1 20240522 (Red Hat 13.3.1-1)"
	.section	.note.GNU-stack,"",@progbits
