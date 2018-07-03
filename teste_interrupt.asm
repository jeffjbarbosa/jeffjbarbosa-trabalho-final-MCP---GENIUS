.ktext 0x80000180
move $k0, $at
la $k1, _regs
sw $k0, 0($k1)
sw $v0, 4($k1)
sw $a0, 8($k1)

lw      $t0, 0xffff0000
li      $t1, 0x00000000 # desabilita interrupcao keyboard

li $v0, 4
la $a0, string
syscall

li $t2, 1
sw $t2, flag

lw $at, 0($k1)
lw $v0, 4($k1)
lw $a0, 8($k1)

mfc0 $k0, $14
addiu $k0, $k0, 4
mtc0 $k0, $14

eret
.kdata
_regs: .space 12
string: .asciiz "entrou na interrupcao!\n"

.ktext 0x80000180
.data
texto: .asciiz "saiu da interrupcao."
flag: .word 0
.text
.globl main
main:
key_wait:
    	    li $v0, 32
    	    li $a0, 3000
    	    syscall
    	    
	    lw      $t0, 0xffff0000
	    li      $t1, 0x00000002 # habilita interrupcao
	    sw	    $t1, 0($t0)   
	    
	    while:
	    	lw $t0, flag
	    	bnez $t0, endwhile
	    j while
	    endwhile: nop
li $v0, 4
la $a0, texto
syscall