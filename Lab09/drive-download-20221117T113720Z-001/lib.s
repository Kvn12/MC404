.equ baseTimer, 0xFFFF0100
.equ baseMidi, 0xFFFF0300

.section .data

.globl _system_time 
_system_time:
.word 0

.section .bss 

.align 4
isr_stack: 
.skip 1024 
isr_stack_end: 
 
stack:
.skip 1024
stack_end:

.section .text
.align 2

.globl play_note
play_note:
    li t0, baseMidi
    sb a0, (t0)
    sh a1, 2(t0)
    sb a2, 4(t0)
    sb a3, 5(t0)
    sh a4, 6(t0)
    ret

getTime:
    #salvar o contexto
    csrrw sp, mscratch, sp 
    addi sp, sp, -64 
    sw t0, 0(sp) 
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)

    #pega o tempo de fato
    li t0, baseTimer
    li t1, 1
    sb t1, 0(t0)
    1:
    lb t2, (t0)
    bnez t2, 1b             #verifica se ja terminou a leitura
    # ja realizou a leitura
    # atualizar o valor de system line
    # programar outra interrupcapo

    lw t2, 4(t0)            #retorna o tempo do sistema
    la t1, _system_time     #atualizar o _system_time
    sw t2, (t1) 

    li t3, 100
    sw t3, 8(t0)            #programa a proxima interrupcao

    #recupera o contexto
    lw t3, 12(sp)
    lw t2, 8(sp)
    lw t1, 4(sp) 
    lw t0, 0(sp) 
    addi sp, sp, 64 
    csrrw sp, mscratch, sp 
    mret

.globl _start
_start:
    #Configurando pra ter a interrupção
    la t0, getTime          #Endereço da rotina de interrupção
    csrw mtvec, t0

    la sp, stack_end        
    la t0, isr_stack_end
    csrw mscratch, t0

    csrr t0, mie            
    li t2, 0x800            
    or t1, t1, t2
    csrw mie, t1            

    csrr t0, mstatus 
    ori t0, t0, 0x8 
    csrw mstatus, t0

    li t0, baseTimer        #Programa a interrupção
    li t3, 100
    sw t3, 8(t0)

    jal main