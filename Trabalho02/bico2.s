# O código da subcamada BiCo deve implementar as rotinas da API de Controle em linguagem de montagem do RISC-V. A API está descrita no arquivo api_car.h 
# Para controlar o hardware, o código deve realizar syscalls, definidas na seção seg

/*
  Self Driving Car Application Programming Interface
*/

/******************************************************************************/
/*  MOTORES                                                                   */
/******************************************************************************/

/*
  Define os valores para o deslocamento vertical e horizontal do carro.
  Paramêtros:
  * vertical:   um byte que define o deslocamento vertical, entre -1 e 1.
                Valor -1 faz o carro andar para trás e 1 para frente
  * horizontal: define o valor para o deslocamento horizontal, entre -127 e 127.
                Valores negativos gera deslocamento para a direita e positivos
                para a esquerda.
  Retorna:
  * 0 em caso de sucesso.
  * -1 caso algum parametro esteja fora de seu intervalo.
*/
# int set_motor(char vertical, char horizontal);

.globl set_motor            
set_motor:
    //syscal 
    li a7, 10
    ecall
    ret

/*
  Aciona o freio de mão do carro.
  Paramêtros:
  * valor:  um byte que define se o freio será acionado ou não.
            1 para acionar o freio e 0 para não acionar.
  Retorna:
  * 0 em caso de sucesso.
  * -1 caso algum parametro esteja fora de seu intervalo .
*/
# int set_handbreak(char valor);

.globl set_handbreak
set_handbreak:
    li t0, 1
    
    beqz a0, 2f         # confere se é zero
    beq a0, t0, 2f      # confere se é 1

    li a0, -1           # caso parametro errado
    1:
    ret

    2:
    li a7, 11
    ecall

    li a0, 0            # caso parametro certo
    j 1b


/******************************************************************************/
/*  SENSORES                                                                  */
/******************************************************************************/

/*
  Lê os valores da camera de linha.
  Paramêtros:
  * img:  endereço de um vetor de 256 elementos que armazenará os
          valores lidos da camera de linha.
  Retorna:
    Nada
*/
# void read_camera(unsigned char* img);

.globl read_camera
read_camera:
    li a7, 12
    ecall

    ret

/*
  Lê a distancia do sensor ultrasônico
  Paramêtros:
    Nenhum
  Retorna:
    O inteiro com a distância do sensor, em centímetros.
*/
# int read_sensor_distance(void);

.globl read_sensor_distance
read_sensor_distance:             
    li a7, 13
    ecall
    ret

/*
  Lê a posição aproximada do carro usano um dispositivo de GPS
  Parametros:
  * x:  endereço da variável que armazenará o valor da posição x
  * y:  endereço da variável que armazenará o valor da posição y
  * z:  endereço da variável que armazenará o valor da posição z
  Retorna:
    Nada
*/
# void get_position(int* x, int* y, int* z);

.globl get_position
get_position:
  li a7, 15
  ecall
  ret


/*
  Lê a rotação global do dispositivo de giroscópio
  Parametros:
  * x:  endereço da variável que armazenará o valor do angulo de Euler em x
  * y:  endereço da variável que armazenará o valor do angulo de Euler em y
  * z:  endereço da variável que armazenará o valor do angulo de Euler em z
  Retorna:
    Nada
*/
# void get_rotation(int* x, int* y, int* z);

.globl get_rotation
get_rotation:
    li a7, 16
    ecall
    ret


/******************************************************************************/
/*  TIMER                                                                     */
/******************************************************************************/

/*
  Lê o tempo do sistema
  Paramêtros:
    Nenhum
  Retorna:
    O tempo do sistema, em milisegundos.
*/
# unsigned int get_time(void);

.globl get_time
get_time:                 
    li a7, 20
    ecall
    ret

/******************************************************************************/
/*  Processamento de Imagem                                                   */
/******************************************************************************/

/*
  Filtra uma imagem unidimensional utilizando um filtro unidimensional (similar ao lab 6b, mas para apenas uma dimensão). 
  Paramêtros:
    img: array representando a imagem.
    filter: vetor de 3 posições representando o filtro 1D.
  Retorna:
    Nada
*/
# void filter_1d_image(char * img, char * filter);
.globl filter_1d_image
filter_1d_image:
    li t0, 0        # Contador
    
    li t1, 255      # Limite contador e cor de pixel
    mv t2, a0       # salva o endereço da imagem ori

    lbu t3, (a0)     # salvar o primeiro byte a ser usado para calculos posteriores
    0:
    beq t0, zero, 3f  # Verifica se n eh a primeira borda
    beq t0, t1, 4f    # Verifica se n eh a ultima borda
    li t5, 0          # zera o termo que recebera as contas

    # Filtro vai aqui
    # a0
    lb t6, 0(a1)    # Pega do filtro o elemento a ser multiplicado
    mul t4, t3, t6  # Multiplica o valor de filtro pelo pixel 
    add t5, t5, t4  # Adiciona o valor da multiplicação

    # a1
    lb t6, 1(a1)    # Pega do filtro o elemento a ser multiplicado
    lbu t3, 0(t2)    # Pega o byte a ser mutilplicado
    mul t4, t3, t6  # Multiplica o valor de filtro pelo pixel 
    add t5, t5, t4  # Adiciona o valor da multiplicação

    # a2
    lb t6, 2(a1)    # Pega do filtro o elemento a ser multiplicado
    lbu t3, 1(t2)    # Pega o byte a ser mutilplicado
    mul t4, t3, t6  # Multiplica o valor de filtro pelo pixel 
    add t5, t5, t4  # Adiciona o valor da multiplicação

    # Até aqui
    # Verificar se eh n eh menor ou maior e dar branch pra outros lugates tratarem disso
    lbu t3, 0(t2)     # atualiza o byte anterior
    addi t0, t0, 1   # Atualiza o contador

    blt t5, zero, 1f  # Verifica se n eh menor q zero
    bgt t5, t1, 2f    # Verifica se n excedeu 255
    sb t5, (t2)       # Salva o valor na imagem
    addi t2, t2, 1    # pega o proximo byte da imagem
    j 0b

    1:               # E menor q 0
    sb zero, 0(t2)   # Salva zero
    addi t2, t2, 1   # pega o proximo byte da imagem
    j 0b

    2:
    sb t1, 0(t2)     # Salva 255 
    addi t2, t2, 1   # pega o proximo byte da imagem
    j 0b

    3:              # Borda
    sb zero, 0(t2)  # colocar preto na borda
    addi t0, t0, 1  # Atualiza o contador
    addi t2, t2, 1  # pega o proximo byte da imagem
    j 0b

    4:              # Acabou a imagem
    sb zero, 0(t2)  # colocar preto na borda
    ret

/*
  Mostra uma imagem 1D (1x256) no canvas. 
  Paramêtros:
    img: array representando a imagem.
  Retorna:
    Nada
*/
# void display_image(char * img);

.globl display_image
display_image:
    li a7, 19
    ecall
    ret

/*
  Para as funções abaixo, veja detalhes no Laboratório 7.
*/
# void puts ( const char * str );

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
    li a7, 18               # syscall write (18)
    ecall                   #imprime a string ate o /0
    li a0, 1
    mv a1, sp            
    li a2, 1
    li a7, 18
    ecall                   #imprime so o /n
    addi sp, sp, 1          #retorna a pilha pro valor inicial
    li a0, 42               # inteiro n negativo
    ret


# char * gets ( char * str );

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
    li a7, 17               # syscall read (17)
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

# int atoi (const char * str);

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


.globl atoi
    atoi:
        addi sp, sp, -20
        sw t5, 20(sp)
        sw t4, 16(sp)
        sw t3, 12(sp)
        sw t2, 8(sp)
        sw t1, 4(sp)
        sw t0, 0(sp)
        add a1, x0, a0
        li a2, ' '
        li t0, '-'
        li t1, -1
        li t2, '+'
        li t3, 1
        li t4, '0'
        addi t4, t4, -1
        li t5, '9'
        addi t5, t5, 1
        1: 
           lb a3, 0(a1)
           addi a1, a1, 1
           beq a3, a2, 1b
        li a0, 0
        li a2, 1
        li a5, 1
        li a6, 10
        beq a3, t2, 1f
        beq a3, t0, 3f
        bge a3, t5, end 
        bge t4, a3, end
        3:
            li a2, -1
        1: 
            lbu a3, 0(a1)
            bge a3, t5, end
            bge t4, a3, end
            mul a0, a0, a5
            addi a3, a3, -'0'
            add a0, a0, a3
            mul a5, a5, a6
            addi a1, a1, 1
            j 1b
        end:
            mul a0, a0, a2
        lw t5, 20(sp)
        lw t4, 16(sp)
        lw t3, 12(sp)
        lw t2, 8(sp)
        lw t1, 4(sp)
        lw t0, 0(sp)
        addi sp, sp, 20
        ret


# char *  itoa ( int value, char * str, int base );

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


# void sleep(int ms);

.globl sleep
sleep:
    addi sp, sp, -16
    sw ra, 12(sp)           # salva o ra
    sw fp, 8(sp)            # salva o fp
    mv t0, a0 
    call get_time
    add t0, t0, a0

    1:
    call get_time
    bgt a0, t0, 2f
    j 1b

    2:
    lw ra, 12(sp)           # salva o ra
    lw fp, 8(sp)            # salva o fp
    addi sp, sp, 16
    ret


# int approx_sqrt(int x, int iterations);

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

