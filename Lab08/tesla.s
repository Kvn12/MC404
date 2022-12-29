.section .data

.equ base, 0xFFFF0100

.section .text

moveForward:
    li t0, 0x21
    li t1, base
    add t0, t0, t1
    li t1, 1
    sb t1, 0(t0)
    ret

moveBackward:
    li t0, 0x21
    li t1, base
    add t0, t0, t1
    li t1, -1
    sb t1, 0(t0)
    ret

moveLeft:
    li t0, 0x20
    li t1, base
    add t0, t0, t1
    sub t1, zero, a0
    sb t1, 0(t0)
    ret

moveRight:
    li t0, 0x20
    li t1, base
    add t0, t0, t1
    mv t1, a0
    sb t1, 0(t0)
    ret

stopEngine:
    li t0, 0x21
    li t1, base
    add t0, t0, t1
    li t1, 0
    sb t1, 0(t0)
    ret

handBreak:
    li t0, 0x22
    li t1, base
    add t0, t0, t1
    li t1, 0
    sb t1, 0(t0)
    ret

getCoord:
    li t0, base
    li t1, 1
    sb t1, 0(t0)
    1:
    lb t2, (t0)
    bnez t2, 1b          # verifica se ja terminou a leitura
    # ja realizou a leitura
    call readCoord
    ret

readCoord:
    li t0, 0x04
    li t1, base
    add t0, t0, t1
    lb a0, (t0)         # posicao angular em x
    
    li t0, 0x0c
    li t1, base
    add t0, t0, t1
    lb a1, (t0)         # posicao angular em z

    li t0, 0x10
    li t1, base
    add t0, t0, t1
    lb a2, (t0)         # posicao em x

    li t0, 0x18
    li t1, base
    add t0, t0, t1
    lb a3, (t0)         # posicao em z

    ret

.globl exit
exit: 
    li a7, 93
    ecall
    ret

.globl _start
_start:
    li t0, 0
    li t1, 5
    call moveForward
    li a0, 15
    call moveLeft
    1:
    beq t0, t1, 2f
    addi t0, t0, 1
    j 1b
    2:
    call stopEngine
    call handBreak
    call getCoord
    call exit