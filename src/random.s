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
  	jal	gen_bit  			#puts the first bit in v0
  	
  	beqz	$v0	direct_second_bit
  	
  	sll	$t1	$v0	1		#left shift the first bit received by 1
  	
  conditional_second_bit:
  	
  	addi	$sp	$sp	-4	#
  	sw	$t1	0($sp)
  	#sw	$	4($sp)		#
  	#--------------------------------	
  	jal	gen_bit				#puts the second bit in v0
  	#--------------------------------
  	lw	$t1	0($sp)		#
  	#lw	$	4($sp)
  	addi	$sp	$sp	4	#
  	
  	bnez	$v0	first_bit		#if second bit is 1, restart
  	move	$v0	$t1			#else the result woulbe be 10, which is already in $t1
  	b	end
  
  direct_second_bit:
  	
  	jal	gen_bit				#if the first bit was 0, then the 2bit result will be the second bit only
  	
  
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
  lw	$t6	0($a0)
  bnez 	$t6	calc_id
  
  move 	$t7 	$a0			#save the conf address
  li 	$a0 	0		#load the appropirate PRNG 
  b	bit_gen
  
  calc_id:
  	# code in the calc_id label for the last task
  	#li	$a0 	0		#load the appropirate PRNG (if skip is 0 and eca is non zero)
  	
	#replicate for now 
	lb	$t1	10($a0) 	# t1 = skip
	lb	$t2	11($a0)		# t2 = column
	
	loop_for_skip:	
		
		beqz	$t1	get_column_bit		# if skip = 0, branch
		
		addi	$sp	$sp	-16	#
  		sw	$ra	0($sp)		#
  		sw	$t1	4($sp)		#
  		sw	$t2	8($sp)		#
  		sw	$a0	12($sp)		#
  		#---------------------------
		jal	simulate_automaton	
		#---------------------------
		lw	$ra	0($sp)		#
		lw	$t1	4($sp)		#
		lw	$t2	8($sp)		#
		lw	$a0	12($sp)		#
  		addi	$sp	$sp	16	#
  		
  		subi	$t1	$t1	1
  		
  		b 	loop_for_skip
  		
  	
	get_column_bit:
		lw	$t6	4($a0)		# t6 = tape conf
  	 	lb	$t3	8($a0)		# t3 = length of tape
  	 	addi	$t2	$t2	1
  	 	sub	$t2	$t3	$t2	# t2 = shift offset
  	 	li	$t3	1
  	 	sllv	$t3	$t3	$t2	# t3 = mask after shifting
  	 	and	$v0	$t6	$t3	# a0 = columnth bit of tape
  	 	srlv	$v0	$v0	$t2
  	 	b 	return_bit

  bit_gen:	
  	li 	$v0 	41
  	syscall
  
  	andi 	$v0 	$a0 	1		#put the result in v0 after bitwise & with 1
 	move 	$a0 	$t7
  
  return_bit:
  	jr 	$ra
