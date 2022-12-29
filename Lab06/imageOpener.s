.section .bss

input_adress: .skip 0x4000F # buffer     

.section .data

input_file: .asciz "imagem.pgm"

.section .text
.align 4

setCanvasSize:
    mv a0, s2
    mv a1, s3
    li a7, 2201
    ecall
    ret

setPixel:
    li a7, 2200            # syscall setGSPixel (2200)
    ecall
    ret

open:
    la a0, input_file       # endereço do caminho para o arquivo
    li a1, 0                # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0                # modo
    li a7, 1024             # syscall open 
    ecall
    ret

read:
    la a1, input_adress     # buffer
    li a2, 262159           # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63               # syscall read (63)
    ecall
    ret

getSize:   
    li a3, 1                #guarda o valor 1 em a3
    li a4, 0                #contador, comec em 2 pra pular o p5
    li s2, 0                #width
    li s3, 0                #lenght
    li t5, 0                #aux pra salvar os numeros
    li t6, 10               #usado pra aumentar a casa decimal
    la t0, input_adress       
    addi t0, t0, 3

    for:
    lb a0, (t0)             #o digito de onde teria numeros
    call isWhiteSpace       #confere se eh whitespace
    beq a3, a1, if          #if a3 == a0 then target
    addi t0, t0, 1          #pro proximo digito 
    jal for                    

    if:                     #encontrou um whiteSpace
    li t1, 1                #vai multiplicar o digito
    mv s1, t0               #salva a posicao do contador
    sub t0, t0, a3          #pra pegar o primeiro digito

    1:
    lb t2, (t0)             #pega o digito
    addi t2, t2, -'0'       #converte pra int
    mul t2, t2, t1          #valor do digito na posicao
    add t5, t5, t2          #salva o numero
    addi t0, t0, -1         #decrementa a posicao
    mul t1, t1, t6          #aumenta a casa decimal
    lb a0, (t0) 
    call isWhiteSpace       #verifica se ja terminou o numero
    beq a3, a1, 2f
    jal 1b

    2:                      #ja terminou o numero
    addi a4, a4, 1          #soma 1 no contador
    bgt a4, a3, part2       #if a4 >a3, then target
    mv s2, t5               #salva o width
    mv t0, s1               #volta a posicao pro proximo numero
    li t5, 0                #zera o registrador usado pra salvar
    addi t0, t0, 1          #pasa para a posicao do proximo numero  
    li t1, 1
    jal for
 
isWhiteSpace:               # o valor vem em a0
    mv s0, ra
    beq a0, zero, 1f        # if a0 == 0
    li a1, 9
    beq a0, a1, 1f          # if t0 == 9 
    li a1, 10
    beq a0, a1, 1f          # if t0 == 10 
    li a1, 13
    beq a0, a1, 1f          # if t0 == 13 
    li a1, 32
    beq a0, a1, 1f          # if t0 == 32 
    mv a1, zero
    ret
    1:
    mv a1, a3               #retorna 1 no a1 se for whiteSpace, 0 se n
    mv ra, s0
    ret

printImage:             
    mv t0, s1               #endereco no arquivo
    addi t0, t0, 5
    li t1, 0                #contador x
    li t2, 0                #contador y
    li t4, 0                #auxiliar pros shifts
    li t5, 0                #auxiliar 2 pros shifts

    1:              
    beq s2, t1, 2f          
    mv a0, t1
    mv a1, t2
    addi t1, t1, 1
                            #colocar em a2 a cor do pixel, shiftar
    li t5, 0
    lbu t4, (t0)
    slli t4, t4, 8
    add t5, t5, t4
    slli t4, t4, 8 
    add t5, t5, t4
    slli t4, t4, 8
    add t5, t5, t4
    addi t5, t5, 0xff 
    mv a2, t5

    jal setPixel
    addi t0, t0, 1
    j 1b

    2:
    beq s3, t2, finish       
    li t1, 0
    addi t2, t2, 1
    jal 1b              

.globl _start
_start:
    call open
    call read
    call getSize
    part2:
    mv s3, t5               #salva o lenght     
    call setCanvasSize
    call printImage
    finish: