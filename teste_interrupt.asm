.ktext 0x80000180
move $k0, $at
la $k1, _regs
sw $k0, 0($k1)
sw $v0, 4($k1)
sw $a0, 8($k1)

lw      $t0, 0xffff0000
li      $t1, 0x00000000 # desabilita interrupcao keyboard

li $v0, 1
move $a0, $13
syscall

li $t3, 0x00000100
and $t1, $12, $t3
beq $t1, 0x0000100, if_keyboard_interrupt
j end_if_keyboard_interrupt

if_keyboard_interrupt:
li $v0, 4
la $a0, string
syscall
li $t2, 1
sw $t2, flag
end_if_keyboard_interrupt: nop

lw $at, 0($k1)
lw $v0, 4($k1)
lw $a0, 8($k1)

mfc0 $k0, $14
addiu $k0, $k0, 4
mtc0 $k0, $14

eret
.kdata
_regs: .space 12
string: .asciiz "\nentrou na interrupcao!\n"

#----------------------------------------------------------------------------------------------------------------------------------------------
.data
texto: .asciiz "saiu da interrupcao."
flag: .word 0
.text
.globl main
main:

# Enable interrupts in status register
	mfc0    $t0, $12

	# Disable all interrupt levels
	li      $t1, 0x0000ff00		#EXC_INT_ALL_MASK
	not     $t1, $t1
	and     $t0, $t0, $t1
	
	# Enable console interrupt levels
	li      $t1, 0x00000100 	#EXC_INT3_MASK KEYBOARD
	or      $t0, $t0, $t1
	
	# Enable exceptions globally
	li      $t1, 0x00000001		#EXC_ENABLE_MASK
	or      $t0, $t0, $t1
	
	mtc0    $t0, $12

key_wait:
    	    li $v0, 32
    	    li $a0, 3000
    	    syscall
	   
	   li      $t0, 0xffff0000     # Receiver control register
	   li      $t1, 0x00000002     # Interrupt enable bit
	   sw      $t1, ($t0)
	    
	    while:
	    	lw $t0, flag
	    	bnez $t0, endwhile
	    j while
	    
	    
	    endwhile: nop
li $v0, 4
la $a0, texto
syscall