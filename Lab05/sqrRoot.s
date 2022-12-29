read:
    li a0, 0                # file descriptor = 0 (stdin)
    la a1, input_adress     #  buffer
    li a2, 20               # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63               # syscall read (63)
    ecall
    ret 

input_adress: .skip 0x20    # buffer

write:  
    li a0, 1                # file descriptor = 1 (stdout)
    la a1, input_adress     # buffer, 
    li a2, 40               # size
    li a7, 64               # syscall write (64)
    ecall
    ret 

toDec:                                  
    lb t0, 0(a2)                        
    addi t0, t0, -'0'
    li t1, 1000      
    mul t0, t0, t1          #milhar
    mv t2, t0               #salvando o valor em t2

    lb t0, 1(a2)
    addi t0, t0, -'0'
    li t1, 100               
    mul t0, t0, t1          #centenas 
    add t2, t2, t0;         #salvando o valor em t2

    lb t0, 2(a2)
    addi t0, t0, -'0'
    li t1, 10                 
    mul t0, t0, t1          #dezenas
    add t2, t2, t0;         #salvando o valor em t2

    lb t0, 3(a2)
    addi t0, t0, -'0'
    li t1, 1                 

    mul t0, t0, t1          #unidades
    add t2, t2, t0;         #salvando o valor em t2
    ret 

sqrRoot: 
    li t4, 10               #contador
    li t1, 2                #numero 2
    div t0, t2, t1          #t1 => denominador,  t2 => numerador /  dividiu por 2
    1:                                                                               
    div t3, t2, t0          #t3 = y/k
    add t5, t0, t3
    div t6, t5, t1
    mv t0, t6               #salvo em t0
    
    addi t4, t4, -1         #diminui o contador
    bnez t4, 1b
    ret

.globl _start
_start:
    jal read

    mv a2, a1               #O endereço está em a2
    li s0, 4
    for:                        
    jal toDec
    jal sqrRoot
                            #Troca pra char
    li t4, 10
    rem t3, t0, t4
    addi t3, t3, '0'
    sb t3, 3(a2)
    div t0, t0, t4

    li t4, 10
    rem t3, t0, t4
    addi t3, t3, '0'
    sb t3, 2(a2)
    div t0, t0, t4

    rem t3, t0, t4
    addi t3, t3, '0'
    sb t3, 1(a2)
    div t0, t0, t4

    rem t3, t0, t4
    addi t3, t3, '0'
    sb t3, 0(a2)
 
    addi a2, a2, 5
    addi s0, s0, -1
    bnez s0, for

    jal write