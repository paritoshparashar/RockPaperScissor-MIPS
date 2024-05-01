# vim:sw=2 syntax=asm
.data
	win: 	.asciiz "W"
	lose:	.asciiz "L"
	tie:	.asciiz "T"
.text
  .globl play_game_once

# Play the game once, that is
# (1) compute two moves (RPS) for the two computer players
# (2) Print (W)in (L)oss or (T)ie, whether the first player wins, looses or ties.
#
# Arguments:
#     $a0 : address of configuration in memory
#   0($a0): eca       (1 word)
#   4($a0): tape      (1 word)
#   8($a0): tape_len  (1 byte)
#   9($a0): rule      (1 byte)
#  10($a0): skip      (1 byte)
#  11($a0): column    (1 byte)
#
# Returns: Nothing, only print either character 'W', 'L', or 'T' to stdout
play_game_once:
  # TODO
  
  addi	$sp	$sp	-4
  sw	$ra	0($sp)		#store return address in stack
  
  ######################## Take inputs below
  
  jal	gen_byte
  move	$t1	$v0		#save player1 move in t1
  
  addi	$sp	$sp	-4	# store $t1 in stack
  sw	$t1	0($sp)	
  
  jal	gen_byte
  move	$t2	$v0		# save player2 move in t2
  
  lw	$t1 	0($sp)		# free stack
  addi	$sp	$sp	4
  
  #######################  Check who won below
  
  beq	$t1	$t2	game_tied		# check for tie
  
  beq	$t1	0	rock			# else if t1 = 0 go to rock
  beq	$t1	1	paper			# else if t1 = 1 go to paper
  b 	scissors				# else branch to scissors
  
  
  	rock:
  		beq	$t2	2	player1_wins	# rock crushes scissors
  		b 	player1_loses			# paper covers rock
  		
  	paper:
  		beq	$t2	0	player1_wins	# paper covers rock
  		b	player1_loses			# scissor cuts paper
  		
  	scissors:
  		beq	$t2	1	player1_wins	# scissor cuts paper
  		b	player1_loses			# rock crushes scissors
  	  	
  ####################### Print the result below
  
  	game_tied:
  		la	$t9	tie
  		b	print
  
  	player1_wins:
  		la	$t9	win
  		b	print
  	
  	player1_loses:
  		la	$t9	lose
  		b	print
  	
  	
  	
  
  print:
  	la	$a0	($t9)	#t9 should contain win/lose/tie (label)
  	li 	$v0	4
  	syscall
  
  #######################
  
  lw	$ra 	0($sp)		#get return address from stack
  addi	$sp	$sp	4
  jr $ra
