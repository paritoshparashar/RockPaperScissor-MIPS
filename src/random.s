# vim:sw=2 syntax=asm
.data

.text
  .globl gen_byte, gen_bit

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value:
#  Compute the next valid byte (00, 01, 10) and put into $v0
#  If 11 would be returned, produce two new bits until valid
#
gen_byte:
  # TODO
  
  move	$t0	$ra
  
  first_bit:
  	jal	gen_bit  #puts the first bit in v0
  	
  	beqz	$v0	direct_second_bit
  	
  	sll	$t1	$v0	1	#left shift the first bit received by 1
  	
  conditional_second_bit:
  	
  	jal	gen_bit	#puts the second bit in v0
  	
  	bnez	$v0	first_bit	#if second bit is 1, restart
  	move	$v0	$t1		#else the result woulbe be 10, which is already in $t1
  	b	end
  
  direct_second_bit:
  	
  	jal	gen_bit	#if the first bit was 0, then the 2bit result will be the second bit only
  	
  
  end:
  	move	$ra	$t0
  	jr $ra

# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return value:
#  Look at the field {eca} and use the associated random number generator to generate one bit.
#  Put the computed bit into $v0
#
gen_bit:
  # TODO
  move $t7 $a0
  lw $a0 0($a0)
  li $v0 41
  syscall
  
  andi $v0 $a0 1
  move $a0 $t7 #testing commit 
  
  jr $ra
