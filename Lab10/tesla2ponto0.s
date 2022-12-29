.section .data

.equ base, 0xFFFF0100

.section .bss 

.align 4
isr_stack: 
.skip 1024 
isr_stack_end: 
 
stack:
.skip 1024
stack_end:

.text
.align 4

int_handler:                                            
    ###### Tratador de interrupções e syscalls ######
    
    # <= Implemente o tratamento da sua syscall aqui

    # Salva o contexto
    csrrw sp, mscratch, sp # Exchange sp with mscratch4 
    addi sp, sp, -64 # Allocates space at the ISR stack5 
    sw t0, 0(sp) 
    sw t1, 4(sp)
    sw t2, 8(sp)

    # avalia qual syscall foi chamada
    li t0, 10
    beq t0, a7, 1f

    li t0, 11
    beq t0, a7, 2f

    li t0, 15
    beq t0, a7, 3f

    # _set_engine_and_steering    a7=10
    1:                  # _set_engine_and_steering
    # verifica se os valores dos parametros sao válidos
    mv t2, a0           # Troca o valor do parametro de lugar
    li a0, -1           # saida de erro caso seja necessario

    li t0, -1
    li t1, 1
    blt t2, t0, 4f
    bgt t2, t1, 4f
    li t0, -127
    li t1, 127
    blt a1, t0, 4f
    bgt a1, t1, 4f

    mv a0, t2           # destroca o valor do parametro de lugar

    li t0, base
    sb a0, 0x21(t0)                         
    sb a1, 0x20(t0)

    li a0, 0            # valores ok 
    j 4f

    # _set_handbreak   a7=11
    2:                  # _set_handbreak
    li t0, base
    sb a0, 0x22(t0)
    j 4f
    
    # _get_position    a7=15
    3:
    li t0, base
    li t1, 1
    sb t1, 0(t0)
    
    1:
    lb t2, (t0)
    bnez t2, 1b          # verifica se ja terminou a leitura
    # ja realizou a leitura
    
    li t0, base
    lb a0, 0x10(t0)         # posicao em x

    li t0, base
    lb a1, 0x14(t0)         # posicao em y

    li t0, base
    lb a2, 0x18(t0)         # posicao em z

    j 4f

    4:
    csrr t0, mepc  # carrega endereço de retorno (endereço 
                   # da instrução que invocou a syscall)
    addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall) 
    csrw mepc, t0  # armazena endereço de retorno de volta no mepc
    
    # Recupera o contexto
    lw t2, 8(sp)
    lw t1, 4(sp) 
    lw t0, 0(sp) 
    addi sp, sp, 64 # Deallocate space from the ISR stack18 
    csrrw sp, mscratch, sp # Exchange sp with mscratch19 

    mret           # Recuperar o restante do contexto (pc <- mepc)
  

.globl _start
_start:

    la t0, int_handler  # Carregar o endereço da rotina que tratará as interrupções
    csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar
                        # o vetor de interrupções.

# Escreva aqui o código para mudar para modo de usuário e chamar a função 
# user_main (definida em outro arquivo). Lembre-se de inicializar a 
# pilha do usuário para que seu programa possa utilizá-la.
    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800 # field (bits 11 and 12)
    and t1, t1, t2 # with value 00 (U-mode)
    csrw mstatus, t1

    la sp, stack_end
    la t0, isr_stack_end
    csrw mscratch, t0

    # ativa interrupcoes
    csrr t0, mstatus 
    ori t0, t0, 0x8 
    csrw mstatus, t0

    la t0, user_main # Loads the user software
    csrw mepc, t0 # entry point into mepc
    mret # PC <= MEPC; mode <= MPP;


.globl logica_controle
logica_controle:
    # implemente aqui sua lógica de controle, utilizando apenas as 
    # syscalls definidas.
    
    # moveForward and moveLeft
    li a0, 1
    li a1, -14
    li a7, 10
    ecall
    
    li t0, 0
    li t1, 58500

    1:                  #deixa o motor ativado por um certo tempo antes de desliga-lo
    beq t0, t1, 2f
    addi t0, t0, 1
    j 1b
    2:

    #handBreak
    li a0, 1
    li a7, 11
    ecall

    # getCoord
    li a7, 15
    ecall

    ret
