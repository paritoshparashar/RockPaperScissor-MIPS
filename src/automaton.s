# vim:sw=2 syntax=asm
.text
  .globl simulate_automaton, print_tape

# Simulate one step of the cellular automaton
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Returns: Nothing, but updates the tape in memory location 4($a0)
simulate_automaton:
  # TODO
  
  lw 	$t9	4($a0)		# t9 = tape encoding
  lb	$t8	8($a0)		# t8 = tape length
  lb	$t7	12($a0)		# t7 = rule
  li	$t6	7		# t6 = 0...111 initially in binary for doing and operation
  li	$t3	0		# t3 = 1 initially, = offset, we will increment it as we go along the tape
  
 
  
  # ------------ loaded the necessary ----------------- #
  
  first_bit: 
  
  	subi	$t8	$t8	1	# decrease the length by 1
  	
  	li	$t2	3		# t2 = mask, t2 = 3 = (0...11)in binary, because here we need last 2 sig bits
  	and	$t5	$t9	$t2	# here t5 = last 2 sig bit seq
  	sll	$t5	$t5	1	# make room for the third digit (most sig bit in this case)
  	
  	li	$t2	1		# now we want only 1 bit
  	sllv	$t2	$t2	$t8	# shift the mask by the offset of length of tape	
  	and	$t1	$t9	$t2	# t1 = most sig bit
  	
  	beqz  	$t1	apply_rule
  		
  		add1:
  			addi	$t5	$t5	1	# doing this will set the least sig bit of t5 from 0 to 1
  	
  	b	apply_rule
  	
  	
  middle_bits:
  	
  	blt	$t8	1	end_loop	
  	blt  	$t8	2	end_bit		#conditions for loop 	
  	
  	and	$t5	$t9	$t6	# t5 = the 3 consecutive bits
  	
  	subi	$t8	$t8	1	# decrease the length by 1
  	b	apply_rule
  	
  		apply_rule:
  		  	li	$t2	1		# t2 = mask, we shift it by t3 bit, to get to the desired bit in t9
  			srlv	$t4	$t7	$t5	# shift right t7 by the number in t5, now the least sig bit will be the next gen tape result
  			andi	$t4	$t4	1	# t4 = result of rule (either 0 or 1)
  			sllv	$t2	$t2	$t3	# t3 contains the shift amount to get to position corresponding to tape 
  			addi	$t3	$t3	1	# increment t3
  			b	change_tape
  		
  		change_tape:
  			beqz	$t4	set_zero
  			b	set_one
  				
  				set_one:
  					or	$t9	$t9	$t2
  					b	go_for_next_bit
  					
  				set_zero:
  					not	$t2	$t2
  					and	$t9	$t9	$t2
  					b	go_for_next_bit
  	go_for_next_bit:	
  	b	middle_bits
  
 
  end_bit:
  	
  	andi	$t5	$t9	1	# get the last sig bit
  	sll	$t5	$t5	2	# shift t5 2 bit, to make room for other 2 bits
  	
  	subi	$t3	$t3	1	# remove one extra offset to get first 2 most sig bits, increment it (for correct behaviour in change tape)
  	li	$t2	3		# t2 = mask, t2 = 3 = (0...11)in binary, because here we need last 2 sig bits
  	sllv	$t2	$t2	$t3	# shift done (now t2 = (11....0))
  	and	$t1	$t9	$t2	# got the last 2 digits
  	
  	add	$t5	$t5	$t1	# t5 = 3 bit sequence
  	
  	addi	$t3	$t3	1	# reset it for correct calc
    	subi	$t8	$t8	1	# decrease the length by 1
  	b	apply_rule
  
  end_loop:
  
  sw	$t9	4($a0)
  jr $ra

# Print the tape of the cellular automaton
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Return nothing, print the tape as follows:
#   Example:
#       tape: 42 (0b00101010)
#       tape_len: 8
#   Print:  
#       __X_X_X_
print_tape:
  # TODO
  
  addi	$sp	$sp	-4
  sw	$a0	0($sp)
  
  ############################
  	
  	lw	$t0	4($a0) 		# load tape config from mem 
  	lb	$t1	8($a0)		# load tape length from mem
  	li	$t2	128		# load <10000000> base 2 in t2 
  	
  	loop:
  		
  		and	$t3	$t0	$t2	# get the 8th least significant bit
  		srl	$t3	$t3	7	# shift to get the and bit
  		sll	$t0	$t0	1	# shift t0 to move the 7th bit to 8th position
  		
  		bnez 	$t3	print_charX
  		beqz	$t3	print_char_
  		
  		condition_end:
  		
  		subi	$t1	$t1	1
  		bnez 	$t1	loop
  		b	end
  		
  	print_charX:
  	
  		li	$a0	88	# store X 
  		li	$v0	11
  		syscall
  		b	condition_end
  		
  	print_char_:
  	
  		li	$a0	95	# store _
  		li	$v0	11
  		syscall
  		b	condition_end
  		
  ############################
  end:
  
  li	$a0	10		# print new line character
  li	$v0	11
  syscall	
  
  
  lw	$a0	0($sp)
  addi	$sp	$sp	4
  jr $ra
