	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"Lab03.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	addi	a7, zero, 63	# syscall read (63) 
	ecall	

	mv	a3, a0
	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	addi	a7, zero, 64	# syscall write (64) 
	ecall	

	#NO_APP
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	strlength
	.p2align	2
	.type	strlength,@function
strlength:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	mv	a0, zero
	sw	a0, -16(s0)
	j	.LBB2_1
.LBB2_1:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	mv	a1, zero
	mv	a2, a1
	sw	a2, -20(s0)
	beq	a0, a1, .LBB2_3
	j	.LBB2_2
.LBB2_2:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -10
	snez	a0, a0
	sw	a0, -20(s0)
	j	.LBB2_3
.LBB2_3:
	lw	a0, -20(s0)
	andi	a0, a0, 1
	mv	a1, zero
	beq	a0, a1, .LBB2_6
	j	.LBB2_4
.LBB2_4:
	j	.LBB2_5
.LBB2_5:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB2_1
.LBB2_6:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end2:
	.size	strlength, .Lfunc_end2-strlength

	.globl	charToInt
	.p2align	2
	.type	charToInt,@function
charToInt:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sb	a0, -9(s0)
	lbu	a0, -9(s0)
	addi	a1, zero, 97
	bne	a0, a1, .LBB3_2
	j	.LBB3_1
.LBB3_1:
	addi	a0, zero, 10
	sw	a0, -16(s0)
	j	.LBB3_18
.LBB3_2:
	lbu	a0, -9(s0)
	addi	a1, zero, 98
	bne	a0, a1, .LBB3_4
	j	.LBB3_3
.LBB3_3:
	addi	a0, zero, 11
	sw	a0, -16(s0)
	j	.LBB3_17
.LBB3_4:
	lbu	a0, -9(s0)
	addi	a1, zero, 99
	bne	a0, a1, .LBB3_6
	j	.LBB3_5
.LBB3_5:
	addi	a0, zero, 12
	sw	a0, -16(s0)
	j	.LBB3_16
.LBB3_6:
	lbu	a0, -9(s0)
	addi	a1, zero, 100
	bne	a0, a1, .LBB3_8
	j	.LBB3_7
.LBB3_7:
	addi	a0, zero, 13
	sw	a0, -16(s0)
	j	.LBB3_15
.LBB3_8:
	lbu	a0, -9(s0)
	addi	a1, zero, 101
	bne	a0, a1, .LBB3_10
	j	.LBB3_9
.LBB3_9:
	addi	a0, zero, 14
	sw	a0, -16(s0)
	j	.LBB3_14
.LBB3_10:
	lbu	a0, -9(s0)
	addi	a1, zero, 102
	bne	a0, a1, .LBB3_12
	j	.LBB3_11
.LBB3_11:
	addi	a0, zero, 15
	sw	a0, -16(s0)
	j	.LBB3_13
.LBB3_12:
	lbu	a0, -9(s0)
	addi	a0, a0, -48
	sw	a0, -16(s0)
	j	.LBB3_13
.LBB3_13:
	j	.LBB3_14
.LBB3_14:
	j	.LBB3_15
.LBB3_15:
	j	.LBB3_16
.LBB3_16:
	j	.LBB3_17
.LBB3_17:
	j	.LBB3_18
.LBB3_18:
	lw	a0, -16(s0)
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end3:
	.size	charToInt, .Lfunc_end3-charToInt

	.globl	position
	.p2align	2
	.type	position,@function
position:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sb	a0, -9(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lbu	a0, -9(s0)
	call	charToInt
	sw	a0, -24(s0)
	mv	a0, zero
	sw	a0, -28(s0)
	j	.LBB4_1
.LBB4_1:
	lw	a0, -28(s0)
	lw	a1, -16(s0)
	bge	a0, a1, .LBB4_4
	j	.LBB4_2
.LBB4_2:
	lw	a0, -24(s0)
	lw	a1, -20(s0)
	mul	a0, a0, a1
	sw	a0, -24(s0)
	j	.LBB4_3
.LBB4_3:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB4_1
.LBB4_4:
	lw	a0, -24(s0)
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end4:
	.size	position, .Lfunc_end4-position

	.globl	changeToLet
	.p2align	2
	.type	changeToLet,@function
changeToLet:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	addi	a0, zero, 2
	sw	a0, -20(s0)
	j	.LBB5_1
.LBB5_1:
	lw	a0, -20(s0)
	lw	a1, -16(s0)
	addi	a1, a1, 2
	bge	a0, a1, .LBB5_16
	j	.LBB5_2
.LBB5_2:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	addi	a1, zero, 58
	bne	a0, a1, .LBB5_4
	j	.LBB5_3
.LBB5_3:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a1, a0, a1
	addi	a0, zero, 97
	sb	a0, 0(a1)
	j	.LBB5_4
.LBB5_4:
	lw	a0, -24(s0)
	addi	a1, zero, 59
	bne	a0, a1, .LBB5_6
	j	.LBB5_5
.LBB5_5:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a1, a0, a1
	addi	a0, zero, 98
	sb	a0, 0(a1)
	j	.LBB5_6
.LBB5_6:
	lw	a0, -24(s0)
	addi	a1, zero, 60
	bne	a0, a1, .LBB5_8
	j	.LBB5_7
.LBB5_7:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a1, a0, a1
	addi	a0, zero, 99
	sb	a0, 0(a1)
	j	.LBB5_8
.LBB5_8:
	lw	a0, -24(s0)
	addi	a1, zero, 61
	bne	a0, a1, .LBB5_10
	j	.LBB5_9
.LBB5_9:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a1, a0, a1
	addi	a0, zero, 100
	sb	a0, 0(a1)
	j	.LBB5_10
.LBB5_10:
	lw	a0, -24(s0)
	addi	a1, zero, 62
	bne	a0, a1, .LBB5_12
	j	.LBB5_11
.LBB5_11:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a1, a0, a1
	addi	a0, zero, 101
	sb	a0, 0(a1)
	j	.LBB5_12
.LBB5_12:
	lw	a0, -24(s0)
	addi	a1, zero, 63
	bne	a0, a1, .LBB5_14
	j	.LBB5_13
.LBB5_13:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	add	a1, a0, a1
	addi	a0, zero, 102
	sb	a0, 0(a1)
	j	.LBB5_14
.LBB5_14:
	j	.LBB5_15
.LBB5_15:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB5_1
.LBB5_16:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	changeToLet, .Lfunc_end5-changeToLet

	.globl	toNegative
	.p2align	2
	.type	toNegative,@function
toNegative:
	addi	sp, sp, -64
	sw	ra, 60(sp)
	sw	s0, 56(sp)
	addi	s0, sp, 64
	sw	a0, -12(s0)
	mv	a0, zero
	sw	a0, -52(s0)
	addi	a0, zero, 2
	sw	a0, -56(s0)
	j	.LBB6_1
.LBB6_1:
	lw	a1, -56(s0)
	addi	a0, zero, 34
	blt	a0, a1, .LBB6_8
	j	.LBB6_2
.LBB6_2:
	lw	a0, -12(s0)
	lw	a1, -56(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 48
	bne	a0, a1, .LBB6_4
	j	.LBB6_3
.LBB6_3:
	lw	a1, -56(s0)
	addi	a0, s0, -47
	add	a1, a0, a1
	addi	a0, zero, 49
	sb	a0, 0(a1)
	j	.LBB6_4
.LBB6_4:
	lw	a0, -12(s0)
	lw	a1, -56(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a1, zero, 49
	bne	a0, a1, .LBB6_6
	j	.LBB6_5
.LBB6_5:
	lw	a1, -56(s0)
	addi	a0, s0, -47
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB6_6
.LBB6_6:
	j	.LBB6_7
.LBB6_7:
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	j	.LBB6_1
.LBB6_8:
	mv	a0, zero
	sw	a0, -60(s0)
	j	.LBB6_9
.LBB6_9:
	lw	a1, -60(s0)
	addi	a0, zero, 34
	blt	a0, a1, .LBB6_19
	j	.LBB6_10
.LBB6_10:
	lw	a1, -60(s0)
	addi	a0, s0, -47
	sub	a0, a0, a1
	lbu	a0, 34(a0)
	addi	a1, zero, 98
	bne	a0, a1, .LBB6_12
	j	.LBB6_11
.LBB6_11:
	j	.LBB6_19
.LBB6_12:
	lw	a1, -60(s0)
	addi	a0, s0, -47
	sub	a0, a0, a1
	lbu	a0, 34(a0)
	addi	a1, zero, 49
	bne	a0, a1, .LBB6_14
	j	.LBB6_13
.LBB6_13:
	lw	a1, -60(s0)
	addi	a0, s0, -47
	sub	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 34(a1)
	j	.LBB6_17
.LBB6_14:
	lw	a1, -60(s0)
	addi	a0, s0, -47
	sub	a0, a0, a1
	lbu	a0, 34(a0)
	addi	a1, zero, 48
	bne	a0, a1, .LBB6_16
	j	.LBB6_15
.LBB6_15:
	lw	a1, -60(s0)
	addi	a0, s0, -47
	sub	a1, a0, a1
	addi	a0, zero, 49
	sb	a0, 34(a1)
	addi	a0, zero, 1
	sw	a0, -52(s0)
	j	.LBB6_19
.LBB6_16:
	j	.LBB6_17
.LBB6_17:
	j	.LBB6_18
.LBB6_18:
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB6_9
.LBB6_19:
	lw	a0, -52(s0)
	mv	a1, zero
	beq	a0, a1, .LBB6_25
	j	.LBB6_20
.LBB6_20:
	addi	a0, zero, 2
	sw	a0, -64(s0)
	j	.LBB6_21
.LBB6_21:
	lw	a1, -64(s0)
	addi	a0, zero, 33
	blt	a0, a1, .LBB6_24
	j	.LBB6_22
.LBB6_22:
	lw	a2, -64(s0)
	addi	a0, s0, -47
	add	a0, a0, a2
	lb	a0, 0(a0)
	lw	a1, -12(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB6_23
.LBB6_23:
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB6_21
.LBB6_24:
	j	.LBB6_26
.LBB6_25:
	lw	a1, -12(s0)
	addi	a0, zero, 49
	sb	a0, 2(a1)
	j	.LBB6_26
.LBB6_26:
	lw	s0, 56(sp)
	lw	ra, 60(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end6:
	.size	toNegative, .Lfunc_end6-toNegative

	.globl	decToBin
	.p2align	2
	.type	decToBin,@function
decToBin:
	addi	sp, sp, -128
	sw	ra, 124(sp)
	sw	s0, 120(sp)
	addi	s0, sp, 128
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	mv	a0, zero
	sw	a0, -24(s0)
	sw	a0, -28(s0)
	sw	a0, -32(s0)
	sw	a0, -36(s0)
	addi	a0, zero, 48
	sb	a0, -106(s0)
	addi	a0, zero, 98
	sb	a0, -105(s0)
	lw	a0, -12(s0)
	lbu	a0, 0(a0)
	addi	a1, zero, 45
	bne	a0, a1, .LBB7_2
	j	.LBB7_1
.LBB7_1:
	addi	a0, zero, 1
	sw	a0, -32(s0)
	j	.LBB7_2
.LBB7_2:
	mv	a0, zero
	sw	a0, -112(s0)
	j	.LBB7_3
.LBB7_3:
	lw	a0, -112(s0)
	lw	a1, -20(s0)
	addi	a1, a1, -1
	bge	a0, a1, .LBB7_11
	j	.LBB7_4
.LBB7_4:
	lw	a0, -32(s0)
	mv	a1, zero
	beq	a0, a1, .LBB7_7
	j	.LBB7_5
.LBB7_5:
	lw	a0, -20(s0)
	lw	a1, -112(s0)
	sub	a0, a0, a1
	addi	a0, a0, -2
	addi	a1, zero, 1
	blt	a0, a1, .LBB7_7
	j	.LBB7_6
.LBB7_6:
	lw	a2, -12(s0)
	lw	a0, -20(s0)
	lw	a1, -112(s0)
	sub	a0, a0, a1
	add	a0, a0, a2
	lbu	a0, -2(a0)
	addi	a2, zero, 10
	call	position
	mv	a1, a0
	lw	a0, -24(s0)
	add	a0, a0, a1
	sw	a0, -24(s0)
	j	.LBB7_7
.LBB7_7:
	lw	a0, -32(s0)
	mv	a1, zero
	bne	a0, a1, .LBB7_9
	j	.LBB7_8
.LBB7_8:
	lw	a2, -12(s0)
	lw	a0, -20(s0)
	lw	a1, -112(s0)
	sub	a0, a0, a1
	add	a0, a0, a2
	lbu	a0, -2(a0)
	addi	a2, zero, 10
	call	position
	mv	a1, a0
	lw	a0, -24(s0)
	add	a0, a0, a1
	sw	a0, -24(s0)
	j	.LBB7_9
.LBB7_9:
	j	.LBB7_10
.LBB7_10:
	lw	a0, -112(s0)
	addi	a0, a0, 1
	sw	a0, -112(s0)
	j	.LBB7_3
.LBB7_11:
	j	.LBB7_12
.LBB7_12:
	lw	a0, -24(s0)
	addi	a1, zero, 1
	blt	a0, a1, .LBB7_14
	j	.LBB7_13
.LBB7_13:
	lw	a0, -24(s0)
	srli	a1, a0, 31
	add	a1, a0, a1
	andi	a1, a1, 254
	sub	a0, a0, a1
	addi	a0, a0, 48
	sb	a0, -107(s0)
	lb	a0, -107(s0)
	lw	a2, -28(s0)
	addi	a1, s0, -71
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -24(s0)
	srli	a1, a0, 31
	add	a0, a0, a1
	srai	a0, a0, 1
	sw	a0, -24(s0)
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB7_12
.LBB7_14:
	mv	a0, zero
	sw	a0, -116(s0)
	j	.LBB7_15
.LBB7_15:
	lw	a0, -116(s0)
	lw	a1, -28(s0)
	bge	a0, a1, .LBB7_18
	j	.LBB7_16
.LBB7_16:
	lw	a0, -28(s0)
	lw	a1, -116(s0)
	sub	a0, a0, a1
	addi	a2, s0, -71
	add	a0, a0, a2
	lb	a0, -1(a0)
	lw	a2, -16(s0)
	add	a1, a1, a2
	sb	a0, 2(a1)
	j	.LBB7_17
.LBB7_17:
	lw	a0, -116(s0)
	addi	a0, a0, 1
	sw	a0, -116(s0)
	j	.LBB7_15
.LBB7_18:
	lw	a1, -16(s0)
	lw	a0, -28(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 2(a1)
	lw	a0, -28(s0)
	addi	a0, a0, 3
	sw	a0, -36(s0)
	lw	a0, -36(s0)
	addi	a1, a0, -1
	addi	a0, zero, 32
	blt	a0, a1, .LBB7_32
	j	.LBB7_19
.LBB7_19:
	mv	a0, zero
	sw	a0, -120(s0)
	j	.LBB7_20
.LBB7_20:
	lw	a0, -120(s0)
	lw	a1, -36(s0)
	addi	a1, a1, -1
	bge	a0, a1, .LBB7_23
	j	.LBB7_21
.LBB7_21:
	lw	a1, -16(s0)
	lw	a0, -36(s0)
	lw	a2, -120(s0)
	sub	a0, a0, a2
	add	a0, a0, a1
	lb	a0, -2(a0)
	addi	a1, s0, -106
	sub	a1, a1, a2
	sb	a0, 33(a1)
	j	.LBB7_22
.LBB7_22:
	lw	a0, -120(s0)
	addi	a0, a0, 1
	sw	a0, -120(s0)
	j	.LBB7_20
.LBB7_23:
	mv	a0, zero
	sw	a0, -124(s0)
	j	.LBB7_24
.LBB7_24:
	lw	a0, -124(s0)
	lw	a2, -36(s0)
	addi	a1, zero, 35
	sub	a1, a1, a2
	bge	a0, a1, .LBB7_27
	j	.LBB7_25
.LBB7_25:
	lw	a0, -124(s0)
	addi	a1, s0, -106
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 2(a1)
	j	.LBB7_26
.LBB7_26:
	lw	a0, -124(s0)
	addi	a0, a0, 1
	sw	a0, -124(s0)
	j	.LBB7_24
.LBB7_27:
	mv	a0, zero
	sw	a0, -128(s0)
	j	.LBB7_28
.LBB7_28:
	lw	a1, -128(s0)
	addi	a0, zero, 33
	blt	a0, a1, .LBB7_31
	j	.LBB7_29
.LBB7_29:
	lw	a2, -128(s0)
	addi	a0, s0, -106
	add	a0, a0, a2
	lb	a0, 0(a0)
	lw	a1, -16(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB7_30
.LBB7_30:
	lw	a0, -128(s0)
	addi	a0, a0, 1
	sw	a0, -128(s0)
	j	.LBB7_28
.LBB7_31:
	lw	a1, -16(s0)
	addi	a0, zero, 10
	sb	a0, 34(a1)
	j	.LBB7_32
.LBB7_32:
	lw	a0, -32(s0)
	mv	a1, zero
	beq	a0, a1, .LBB7_34
	j	.LBB7_33
.LBB7_33:
	lw	a0, -16(s0)
	call	toNegative
	j	.LBB7_34
.LBB7_34:
	lw	s0, 120(sp)
	lw	ra, 124(sp)
	addi	sp, sp, 128
	ret
.Lfunc_end7:
	.size	decToBin, .Lfunc_end7-decToBin

	.globl	hexToBin
	.p2align	2
	.type	hexToBin,@function
hexToBin:
	addi	sp, sp, -112
	sw	ra, 108(sp)
	sw	s0, 104(sp)
	addi	s0, sp, 112
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	addi	a0, zero, 2
	sw	a0, -24(s0)
	addi	a1, zero, 48
	sb	a1, -68(s0)
	addi	a1, zero, 98
	sb	a1, -67(s0)
	sw	a0, -72(s0)
	j	.LBB8_1
.LBB8_1:
	lw	a0, -72(s0)
	lw	a1, -20(s0)
	addi	a1, a1, -1
	bge	a0, a1, .LBB8_19
	j	.LBB8_2
.LBB8_2:
	lw	a0, -12(s0)
	lw	a1, -72(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	call	charToInt
	sw	a0, -76(s0)
	mv	a0, zero
	sw	a0, -80(s0)
	j	.LBB8_3
.LBB8_3:
	lw	a0, -76(s0)
	addi	a1, zero, 1
	blt	a0, a1, .LBB8_5
	j	.LBB8_4
.LBB8_4:
	lw	a0, -76(s0)
	srli	a1, a0, 31
	add	a1, a0, a1
	andi	a1, a1, 254
	sub	a0, a0, a1
	addi	a0, a0, 48
	sb	a0, -33(s0)
	lb	a0, -33(s0)
	lw	a2, -80(s0)
	addi	a1, s0, -32
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -76(s0)
	srli	a1, a0, 31
	add	a0, a0, a1
	srai	a0, a0, 1
	sw	a0, -76(s0)
	lw	a0, -80(s0)
	addi	a0, a0, 1
	sw	a0, -80(s0)
	j	.LBB8_3
.LBB8_5:
	mv	a0, zero
	sw	a0, -84(s0)
	j	.LBB8_6
.LBB8_6:
	lw	a0, -84(s0)
	lw	a2, -80(s0)
	addi	a1, zero, 4
	sub	a1, a1, a2
	bge	a0, a1, .LBB8_9
	j	.LBB8_7
.LBB8_7:
	lw	a0, -80(s0)
	lw	a1, -84(s0)
	add	a1, a0, a1
	addi	a0, s0, -32
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 0(a1)
	j	.LBB8_8
.LBB8_8:
	lw	a0, -84(s0)
	addi	a0, a0, 1
	sw	a0, -84(s0)
	j	.LBB8_6
.LBB8_9:
	mv	a0, zero
	sw	a0, -88(s0)
	j	.LBB8_10
.LBB8_10:
	lw	a1, -88(s0)
	addi	a0, zero, 3
	blt	a0, a1, .LBB8_13
	j	.LBB8_11
.LBB8_11:
	lw	a1, -88(s0)
	addi	a0, s0, -32
	sub	a0, a0, a1
	lb	a0, 3(a0)
	lw	a1, -16(s0)
	lw	a2, -24(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB8_12
.LBB8_12:
	lw	a0, -88(s0)
	addi	a0, a0, 1
	sw	a0, -88(s0)
	j	.LBB8_10
.LBB8_13:
	mv	a0, zero
	sw	a0, -92(s0)
	j	.LBB8_14
.LBB8_14:
	lw	a1, -92(s0)
	addi	a0, zero, 3
	blt	a0, a1, .LBB8_17
	j	.LBB8_15
.LBB8_15:
	lw	a1, -92(s0)
	addi	a0, s0, -32
	add	a1, a0, a1
	mv	a0, zero
	sb	a0, 0(a1)
	j	.LBB8_16
.LBB8_16:
	lw	a0, -92(s0)
	addi	a0, a0, 1
	sw	a0, -92(s0)
	j	.LBB8_14
.LBB8_17:
	j	.LBB8_18
.LBB8_18:
	lw	a0, -72(s0)
	addi	a0, a0, 1
	sw	a0, -72(s0)
	j	.LBB8_1
.LBB8_19:
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	lw	a0, -28(s0)
	addi	a1, a0, -1
	addi	a0, zero, 31
	blt	a0, a1, .LBB8_33
	j	.LBB8_20
.LBB8_20:
	mv	a0, zero
	sw	a0, -96(s0)
	j	.LBB8_21
.LBB8_21:
	lw	a0, -96(s0)
	lw	a1, -28(s0)
	addi	a1, a1, -2
	bge	a0, a1, .LBB8_24
	j	.LBB8_22
.LBB8_22:
	lw	a1, -16(s0)
	lw	a0, -28(s0)
	lw	a2, -96(s0)
	sub	a0, a0, a2
	add	a0, a0, a1
	lb	a0, -2(a0)
	addi	a1, s0, -68
	sub	a1, a1, a2
	sb	a0, 33(a1)
	j	.LBB8_23
.LBB8_23:
	lw	a0, -96(s0)
	addi	a0, a0, 1
	sw	a0, -96(s0)
	j	.LBB8_21
.LBB8_24:
	mv	a0, zero
	sw	a0, -100(s0)
	j	.LBB8_25
.LBB8_25:
	lw	a0, -100(s0)
	lw	a2, -28(s0)
	addi	a1, zero, 35
	sub	a1, a1, a2
	bge	a0, a1, .LBB8_28
	j	.LBB8_26
.LBB8_26:
	lw	a0, -100(s0)
	addi	a1, s0, -68
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 2(a1)
	j	.LBB8_27
.LBB8_27:
	lw	a0, -100(s0)
	addi	a0, a0, 1
	sw	a0, -100(s0)
	j	.LBB8_25
.LBB8_28:
	mv	a0, zero
	sw	a0, -104(s0)
	j	.LBB8_29
.LBB8_29:
	lw	a1, -104(s0)
	addi	a0, zero, 33
	blt	a0, a1, .LBB8_32
	j	.LBB8_30
.LBB8_30:
	lw	a2, -104(s0)
	addi	a0, s0, -68
	add	a0, a0, a2
	lb	a0, 0(a0)
	lw	a1, -16(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB8_31
.LBB8_31:
	lw	a0, -104(s0)
	addi	a0, a0, 1
	sw	a0, -104(s0)
	j	.LBB8_29
.LBB8_32:
	j	.LBB8_33
.LBB8_33:
	lw	a1, -16(s0)
	addi	a0, zero, 10
	sb	a0, 34(a1)
	lw	s0, 104(sp)
	lw	ra, 108(sp)
	addi	sp, sp, 112
	ret
.Lfunc_end8:
	.size	hexToBin, .Lfunc_end8-hexToBin

	.globl	hexToDecUnsigned
	.p2align	2
	.type	hexToDecUnsigned,@function
hexToDecUnsigned:
	addi	sp, sp, -192
	sw	ra, 188(sp)
	sw	s0, 184(sp)
	addi	s0, sp, 192
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	sw	a4, -28(s0)
	mv	a0, zero
	sw	a0, -32(s0)
	sw	a0, -176(s0)
	sw	a0, -184(s0)
	lw	a0, -20(s0)
	lbu	a0, 2(a0)
	addi	a1, zero, 49
	bne	a0, a1, .LBB9_3
	j	.LBB9_1
.LBB9_1:
	lw	a0, -28(s0)
	mv	a1, zero
	bne	a0, a1, .LBB9_3
	j	.LBB9_2
.LBB9_2:
	lw	a1, -16(s0)
	addi	a0, zero, 45
	sb	a0, 0(a1)
	addi	a0, zero, 1
	sw	a0, -176(s0)
	j	.LBB9_3
.LBB9_3:
	mv	a0, zero
	sw	a0, -188(s0)
	j	.LBB9_4
.LBB9_4:
	lw	a0, -188(s0)
	lw	a1, -24(s0)
	addi	a1, a1, -3
	bge	a0, a1, .LBB9_7
	j	.LBB9_5
.LBB9_5:
	lw	a2, -12(s0)
	lw	a0, -24(s0)
	lw	a1, -188(s0)
	sub	a0, a0, a1
	add	a0, a0, a2
	lbu	a0, -2(a0)
	addi	a2, zero, 16
	call	position
	mv	a1, a0
	lw	a0, -184(s0)
	add	a0, a0, a1
	sw	a0, -184(s0)
	j	.LBB9_6
.LBB9_6:
	lw	a0, -188(s0)
	addi	a0, a0, 1
	sw	a0, -188(s0)
	j	.LBB9_4
.LBB9_7:
	j	.LBB9_8
.LBB9_8:
	lw	a0, -184(s0)
	mv	a1, zero
	beq	a0, a1, .LBB9_10
	j	.LBB9_9
.LBB9_9:
	lw	a0, -184(s0)
	lui	a1, 838861
	addi	a1, a1, -819
	mulhu	a2, a0, a1
	srli	a2, a2, 3
	addi	a3, zero, 10
	mul	a2, a2, a3
	sub	a0, a0, a2
	lw	a2, -32(s0)
	slli	a3, a2, 2
	addi	a2, s0, -172
	add	a2, a2, a3
	sw	a0, 0(a2)
	lw	a0, -184(s0)
	mulhu	a0, a0, a1
	srli	a0, a0, 3
	sw	a0, -184(s0)
	lw	a0, -32(s0)
	addi	a0, a0, 1
	sw	a0, -32(s0)
	j	.LBB9_8
.LBB9_10:
	mv	a0, zero
	sw	a0, -192(s0)
	j	.LBB9_11
.LBB9_11:
	lw	a0, -192(s0)
	lw	a1, -32(s0)
	bge	a0, a1, .LBB9_17
	j	.LBB9_12
.LBB9_12:
	lw	a0, -176(s0)
	mv	a1, zero
	beq	a0, a1, .LBB9_14
	j	.LBB9_13
.LBB9_13:
	lw	a0, -32(s0)
	lw	a1, -192(s0)
	sub	a0, a0, a1
	slli	a0, a0, 2
	addi	a1, s0, -172
	add	a0, a0, a1
	lw	a0, -4(a0)
	addi	a0, a0, 48
	sb	a0, -177(s0)
	lb	a0, -177(s0)
	lw	a2, -16(s0)
	lw	a1, -192(s0)
	add	a1, a1, a2
	sb	a0, 1(a1)
	j	.LBB9_15
.LBB9_14:
	lw	a0, -32(s0)
	lw	a1, -192(s0)
	sub	a0, a0, a1
	slli	a0, a0, 2
	addi	a1, s0, -172
	add	a0, a0, a1
	lw	a0, -4(a0)
	addi	a0, a0, 48
	sb	a0, -177(s0)
	lb	a0, -177(s0)
	lw	a1, -16(s0)
	lw	a2, -192(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB9_15
.LBB9_15:
	j	.LBB9_16
.LBB9_16:
	lw	a0, -192(s0)
	addi	a0, a0, 1
	sw	a0, -192(s0)
	j	.LBB9_11
.LBB9_17:
	lw	a0, -176(s0)
	mv	a1, zero
	beq	a0, a1, .LBB9_19
	j	.LBB9_18
.LBB9_18:
	lw	a1, -16(s0)
	lw	a0, -32(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 1(a1)
	j	.LBB9_20
.LBB9_19:
	lw	a0, -16(s0)
	lw	a1, -32(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 0(a1)
	j	.LBB9_20
.LBB9_20:
	lw	s0, 184(sp)
	lw	ra, 188(sp)
	addi	sp, sp, 192
	ret
.Lfunc_end9:
	.size	hexToDecUnsigned, .Lfunc_end9-hexToDecUnsigned

	.globl	hexToDecSigned
	.p2align	2
	.type	hexToDecSigned,@function
hexToDecSigned:
	addi	sp, sp, -192
	sw	ra, 188(sp)
	sw	s0, 184(sp)
	addi	s0, sp, 192
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	sw	a4, -28(s0)
	mv	a0, zero
	sw	a0, -32(s0)
	sw	a0, -176(s0)
	sw	a0, -184(s0)
	lw	a0, -20(s0)
	lbu	a0, 2(a0)
	addi	a1, zero, 49
	bne	a0, a1, .LBB10_3
	j	.LBB10_1
.LBB10_1:
	lw	a0, -28(s0)
	mv	a1, zero
	bne	a0, a1, .LBB10_3
	j	.LBB10_2
.LBB10_2:
	lw	a1, -16(s0)
	addi	a0, zero, 45
	sb	a0, 0(a1)
	addi	a0, zero, 1
	sw	a0, -176(s0)
	j	.LBB10_3
.LBB10_3:
	mv	a0, zero
	sw	a0, -188(s0)
	j	.LBB10_4
.LBB10_4:
	lw	a0, -188(s0)
	lw	a1, -24(s0)
	addi	a1, a1, -3
	bge	a0, a1, .LBB10_7
	j	.LBB10_5
.LBB10_5:
	lw	a2, -12(s0)
	lw	a0, -24(s0)
	lw	a1, -188(s0)
	sub	a0, a0, a1
	add	a0, a0, a2
	lbu	a0, -2(a0)
	addi	a2, zero, 16
	call	position
	mv	a1, a0
	lw	a0, -184(s0)
	add	a0, a0, a1
	sw	a0, -184(s0)
	j	.LBB10_6
.LBB10_6:
	lw	a0, -188(s0)
	addi	a0, a0, 1
	sw	a0, -188(s0)
	j	.LBB10_4
.LBB10_7:
	lw	a1, -184(s0)
	addi	a0, zero, -1
	blt	a0, a1, .LBB10_9
	j	.LBB10_8
.LBB10_8:
	lw	a1, -184(s0)
	mv	a0, zero
	sub	a0, a0, a1
	sw	a0, -184(s0)
	j	.LBB10_9
.LBB10_9:
	j	.LBB10_10
.LBB10_10:
	lw	a0, -184(s0)
	addi	a1, zero, 1
	blt	a0, a1, .LBB10_12
	j	.LBB10_11
.LBB10_11:
	lw	a0, -184(s0)
	lui	a1, 419430
	addi	a1, a1, 1639
	mulh	a2, a0, a1
	srli	a3, a2, 31
	srai	a2, a2, 2
	add	a2, a2, a3
	addi	a3, zero, 10
	mul	a2, a2, a3
	sub	a0, a0, a2
	lw	a2, -32(s0)
	slli	a3, a2, 2
	addi	a2, s0, -172
	add	a2, a2, a3
	sw	a0, 0(a2)
	lw	a0, -184(s0)
	mulh	a0, a0, a1
	srli	a1, a0, 31
	srai	a0, a0, 2
	add	a0, a0, a1
	sw	a0, -184(s0)
	lw	a0, -32(s0)
	addi	a0, a0, 1
	sw	a0, -32(s0)
	j	.LBB10_10
.LBB10_12:
	mv	a0, zero
	sw	a0, -192(s0)
	j	.LBB10_13
.LBB10_13:
	lw	a0, -192(s0)
	lw	a1, -32(s0)
	bge	a0, a1, .LBB10_19
	j	.LBB10_14
.LBB10_14:
	lw	a0, -176(s0)
	mv	a1, zero
	beq	a0, a1, .LBB10_16
	j	.LBB10_15
.LBB10_15:
	lw	a0, -32(s0)
	lw	a1, -192(s0)
	sub	a0, a0, a1
	slli	a0, a0, 2
	addi	a1, s0, -172
	add	a0, a0, a1
	lw	a0, -4(a0)
	addi	a0, a0, 48
	sb	a0, -177(s0)
	lb	a0, -177(s0)
	lw	a2, -16(s0)
	lw	a1, -192(s0)
	add	a1, a1, a2
	sb	a0, 1(a1)
	j	.LBB10_17
.LBB10_16:
	lw	a0, -32(s0)
	lw	a1, -192(s0)
	sub	a0, a0, a1
	slli	a0, a0, 2
	addi	a1, s0, -172
	add	a0, a0, a1
	lw	a0, -4(a0)
	addi	a0, a0, 48
	sb	a0, -177(s0)
	lb	a0, -177(s0)
	lw	a1, -16(s0)
	lw	a2, -192(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB10_17
.LBB10_17:
	j	.LBB10_18
.LBB10_18:
	lw	a0, -192(s0)
	addi	a0, a0, 1
	sw	a0, -192(s0)
	j	.LBB10_13
.LBB10_19:
	lw	a0, -176(s0)
	mv	a1, zero
	beq	a0, a1, .LBB10_21
	j	.LBB10_20
.LBB10_20:
	lw	a1, -16(s0)
	lw	a0, -32(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 1(a1)
	j	.LBB10_22
.LBB10_21:
	lw	a0, -16(s0)
	lw	a1, -32(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 0(a1)
	j	.LBB10_22
.LBB10_22:
	lw	s0, 184(sp)
	lw	ra, 188(sp)
	addi	sp, sp, 192
	ret
.Lfunc_end10:
	.size	hexToDecSigned, .Lfunc_end10-hexToDecSigned

	.globl	hexToDec
	.p2align	2
	.type	hexToDec,@function
hexToDec:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	sw	a4, -28(s0)
	lw	a0, -20(s0)
	lbu	a0, 2(a0)
	addi	a1, zero, 49
	bne	a0, a1, .LBB11_3
	j	.LBB11_1
.LBB11_1:
	lw	a0, -20(s0)
	lbu	a0, 3(a0)
	addi	a1, zero, 49
	bne	a0, a1, .LBB11_3
	j	.LBB11_2
.LBB11_2:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	lw	a2, -20(s0)
	lw	a3, -24(s0)
	lw	a4, -28(s0)
	call	hexToDecSigned
	j	.LBB11_4
.LBB11_3:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	lw	a2, -20(s0)
	lw	a3, -24(s0)
	lw	a4, -28(s0)
	call	hexToDecUnsigned
	j	.LBB11_4
.LBB11_4:
	lw	s0, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end11:
	.size	hexToDec, .Lfunc_end11-hexToDec

	.globl	binToHex
	.p2align	2
	.type	binToHex,@function
binToHex:
	addi	sp, sp, -80
	sw	ra, 76(sp)
	sw	s0, 72(sp)
	addi	s0, sp, 80
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	mv	a0, zero
	sw	a0, -20(s0)
	addi	a1, zero, 1
	sw	a1, -24(s0)
	sw	a0, -28(s0)
	sw	a0, -60(s0)
	j	.LBB12_1
.LBB12_1:
	lw	a1, -60(s0)
	addi	a0, zero, 34
	blt	a0, a1, .LBB12_10
	j	.LBB12_2
.LBB12_2:
	lw	a0, -12(s0)
	lw	a1, -60(s0)
	sub	a0, a0, a1
	lb	a0, 33(a0)
	lw	a2, -24(s0)
	addi	a1, s0, -53
	sub	a1, a1, a2
	sb	a0, 4(a1)
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	addi	a1, zero, 5
	bne	a0, a1, .LBB12_8
	j	.LBB12_3
.LBB12_3:
	mv	a0, zero
	sw	a0, -64(s0)
	sw	a0, -68(s0)
	j	.LBB12_4
.LBB12_4:
	lw	a1, -68(s0)
	addi	a0, zero, 3
	blt	a0, a1, .LBB12_7
	j	.LBB12_5
.LBB12_5:
	lw	a1, -68(s0)
	addi	a0, s0, -53
	sub	a0, a0, a1
	lbu	a0, 3(a0)
	addi	a2, zero, 2
	call	position
	mv	a1, a0
	lw	a0, -64(s0)
	add	a0, a0, a1
	sw	a0, -64(s0)
	j	.LBB12_6
.LBB12_6:
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB12_4
.LBB12_7:
	lw	a0, -64(s0)
	addi	a0, a0, 48
	sb	a0, -29(s0)
	lb	a0, -29(s0)
	lw	a2, -20(s0)
	addi	a1, s0, -49
	add	a1, a1, a2
	sb	a0, 0(a1)
	addi	a0, zero, 1
	sw	a0, -24(s0)
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB12_8
.LBB12_8:
	j	.LBB12_9
.LBB12_9:
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB12_1
.LBB12_10:
	lw	a1, -16(s0)
	addi	a0, zero, 48
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	addi	a0, zero, 120
	sb	a0, 1(a1)
	mv	a0, zero
	sw	a0, -72(s0)
	j	.LBB12_11
.LBB12_11:
	lw	a0, -72(s0)
	lw	a1, -20(s0)
	bge	a0, a1, .LBB12_14
	j	.LBB12_12
.LBB12_12:
	lw	a0, -20(s0)
	lw	a1, -72(s0)
	sub	a0, a0, a1
	addi	a2, s0, -49
	add	a0, a0, a2
	lb	a0, -1(a0)
	lw	a2, -16(s0)
	add	a1, a1, a2
	sb	a0, 2(a1)
	j	.LBB12_13
.LBB12_13:
	lw	a0, -72(s0)
	addi	a0, a0, 1
	sw	a0, -72(s0)
	j	.LBB12_11
.LBB12_14:
	lw	a1, -16(s0)
	lw	a0, -20(s0)
	add	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 2(a1)
	lw	a0, -16(s0)
	lw	a1, -20(s0)
	call	changeToLet
	lw	s0, 72(sp)
	lw	ra, 76(sp)
	addi	sp, sp, 80
	ret
.Lfunc_end12:
	.size	binToHex, .Lfunc_end12-binToHex

	.globl	endianessInverter
	.p2align	2
	.type	endianessInverter,@function
endianessInverter:
	addi	sp, sp, -64
	sw	ra, 60(sp)
	sw	s0, 56(sp)
	addi	s0, sp, 64
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a0, -12(s0)
	call	strlength
	sw	a0, -52(s0)
	lw	a1, -16(s0)
	addi	a0, zero, 48
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	addi	a0, zero, 120
	sb	a0, 1(a1)
	lw	a0, -52(s0)
	addi	a1, a0, -1
	addi	a0, zero, 9
	blt	a0, a1, .LBB13_10
	j	.LBB13_1
.LBB13_1:
	mv	a0, zero
	sw	a0, -56(s0)
	j	.LBB13_2
.LBB13_2:
	lw	a0, -56(s0)
	lw	a1, -52(s0)
	addi	a1, a1, -3
	bge	a0, a1, .LBB13_5
	j	.LBB13_3
.LBB13_3:
	lw	a1, -12(s0)
	lw	a0, -52(s0)
	lw	a2, -56(s0)
	sub	a0, a0, a2
	add	a0, a0, a1
	lb	a0, -2(a0)
	addi	a1, s0, -48
	sub	a1, a1, a2
	sb	a0, 9(a1)
	j	.LBB13_4
.LBB13_4:
	lw	a0, -56(s0)
	addi	a0, a0, 1
	sw	a0, -56(s0)
	j	.LBB13_2
.LBB13_5:
	mv	a0, zero
	sw	a0, -60(s0)
	j	.LBB13_6
.LBB13_6:
	lw	a0, -60(s0)
	lw	a2, -52(s0)
	addi	a1, zero, 11
	sub	a1, a1, a2
	bge	a0, a1, .LBB13_9
	j	.LBB13_7
.LBB13_7:
	lw	a0, -60(s0)
	addi	a1, s0, -48
	add	a1, a0, a1
	addi	a0, zero, 48
	sb	a0, 2(a1)
	j	.LBB13_8
.LBB13_8:
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB13_6
.LBB13_9:
	lb	a0, -40(s0)
	lw	a1, -16(s0)
	sb	a0, 2(a1)
	lb	a0, -39(s0)
	lw	a1, -16(s0)
	sb	a0, 3(a1)
	lb	a0, -42(s0)
	lw	a1, -16(s0)
	sb	a0, 4(a1)
	lb	a0, -41(s0)
	lw	a1, -16(s0)
	sb	a0, 5(a1)
	lb	a0, -44(s0)
	lw	a1, -16(s0)
	sb	a0, 6(a1)
	lb	a0, -43(s0)
	lw	a1, -16(s0)
	sb	a0, 7(a1)
	lb	a0, -46(s0)
	lw	a1, -16(s0)
	sb	a0, 8(a1)
	lb	a0, -45(s0)
	lw	a1, -16(s0)
	sb	a0, 9(a1)
	lw	a1, -16(s0)
	addi	a0, zero, 10
	sb	a0, 10(a1)
	j	.LBB13_11
.LBB13_10:
	lw	a0, -12(s0)
	lb	a0, 8(a0)
	lw	a1, -16(s0)
	sb	a0, 2(a1)
	lw	a0, -12(s0)
	lb	a0, 9(a0)
	lw	a1, -16(s0)
	sb	a0, 3(a1)
	lw	a0, -12(s0)
	lb	a0, 6(a0)
	lw	a1, -16(s0)
	sb	a0, 4(a1)
	lw	a0, -12(s0)
	lb	a0, 7(a0)
	lw	a1, -16(s0)
	sb	a0, 5(a1)
	lw	a0, -12(s0)
	lb	a0, 4(a0)
	lw	a1, -16(s0)
	sb	a0, 6(a1)
	lw	a0, -12(s0)
	lb	a0, 5(a0)
	lw	a1, -16(s0)
	sb	a0, 7(a1)
	lw	a0, -12(s0)
	lb	a0, 2(a0)
	lw	a1, -16(s0)
	sb	a0, 8(a1)
	lw	a0, -12(s0)
	lb	a0, 3(a0)
	lw	a1, -16(s0)
	sb	a0, 9(a1)
	lw	a1, -16(s0)
	addi	a0, zero, 10
	sb	a0, 10(a1)
	j	.LBB13_11
.LBB13_11:
	lw	s0, 56(sp)
	lw	ra, 60(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end13:
	.size	endianessInverter, .Lfunc_end13-endianessInverter

	.globl	truncate
	.p2align	2
	.type	truncate,@function
truncate:
	addi	sp, sp, -80
	sw	ra, 76(sp)
	sw	s0, 72(sp)
	addi	s0, sp, 80
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	addi	a0, zero, 48
	sb	a0, -51(s0)
	lw	a0, -16(s0)
	addi	a1, zero, 1
	bne	a0, a1, .LBB14_2
	j	.LBB14_1
.LBB14_1:
	addi	a0, zero, 98
	sb	a0, -50(s0)
	j	.LBB14_3
.LBB14_2:
	addi	a0, zero, 120
	sb	a0, -50(s0)
	j	.LBB14_3
.LBB14_3:
	addi	a0, zero, 2
	sw	a0, -60(s0)
	j	.LBB14_4
.LBB14_4:
	lw	a0, -12(s0)
	lw	a1, -60(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	mv	a2, zero
	addi	a1, zero, 48
	sw	a2, -72(s0)
	bne	a0, a1, .LBB14_6
	j	.LBB14_5
.LBB14_5:
	lw	a0, -60(s0)
	slti	a0, a0, 35
	sw	a0, -72(s0)
	j	.LBB14_6
.LBB14_6:
	lw	a0, -72(s0)
	andi	a0, a0, 1
	mv	a1, zero
	beq	a0, a1, .LBB14_9
	j	.LBB14_7
.LBB14_7:
	j	.LBB14_8
.LBB14_8:
	lw	a0, -60(s0)
	addi	a0, a0, 1
	sw	a0, -60(s0)
	j	.LBB14_4
.LBB14_9:
	lw	a0, -60(s0)
	sw	a0, -56(s0)
	lw	a0, -56(s0)
	sw	a0, -64(s0)
	j	.LBB14_10
.LBB14_10:
	lw	a1, -64(s0)
	addi	a0, zero, 34
	blt	a0, a1, .LBB14_13
	j	.LBB14_11
.LBB14_11:
	lw	a0, -12(s0)
	lw	a1, -64(s0)
	add	a0, a0, a1
	lb	a0, 0(a0)
	lw	a2, -56(s0)
	sub	a1, a1, a2
	addi	a2, s0, -51
	add	a1, a1, a2
	sb	a0, 2(a1)
	j	.LBB14_12
.LBB14_12:
	lw	a0, -64(s0)
	addi	a0, a0, 1
	sw	a0, -64(s0)
	j	.LBB14_10
.LBB14_13:
	mv	a0, zero
	sw	a0, -68(s0)
	j	.LBB14_14
.LBB14_14:
	lw	a0, -68(s0)
	lw	a2, -56(s0)
	addi	a1, zero, 36
	sub	a1, a1, a2
	bge	a0, a1, .LBB14_17
	j	.LBB14_15
.LBB14_15:
	lw	a2, -68(s0)
	addi	a0, s0, -51
	add	a0, a0, a2
	lb	a0, 0(a0)
	lw	a1, -12(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB14_16
.LBB14_16:
	lw	a0, -68(s0)
	addi	a0, a0, 1
	sw	a0, -68(s0)
	j	.LBB14_14
.LBB14_17:
	lw	a0, -12(s0)
	lw	a1, -56(s0)
	sub	a1, a0, a1
	addi	a0, zero, 10
	sb	a0, 36(a1)
	lw	s0, 72(sp)
	lw	ra, 76(sp)
	addi	sp, sp, 80
	ret
.Lfunc_end14:
	.size	truncate, .Lfunc_end14-truncate

	.globl	handler
	.p2align	2
	.type	handler,@function
handler:
	addi	sp, sp, -64
	sw	ra, 60(sp)
	sw	s0, 56(sp)
	addi	s0, sp, 64
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	sw	a4, -28(s0)
	sw	a5, -32(s0)
	sw	a6, -36(s0)
	lw	a0, -12(s0)
	lbu	a0, 1(a0)
	addi	a1, zero, 120
	bne	a0, a1, .LBB15_6
	j	.LBB15_1
.LBB15_1:
	mv	a0, zero
	sw	a0, -40(s0)
	j	.LBB15_2
.LBB15_2:
	lw	a0, -40(s0)
	lw	a1, -36(s0)
	bge	a0, a1, .LBB15_5
	j	.LBB15_3
.LBB15_3:
	lw	a0, -12(s0)
	lw	a2, -40(s0)
	add	a0, a0, a2
	lb	a0, 0(a0)
	lw	a1, -24(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB15_4
.LBB15_4:
	lw	a0, -40(s0)
	addi	a0, a0, 1
	sw	a0, -40(s0)
	j	.LBB15_2
.LBB15_5:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	lw	a2, -36(s0)
	call	hexToBin
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	lw	a2, -16(s0)
	lw	a3, -36(s0)
	mv	a4, zero
	call	hexToDec
	lw	a0, -24(s0)
	lw	a1, -28(s0)
	call	endianessInverter
	lw	a0, -28(s0)
	call	strlength
	sw	a0, -44(s0)
	lw	a0, -28(s0)
	lw	a1, -32(s0)
	lw	a2, -16(s0)
	lw	a3, -44(s0)
	addi	a4, zero, 1
	call	hexToDecUnsigned
	j	.LBB15_11
.LBB15_6:
	mv	a0, zero
	sw	a0, -48(s0)
	j	.LBB15_7
.LBB15_7:
	lw	a0, -48(s0)
	lw	a1, -36(s0)
	bge	a0, a1, .LBB15_10
	j	.LBB15_8
.LBB15_8:
	lw	a0, -12(s0)
	lw	a2, -48(s0)
	add	a0, a0, a2
	lb	a0, 0(a0)
	lw	a1, -20(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB15_9
.LBB15_9:
	lw	a0, -48(s0)
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB15_7
.LBB15_10:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	lw	a2, -36(s0)
	call	decToBin
	lw	a0, -16(s0)
	lw	a1, -24(s0)
	call	binToHex
	lw	a0, -24(s0)
	lw	a1, -28(s0)
	call	endianessInverter
	lw	a0, -28(s0)
	call	strlength
	sw	a0, -52(s0)
	lw	a0, -28(s0)
	lw	a1, -32(s0)
	lw	a2, -16(s0)
	lw	a3, -52(s0)
	addi	a4, zero, 1
	call	hexToDecUnsigned
	j	.LBB15_11
.LBB15_11:
	lw	s0, 56(sp)
	lw	ra, 60(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end15:
	.size	handler, .Lfunc_end15-handler

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -288
	sw	ra, 284(sp)
	sw	s0, 280(sp)
	addi	s0, sp, 288
	mv	a0, zero
	sw	a0, -248(s0)
	sw	a0, -12(s0)
	addi	a1, s0, -47
	sw	a1, -276(s0)
	addi	a2, zero, 20
	call	read
	mv	a1, a0
	lw	a0, -276(s0)
	sw	a1, -228(s0)
	lw	a6, -228(s0)
	addi	a1, s0, -82
	sw	a1, -272(s0)
	addi	a2, s0, -187
	sw	a2, -268(s0)
	addi	a3, s0, -117
	sw	a3, -264(s0)
	addi	a4, s0, -152
	addi	a5, s0, -222
	sw	a5, -256(s0)
	call	handler
	lw	a0, -272(s0)
	addi	a1, zero, 1
	sw	a1, -252(s0)
	call	truncate
	lw	a0, -264(s0)
	lw	a1, -248(s0)
	call	truncate
	lw	a0, -272(s0)
	call	strlength
	lw	a1, -272(s0)
	mv	a2, a0
	lw	a0, -252(s0)
	sw	a2, -232(s0)
	lw	a2, -232(s0)
	add	a3, a2, a1
	addi	a2, zero, 10
	sw	a2, -260(s0)
	sb	a2, -1(a3)
	lw	a2, -232(s0)
	call	write
	lw	a0, -268(s0)
	call	strlength
	lw	a1, -268(s0)
	lw	a2, -260(s0)
	mv	a3, a0
	lw	a0, -252(s0)
	sw	a3, -236(s0)
	lw	a3, -236(s0)
	add	a3, a3, a1
	sb	a2, -1(a3)
	lw	a2, -236(s0)
	call	write
	lw	a0, -264(s0)
	call	strlength
	lw	a1, -264(s0)
	lw	a2, -260(s0)
	mv	a3, a0
	lw	a0, -252(s0)
	sw	a3, -240(s0)
	lw	a3, -240(s0)
	add	a3, a3, a1
	sb	a2, -1(a3)
	lw	a2, -240(s0)
	call	write
	lw	a0, -256(s0)
	call	strlength
	lw	a2, -260(s0)
	lw	a1, -256(s0)
	mv	a3, a0
	lw	a0, -252(s0)
	sw	a3, -244(s0)
	lw	a3, -244(s0)
	add	a3, a3, a1
	sb	a2, -1(a3)
	lw	a2, -244(s0)
	call	write
	lw	a0, -248(s0)
	lw	s0, 280(sp)
	lw	ra, 284(sp)
	addi	sp, sp, 288
	ret
.Lfunc_end16:
	.size	main, .Lfunc_end16-main

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	main
	lw	s0, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end17:
	.size	_start, .Lfunc_end17-_start

	.ident	"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym strlength
	.addrsig_sym charToInt
	.addrsig_sym position
	.addrsig_sym changeToLet
	.addrsig_sym toNegative
	.addrsig_sym decToBin
	.addrsig_sym hexToBin
	.addrsig_sym hexToDecUnsigned
	.addrsig_sym hexToDecSigned
	.addrsig_sym hexToDec
	.addrsig_sym binToHex
	.addrsig_sym endianessInverter
	.addrsig_sym truncate
	.addrsig_sym handler
	.addrsig_sym main
