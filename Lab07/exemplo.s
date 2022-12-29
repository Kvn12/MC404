	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"exemplo.c"
	.globl	run_operation
	.p2align	2
	.type	run_operation,@function
run_operation:
	addi	sp, sp, -128
	sw	ra, 124(sp)
	sw	s0, 120(sp)
	addi	s0, sp, 128
	sw	a0, -12(s0)
	lw	a1, -12(s0)
	sw	a1, -84(s0)
	addi	a0, zero, 10
	bltu	a0, a1, .LBB0_29
	lw	a0, -84(s0)
	slli	a0, a0, 2
	lui	a1, %hi(.LJTI0_0)
	addi	a1, a1, %lo(.LJTI0_0)
	add	a0, a0, a1
	lw	a0, 0(a0)
	jr	a0
.LBB0_2:
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	call	puts
	j	.LBB0_30
.LBB0_3:
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	sw	a0, -88(s0)
	call	gets
	lw	a0, -88(s0)
	call	puts
	j	.LBB0_30
.LBB0_4:
	lui	a0, %hi(number)
	lw	a0, %lo(number)(a0)
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	addi	a2, zero, 10
	call	itoa
	call	puts
	j	.LBB0_30
.LBB0_5:
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	sw	a0, -92(s0)
	call	gets
	call	atoi
	lw	a1, -92(s0)
	addi	a2, zero, 16
	call	itoa
	call	puts
	j	.LBB0_30
.LBB0_6:
	call	time
	sw	a0, -16(s0)
	lui	a0, %hi(number)
	lw	a0, %lo(number)(a0)
	call	sleep
	call	time
	sw	a0, -20(s0)
	lw	a0, -20(s0)
	lw	a1, -16(s0)
	sub	a0, a0, a1
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	addi	a2, zero, 10
	call	itoa
	call	puts
	j	.LBB0_30
.LBB0_7:
	call	time
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	addi	a2, zero, 10
	call	itoa
	call	puts
	j	.LBB0_30
.LBB0_8:
	lui	a0, %hi(number)
	lw	a0, %lo(number)(a0)
	addi	a1, zero, 40
	call	approx_sqrt
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	addi	a2, zero, 10
	call	itoa
	call	puts
	j	.LBB0_30
.LBB0_9:
	call	time
	sw	a0, -16(s0)
	lui	a0, %hi(number)
	sw	a0, -104(s0)
	lw	a0, %lo(number)(a0)
	addi	a1, zero, 100
	call	approx_sqrt
	call	time
	sw	a0, -20(s0)
	lw	a0, -20(s0)
	lw	a1, -16(s0)
	sub	a0, a0, a1
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	sw	a1, -100(s0)
	addi	a2, zero, 10
	sw	a2, -96(s0)
	call	itoa
	call	puts
	lw	a0, -104(s0)
	lw	a1, -100(s0)
	lw	a2, -96(s0)
	lw	a0, %lo(number)(a0)
	call	itoa
	call	puts
	j	.LBB0_30
.LBB0_10:
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	sw	a0, -112(s0)
	call	gets
	call	atoi
	mv	a1, a0
	lw	a0, -112(s0)
	sw	a1, -32(s0)
	call	gets
	call	atoi
	mv	a1, a0
	lw	a0, -112(s0)
	sw	a1, -36(s0)
	call	gets
	call	atoi
	mv	a1, a0
	lw	a0, -112(s0)
	sw	a1, -40(s0)
	call	gets
	call	atoi
	mv	a1, a0
	lw	a0, -112(s0)
	sw	a1, -44(s0)
	call	gets
	call	atoi
	mv	a1, a0
	lw	a0, -112(s0)
	sw	a1, -48(s0)
	call	gets
	call	atoi
	lw	a1, -112(s0)
	sw	a0, -52(s0)
	lw	a0, -24(s0)
	addi	a2, zero, 10
	sw	a2, -108(s0)
	call	itoa
	call	puts
	lw	a1, -112(s0)
	lw	a2, -108(s0)
	lw	a0, -28(s0)
	call	itoa
	call	puts
	j	.LBB0_30
.LBB0_11:
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	sw	a0, -116(s0)
	call	gets
	call	atoi
	mv	a1, a0
	lw	a0, -116(s0)
	sw	a1, -56(s0)
	call	gets
	call	atoi
	sw	a0, -60(s0)
	mv	a0, zero
	sw	a0, -64(s0)
	j	.LBB0_12
.LBB0_12:
	lw	a1, -64(s0)
	addi	a0, zero, 2
	blt	a0, a1, .LBB0_19
	j	.LBB0_13
.LBB0_13:
	mv	a0, zero
	sw	a0, -68(s0)
	j	.LBB0_14
.LBB0_14:
	lw	a1, -68(s0)
	addi	a0, zero, 2
	blt	a0, a1, .LBB0_17
	j	.LBB0_15
.LBB0_15:
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	call	gets
	call	atoi
	lw	a2, -64(s0)
	slli	a1, a2, 1
	add	a2, a1, a2
	addi	a1, s0, -77
	add	a1, a1, a2
	lw	a2, -68(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB0_16
.LBB0_16:
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB0_14
.LBB0_17:
	j	.LBB0_18
.LBB0_18:
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB0_12
.LBB0_19:
	lw	a1, -56(s0)
	lw	a2, -60(s0)
	lui	a0, %hi(img)
	addi	a0, a0, %lo(img)
	addi	a3, s0, -77
	call	imageFilter
	mv	a0, zero
	sw	a0, -64(s0)
	j	.LBB0_20
.LBB0_20:
	lw	a0, -64(s0)
	lw	a1, -60(s0)
	bge	a0, a1, .LBB0_27
	j	.LBB0_21
.LBB0_21:
	mv	a0, zero
	sw	a0, -68(s0)
	j	.LBB0_22
.LBB0_22:
	lw	a0, -68(s0)
	lw	a1, -56(s0)
	bge	a0, a1, .LBB0_25
	j	.LBB0_23
.LBB0_23:
	lw	a0, -64(s0)
	lw	a1, -56(s0)
	mul	a0, a0, a1
	lw	a1, -68(s0)
	add	a0, a0, a1
	lui	a1, %hi(img)
	addi	a1, a1, %lo(img)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	lui	a1, %hi(buffer)
	addi	a1, a1, %lo(buffer)
	addi	a2, zero, 10
	call	itoa
	call	puts
	j	.LBB0_24
.LBB0_24:
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB0_22
.LBB0_25:
	j	.LBB0_26
.LBB0_26:
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB0_20
.LBB0_27:
	j	.LBB0_30
.LBB0_28:
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	sw	a0, -120(s0)
	call	gets
	lw	a0, -120(s0)
	call	puts
	lw	a0, -120(s0)
	call	gets
	lw	a0, -120(s0)
	call	puts
	j	.LBB0_30
.LBB0_29:
	j	.LBB0_30
.LBB0_30:
	lw	s0, 120(sp)
	lw	ra, 124(sp)
	addi	sp, sp, 128
	ret
.Lfunc_end0:
	.size	run_operation, .Lfunc_end0-run_operation
	.section	.rodata,"a",@progbits
	.p2align	2
.LJTI0_0:
	.word	.LBB0_2
	.word	.LBB0_3
	.word	.LBB0_4
	.word	.LBB0_5
	.word	.LBB0_6
	.word	.LBB0_7
	.word	.LBB0_8
	.word	.LBB0_9
	.word	.LBB0_10
	.word	.LBB0_11
	.word	.LBB0_28

	.text
	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	call	gets
	call	atoi
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	run_operation
	mv	a0, zero
	call	exit
.Lfunc_end1:
	.size	_start, .Lfunc_end1-_start

	.type	number,@object
	.section	.sdata,"aw",@progbits
	.globl	number
	.p2align	2
number:
	.word	635
	.size	number, 4

	.type	buffer,@object
	.bss
	.globl	buffer
buffer:
	.zero	100
	.size	buffer, 100

	.type	img,@object
	.globl	img
img:
	.zero	40000
	.size	img, 40000

	.ident	"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym run_operation
	.addrsig_sym puts
	.addrsig_sym gets
	.addrsig_sym itoa
	.addrsig_sym atoi
	.addrsig_sym time
	.addrsig_sym sleep
	.addrsig_sym approx_sqrt
	.addrsig_sym imageFilter
	.addrsig_sym exit
	.addrsig_sym number
	.addrsig_sym buffer
	.addrsig_sym img
