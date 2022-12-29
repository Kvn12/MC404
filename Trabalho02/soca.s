.equ base_gpt, 0xFFFF0100             
.equ base_self_driving, 0xFFFF0300             
.equ base_serial_port, 0xFFFF0500
.equ base_canvas, 0xFFFF0700 

.section .bss 

.align 4
isr_stack: 
.skip 1024 
isr_stack_end: 

.text
.align 4

int_handler:
    csrrw sp, mscratch, sp # Exchange sp with mscratch4 
    addi sp, sp, -64 # Allocates space at the ISR stack5 
    sw t0, 0(sp) 
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 14(sp)
    sw ra, 16(sp)
    la ra, fim
    li t0, 10
    beq t0, a7, _set_motor

    li t0, 11
    beq t0, a7, _set_handbreak

    li t0, 12
    beq t0, a7, _read_sensors

    li t0, 13
    beq t0, a7, _read_sensor_distance

    li t0, 15
    beq t0, a7, _get_position

    li t0, 16
    beq t0, a7, _get_rotation

    li t0, 17
    beq t0, a7, _read

    li t0, 18
    beq t0, a7, _write

    li t0, 19
    beq t0, a7, _draw_line

    li t0, 20
    beq t0, a7, _get_systime

    fim:

    csrr t0, mepc  # carrega endereço de retorno (endereço 
                   # da instrução que invocou a syscall)
    addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall) 
    csrw mepc, t0  # armazena endereço de retorno de volta no mepc
    
    # Recupera o contexto
    lw ra, 16(sp)
    lw t4, 14(sp)
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp) 
    lw t0, 0(sp) 
    addi sp, sp, 64 # Deallocate space from the ISR stack18 
    csrrw sp, mscratch, sp # Exchange sp with mscratch19 

    mret

_set_motor:
    # verifica se os valores dos parametros sao válidos
    mv t2, a0           # Troca o valor do parametro de lugar
    li a0, -1           # saida de erro caso seja necessario

    li t0, -1
    li t1, 1
    blt t2, t0, 1f
    bgt t2, t1, 1f
    li t0, -127
    li t1, 127
    blt a1, t0, 1f
    bgt a1, t1, 1f

    mv a0, t2           # destroca o valor do parametro de lugar
        
    # Implementar as acoes da syscall aqui
    li t0, base_self_driving
    sb a0, 0x21(t0)                         
    sb a1, 0x20(t0)

    li a0, 0            # valores ok

    1:
    ret


_set_handbreak:
    # acoes da syscall
    li t0, base_self_driving
    sb a0, 0x22(t0)
    ret

_read_sensors:
    # Pede pra receber a imagem
    li t0, base_self_driving
    li t1, 1
    sb t1, 0x01(t0)
    1:
    lb t2, 1(t0)
    bnez t2, 1b          # verifica se ja terminou a leitura
    # ja realizou a leitura

    li t0, 256           # valor final de byte
    li t1, 0             # Contador
    mv a1, a0            # Posicao no vetor a ser devolvido em a1 para manipular
    li t2, base_self_driving
    addi t2, t2, 0x24    # offset de onde vai ter os dados devolvidos

    2:                   # Copia byte a byte pro vetor em a0
    beq t0, t1, 3f
    lb t4, 0x00(t2)      # Pegando o byte a ser copiado
    sb t4, (a1)          # Copia o byte
    addi t1, t1, 1       # Aumenta o contador
    addi a1, a1, 1       # Passa pra proxima pos pra salvar o byte
    addi t2, t2, 1       # Passa pro proximo byte a ser salvo
    j 2b    
    3:
    ret

_read_sensor_distance:
    # Pede pra receber a leituraa
    li t0, base_self_driving
    li t1, 1
    sb t1, 0x02(t0)
    1:
    lb t2, 0x02(t0)
    bnez t2, 1b          # verifica se ja terminou a leitura
    # ja realizou a leitura
    lb a0, 0x1C(t0)
    ret

_get_position:
    # Pede pra receber a leituraa
    li t0, base_self_driving
    li t1, 1
    sb t1, 0(t0)
    1:
    lb t2, (t0)
    bnez t2, 1b          # verifica se ja terminou a leitura
    # ja realizou a leitura
   
    lw t2, 0x10(t0)         # posicao em x
    sw t2, 0(a0)            # guardar o valor na variavel q ele pede
    lw t2, 0x14(t0)         # posicao em y
    sw t2, 0(a1)            # guardar o valor na variavel q ele pede
    lw t2, 0x18(t0)         # posicao em z
    sw t2, 0(a2)            # guardar o valor na variavel q ele pede

    ret

_get_rotation:
    # Pede pra receber a leituraa
    li t0, base_self_driving
    li t1, 1
    sb t1, 0(t0)
    1:
    lb t2, (t0)
    bnez t2, 1b          # verifica se ja terminou a leitura
    # ja realizou a leitura
   
    lw t2, 0x04(t0)         # posicao angular em x
    sw t2, 0(a0)            # guardar o valor na variavel q ele pede
    lw t2, 0x08(t0)         # posicao angular em y
    sw t2, 0(a1)            # guardar o valor na variavel q ele pede
    lw t2, 0x0C(t0)         # posicao angular em z
    sw t2, 0(a2)            # guardar o valor na variavel q ele pede

    ret

_read:
    # a0 file
    # a1 buffer
    # a2 size
    # Pede pra receber a leituraa
    li t0, base_serial_port
    li t2, 0            # contador
    mv t3, a1           # salvando o buffer para manipular

    0:
    beq t2, a2, 2f       # verifica se ja deu o size

    li t1, 1
    sb t1, 0x02(t0)      # trigger to read
    1:
    lb t2, 0x02(t0)      # byte verificador
    bnez t2, 1b          # verifica se ja terminou a leitura
    # ja realizou a leitura
    lb t4, 0x03(t0)      # byte lido
    sb t4, (t3)          # coloca no buffer
    addi t2, t2, 1       # atualiza o contador
    addi t3, t3, 1       # atualiza o indice do buffer
    beqz t2, 2f          # verifica se o byte ehy null
    j 0b

    2:                   # terminou o read
    mv a0, t2            # retorna o size
    ret

_write:
    # a0 file
    # a1 buffer
    # a2 size
    # Pede pra escrever
    li t0, base_serial_port
    li t2, 0            # contador
    mv t3, a1           # salvando o buffer para manipular

    0:
    beq t2, a2, 2f       # verifica se ja deu o size

    lb t1, (t3)          # pega oo byte a ser impresso
    sb t1, 0x01(t0)      # byte a ser impresso
    li t1, 1
    sb t1, 0x00(t0)      # trigger to write
    1:
    lb t4, 0x00(t0)      # byte verificador
    bnez t4, 1b          # verifica se ja terminou a escrita
    # ja realizou a escrita
    addi t2, t2, 1       # atualiza o contador
    addi t3, t3, 1       # atualiza o indice do buffer
    j 0b

    2:                   # terminou o write
    ret

_draw_line:            
    li t0, base_canvas
    # Dividir em 3 loads pra memoria
    # Primeiro Bloco          
    li t1, 504           # Size 
    sh t1, 0x02(t0)
    li t1, 0             # Posicao inicial na tela
    sw t1, 0x04(t0)
    # pixels
    addi t2, t0, 0x8     # Posicao inicial do array pra printa
    addi t3, t0, 0x204   # Posicao final do array pra printa           
    0:
    bge t2, t3, 1f          
    lbu t4, (a0)
    sb t4, (t2)
    sb t4, 1(t2)
    sb t4, 2(t2)
    li t1, 0xff
    sb t1, 3(t2)
    addi t2, t2, 4
    addi a0, a0, 1
    j 0b

    1:
    li t1, 1
    sb t1, 0x00(t0)
    2:
    lb t2, (t0)
    bnez t2, 2b          # verifica se ja terminou a leitura
    # ja realizou a escrita

    # Segundo Bloco
    li t1, 504           # Size 
    sh t1, 0x02(t0)
    li t1, 504           # Posicao inicial na tela
    sw t1, 0x04(t0)
    # pixels
    addi t2, t0, 0x8     # Posicao inicial do array pra printa
    addi t3, t0, 0x204   # Posicao final do array pra printa           
    0:
    bge t2, t3, 1f
    lbu t4, (a0)
    sb t4, (t2)
    sb t4, 1(t2)
    sb t4, 2(t2)
    li t1, 0xff
    sb t1, 3(t2)
    addi t2, t2, 4
    addi a0, a0, 1
    j 0b

    1:
    li t1, 1
    sb t1, 0x00(t0)
    2:
    lb t2, (t0)
    bnez t2, 2b          # verifica se ja terminou a leitura
    # ja realizou a escrita

    # Terceiro Bloco
    li t1, 4             # Size 
    sh t1, 0x02(t0)
    li t1, 1008          # Posicao inicial na tela
    sw t1, 0x04(t0)
    # pixels
    addi t2, t0, 0x8     # Posicao inicial do array pra printa
    addi t3, t0, 0x14    # Posicao final do array pra printa           
    0:
    bge t2, t3, 1f
    lbu t4, (a0)
    sb t4, (t2)
    sb t4, 1(t2)
    sb t4, 2(t2)
    li t1, 0xff
    sb t1, 3(t2)
    addi t2, t2, 4
    addi a0, a0, 1
    j 0b

    1:
    li t1, 1
    sb t1, 0x00(t0)
    2:
    lb t2, (t0)
    bnez t2, 2b          # verifica se ja terminou a leitura
    # ja realizou a escrita
    ret
    



_get_systime:
    li t0, base_gpt
    li t1, 1
    sb t1, 0(t0)
    1:
    lb t2, 0(t0)
    bnez t2, 1b             #verifica se ja terminou a leitura
    # ja realizou a leitura
    lw a0, 0x04(t0)         #retorna o tempo do sistema
    ret

.globl _start
_start:
    la t0, int_handler  # Carregar o endereço da rotina que tratará as interrupções
    csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar
                        # o vetor de interrupções.

    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800 # field (bits 11 and 12)
    and t1, t1, t2 # with value 00 (U-mode)
    csrw mstatus, t1

    li sp, 0x07FFFFFC
    la t0, isr_stack_end
    csrw mscratch, t0

    # ativa interrupcoes
    csrr t0, mstatus 
    ori t0, t0, 0x8 
    csrw mstatus, t0

    la t0, main # Loads the user software
    csrw mepc, t0 # entry point into mepc
    mret # PC <= MEPC; mode <= MPP;