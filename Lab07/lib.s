.globl approx_sqrt
approx_sqrt:
    li t4, 10               #contador
    li t1, 2                #numero 2
    mv t2, a0
    div t0, t2, t1          #t1 => denominador,  t2 => numerador /  dividiu por 2
    1:                                                                               
    div t3, t2, t0          #t3 = y/k
    add t5, t0, t3
    div t6, t5, t1
    mv t0, t6               #salvo em t0
    
    addi t4, t4, -1         #diminui o contador
    mv a0, t0
    bnez t4, 1b
    ret

.globl exit
exit: 
    li a7, 93
    ecall
    ret

.globl puts              
puts:
    li t0, 0                #size da string
    mv t1, a0               #endereço da string

    1:
    lb t2, (t1)
    beq t2, zero, 2f        # if a0 == 0
    addi t0, t0, 1
    addi t1, t1, 1
    j 1b

    2:                      #ja achou a posicao do /0
    addi sp, sp, -1
    li t1, '\n'
    sb t1, (sp)
    mv a1, a0
    li a0, 1                # file descriptor = 1 (stdout)
    mv a2, t0               # size                                 
    li a7, 64               # syscall write (64)
    ecall                   #imprime a string ate o /0
    li a0, 1
    mv a1, sp            
    li a2, 1
    li a7, 64
    ecall                   #imprime so o /n
    addi sp, sp, 1          #retorna a pilha pro valor inicial
    li a0, 42               # inteiro n negativo
    ret

.globl gets
gets:
    addi sp, sp, -16
    sw ra, 12(sp)           # salva o ra
    sw fp, 8(sp)            # salva o fp
    sw s0, 4(sp)            # salva o q tiver no s0
    sw a0, (sp)             # salva o endereço da str
    mv s0, a0               # move pra s0 o endereço de s0s

    1:
    li a0, 0                # file descriptor = 0 (stdout) 
    mv a1, s0               # endereco de funcao
    li a2, 1                # size
    li a7, 63               # syscall write (63)
    ecall

    lbu t1, (s0)
    li t2, '\n'
    beq t1, t2, 2f
    addi s0, s0, 1

    j 1b

    2:
    sb zero, (s0)
    lw a0, (sp)            # devolve o endereço da str
    lw s0, 4(sp)           # devolve pra s0 o q estava la
    lw fp, 8(sp)           # devolve o valor de fp 
    lw ra, 12(sp)          # devolve o valor de ra
    addi sp, sp, 16
    ret 

.globl atoi
atoi:
    addi sp, sp, -16
    sw ra, 12(sp)           # salva o ra
    sw fp, 8(sp)            # salva o fp
    sw s0, 4(sp)            # salva o q tiver no s0
    mv s0, a0
    li t2, 0                # numero vai ser feito aqui
    li a2, 1

    1:
    lb a0, (s0)             # Pega um digito
    mv t6, a0
    call isSpace
    li t1, 0
    beq a0, t1, 2f          # verifica se n eh whiteSpace
    addi s0, s0, 1          # proximo digito
    j 1b

    2:                      # nao eh whiteSpace
    lb a0, (s0)
    mv t6, a0
    li t4, 10
    addi t6, t6, -'0'       # verificar se eh digito
    mv a0, t6
    call isDigit            
    beq a0, zero, 3f        
    mul t2, t2, t4          # multiplica por 10
    add t2, t2, t6
    addi s0, s0, 1 
    j 2b

    3:                      # nao eh digito, acabo o numero e cai fora
    mul a0, t2, a2
    lw s0, 4(sp)            # devolve o s0
    lw fp, 8(sp)            # devolve o fp
    lw ra, 12(sp)           # devolve o ra
    addi sp, sp, 16
    ret 

isSpace:                               
    mv t0, a0       

    li t1, 0x09
    beq t0, t1, 1f          # if a0 == 0x09
    li t1, 0x0a
    beq t0, t1, 1f          # if t0 == 0x0a
    li t1, 0x0b
    beq t0, t1, 1f          # if t0 == 0x0b 
    li t1, 0x0c
    beq t0, t1, 1f          # if t0 == 0x0c
    li t1, 0x0d
    beq t0, t1, 1f          # if t0 == 0x0d 
    li t1, 0x20
    beq t0, t1, 1f          # if t0 == 0x20 
    li t1, '+'
    beq t0, t1, 1f
    li t1, '-'
    beq t0, t1, 2f

    mv a0, zero             # retorna 1 no a0 se for whiteSpace, 0 se n
    ret

    1:
    li a0, 1                # retorna 1 no a0 se for whiteSpace, 0 se n
    ret

    2:
    li a0, 1                # retorna 1 no a0 se for whiteSpace, 0 se n
    li a2, -1               # manda o sinal do numero
    ret

isDigit:
    li t4, 10
    bge a0, zero, 1f
    li a0, 0                # n eh digito
    ret
    1:
    blt a0, t4, 2f
    li a0, 0                # n eh digito
    ret
    2:
    li a0, 1                # é digito
    ret

.globl time
time:
    addi sp, sp, -32
    sw ra, 28(sp)           # salva o ra
    sw fp, 24(sp)           # salva o fp
    addi t4, sp, 12         # alocar aqui o timeval
    addi t5, sp, 4          # alocar aqui o timezone

    mv a0, t4
    mv a1, t5
    li a7, 169              # chamada de sistema gettimeofday
    ecall
    mv a0, t4
    lw t1, 0(a0)            # tempo em segundos
    lw t2, 8(a0)            # fração do tempo em microssegundos
    li t3, 1000
    mul t1, t1, t3
    div t2, t2, t3
    add a0, t2, t1

    lw ra, 28(sp)           # devolve o ra
    lw fp, 24(sp)           # devolve o fp
    addi sp, sp, 32
    ret

.globl sleep
sleep:
    addi sp, sp, -16
    sw ra, 12(sp)           # salva o ra
    sw fp, 8(sp)            # salva o fp
    mv t0, a0 
    call time
    add t0, t0, a0

    1:
    call time
    bgt a0, t0, 2f
    j 1b

    2:
    lw ra, 12(sp)           # salva o ra
    lw fp, 8(sp)            # salva o fp
    addi sp, sp, 16
    ret

.globl itoa
itoa:
    addi sp, sp, -16
    sw ra, 12(sp)           # salva o ra
    sw fp, 8(sp)            # salva o fp
    sw s0, 4(sp) 
    mv s0, a1               # endereco da str retorno
    li t1, 0                # contador

    bge a0, zero, 2f        # positvo vai pra 2f
    li t0, 10
    bne a2, t0, 2f          # é negativo e nao eh base 10, vai pra longe 
    sub a0, zero, a0

    # é naegativo e em base 10
    1:
    beq a0, zero, 1f        # acabo numero
    remu t0, a0, a2         # pega o digito
    addi t0, t0, '0'        # vira caracter
    divu a0, a0, a2         # divide pela base
    sb t0, (a1)             # salva o caractere
    addi a1, a1, 1          # proxima posicao
    addi t1, t1, 1          # aumenta contador
    j 1b

    1:
    li t0, '-'
    sb t0, (a1)
    addi a1, a1, 1
    addi t1, t1, 1          # aumenta contador
    j 3f

    2:                      # positivo ou negativo e n eh base 10, so dividitr normalmente
    //o numero vem em a0
    //endereco em a1
    //a base em a2
    beq a0, zero, 3f        # acabo numero
    remu t0, a0, a2         # pega o digito
    addi t0, t0, '0'        # vira caracter
    divu a0, a0, a2         # divide pela base
    sb t0, (a1)             # salva o caractere
    addi a1, a1, 1          # proxima posicao
    addi t1, t1, 1          # aumenta contador
    j 2b

    3:                      # finaliza a rotina
    //inverter os caractersaqui
    mv t2, s0               # pos inicial
    add t3, t1, s0          # pos final
    addi t3, t3, -1
    li t5, 0                # contador pra inversao
    addi t1, t1, 1
    srli t6, t1, 1          # quantidade dividida por 2
    1:
    beq t5, t6, 3f
    lb a5, (t2)
    lb a6, (t3)
    sb a6, (t2)
    sb a5, (t3)
    addi t2, t2, 1
    addi t3, t3, -1
    addi t5, t5, 1
    j 1b

    3:  
    //adicionar o /0
    mv t0, zero
    addi t1, t1, -1     
    add a7, s0, t1
    stop:
    sb t0, (a7)

    mv a0, s0
    call getLetters

    lw ra, 12(sp)           # salva o ra
    lw fp, 8(sp)            # salva o fp
    lw s0, 4(sp)        
    addi sp, sp, 16
    ret

getLetters:
    mv t1, a0               # endereco
    9:
    lb t2, (t1)
    li t0, 0x3a
    beq t0, t2, 1f
    li t0, 0x3b
    beq t0, t2, 2f
    li t0, 0x3c
    beq t0, t2, 3f
    li t0, 0x3d
    beq t0, t2, 4f
    li t0, 0x3e
    beq t0, t2, 5f
    li t0, 0x3f
    beq t0, t2, 6f
    beq zero, t2, 7f
    addi t1, t1, 1
    j 9b

    1:
    li t0, 'a'
    sb t0, (t1)
    addi t1, t1, 1
    j 9b
    2:
    li t0, 'b'
    sb t0, (t1)
    addi t1, t1, 1
    j 9b
    3:
    li t0, 'c'
    sb t0, (t1)
    addi t1, t1, 1
    j 9b
    4:
    li t0, 'd'
    sb t0, (t1)
    addi t1, t1, 1
    j 9b
    5:
    li t0, 'e'
    sb t0, (t1)
    addi t1, t1, 1
    j 9b
    6:
    li t0, 'f'
    sb t0, (t1)
    addi t1, t1, 1
    j 9b
    7:
    stop2:
    ret

.globl imageFilter
imageFilter:
    # a0, img
    # a1, width
    # a2, height
    # a3, filter

    mul t0, a1, a2
    li t2, 16
    rem t1, t0, t2
    sub t1, t2, t1
    add t0, t0, t1       # multiplo de 16 pra alocar
    addi t0, t0, 16      # mais 16 pra salvar as coisas do registradores s
    sub t0, zero, t0
    add sp, sp, t0       # alocando espaço pra imagem
    sub t0, zero, t0     # deixar positivo dinovo

    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    addi sp, sp, 12
    
    mv s0, a0             # endereco img
    mv s1, a3             # endereco filter

    li t1, 0
    1:                    # copiar a imagem toda pra pilha
    beq t1, t0, 1f
    lb a5, (a0)
    sw a5, (sp)
    addi a0, a0, 1
    addi sp, sp, 1
    addi t1, t1, 1

    j 1b

    # begin
    1:
    add t1, zero, t1    
    add sp, sp, t1          #volta pro inicio da imagem

    mv s2, a1               # salva o width em s2

    li t1, 0                #contador x
    li t2, 0                #contador y
    li t3, 0                #auxiliar 
    li t4, 0                #auxiliar 2
    li t5, 255              #valor maximo do resultado do filtro
    addi a3, a1, -1         #width - 1
    addi a4, a2, -1         #lentgh -1
  
    1:
    addi s0, s0, 1          #endereço da matriz de saida  
    beq s2, t1, 4f          #passa pra poxima linha
    beq t1, zero, 2f        #borda esquerda é zero
    beq t1, a3, 2f          #borda direita                 
    beq t2, zero, 2f        #borda superior
    beq t2, a4, 2f          #borda inferior

    //fazer o filtro aqui --> guardar o valor em a2 
    li a2, 0 
    #a00
    addi t3, t1, -1         #pegando o x de a00
    addi t4, t2, -1         #pegando o y de a00
    mul t4, t4, s2          #quantidade de bytes ate essa linha
    add t3, t3, t4          #quantidade de bytes ate essa kinha e esse ponto
    add t3, t3, sp          #posicao na memoria do byte desejado
    lbu t4, (t3)            #coloca em t4 o byte pra ser manipulado

    lb a7, 0(s1)

    mul t4, t4, a7          #multiplica pelo valor do filtro
    add a2, a2, t4          #salvando em a2 o valor do fixel

    #a01
    mv t3, t1               #pegando o x de a01
    addi t4, t2, -1         #pegando o y de a01
    mul t4, t4, s2          #quantidade de bytes ate essa linha
    add t3, t3, t4          #quantidade de bytes ate essa kinha e esse ponto
    add t3, t3, sp          #posicao na memoria do byte desejado

    lb a7, 1(s1)

    lbu t4, (t3)            #coloca em t4 o byte pra ser manipulado
    mul t4, t4, a7          #multiplica pelo valor do filtro
    add a2, a2, t4          #salvando em a2 o valor do fixel

    #a02
    li t3, 0 
    addi t3, t1, 1          #pegando o x de a02
    addi t4, t2, -1         #pegando o y de a02
    mul t4, t4, s2          #quantidade de bytes ate essa linha
    add t3, t3, t4          #quantidade de bytes ate essa kinha e esse ponto
    add t3, t3, sp          #posicao na memoria do byte desejado
    lbu t4, (t3)            #coloca em t4 o byte pra ser manipulado

    lb a7, 2(s1)

    mul t4, t4, a7          #multiplica pelo valor do filtro
    add a2, a2, t4          #salvando em a2 o valor do fixel

    #a10
    li t3, 0 
    addi t3, t1, -1         #pegando o x de a10
    mv t4, t2               #pegando o y de a10
    mul t4, t4, s2          #quantidade de bytes ate essa linha
    add t3, t3, t4          #quantidade de bytes ate essa kinha e esse ponto
    add t3, t3, sp          #posicao na memoria do byte desejado
    lbu t4, (t3)            #coloca em t4 o byte pra ser manipulado

    lb a7, 3(s1)

    mul t4, t4, a7          #multiplica pelo valor do filtro
    add a2, a2, t4          #salvando em a2 o valor do fixel

    #a11 
    mv t3, t1               #pegando o x de a11
    mv t4, t2               #pegando o y de a11
    mul t4, t4, s2          #quantidade de bytes ate essa linha
    add t3, t3, t4          #quantidade de bytes ate essa kinha e esse ponto
    add t3, t3, sp          #posicao na memoria do byte desejado
    lbu t4, (t3)            #coloca em t4 o byte pra ser manipulado

    lb a7, 4(s1)

    mul t4, t4, a7          #multiplica pelo valor do filtro
    add a2, a2, t4          #salvando em a2 o valor do fixel

    #a12
    li t3, 0 
    addi t3, t1, 1          #pegando o x de a12
    mv t4, t2               #pegando o y de a12
    mul t4, t4, s2          #quantidade de bytes ate essa linha
    add t3, t3, t4          #quantidade de bytes ate essa kinha e esse ponto
    add t3, t3, sp          #posicao na memoria do byte desejado
    lbu t4, (t3)            #coloca em t4 o byte pra ser manipulado

    lb a7, 5(s1)

    mul t4, t4, a7          #multiplica pelo valor do filtro
    add a2, a2, t4          #salvando em a2 o valor do fixel

    #a20
    li t3, 0 
    addi t3, t1, -1         #pegando o x de a20
    addi t4, t2, 1          #pegando o y de a20
    mul t4, t4, s2          #quantidade de bytes ate essa linha
    add t3, t3, t4          #quantidade de bytes ate essa kinha e esse ponto
    add t3, t3, sp          #posicao na memoria do byte desejado
    lbu t4, (t3)            #coloca em t4 o byte pra ser manipulado

    lb a7, 6(s1)

    mul t4, t4, a7          #multiplica pelo valor do filtro
    add a2, a2, t4          #salvando em a2 o valor do fixel

    #a21
    mv t3, t1               #pegando o x de a21
    addi t4, t2, 1          #pegando o y de a21
    mul t4, t4, s2          #quantidade de bytes ate essa linha
    add t3, t3, t4          #quantidade de bytes ate essa kinha e esse ponto
    add t3, t3, sp          #posicao na memoria do byte desejado
    lbu t4, (t3)            #coloca em t4 o byte pra ser manipulado

    lb a7, 7(s1)

    mul t4, t4, a7          #multiplica pelo valor do filtro
    add a2, a2, t4          #salvando em a2 o valor do fixel

    #a22
    li t3, 0 
    addi t3, t1, 1          #pegando o x de a22
    addi t4, t2, 1          #pegando o y de a22
    mul t4, t4, s2          #quantidade de bytes ate essa linha
    add t3, t3, t4          #quantidade de bytes ate essa kinha e esse ponto
    add t3, t3, sp          #posicao na memoria do byte desejado
    lbu t4, (t3)            #coloca em t4 o byte pra ser manipulado

    lb a7, 8(s1)

    mul t4, t4, a7          #multiplica pelo valor do filtro
    add a2, a2, t4          #salvando em a2 o valor do fixel

    //filtro em cima

    blt a2, zero, 2f        #verifica se n é menor q 0
    bge a2, t5, 3f          #verifica se n excedeu 255
    sb a2, (s0)             #salva o valor na memoria

    addi t1, t1, 1          #passa pra proxima coluna

    jal 1b

    2:                      #encontrou borda, ai coloca preto
    sb zero, (s0)           #coloca 0
    addi t1, t1, 1 
    jal 1b            

    3:                      #coloca o valor 255
    sb t5, (s0)
    addi t1, t1, 1 
    jal 1b

    4: 
    beq s3, t2, 5f       #acabou
    li t1, 0
    addi t2, t2, 1          #passa pra proxima linha
    jal 1b 

    # end
    5:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    add sp, sp, t0
    ret