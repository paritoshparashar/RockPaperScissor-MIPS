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
  		
  		bnez 	$t3	print_charX
  		beqz	$t3	print_char_
  		
  		condition_end:
  		
  		subi	$t1	$t1	1
  		bnez 	$t1	loop
  		
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
  		
  lw	$a0	0($sp)
  addi	$sp	$sp	4
  jr $ra
